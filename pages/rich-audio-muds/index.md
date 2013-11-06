title: Rich Audio MUDs
date: 2008-05-29



Gary has mentioned that sound adventure games like [Descent into Madness](http://www.cs.unc.edu/Research/assist/et/2005/SoundsLikeFun.html) and [The Last Crusade](http://www.cs.unc.edu/Research/assist/et/projects/RPG/TheLastCrusade.htm) have served as effective rewards in some local schools. Kids with visual impairments work hard in order to earn time playing them.



I've been brainstorming a bit about open-ended multi-user dungeons (MUDs) with rich sound and speech. Gary thinks it would be beneficial to use the MUD for educational purposes, not just as a reward after the work is done. I tend to agree, as long as its easy for teachers, older students, parents, and so on to translate lessons into in-game puzzles and adventures.

Here are some ideas I think could go into such a system to make it fun and rewarding for the kids, and an interesting platform for games.

* Rooms and items. A simple setup including the entire dungeon, rooms with arbitrary connections, items in rooms, and users in rooms can should account for a large number of adventure game designs.
* A basic command set. Take, drop, give, use, go, and a few other very simple commands can be supported everywhere to let the user navigate and interact with the environment.
* An extensible parser. Items can define additional supported commands, even to the extent where the become...
* In-world games. To go beyond exploring rooms, picking up items, and using items, items and rooms themselves can become full games. Imagine a puzzle game as an item or a room where everyone is participating in a guessing game.
* Other input methods. Items can reconfigure the keyboard to support simpler methods of interaction. For example, an multiple choice game might require only use of the arrow keys instead of requiring the user to enter full sentences. A game might enable other devices too (e.g., DDR pad).
* A rich audio client. Most MUD clients are text-only. When used with a screen reader, the game experience is entirely spoken. With a custom client, the game logic can provide responses the client renders as speech and sound in any number of streams.
* A client/server configuration over XMPP. The dungeon lives on a server, though not necessarily the same machine as the XMPP server. Instead, it's just another XMPP client with a well known JID. A bot of sorts. The rooms and items can be objects managed by that bot, or even become other bots themselves. The dungeon can exist across multiple machines.
* Collaboration. Rooms in the dungeon are like chat rooms where some text entered in the client is broadcast to everyone, and other commands are addressed to items in rooms. Going beyond simple text, clients could implement XMPP Jingle to support voice chat.

Is anyone working on a similar project? Heard of a similar project?