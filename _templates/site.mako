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
    <link href='http://fonts.googleapis.com/css?family=Tinos:regular,italic,bold' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Nobile:regular,italic,bold' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/reset.css')}" type="text/less" media="screen" />
    <link rel="stylesheet" href="${bf.util.site_path_helper(bf.config.blog.path,'/css/fluid.less')}" type="text/less" media="screen" />
    <script src="${bf.util.site_path_helper(bf.config.blog.path,'/js/less-1.1.3.min.js')}" type="text/javascript"></script>
    <!--[if lt IE 9]>
    	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
    <![endif]-->

  </head>
  <body>
    <!-- Header -->
    <header id="top">
      <a href="${bf.config.site.url}">${bf.config.blog.name}</a>
      <!--<h1 id="siteTitle"><a href="${bf.config.site.url}">${bf.config.blog.name}</a></h1>-->
      <!--<h2 id="siteSubtitle" class="grid_6">${bf.config.blog.description}</h2>-->
    </header>

    <!-- Main Body -->
    <article id="maincolumn">
      ${next.body()}
    </article>

    <!-- Sidebar -->
    <section id="sidebar">
      <aside class="widget">
        <h3>Contact</h3>
        <div>
          Peter Parente<br/>
          <a class="emailIcon" title="Email address" href="mailto:parente@cs.unc.edu">parente@cs.unc.edu</a><br/>
          <a class="githubIcon" title="GitHub account" href="http://github.com/parente">github.com/parente</a><br/>
          <a class="twitterIcon" title="Twitter account" href="http://twitter.com/parente">twitter.com/parente</a><br/>
        </div>
      </aside>

      <aside class="widget">
        <h3>Latest posts</h3>
        <ul>
        % for post in bf.config.blog.posts[:8]:
          <li><a href="${post.path}">${post.title}</a></li>
        % endfor
        </ul>
        <div>
          <a class="feedIcon secondary" href="${bf.util.site_path_helper(bf.config.blog.path,'feed/index.xml')}">Subscribe to posts »</a>
% if bf.config.blog.disqus.enabled:
          <br/><a class="feedIcon secondary" href="http://${bf.config.blog.disqus.name}.disqus.com/latest.rss">Subscribe to comments »</a>
% endif
        </div>
      </aside>

      <aside id="info" class="widget">
        Copyright &copy; 2008, 2012 Peter Parente. All rights reserved.
      </aside>
    </section>

    <%include file="footer.mako" />
  </body>
</html>