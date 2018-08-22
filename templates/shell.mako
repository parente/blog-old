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
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" integrity="sha384-T8Gy5hrqNKT+hzMclPo118YTQO6cYprQmhrYwIiQ/3axmI1hQomh7Ud2hPOy8SP1" crossorigin="anonymous">
    <link rel="stylesheet" href="${site_root}/static/css/site.css" type="text/css" media="screen" />

    <!-- Google Analytics -->
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-50187496-1', 'mindtrove.info');
      ga('send', 'pageview');

    </script>
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
            <i class="fa fa-envelope-o fa-fw"></i> <a title="Email address" href="mailto:parente@cs.unc.edu"> parente@cs.unc.edu</a><br/>
            <i class="fa fa-github fa-fw"></i> <a title="GitHub account" href="https://github.com/parente">github.com/parente</a><br/>
            <i class="fa fa-twitter fa-fw"></i> <a title="Twitter account" href="https://twitter.com/parente">twitter.com/parente</a><br/>
            <i class="fa fa-google-plus fa-fw"></i> <a title="Google Plus account" href="https://plus.google.com/108324270881375083602/">google.com/+PeterParente</a>
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
        <p class="footerText">Copyright &copy; 2008, 2018 Peter Parente. All rights reserved. Except for materials otherwise noted. </p>
      </footer>
    </div>
  </body>
</html>