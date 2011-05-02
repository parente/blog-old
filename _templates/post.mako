<%page args="post"/>
<div class="blogPost">
  <a name="${post.slug}"></a>
  <h1 class="blogPostTitle"><a href="${post.permapath()}" rel="bookmark" title="Permalink to ${post.title}">${post.title}</a></h1>
  <p class="blogPostMeta">${post.date.strftime("%B %d, %Y at %I:%M %p")} | Tags: 
<% 
   tag_links = []
   for tag in post.tags:
       if post.draft:
           #For drafts, we don't write to the tag dirs, so just write the categories as text
           tag_links.append(tag.name)
       else:
           tag_links.append("<a href='%s'>%s</a>" % (tag.path, tag.name))
%>
${", ".join(tag_links)}
% if bf.config.blog.disqus.enabled:
 <br /><a href="${post.permalink}#disqus_thread">View Comments</a>
% endif
  </p>
  <div class="blog_post_prose">
    ${self.post_prose(post)}
  </div>
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>
