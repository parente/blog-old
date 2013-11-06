## -*- coding: utf-8 -*-
<%inherit file="shell.mako"/>
<%block name="header">
  <title>${page['title']} - ${site_name}</title>
</%block>

<%block name="mainColumn">
  <h1 class="pageTitle">${page['title']}</h1>
  % if 'date' in page:
    <p class="pageDate">${page['date'].strftime('%B %d, %Y')}</p>
  % endif
  ${page['html']}
</%block>

<%block name="pageMeta">
  % if 'next' in page:
    <div class="footerSection" id="pageMeta">
        <h3>Another Read: <a href="${site_root}/${page['next']['slug']}">${page['next']['title']} &#187;</a></h3>
        <div class="excerpt">${page['next']['excerpt']}</div>
    </div>
  % endif
</%block>