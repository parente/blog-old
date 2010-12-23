<%inherit file="base.mako" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="robots" content="index,follow">
    <title>${bf.config.blog.name}</title>
    <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/index.xml')}" />
    <link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom/index.xml')}" />
    <link rel="stylesheet" type="text/css" href="${bf.util.site_path_helper(bf.config.blog.path,'css/reset.css')}" />
    <link rel="stylesheet" type="text/css" href="${bf.util.site_path_helper(bf.config.blog.path,'css/960.css')}" />
    <link rel="stylesheet" type="text/css" href="${bf.util.site_path_helper(bf.config.blog.path,'css/site.css')}" />
    <!--[if lt IE 9]>
    	<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
    <![endif]-->    
  </head>
  <body>
    <div id="wrapper" class="container_12">
      <header id="header" class="grid_12">
        <h1><a href="${bf.config.site.url}">${bf.config.blog.name}</a></h1>
        <h2>${bf.config.blog.description}</h2>
      </header>
      <div id="content">
        
        <nav id="menu" class="grid_12">
          <ul>
            <li>Blog</li>
            <li>About</hi>
            <li>Papers</li>
            <li>Clique</li>
          </ul>
        </nav>
        
        <div id="main" class="grid_9">
          ${next.body()}
        </div>

        <div id="sidebar" class="grid_3">
          <aside class="widget">
            <h3>Contact</h3>
            Peter Parente<br/>
            <a class="emailIcon" title="Email address" href="mailto:parente@cs.unc.edu">parente@cs.unc.edu</a><br/>
            <a class="githubIcon" title="GitHub account" href="http://github.com/parente">github.com/parente</a><br/>
            <a class="twitterIcon" title="Twitter account" href="http://twitter.com/parente">twitter.com/parente</a><br/>
          </aside>

          <aside class="widget">
            <h3>Latest posts</h3>
            <ul>
            % for post in bf.config.blog.posts[:5]:
              <li><a href="${post.path}">${post.title}</a></li>
            % endfor
            </ul>
            <a class="feedIcon secondary" href="${bf.util.site_path_helper(bf.config.blog.path,'feed/')}">Subscribe to posts »</a>
% if bf.config.blog.disqus.enabled:
            <br/><a class="feedIcon secondary" href="http://${bf.config.blog.disqus.name}.disqus.com/latest.rss">Subscribe to comments »</a>
% endif
          </aside>

          <aside class="widget">
            <h3>Archives</h3>
              <select onchange="location=this.options[this.selectedIndex].value;">
              % for link, name, num_posts in bf.config.blog.archive_links:
                <option value="${bf.util.site_path_helper(bf.config.blog.path,link)}/1">${name}&nbsp;(${num_posts})</option>
              % endfor
              </select>
          </aside>

          <aside id="greader" class="widget">
            <script type="text/javascript" src="http://www.google.com/reader/ui/publisher-en.js"></script>
<script type="text/javascript" src="http://www.google.com/reader/public/javascript/user/15451515962691441753/state/com.google/broadcast?n=5&callback=GRC_p(%7Bc%3A%22-%22%2Ct%3A%22Google%20Reader%22%2Cs%3A%22true%22%2Cn%3A%22true%22%2Cb%3A%22false%22%7D)%3Bnew%20GRC"></script>
          </aside>
        </div>
        
        <footer id="footer" class="grid_12">
          <p>Copyright &copy; 2011 Peter Parente. All rights reserved.</p>
          <p>Powered by <a href="http://blogofile.com">Blogofile</a></p>
        </footer>
      </div>
    </div>
    <%include file="footer.mako" />
  </body>
</html>
