<%page args="post"/>
<div class="blogPost">
  <a name="${post.slug}"></a>
  <h1 class="blogPostTitle"><a href="${post.permapath()}" rel="bookmark" title="Permalink to ${post.title}">${post.title}</a></h1>
  <p class="blogPostMeta">${post.date.strftime("%B %d, %Y")}</p>
  <div class="blogPostProse">
    ${self.post_prose(post)}
  </div>
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>