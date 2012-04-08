<%!
   current_ = 'posts'
%>
<%inherit file="_templates/site.mako" />
<%
    curr_mo = None
    curr_year = None
    started = False
%>
% for post in bf.config.blog.posts:
%   if post.date.month != curr_mo or post.date.year != curr_year:
%       if started:
</ul>
% endif
<h2>${post.date.strftime("%B %Y")}</h2>
<ul class="dated">
<%
    started = True
    curr_mo = post.date.month
    curr_year = post.date.year
%>
%   endif
    <li><span class="date">${post.date.strftime("%m-%d")}</span> - <a href="${post.path}">${post.title}</a></li>
% endfor