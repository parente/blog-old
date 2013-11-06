title: scp Backward
date: 2011-01-10



I get into this situation all the time:

1. ssh into a remote box
2. Look around for a file
3. Want to copy the file back to my local box



Maybe I'm missing some magic everyone else knows, but at this point I usually:

1. *Grumble*
2. Run pwd on the remote box
3. Copy the path to the clipboard
4. Open another console
5. scp the pasted path to my local box

or:

1. *Grumble*
2. Make sure I'm running sshd locally
3. Figure out the IP address of my local box
4. scp the file to my local box

Both suck. Here's my latest solution. As long as I have sshd running on the local machine and this script on the remote machine:

```bash
#!/bin/bash
RIP=${SSH_CLIENT%% *}
scp $@ $RIP:
```

... I can do the following:

```bash
$ ssh foobar.com
$ cd some/place
$ ls # looking ...
$ cd some/other/place
$ ls # looking ... etc.
$ rscp -r some_file_or_dir
```

... to copy `some_file_or_dir` into my home dir on my local box.