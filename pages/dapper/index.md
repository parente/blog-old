---
title: Dapper
date: 2007-07-07
---

Problem - I want to track water conservation notices in my county, but [ncwater.org](http://www.ncwater.org/) does not offer feeds or alerts of any kind. It only has static HTML pages generated via form input.

Solution - My very own [NC Water Management Dapp](http://www.dapper.net/dapp-howto-use.php?dappName=NCWaterManagement). I can now consume notices about water restrictions in an RSS feed, NetVibes module, XML doc, email alert, JSON, CSV, and about seven other formats.

I'd toyed with [Dapper](http://www.dapper.net/) before. It sounded like an interesting concept: point Dapper to similar pages, show it what inputs generated that page, tell it what output is important on the page, and choose an output format for the scraped data. Admittedly, I shrugged it off. Why would I want to screen scrape a site? Doesn't everyone provide RSS/Atom feeds, email alerts, text messages, etc. these days?

How easy I forget that not everyone is so tech-savvy. I can thank Google for making me so naive. 'What do you mean I can't get service X delivered in format Y to my device Z?!'

Anyway, now I see how truly useful Dapper can be. I spent about fifteen minutes teaching it:

1. What input to use on the [Check water use restriction status page](http://www.ncwater.org/Drought_Monitoring/reporting/index.php)
2. What output from the county [Water system summary page](http://www.ncwater.org/Drought_Monitoring/reporting/displaysystems.php) to scrape
3. How to group the output information
4. What output format to produce from the data

If you haven't seen Dapper already, I recommend [watching the demo](http://www.dapper.net/dapperDemo/) or toying with it yourself. It appears capable of doing quite a bit more than what I tested today.
