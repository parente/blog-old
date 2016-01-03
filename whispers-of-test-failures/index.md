title: Whispers of Test Failures
date: 2014-04-19

Yesterday, I learned that support for the [speech synthesis portion of the Web Speech API spec](https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html#tts-section) landed in Chrome stable. I also learned that I'm behind the curve given that the [HTML5 Rocks Speech Synthesis tutorial](http://updates.html5rocks.com/2014/01/Web-apps-that-talk---Introduction-to-the-Speech-Synthesis-API) was published nearly four months ago. I immediately set out to rectify this situation by having my browser whisper my frontend test failures to me.

<div class="centered">
  <a href="http://s1000.photobucket.com/user/LanningCk/media/Gifs/explain.gif.html" target="_blank"><img src="http://i1000.photobucket.com/albums/af128/LanningCk/Gifs/explain.gif" class="rounded" alt="Image of Dalek exclaiming EXPLAIN!"/></a>
</div>

I've been playing the part of frontend web dev recently at work. While I'm developing, I keep my [Mocha](http://visionmedia.github.io/mocha/) test runner page open in Chrome with [LiveReload](http://livereload.com/) automatically refreshing the page every time I save a file. As I write new tests and code, I keep an eye on the Mocha results to ensure I'm not seriously regressing previous work. It's a decent, single-browser sanity check, but it does take up valuable screen space and requires flickers of my visual attention.

<div class="centered">
  <a href="http://imgur.com/J41wqlY"><img class="rounded" src="http://i.imgur.com/J41wqlY.jpg" alt="Image of Cyberman saying YOU WILL BE UPGRADED" title="Hosted by imgur.com" /></a>
</div>

Enter Chrome text-to-speech. I added a bit of JavaScript to our Mocha test runner that speaks aloud the test case failure count. With this addition, I keep the test page tab in the background and simply listen for failure announcements to get an idea of how badly I've broken my sandbox.

Here's the relevant code in the context of a RequireJS callback.

```javascript
requirejs([
    'jquery',
    'mocha',
    'should',
    'test_foo',
    'test_bar'
], function($, mocha) {
  // Ignore livereload if used
  mocha.checkLeaks(['LiveReload']);

  if(window.speechSynthesis) {

    // I want my Mac whispering, so I have to wait for the voiceschanged
    // event to fire. If I weren't so picky, I wouldn't need this listener.
    $(speechSynthesis).on('voiceschanged', function() {

      // Run my tests
      var run = mocha.run(function() {

        // Got failures? Fire up the text-to-speech!
        if(run.failures) {
          // I've got a Mac. I know this voice exists. I'm primarily doing this
          // for myself so ... hardcode!
          var v = speechSynthesis.getVoices().filter(function(voice) {
              return voice.name == 'Whisper';
          });
          // Build an utterance
          var msg = new SpeechSynthesisUtterance(run.failures + 'failed');
          // Set the voice properties
          if(v.length) msg.voice = v[0];
          msg.rate = 1;
          // And ...
          speechSynthesis.speak(msg);
        }

      });

    });

  } else {
    // Don't break mute browsers
    mocha.run();
  }

});
```

The upgrade works wonderfully, with a rare browser tab crash that I'm sure the Chrome devs will iron out in due time. Beyond that, one change might make it better: an appropriately villainous robotic voice.

<div class="centered">
  <a href="http://imgur.com/CvoLSHs"><img class="rounded" src="http://i.imgur.com/CvoLSHs.jpg?1" title="Hosted by imgur.com" alt="Image of Weakest Link Robot Host from Doctor Who saying GOODBYE" /></a>
</div>

<p class="footnote">All images on this page are third-party works derived from robots of the <a href="http://www.bbc.co.uk/programmes/b006q2x0">Doctor Who</a> universe, copyright <a href="http://www.bbc.com">the BBC</a>, producers of quintessential synthetic voices.</p>