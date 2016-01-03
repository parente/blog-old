title: Spaceship!
date: 2009-05-24



<p>When Gary announced <a href="http://wwwx.cs.unc.edu/~gb/wp/blog/2008/07/27/outfox-speech-sound-and-more-for-firefox/">Outfox</a> back in 2008, all manner of ideas for using speech and sound in the browser popped into my head. I've always had the <a href="http://mindtrove.info/clique/">boring demos</a> (i.e., for adults) at <a href="http://wwwx.cs.unc.edu/~gb/wp/blog/2008/01/22/maze-day-2008/">Maze Day</a>, so I decided to work first on a fun, somewhat educational, self-voicing browser game for <a href="http://wwwx.cs.unc.edu/~gb/wp/blog/2009/02/15/maze-day-2009/">the 2009 rendition</a>. After all, keeping the mostly under-13, soda drinking, pizza eating, game playing clientele happy is always priority #1 at Maze Day.</p>



<p>The result is Spaceship!, a JavaScript game for Firefox built using <a href="http://creativecommons.org/">Creative Commons</a> licensed music, sound, speech, and graphics; the <a href="http://dojotoolkit.org">Dojo toolkit</a>; and the <a href="http://code.google.com/p/outfox">Outfox add-on</a>. In the primary portion of the game, the player fires shots at a grid of tiles trying to hit enemy ships. When the player runs out of ammo, he or she plays a set of minigames in an attempt to earn more shots. Of course, hazards and bonuses abound to keep things interesting.</p>

<p>A text description is nice, but you're better off watching the gameplay video below to really understand what I'm jabbering about. Or, better yet, grab <a href="http://code.google.com/p/outfox">Outfox</a> and <a href="http://www.mozilla.com/en-US/firefox/personal.html?from=getfirefox">Firefox 3</a>.</p>

<iframe src="//player.vimeo.com/video/4812387" width="640" height="480" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

<p>What a great exercise this turned out to be! The payoff has been manyfold:</p>

<ol>
    <li>I learned a ton more about Dojo and writing custom widgets.</li>
    <li>I developed some interesting MVC techniques for aural+visual event driven apps in Dojo. I hope to blog about these.</li>
    <li>I built some nice, reusable Dojo components for future browser games.</li>
    <li>I got to show off client-side music, sound, and speech in Firefox with pure JS. Maybe this will spur development of other audio apps?</li>
    <li>I drummed up some interest in extending Spaceship! with new minigames. Hopefully more coming soon.</li>
    <li>My wife was entertained. Yes, she will actually ask to play the game if she sees me working on it.</li>
    <li>I had lots of teachers ask when the game will be online at Maze Day. Well, here it is, a month later.</li>
    <li>And, most importantly, a steady stream of kids (and adults) got to play it at Maze Day. Hopefully even more can enjoy it now online.</li>
</ol>

<p>If you try it out, leave a comment. It's new, there are bugs, and there is room for improvement. But anything you report will help in making the game better.
</p>

<p>I owe many thanks to the artists who made their wonderful images, songs, and sounds available under open licenses. Their names appear in the <em>Credits</em> section off the main game menu. Be sure to check them out.
</p>

<p>Oh, and of course the game code itself is <a href="http://creativecommons.org/licenses/BSD/">BSD-licensed</a>. Grab the code from <del><a href="http://svn.mindtrove.info/spaceship">http://svn.mindtrove.info/spaceship</a></del> <a href="http://github.com/parente/spaceship">http://github.com/parente/spaceship</a> if you're feeling adventurous.</p>