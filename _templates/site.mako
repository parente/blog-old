<%!
   current_ = 'blog'
%>
<%inherit file="base.mako" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="robots" content="index,follow">
    <title>${bf.config.blog.name} - ${bf.config.blog.owner}</title>
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/index.xml')}" />
    <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom/index.xml')}" />
    <link rel="stylesheet" type="text/css" href="${bf.util.site_path_helper(bf.config.blog.path,'css/pygments_%s.css' % bf.config.filters.syntax_highlight.style)}" />
    <link href='http://fonts.googleapis.com/css?family=Dosis:300,600' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Gentium+Basic' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/bootstrap.min.css')}" type="text/css" media="screen" />
    <link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/site.css')}" type="text/css" media="screen" />
  </head>
  <body>
    <div class="container">
      <!-- Header -->
      <header id="siteTitle">
        <h1><a href="${bf.config.site.url}">${bf.config.blog.name}</a></h1>
        <nav><a href="/">Latest</a> <a href="/posts.html">Posts</a> <a href="/about.html">About</a></nav>
      </header>

      <!-- Main Body -->
      <article id="maincolumn">
        ${next.body()}
      </article>

      <!-- Meta -->
      <div class="row" id="siteMeta">
        <div class="col-sm-4" id="contact">
          <h3>Contact</h3>
          <div>
            <a class="emailIcon" title="Email address" href="mailto:parente@cs.unc.edu">parente@cs.unc.edu</a><br/>
            <a class="githubIcon" title="GitHub account" href="http://github.com/parente">github.com/parente</a><br/>
            <a class="twitterIcon" title="Twitter account" href="http://twitter.com/parente">twitter.com/parente</a><br/>
          </div>
        </div>

        <div class="col-sm-4" id="latest">
          <h3>Latest</h3>
          <ul>
          % for post in bf.config.blog.posts[:3]:
            <li><a href="${post.path}">${post.title}</a></li>
          % endfor
          </ul>
        </div>

        <div class="col-sm-4" id="other">
          <h3>More</h3>
          <ul>
            <li><a href="/posts.html">See all posts »</a></li>
            <li><a href="${bf.util.site_path_helper(bf.config.blog.path,'feed/index.xml')}">Subscribe to posts »</a></li>
          </ul>
        </div>
      </div>

      <!-- Footer -->
      <footer id="siteFooter">
        <p class="secondary">Copyright &copy; 2008, 2013 Peter Parente. All rights reserved.</p>
      </footer>

      <%include file="footer.mako" />
    </div>
  </body>
</html>