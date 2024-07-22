---
title: Introducing the OpenCoweb Project
date: 2011-04-25
---

I've been part of a project at IBM since 2007, exploring what our team calls <em>cooperative web</em> concepts: multi-user interaction and audio/video conferencing within web applications. In January, IBM approved our team's proposal to release a portion of this work as the <a href="http://opencoweb.org">Open Cooperative Web Framework</a>, or OpenCoweb for short. This release features a JavaScript API for adding lock-free, concurrent editing to new or existing web applications. The keystone in the framework is an <a href="http://en.wikipedia.org/wiki/Operational_transformation">operational transformation</a> (OT) algorithm that guarantees all users converge to the same shared state.

<h2>Applying OT</h2>

Operational transformation is most often associated with collaborative text editors in which all users can make changes to the document at the same time. While text-editing was the original embodiment of OT, and is certainly still a great application of the technique, operational transformation can prove useful in other domains. Consider some sample cooperative web applications in which:

  <ul>
    <li>a team of software developers can triage bugs together (think: real-time cooperative GitHub issue tracker)</li>
    <li>a realtor and potential out-of-state buyer can review properties of interest together</li>
    <li>friends can plan and adjust a vacation route, landmarks to visit, and trip todo list as a group</li>
    <li>co-workers can update a shared mind-map during brainstorming sessions</li>
  </ul>

All of these applications require some form of consistency-maintenance to ensure remote instances do not get out-of-sync. OT can fill this role without the need for pessimistic locks or sluggish server acknowledgements that can hamper cooperation. For example, OT can allow both the realtor and buyer to simultaneously create and sort a list of interesting properties to visit without forced turn-taking or "click-to-edit" controls.

The OpenCoweb framework enables OT in any application domain as long as the application adheres to a few simple rules. For example, the triage app noted above would need to indicate the assignment of a label to a bug as an "insert" type event and the removal of a label as a "delete". In return, the framework algorithm would guarantee all users end up seeing the same set of labels on the bug, even in the face of simultaneous, conflicting label changes by multiple users.

<h2>Design and implementation</h2>

From the outset, we attempted to design OpenCoweb to be a small, unobtrusive framework. The JavaScript API exists as a set of modules in <a href="http://wiki.commonjs.org/wiki/Modules/AsynchronousDefinition">AMD format</a> for cross-toolkit compatibility. An application uses the API to join cooperative sessions and transmit events while the framework worries about transforming events for convergence and inbound/outbound event delivery.

The two server implementations, one in Java using <a href="http://cometd.org">CometD</a> and the other in Python on <a href="http://tornadoweb.org">Tornado</a>, are simple event relays that work out-of-the-box or can be extended to dictate access control, provide additional services, and so on. The OpenCoweb protocol between the framework JavaScript and server of choice is defined as an extension to <a href="http://cometd.org/documentation/bayeux/spec">Bayeux</a> with either a comet long-polling technique or a WebSocket providing the transport underneath. Again, a web application developer need not worry about these details in most cases. Nevertheless, the framework can support new server implementations (e.g. on <a href="http://nodejs.org/">Node</a>) and even other protocols (e.g., <a href="http://socket.io/">socket.io</a>) if so desired.

<h2>For more information</h2>

The <a href="http://opencoweb.org">project home page</a>, <a href="http://opencoweb.org/ocwdocs">developer documentation</a>, and <a href="http://github.com/opencoweb/coweb">README on GitHub</a> have plenty of additional details about OpenCoweb. I believe the <a href="http://opencoweb.org/ocwdocs/intro/openg.html">treatment of OT in our docs</a> is very accessible for those seeking a gentle introduction to the topic. At the same time, I think our framework is well suited to those wanting to reap the benefits of OT without worrying much about its specifics, as evidenced by <a href="http://opencoweb.org/ocwdocs/tutorial/shopping.html">our step-by-step tutorial</a>.

If you'd like to get involved, subscribe to our <a href="https://groups.google.com/group/opencoweb"> our Google Group</a>, join our <a href="http://webchat.freenode.net?randomnick=1&channels=coweb&uio=d4">#coweb channel on Freenode</a>, or fork our code and send <a href="http://github.com/opencoweb/coweb">pull requests on GitHub</a>.
