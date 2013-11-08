title: Watch Vagrant Changes
date: 2013-11-07

[Vagrant]() is a great tool for a building consistent, reproducible development environments. I can include a Vagrantfile in my code base, type `vagrant up` and `vagrant ssh` in my project folder, install project dependences in the Vagrant VM, and then run my code in the convenient `/vagrant` project mount. Meanwhile, I can continue to write my code and view the results on my Mac. It's a nice setup, especially when I need to hop among projects with very different setups or need to trash a VM due to conflicting libs or other damage.

One gotcha I've found using Vagrant and VirtualBox occurs when I use tools that watch the filesystem like [node-supervisor](https://github.com/isaacs/node-supervisor) and [wr](https://github.com/pmuellr/wr). These utils are handy when I want my test suite to execute, or my static code to compile, or my web app server to restart each time I make changes to my code base. Unfortunately, they fail to monitor the VirtualBox mounted `/vagrant` folder effectively, undoubtedly because of some VirtualBox shared folder magic.

For instance, when I do the following in the VM:

```console
vagrant@vm:~$ npm install -g wr
vagrant@vm:~$ mkdir /vagrant/tmp
vagrant@vm:~$ touch /vagrant/tmp/foo
vagrant@vm:~$ wr "echo CHANGED" /vagrant/tmp
01:43:10 wr: watching 1 files, running 'echo CHANGED'
```

and then edit the `foo` file on my Mac, nothing happens. Occasionally, I'll see "CHANGED" printed, but it's entirely unpredictable.

An idea struck me the other day about how to overcome this problem: watch the filesystem outside the VM and get the command to run inside using SSH. It sounds nasty but the cost is minimal: a one-time setup and a minor addition to the command I want to run.

First, I install my watch utility on my Mac and save a copy of my project Vagrant SSH config file.

```console
parente@mac:~/myproject$ npm install -g wr
parente@mac:~/myproject$ vagrant ssh-config > .ssh-config
```

Then, I run my watch tool on my Mac with an `ssh` command to run on change. Typically I hide this in whatever the project is using for automation (e.g., bash script, Makefile).

```console
parente@mac:~/myproject$ wr "ssh -F .ssh-config default ls -l /vagrant/tmp" .
21:09:36 wr: watching 3 files, running 'ssh -F .ssh-config default ls -l /vagrant/tmp'
```

Finally, when I make a code change on my Mac, I see `wr` ssh into my VM and execute my command immediately, as desired.

```console
21:11:16 wr: file changed

21:11:16 wr: running 'ssh -F .ssh-config default ls -l /vagrant/tmp'

total 4
-rw-r--r-- 1 vagrant vagrant 7 Nov  8 02:11 foo
21:11:16 wr: 0.1s - command succeeded
```

The same trick works whether I want to run `make build` or `mocha` or `fab deploy` within my VM.

There can be a slight delay as SSH reconnects on each change. But even this minor annoyance can be overcome by enabling SSH connection sharing and keeping a second secure shell connected to the VM.

```console
parente@mac:~/myproject$ echo "\nControlMaster auto\nControlPath /tmp/ssh_mux_%h_%p_%r" >> ~/.ssh/config
parente@mac:~/myproject$ vagrant ssh
vagrant@tottbox:~$
```

I've been successfully using this recipe for a little while now. If you have an alternative or better workaround, I'd love to hear from you.