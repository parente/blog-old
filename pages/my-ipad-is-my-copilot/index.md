---
title: My iPad Is My Copilot
date: 2011-06-05
---

For the past month, I've been running an eyes-busy, mobile computing experiment: I've been using VoiceOver on my iPad to listen to saved <a href="http://instapaper.com">Instapaper</a> articles during my 15 minute work commute. My hypothesis is that I can <em>enjoy</em> reading during my drive without sacrificing <em>safety</em>.

For the purposes of this experiment, I consider my reading enjoyable if I don't want to give up and use the screen later out of frustration with mispronunciations, poor prosody, and interruptions. At the same time, I consider my driving safe if I do not look at, touch, or think about my iPad any more than I would the car radio. These requirements might sound quite difficult to satisfy. But, <a href="/clique">as I've suggested before</a> and have once again found, you can get quite a bit of utility out of a combined audio display plus simple touch interface.

<h2>Training</h2>

To save life and limb, I first practiced using Instapaper via VoiceOver at home until I felt I had mastered the basic gestures. I don't remember exactly how long I spent on this training, but I'm sure it was significantly less than an hour.

<h2>Daily Setup</h2>

When time permits at home and work, I load up my Instapaper account with articles I want to read. Before I leave home or the office, I open the <a href="http://www.instapaper.com/iphone">Instapaper app</a> on my iPad and let it cache my articles for offline viewing. It usually finishes in a matter of seconds, long before I head out the door.

In my car, I pick the first article I want to read before I put the key in the ignition. (I might as well use the display when I can.) I prop my iPad up in locked landscape mode between the stick shift and the emergency brake handle on the center arm rest. I tap the home button three times to enable VoiceOver (a shortcut enabled in the Accessibility settings). Then I start the car, put it in gear, and start my drive.

<h2>Reading</h2>

Using Instapaper with VoiceOver requires very few gestures. A few one-finger swipes to the right skips me through the minimal UI at the top of the article. When I hear the title, a two-finger swipe down the screen starts VoiceOver reading the article continuously.

<div class="centered">
<img src="instapaper-article.jpg" class="bordered" alt="Screenshot of an article in the Instapaper iPad app" />
</div>

If I find my attention wandering, a one-finger swipe to the left backs VoiceOver up. If I hit a particularly dull section, a one-finger swipe to the right skips to the next paragraph. Another two-finger swipe down the screen starts VoiceOver reading continuously again from the new location.

Sometimes my commute is long or the article is short. If I finish reading the first article, I select another by doing the following:

<ul>
  <li>I feel for the top-left corner of the device with my fingers. This is no more complicated than searching for the buttons on my car radio.</li>
  <li>I touch the screen a little down from the top-left. This action selects the  "Articles" button. If I miss, I tap around a bit more until I hear "Articles."</li>
  <li>I double-tap anywhere on the screen to activate the "Articles" button.</li>
  <li>I tap anywhere on the far right of the screen to select any article title in my to-read list. The list is large in landscape mode and hard to miss.</li>
  <li>I listen to the titles of the other articles in my list using one-finger, left and right swipes to navigate the list.</li>
  <li>I double-tap anywhere on the screen to select the last article announced.</li>
</ul>

<div class="centered">
<img src="instapaper-home.png" class="bordered" alt="Screenshot of the Instapaper iPad home screen" />
</div>

As complicated as any of these sequences sound, I learned them with minimal practice. I can now perform them all without a single glance at the screen.

<h2>Discovered Settings</h2>

I did encounter a few gotchas along the way related to my default iPad settings.

<h3>Max-out the volume</h3>

I can hear VoiceOver well as long as the windows are up and I set my iPad volume at the maximum. Granted, my Civic's engine is a mouse compared to your V8 or Hemi. But the Civic's soundproofing isn't top-of-the-line either.

<h3>Lock the screen rotation</h3>

My commute in RTP is bumpy enough to cause the iPad's rotation to change if left unlocked. (I kid you not.) VoiceOver considers the switch so important that it stops reading, announces the change, and then often forgets what it was doing beforehand. Locking the rotation avoids this hassle.

<h3>Disable WiFi finding</h3>

With WiFi network finding enabled, my iPad manages to find quite a few networks during my drive. The network connection popup interrupts VoiceOver's reading when it appears and requires quite a few finger gymnastics to dismiss. After it's gone, I find that VoiceOver often forgets its place in the article. Disabling the "Use available networks" option sidesteps this problem entirely.

<h3>Curtain the screen</h3>

The iPad screen is an undesirable distraction and battery drain while driving. VoiceOver has a nice feature to counter it: the screen curtain. Triple-tapping with three fingers turns the screen black, saving both precious battery and human life.

<h2>Possible Improvements</h2>

My commute system is definitely not perfect. Here are couple thoughts on how it could be improved.

<h3>Skip the chrome</h3>

It would be great if a two-finger swipe down the screen started VoiceOver reading the article text immediately. Having the ability to hide the Instapaper chrome via a preference or to skip it using VoiceOver would add a little more "insta" to my setup.

<h3>Continue to the next article</h3>

A "Next" button at the end of an article would save me the complex gesture sequence required to pick another article. Such a button would be a useful shortcut during screen use of Instapaper as well, avoiding the out-and-in navigation to the articles list required today.

<h2>Outcome (So Far)</h2>

My continued use of VoiceOver plus Instapaper for over a month without a driving incident or foolish look at the screen is the best evidence I have in support of my hypothesis. I am finding the commute time quite convenient for attending to my Instapaper queue and my reading has been enjoyable.

Because of the success of the system during short commutes, I attempted something similar during two recent car trips lasting over 10 hours each. During both trips, I used VoiceOver to read many chapters of <a href="http://en.wikipedia.org/wiki/The_Night%27s_Dawn_Trilogy">The Night's Dawn</a> in iBooks. I found myself enjoying the reading for well over 6 hours each time as I drove through the night (10 PM to 9 AM). Surprisingly, the reading voice helped keep me awake rather than lulled me to sleep.

<h2>Doing More with Structured Navigation</h2>

With a little code, I think I could use VoiceOver plus Safari to go beyond reading simple, saved text articles. Imagine pre-processing your email, feed reader headlines, Twitter timeline, and so on into a single HTML document marked with simple structural elements like headings. Visit this page in Mobile Safari before leaving home or the office. Enable VoiceOver and set its <a href="http://www.apple.com/accessibility/ipad/vision.html">Rotor Control</a> to skip by headings. Start reading and use single-finger up / down flicks to navigate among the various sections.

I've also thought about tossing some JavaScript on the resulting page. Consider a section containing only email titles: a summary view of your morning inbox. A double-tap while VoiceOver reads the current title activates the standard "onclick" handler on the title's HTML element. Perhaps that click moves the focus to the body of the email stored somewhere else on the page. Maybe a double-tap on the body returns the focus back to the title.

I think I've only scratched the surface of what's possible. I intend to explore more.

<h2>No Liability Clause</h2>

I sadly think I have to say the following.

I accept no liability for any damages or losses suffered as a result of actions taken based on information contained herein. If you're dumb enough to read, compose email, play games, browse the web, etc. using your mobile device while driving, you cannot blame me when you crash and burn.
