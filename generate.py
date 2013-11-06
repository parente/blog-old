from os.path import join
from datetime import datetime
import mako.template
import mako.lookup
import markdown
import glob
import shutil
import os

site_author = "Peter Parente"
site_name = "Parente's Mindtrove"
site_root_href = os.environ.get('SITE_ROOT', '')
site_domain = os.environ.get('SITE_DOMAIN', 'http://mindtrove.info')

static_dir = 'static'
templates_dir = 'templates'
pages_dir = 'pages'
out_dir = '_output'

tmpl_lookup = mako.lookup.TemplateLookup(directories=[join('.', templates_dir)])


def copyinto(src, dst, symlinks=False, ignore=None):
    '''
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
    rss_tmpl = tmpl_lookup.get_template('rss.mako')
    xml = rss_tmpl.render(
        site_domain=site_domain,
        site_name=site_name,
        site_root=site_root_href,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.mkdir(join(out_dir, 'feed'))
    with file(join(out_dir, 'feed', 'index.xml'), 'w') as f:
        f.write(xml)

def save_atom(pages):
    atom_tmpl = tmpl_lookup.get_template('atom.mako')
    xml = atom_tmpl.render(
        site_author=site_author,
        site_domain=site_domain,
        site_name=site_name,
        site_root=site_root_href,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.makedirs(join(out_dir, 'feed', 'atom'))
    with file(join(out_dir, 'feed', 'atom', 'index.xml'), 'w') as f:
        f.write(xml)

def save_archive(pages):
    archive_tmpl = tmpl_lookup.get_template('archive.mako')
    html = archive_tmpl.render(
        site_name=site_name,
        site_root=site_root_href,
        all_pages=pages
    )
    with file(join(out_dir, "posts.html"), 'w') as f:
        f.write(html)


def save_latest(pages):
    page = pages[0]
    in_tree = join(out_dir, page['slug'])
    print 'Saving', in_tree, 'as latest'
    copyinto(in_tree, out_dir)


def save_html(pages):
    page_tmpl = tmpl_lookup.get_template('page.mako')
    for page in pages:
        html = page_tmpl.render(
            site_name=site_name,
            site_root=site_root_href,
            page=page,
            all_pages=pages
        )
        in_tree = page['src']
        out_tree = join(out_dir, os.path.basename(in_tree))
        print 'Saving', out_tree
        shutil.copytree(in_tree, out_tree)
        with file(join(out_tree, 'index.html'), 'w') as f:
            f.write(html)


def _build_excerpt(md, text):
    '''
    First non-blank line after the first blank line separating the metadata
    from the content of the doc.
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
    return md.convert('\n'.join(lines[start+1:end]))


def org_pages(pages):
    # newest to oldest
    pages.sort(key=lambda page: page.get('date', datetime(1, 1, 1)), reverse=True)
    for i, page in enumerate(pages):
        try:
            page['next'] = pages[i+1]
        except IndexError:
            pass


def load_pages():
    pages = []
    md = markdown.Markdown(extensions=['meta', 'fenced_code', 'codehilite'], output_format='xhtml5')
    for i, path in enumerate(glob.glob(join(pages_dir, '*'))):
        with file(join(path, 'index.md')) as f:
            print 'Processing', path
            text = f.read()
            html = md.convert(text)
            meta = md.Meta
            for key, value in meta.iteritems():
                meta[key] = ''.join(value)
            d = {}
            d.update(meta)
            d['html'] = html
            d['excerpt'] = _build_excerpt(md, text)
            d['src'] = path
            d['slug'] = os.path.basename(path)
            if 'date' in d:
                d['date'] = datetime.strptime(d['date'], '%Y-%m-%d')
            pages.append(d)
    return pages


def save_static():
    shutil.copytree(static_dir, join(out_dir, static_dir))


def clean():
    shutil.rmtree(out_dir, True)


def main():
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