<%page args="current"/>
        <nav id="menu" class="grid_12">
          <ul>
            ${menuLink('/', 'Blog')}
            ${menuLink('/about.html', 'About')}
            ${menuLink('/software.html', 'Software')}
            ${menuLink('/clique.html', 'Clique')}
            ${menuLink('/papers.html', 'Papers')}
          </ul>
        </nav>
<%def name="menuLink(link, text)" ><% 
  if current == text.lower():
    cl = ' class="menuCurrent"'
  else:
    cl = ''
  %><li${cl}><a href="${link}">${text}</a></li>
</%def>
