<%page args="post"/>
<div class="blogPost">
  <a name="${post.slug}"></a>
  <h1 class="blogPostTitle"><a href="${post.permapath()}" rel="bookmark" title="Permalink to ${post.title}">${post.title}</a></h1>
  <p class="blogPostMeta">${post.date.strftime("%B %d, %Y at %I:%M %p")} | categories: 
<% 
   category_links = []
   for category in post.categories:
       if post.draft:
           #For drafts, we don't write to the category dirs, so just write the categories as text
           category_links.append(category.name)
       else:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
${", ".join(category_links)}
% if bf.config.blog.disqus.enabled:
 | <a href="${post.permalink}#disqus_thread">View Comments</a>
% endif
  </p>
  <div class="blog_post_prose">
    ${self.post_prose(post)}
  </div>
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>
