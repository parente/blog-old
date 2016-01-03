'''Renders my blog.'''
from os.path import join
from datetime import datetime
import mako.template
import mako.lookup
import markdown
import glob
import shutil
import os
import subprocess
import json

SITE_AUTHOR = os.environ.get('SITE_AUTHOR', "Peter Parente")
SITE_NAME = os.environ.get('SITE_NAME', "Parente's Mindtrove")
SITE_ROOT = os.environ.get('SITE_ROOT', '')
SITE_DOMAIN = os.environ.get('SITE_DOMAIN', 'http://mindtrove.info')

STATIC_DIR = 'static'
TEMPLATES_DIR = 'templates'
PAGES_DIR = 'pages'
OUT_DIR = '_output'

TMPL_LOOKUP = mako.lookup.TemplateLookup(
    directories=[join('.', TEMPLATES_DIR)],
    output_encoding='utf-8',
    encoding_errors='replace'
)


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
    '''Save the rendered RSS feed.'''
    rss_tmpl = TMPL_LOOKUP.get_template('rss.mako')
    xml = rss_tmpl.render(
        site_domain=SITE_DOMAIN,
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.mkdir(join(OUT_DIR, 'feed'))
    with file(join(OUT_DIR, 'feed', 'index.xml'), 'w') as f:
        f.write(xml)


def save_atom(pages):
    '''Save the rendered Atom feed.'''
    atom_tmpl = TMPL_LOOKUP.get_template('atom.mako')
    xml = atom_tmpl.render(
        site_author=SITE_AUTHOR,
        site_domain=SITE_DOMAIN,
        site_name=SITE_NAME,
        site_root=SITE_ROOT,
        latest_pages=[page for page in pages[:10] if 'date' in page]
    )
    os.makedirs(join(OUT_DIR, 'feed', 'atom'))
    with file(join(OUT_DIR, 'feed', 'atom', 'index.xml'), 'w') as f:
        f.write(xml)


def save_archive(pages):
    '''Save the rendered archive page.'''
    archive_tmpl = TMPL_LOOKUP.get_template('archive.mako')
    html = archive_tmpl.render(
        site_name=SITE_NAME,
        site_root='.',
        all_pages=pages
    )
    with file(join(OUT_DIR, "posts.html"), 'w') as f:
        f.write(html)


def save_latest(pages):
    '''Save the latest page as the index page.'''
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
    print 'Saving', in_tree, 'as latest'
    copyinto(in_tree, OUT_DIR)
    with file(join(OUT_DIR, 'index.html'), 'w') as f:
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
        print 'Saving', out_tree
        shutil.copytree(in_tree, out_tree)
        with file(join(out_tree, 'index.html'), 'w') as f:
            f.write(html)


def org_pages(pages):
    '''Sort pages newest to oldest.'''
    pages.sort(key=lambda page: page.get('date', datetime(1, 1, 1)), reverse=True)
    for i, page in enumerate(pages):
        try:
            page['next'] = pages[i+1]
        except IndexError:
            pass


class IPythonNotebookParser(object):
    @classmethod
    def render(cls, path):
        ipynb = join(path, 'index.ipynb')
        with file(ipynb) as f:
            print 'Processing', path, 'as ipynb'
            text = f.read()

        d = cls._get_metadata(text)
        d['html'] = cls._nbconvert_to_html(ipynb)
        d['src'] = path
        d['slug'] = os.path.basename(path)
        # more specific template which includes additional css
        d['template'] = 'notebook.mako'
        return d

    @classmethod
    def _nbconvert_to_html(cls, ipynb):
        rv = subprocess.Popen(['ipython', 'nbconvert', '--to', 'html', '--template', 'basic', ipynb, '--stdout'], stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        stdout, stderr = rv.communicate()
        if rv.returncode == 0:
            return stdout
        else:
            raise RuntimeError(stderr)

    @classmethod
    def _get_metadata(cls, text):
        doc = json.loads(text)
        title = doc['metadata']['title']
        date = doc['metadata'].get('date', '1-1-1')
        date = datetime.strptime(date, '%Y-%m-%d')
        return dict(title=title, date=date, excerpt=cls._build_excerpt(doc))

    @classmethod
    def _build_excerpt(cls, doc):
        try:
            cells = doc['worksheets'][0]['cells']
        except (KeyError, ValueError):
            return ''
        for cell in cells:
            if cell['cell_type'] == 'markdown':
                excerpt = []
                for line in cell['source']:
                    if line.strip() == '':
                        break
                    excerpt.append(line)
                return MarkdownParser.md.convert(''.join(excerpt))
        return ''

class MarkdownParser(object):
    md = markdown.Markdown(extensions=['meta', 'fenced_code', 'codehilite'], output_format='xhtml5')

    @classmethod
    def render(cls, path):
        with file(join(path, 'index.md')) as f:
            print 'Processing', path, 'as md'
            text = f.read()
        html = cls.md.convert(text)
        meta = cls.md.Meta
        for key, value in meta.iteritems():
            meta[key] = ''.join(value)
        d = {}
        d.update(meta)
        d['html'] = html
        d['excerpt'] = cls._build_excerpt(text)
        d['src'] = path
        d['slug'] = os.path.basename(path)
        if 'date' in d:
            d['date'] = datetime.strptime(d['date'], '%Y-%m-%d')
        return d

    @classmethod
    def _build_excerpt(cls, text):
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
        return cls.md.convert('\n'.join(lines[start+1:end]))

def load_pages():
    '''Parse data and metadata for all pages.'''
    pages = []
    renderers = [MarkdownParser, IPythonNotebookParser]
    for path in glob.glob(join(PAGES_DIR, '*')):
        page = None
        for renderer in renderers:
            try:
                page = renderer.render(path)
                break
            except IOError:
                pass
        if page is None:
            raise RuntimeError('Could not handle ' + path)
        pages.append(page)
    return pages


def save_static():
    '''Duplicate the static directory in the output directory.'''
    shutil.copytree(STATIC_DIR, join(OUT_DIR, STATIC_DIR))


def clean():
    '''Remove the output directory.'''
    shutil.rmtree(OUT_DIR, True)


def main():
    '''Clean and build all pages to the output directory.'''
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