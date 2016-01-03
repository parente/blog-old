title: Android Speech Synth (Where Are You?)
date: 2007-12-18

I took a peek at the [Google Android class hierarchy](http://code.google.com/android/reference/packages.html) today. As far as UI goes, it looks like there's great support for 2D/3D visuals. There's some APIs for doing MIDI and sampled sound output. There's even a class for doing speech reco.



What I don't see is anything supporting synthesized speech output. That's a bit depressing. It would be a huge boon to have an open environment for developing mobile audio apps. Talking cell phones can be a bit pricey because they're primarily intended as assistive technologies (i.e., small market). But I can imagine a ton of applications with speech-displays that could be useful to sighted and blind users alike: listening to your email while you walk instead of reading it on a tiny screen, announcements about upcoming meetings in your calendar, voice-jockey-like naming of songs about to come up on your MP3 playlist, spoken caller ID, etc.

Perhaps it's possible to add custom classes to support [FreeTTS](http://freetts.sourceforge.net/docs/index.php) or some other Java-accessible engine. However, it would be much nicer to have the speech API in the platform itself so it's available everywhere. Maybe they left it out because all the free engines are too resource hungry? Somehow, I can't imagine something like [espeak](http://espeak.sourceforge.net/) being too bulky for a mobile platform.