#!/usr/bin/env python
"""Renders my blog."""
import glob
import os
import shutil

from datetime import datetime
from os.path import join

import mako.template
import mako.lookup
import markdown


# Default to my blog configuration, but let env vars override
SITE_AUTHOR = os.environ.get("SITE_AUTHOR", "Peter Parente")
SITE_NAME = os.environ.get("SITE_NAME", "parente.dev")
SITE_ROOT = os.environ.get("SITE_ROOT", "")
SITE_DOMAIN = os.environ.get("SITE_DOMAIN", "parente.dev")

# Constants
STATIC_DIR = "static"
TEMPLATES_DIR = "templates"
PAGES_DIR = "pages"
OUT_DIR = "_output"

# Configure mako to look in the templates directory
TMPL_LOOKUP = mako.lookup.TemplateLookup(
    directories=[join(".", TEMPLATES_DIR)],
    output_encoding="utf-8",
    encoding_errors="replace",
)


def copyinto(src, dst, symlinks=False, ignore=None):
    """
    Copy files and subdirectoryes from src into dst.

    http://stackoverflow.com/questions/1868714/how-do-i-copy-an-entire-directory-of-files-into-an-existing-directory-using-pyth
    """
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)


def save_rss(pages):
    """Save a RSS document listing all of the pages."""
    rss_tmpl = TMPL_LOOKUP.get_template("rss.mako")
    xml = rss_tmpl.render(
        site_domain=f"https://{SITE_DOMAIN}",
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if "date" in page],
    )
    os.mkdir(join(OUT_DIR, "feed"))
    with open(join(OUT_DIR, "feed", "index.xml"), "wb") as f:
        f.write(xml)


def save_atom(pages):
    """Save an Atom document listing of all of the pages."""
    atom_tmpl = TMPL_LOOKUP.get_template("atom.mako")
    xml = atom_tmpl.render(
        site_author=SITE_AUTHOR,
        site_domain=f"https://{SITE_DOMAIN}",
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if "date" in page],
    )
    os.makedirs(join(OUT_DIR, "feed", "atom"))
    with open(join(OUT_DIR, "feed", "atom", "index.xml"), "wb") as f:
        f.write(xml)


def save_archive(pages):
    """Save an HTML document listing all of the pages."""
    archive_tmpl = TMPL_LOOKUP.get_template("archive.mako")
    html = archive_tmpl.render(site_name=SITE_NAME, site_root="..", all_pages=pages)
    os.makedirs(join(OUT_DIR, "posts"))
    with open(join(OUT_DIR, "posts", "index.html"), "wb") as f:
        f.write(html)


def save_latest(pages):
    """Save the latest page as index.html."""
    page = pages[0]
    tmpl_name = page.get("template", "page.mako")
    page_tmpl = TMPL_LOOKUP.get_template(tmpl_name)
    html = page_tmpl.render(
        site_name=SITE_NAME, site_root=".", page=page, all_pages=pages
    )
    in_tree = page["src"]
    print("Saving", in_tree, "as latest")
    copyinto(in_tree, OUT_DIR)
    with open(join(OUT_DIR, "index.html"), "wb") as f:
        f.write(html)


def save_html(pages):
    """Save every page as an HTML document."""
    for page in pages:
        tmpl_name = page.get("template", "page.mako")
        page_tmpl = TMPL_LOOKUP.get_template(tmpl_name)
        html = page_tmpl.render(
            site_name=SITE_NAME, site_root="..", page=page, all_pages=pages
        )
        in_tree = page["src"]
        out_tree = join(OUT_DIR, os.path.basename(in_tree))
        print("Saving", out_tree)
        shutil.copytree(in_tree, out_tree)
        with open(join(out_tree, "index.html"), "wb") as f:
            f.write(html)


def org_pages(pages):
    """Sort pages from newest to oldest.

    Use the `date` key for sorting. Add a `next` key to link one page to the
    next.
    """
    for page in pages:
        if "date" in page:
            page["date"] = datetime.strptime(page["date"], "%Y-%m-%d")
    pages.sort(key=lambda page: page.get("date", datetime(1900, 1, 1)), reverse=True)
    for i, page in enumerate(pages):
        try:
            page["next"] = pages[i + 1]
        except IndexError:
            pass


class MarkdownParser:
    md = markdown.Markdown(
        extensions=["meta", "fenced_code", "codehilite"], output_format="html"
    )

    def execute(self, path, page):
        """Parse an md file in the path and update the page with its
        contents.

        Use the page filename or fall back on index.md as the default.
        Add metadata from the extended metadata section of the document to the
        page along with the rendered HTML.
        """
        fn = join(path, page.get("filename", "index.md"))
        if not os.path.isfile(fn) or not fn.endswith(".md"):
            return
        else:
            page.setdefault("filename", "index.md")
        with open(fn) as f:
            print("Processing", path, "as Markdown")
            text = f.read()
        html = self.md.convert(text)
        meta = self.md.Meta
        for key, value in meta.items():
            meta[key] = "".join(value)
        page.update(meta)

        if "excerpt" not in page:
            page["excerpt"] = self._build_excerpt(text)
        # if "author_comment" in page:
        #     page["author_comment"] = self.md.convert(page["author_comment"])
        page["src"] = path
        page["slug"] = os.path.basename(path)
        page["html"] = html

    def _build_excerpt(self, text):
        """Build an excerpt from the first non-blank line after the first blank
        line separating the metadata from the content of the doc.
        """
        lines = []
        prior = None

        for line in text.split("\n"):
            line = line.strip()
            if line != prior or line != "":
                lines.append(line)
            prior = line
        start = lines.index("")
        try:
            end = lines.index("", start + 1)
        except ValueError:
            end = None
        return self.md.convert("\n".join(lines[start + 1 : end]))


def load_pages():
    """Parse data and metadata for all pages.

    Iterate over the page directories. Pass the page source document and
    in-memory page representation to all parsers. Raise a RuntimeError if
    no parser emits HTML for the page.
    """
    pages = []
    handlers = [MarkdownParser()]
    for path in glob.glob(join(PAGES_DIR, "*")):
        page = {}
        for handler in handlers:
            handler.execute(path, page)
        if "skip" in page:
            continue
        elif "html" not in page:
            print("WARN: Nothing rendered HTML for", path)
            continue
            raise RuntimeError("Nothing rendered HTML for " + path)
        pages.append(page)
    return pages


def save_static():
    """Duplicate the static directory in the output directory."""
    shutil.copytree(STATIC_DIR, join(OUT_DIR, STATIC_DIR))


def clean():
    """Remove the output directory."""
    shutil.rmtree(OUT_DIR, True)


def main():
    """Clean and build the blog site in the output directory."""
    clean()
    save_static()
    pages = load_pages()
    org_pages(pages)
    save_html(pages)
    save_latest(pages)
    save_archive(pages)
    save_rss(pages)
    save_atom(pages)


if __name__ == "__main__":
    main()
