FROM debian:jessie

MAINTAINER Peter Parente <parente@cs.unc.edu>

RUN apt-get update && \
    apt-get -yq install python-pip pandoc git
RUN pip install pip -U
RUN pip install 'mako==1.0.*' \
    'markdown==2.6.*' \
    'nbconvert==4.2.*' \
    'ipython==4.2.*' \
    'pyyaml==3.11'

COPY . /srv/blog
WORKDIR /srv/blog
