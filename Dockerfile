FROM debian:wheezy

MAINTAINER Peter Parente <parente@cs.unc.edu>

RUN apt-get update
RUN apt-get -yq install python-pip openssh-client rsync pandoc
RUN pip install Mako==0.9.1 Markdown==2.4 Pygments==1.6 Watchdog==0.8 ipython[nbconvert]==2.0

ADD . /srv/blog
WORKDIR /srv/blog
