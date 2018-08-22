#!/usr/bin/env python
'''Renders my blog.'''
import glob
import shutil
import os
import re
import mako.template
import mako.lookup
import markdown
import yaml
import nbformat
from os.path import join
from datetime import datetime
from subprocess import call, check_call
from nbconvert import HTMLExporter

# Default to my blog configuration, but let env vars override
SITE_AUTHOR = os.environ.get('SITE_AUTHOR', "Peter Parente")
SITE_NAME = os.environ.get('SITE_NAME', "Parente's Mindtrove")
SITE_ROOT = os.environ.get('SITE_ROOT', '')
SITE_DOMAIN = os.environ.get('SITE_DOMAIN', 'http://mindtrove.info')

# Constants
STATIC_DIR = 'static'
TEMPLATES_DIR = 'templates'
PAGES_DIR = 'pages'
OUT_DIR = '_output'

# Configure mako to look in the templates directory
TMPL_LOOKUP = mako.lookup.TemplateLookup(
    directories=[join('.', TEMPLATES_DIR)],
    output_encoding='utf-8',
    encoding_errors='replace'
)


def copyinto(src, dst, symlinks=False, ignore=None):
    '''
    Copy files and subdirectoryes from src into dst.
    
    http://stackoverflow.com/questions/1868714/how-do-i-copy-an-entire-directory-of-files-into-an-existing-directory-using-pyth
    '''
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)


def save_rss(pages):
    '''Save a RSS document listing all of the pages.'''
    rss_tmpl = TMPL_LOOKUP.get_template('rss.mako')
    xml = rss_tmpl.render(
        site_domain=SITE_DOMAIN,
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.mkdir(join(OUT_DIR, 'feed'))
    with open(join(OUT_DIR, 'feed', 'index.xml'), 'wb') as f:
        f.write(xml)


def save_atom(pages):
    '''Save an Atom document listing of all of the pages.'''
    atom_tmpl = TMPL_LOOKUP.get_template('atom.mako')
    xml = atom_tmpl.render(
        site_author=SITE_AUTHOR,
        site_domain=SITE_DOMAIN,
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.makedirs(join(OUT_DIR, 'feed', 'atom'))
    with open(join(OUT_DIR, 'feed', 'atom', 'index.xml'), 'wb') as f:
        f.write(xml)


def save_archive(pages):
    '''Save an HTML document listing all of the pages.'''
    archive_tmpl = TMPL_LOOKUP.get_template('archive.mako')
    html = archive_tmpl.render(
        site_name=SITE_NAME,
        site_root='..',
        all_pages=pages
    )
    os.makedirs(join(OUT_DIR, 'posts'))
    with open(join(OUT_DIR, 'posts', 'index.html'), 'wb') as f:
        f.write(html)


def save_latest(pages):
    '''Save the latest page as index.html.'''
    page = pages[0]
    tmpl_name = page.get('template', 'page.mako')
    page_tmpl = TMPL_LOOKUP.get_template(tmpl_name)
    html = page_tmpl.render(
        site_name=SITE_NAME,
        site_root='.',
        page=page,
        all_pages=pages
    )
    in_tree = page['src']
    print('Saving', in_tree, 'as latest')
    copyinto(in_tree, OUT_DIR)
    with open(join(OUT_DIR, 'index.html'), 'wb') as f:
        f.write(html)


def save_html(pages):
    '''Save every page as an HTML document.'''
    for page in pages:
        tmpl_name = page.get('template', 'page.mako')
        page_tmpl = TMPL_LOOKUP.get_template(tmpl_name)
        html = page_tmpl.render(
            site_name=SITE_NAME,
            site_root='..',
            page=page,
            all_pages=pages
        )
        in_tree = page['src']
        out_tree = join(OUT_DIR, os.path.basename(in_tree))
        print('Saving', out_tree)
        shutil.copytree(in_tree, out_tree)
        with open(join(out_tree, 'index.html'), 'wb') as f:
            f.write(html)


def org_pages(pages):
    '''Sort pages from newest to oldest.
    
    Use the `date` key for sorting. Add a `next` key to link one page to the
    next.
    '''
    for page in pages:
        if 'date' in page:
            page['date'] = datetime.strptime(page['date'], '%Y-%m-%d')
    pages.sort(key=lambda page: page.get('date', datetime(1900, 1, 1)), reverse=True)
    for i, page in enumerate(pages):
        try:
            page['next'] = pages[i+1]
        except IndexError:
            pass


class YamlParser(object):
    @classmethod
    def execute(cls, path, page):
        '''Parse a yaml file in the path and update page with its contents.

        Use the page filename or fall back on index.yml as the default.
        '''
        fn = join(path, page.get('filename', 'index.yml'))
        if not os.path.isfile(fn) or not fn.endswith('.yml'):
            return
        with open(fn) as f:
            print('Processing', path, 'as YAML')
            page.update(yaml.load(f.read()))

    
class GitFetcher(object):
    @classmethod
    def execute(cls, path, page):
        '''Clone a git repo into the path if the page contains a git_url key.'''
        if 'git_url' in page:
            check_call(['git', 'init'], cwd=path)
            call(['git', 'remote', 'add', 'origin', page['git_url']], cwd=path)
            check_call(['git', 'fetch', '--depth=1', 'origin'], cwd=path)
            check_call(['git', 'reset', '--hard', 'origin/master'], cwd=path)
            check_call(['rm', '-rf', '.git'], cwd=path)


class FileMerger(object):
    @classmethod
    def execute(cls, path, page):
        if 'merge' not in page:
            return

        to_merge = [join(path, fn) for fn in page['merge']]
        exts = {os.path.splitext(fn)[1] for fn in to_merge}
        if '.ipynb' in exts:
            # Merge into a single notebook file
            merged = cls._join_into_ipynb(to_merge)
            page['filename'] = 'merged.ipynb'
            with open(join(path, page['filename']), 'w') as fh:
                nbformat.write(merged, fh)
        else:
            # Assume we're merging into a flat markdown file
            merged = cls._join_into_md(to_merge)
            page['filename'] = 'merged.md'
            with open(join(path, page['filename']), 'w') as fh:
                fh.write(merged)

    @classmethod
    def _join_into_ipynb(cls, paths):
        needs_header = False
        embed_tmpl = TMPL_LOOKUP.get_template('embed.mako')

        nb = nbformat.v4.new_notebook()
        for path in paths:
            if needs_header:
                # Introduce the file if it's not the first file
                header_html = embed_tmpl.render(filename=os.path.basename(path))
                nb.cells.append(nbformat.v4.new_markdown_cell(header_html.decode('utf-8')))
            else:
                needs_header = True

            if path.endswith('.md'):
                # Splat a markdown file into a notebook markdown cell
                with open(path) as fh:
                    md = fh.read()
                md_cell = nbformat.v4.new_markdown_cell(md)
                nb.cells.append(md_cell)
            elif path.endswith('.ipynb'):
                # Add all cells from a notebook into the new output notebook
                with open(path) as fh:
                    partial_nb = nbformat.read(path, 4)
                nb.cells.extend(partial_nb.cells)
            else:
                raise RuntimeError(f'Unsupported file format: {path}')
        return nb

    @classmethod
    def _join_into_md(cls, paths):
        merged = []
        for path in paths:
            with open(path) as fh:
                lines = fh.read()
            merged.append(lines)
        return '\n'.join(merged)


class JupyterNotebookParser(object):
    @classmethod
    def execute(cls, path, page):
        '''Parse an ipynb file in the path and update the page with its
        contents.

        Use the page filename or fall back on index.ipynb as the default.
        Use the title and date from the notebook metadata if the page does not
        already contain a title and date key. Generate an excerpt and HTML
        rendering of the notebook.
        '''
        ipynb = join(path, page.get('filename', 'index.ipynb'))
        if not os.path.isfile(ipynb) or not ipynb.endswith('.ipynb'):
            return
        else:
            page.setdefault('filename', 'index.ipynb')
        with open(ipynb) as f:
            print('Processing', path, 'as a Jupyter Notebook')
            doc = nbformat.read(f, 4)

        if 'title' not in page and 'title' in doc['metadata']:
            page['title'] = doc['metadata']['title']
        if 'date' not in page and 'date' in doc['metadata']:
            page['date'] = doc['metadata']['date']
        page['excerpt'] = cls._build_excerpt(doc)
        page['html'] = cls._nbconvert_to_html(doc)
        page['src'] = path
        page['slug'] = os.path.basename(path)
        # more specific template which includes additional css
        page['template'] = 'notebook.mako'

    @classmethod
    def _nbconvert_to_html(cls, doc):
        '''Use nbconvert to render a notebook as HTML.

        Strip the headings from the first markdown cell to avoid showing the
        page title twice on the blog.
        '''
        if doc.cells and doc.cells[0].cell_type == 'markdown':
            source = doc.cells[0].source
            doc.cells[0].source = re.sub('^# .*\n', '', source)

        e = HTMLExporter()
        e.template_file = 'basic'
        return e.from_notebook_node(doc)[0]

    @classmethod
    def _build_excerpt(cls, page):
        '''Build an excerpt from the first paragraph of the first markdown
        cell in the notebook.
        '''
        try:
            cells = page['cells']
        except (KeyError, ValueError):
            return ''
        for cell in cells:
            if cell['cell_type'] == 'markdown':
                excerpt = []
                for line in cell['source'].split('\n'):
                    if line.startswith('#'): continue
                    if line.strip() == '' and excerpt: break
                    excerpt.append(line)
                return MarkdownParser.md.convert(''.join(excerpt))
        return ''


class MarkdownParser(object):
    md = markdown.Markdown(extensions=['meta', 'fenced_code', 'codehilite'], 
        output_format='xhtml5')

    @classmethod
    def execute(cls, path, page):
        '''Parse an md file in the path and update the page with its
        contents.
        
        Use the page filename or fall back on index.md as the default.
        Add metadata from the extended metadata section of the document to the
        page along with the rendered HTML.
        '''
        fn = join(path, page.get('filename', 'index.md'))
        if not os.path.isfile(fn) or not fn.endswith('.md'):
            return
        else:
            page.setdefault('filename', 'index.md')
        with open(fn) as f:
            print('Processing', path, 'as Markdown')
            text = f.read()
        html = cls.md.convert(text)
        meta = cls.md.Meta
        for key, value in meta.items():
            meta[key] = ''.join(value)
        
        page.update(meta)
        page['html'] = html
        page['excerpt'] = cls._build_excerpt(text)
        page['src'] = path
        page['slug'] = os.path.basename(path)

    @classmethod
    def _build_excerpt(cls, text):
        '''Build an excerpt from the first non-blank line after the first blank 
        line separating the metadata from the content of the doc.
        '''
        lines = []
        prior = None

        for line in text.split('\n'):
            line = line.strip()
            if line != prior or line != '':
                lines.append(line)
            prior = line
        start = lines.index('')
        try:
            end = lines.index('', start+1)
        except ValueError:
            end = None
        return cls.md.convert('\n'.join(lines[start+1:end]))

def load_pages():
    '''Parse data and metadata for all pages.

    Iterate over the page directories. Pass the page source document and
    in-memory page representation to all parsers. Raise a RuntimeError if
    no parser emits HTML for the page.
    '''
    pages = []
    handlers = [YamlParser, GitFetcher, FileMerger, MarkdownParser, JupyterNotebookParser]
    for path in glob.glob(join(PAGES_DIR, '*')):
        page = {}
        for handler in handlers:
            handler.execute(path, page)
        if 'skip' in page:
            continue
        elif 'html' not in page:
            raise RuntimeError('Nothing rendered HTML for ' + path)
        pages.append(page)
    return pages


def save_static():
    '''Duplicate the static directory in the output directory.'''
    shutil.copytree(STATIC_DIR, join(OUT_DIR, STATIC_DIR))


def clean():
    '''Remove the output directory.'''
    shutil.rmtree(OUT_DIR, True)


def main():
    '''Clean and build the blog site in the output directory.'''
    clean()
    save_static()
    pages = load_pages()
    org_pages(pages)
    save_html(pages)
    save_latest(pages)
    save_archive(pages)
    save_rss(pages)
    save_atom(pages)


if __name__ == '__main__':
    main()