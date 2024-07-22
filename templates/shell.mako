## -*- coding: utf-8 -*-
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="robots" content="index,follow">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%block name="header">
      <title>${site_name}</title>
    </%block>
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${site_root}/feed/index.xml" />
    <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${site_root}/feed/atom/index.xml" />
    <link rel="stylesheet" type="text/css" href="${site_root}/static/css/pygments.css" />
    <link rel="stylesheet" href='//fonts.googleapis.com/css?family=Dosis:300,600' type='text/css'>
    <link rel="stylesheet" href='//fonts.googleapis.com/css?family=Gentium+Basic' type='text/css'>
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" integrity="sha384-T8Gy5hrqNKT+hzMclPo118YTQO6cYprQmhrYwIiQ/3axmI1hQomh7Ud2hPOy8SP1" crossorigin="anonymous">
    <link rel="stylesheet" href="${site_root}/static/css/site.css" type="text/css" />
  </head>
  <body>
    <div class="container">
      <!-- Header -->
      <header id="siteTitle">
        <h1><a href="${site_root}/">${site_name}</a></h1>
        <nav>
          <a href="${site_root}/">Latest</a>
          <a href="${site_root}/posts/">Posts</a>
          <a href="${site_root}/about/">About</a>
        </nav>
      </header>

      <!-- Main Body -->
      <article id="mainColumn">
        <%block name="mainColumn" />
      </article>

      <!-- Meta -->
      <%block name="pageMeta" />

      <div class="row footerSection" id="siteMeta">
        <div class="col-md-4" id="contact">
          <h3>Contact</h3>
          <div>
            <i class="fa fa-envelope-o fa-fw"></i> <a title="Email address" href="mailto:parente@gmail.com">parente@gmail.com</a><br/>
            <i class="fa fa-github fa-fw"></i> <a title="GitHub account" href="https://github.com/parente">github.com/parente</a><br/>
            <i class="fa fa-linkedin fa-fw"></i> <a title="LinkedIn account" href="https://linkedin.com/in/parente">linkedin.com/in/parente</a><br/>
          </div>
        </div>

        <div class="col-md-5" id="latest">
          <h3>Latest</h3>
          <ul>
          % for recent in all_pages[:4]:
            <li><a href="${site_root}/${recent['slug']}">${recent['title']}</a></li>
          % endfor
          </ul>
        </div>

        <div class="col-md-3" id="other">
          <h3>More</h3>
          <ul>
            <li><a href="${site_root}/posts/">See all posts &#187;</a></li>
            <li><a href="${site_root}/feed/index.xml">Subscribe to posts &#187;</a></li>
          </ul>
        </div>
      </div>

      <!-- Footer -->
      <footer id="siteFooter" class="footerSection">
        <p class="footerText">Copyright &copy; 2008, 2024 Peter Parente. All rights reserved. Except for materials otherwise noted. </p>
      </footer>
    </div>
  </body>
</html>