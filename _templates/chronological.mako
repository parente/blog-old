<%inherit file="site.mako" />
% for post in posts:
  <%include file="post.mako" args="post=post" />
  <hr class="blogPostRule" />
% endfor
% if prev_link:
 <a href="${prev_link}">« Newer Post</a>
% endif
% if prev_link and next_link:
  --  
% endif
% if next_link:
 <a href="${next_link}">Older Post »</a>
% endif
