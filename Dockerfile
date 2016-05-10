FROM debian:wheezy

MAINTAINER Peter Parente <parente@cs.unc.edu>

RUN apt-get update && \
    apt-get -yq install python-pip openssh-client rsync pandoc
RUN pip install Mako==0.9.1 Markdown==2.4 Pygments==1.6 Watchdog==0.8.2 ipython[nbconvert]==2.0

COPY . /srv/blog
WORKDIR /srv/blog
