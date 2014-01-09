Title: pass on OSX
Date: 2014-01-08

I setup [pass](http://zx2c4.com/projects/password-store/) on my OSX boxes as a simple password manager. The doc for `pass` is good, but assumes you have a GPG key already. Here's what I did top to bottom.

```bash
desktop$ brew update
desktop$ brew install pass

# create a key, answer all prompts
desktop$ gpg2 --gen-key

# init password store using email from key
desktop$ pass init parente@cs.unc.edu

# add passwords
desktop$ pass insert Home/wifi
desktop$ pass insert Home/rpi
desktop$ pass insert Webfaction/panel

# make it a git repo
desktop$ pass git init

# export keys for laptop
desktop$ gpg2 --export parente@cs.unc.edu > /tmp/key.pub
desktop$ gpg2 --export-secret-key parente@cs.unc.edu > /tmp/key

# import keys on laptop
laptop$ scp desktop:/tmp/key* /tmp
laptop$ gpg2 --import /tmp/key.pub
laptop$ gpg2 --import /tmp/key

# git clone to laptop
laptop$ git clone desktop/.password-store ~/.password-store
```