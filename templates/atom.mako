## -*- coding: utf-8 -*-
<?xml version="1.0" encoding="UTF-8"?><% from datetime import datetime %>
<feed
  xmlns="http://www.w3.org/2005/Atom"
  xmlns:thr="http://purl.org/syndication/thread/1.0"
  xml:lang="en"
   >
  <title type="text">${site_name}</title>
  <subtitle type="text">Blog of Peter Parente</subtitle>

  <updated>${datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")}</updated>
  <generator>custom</generator>
  <link rel="alternate" type="text/html" href="${site_domain}" />
  <id>${site_domain}/feed/atom/</id>
  <link rel="self" type="application/atom+xml" href="${site_domain}/feed/atom/" />
% for page in latest_pages:
  <entry>
    <author>
      <name>${site_author}</name>
      <uri>${site_domain}</uri>
    </author>
    <title type="html"><![CDATA[${page['title']}]]></title>
    <link rel="alternate" type="text/html" href="${site_domain}${site_root}/${page['slug']}/" />
    <id>${site_domain}${site_root}/${page['slug']}/</id>
    <updated>${page['date'].strftime("%Y-%m-%dT%H:%M:%SZ")}</updated>
    <published>${page['date'].strftime("%Y-%m-%dT%H:%M:%SZ")}</published>
    <summary type="html"><![CDATA[${page['title']}]]></summary>
    <content type="html" xml:base="${site_domain}${site_root}/${page['slug']}/"><![CDATA[${page['excerpt']}]]></content>
  </entry>
% endfor
</feed>
