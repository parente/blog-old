## -*- coding: utf-8 -*-
<%inherit file="shell.mako"/>

<%block name="header">
    <title>All Posts - ${site_name}</title>
</%block>

<%block name="mainColumn">
    <ul class="archiveList">
    <% curr = 0 %>
    % for page in all_pages:
      % if 'date' in page:
        <li class="${'yearBreak' if page['date'].year != curr else ''}"><span class="date"><span class="year">${page['date'].strftime('%Y')}</span>${page['date'].strftime('-%m-%d')}</span> &mdash; <a href="${site_root}/${page['slug']}">${page['title']}</a></li>
        <%
            curr = page['date'].year
        %>
      % endif
    % endfor
    </ul>
</%block>