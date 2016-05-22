FROM debian:jessie

MAINTAINER Peter Parente <parente@cs.unc.edu>

RUN apt-get update && \
    apt-get -yq install python-pip pandoc
RUN pip install pip -U
RUN pip install 'Mako==1.0.*' \
    'Markdown==2.6.*' \
    'nbconvert==4.2.*' \
    'ipython==4.2.*'

COPY . /srv/blog
WORKDIR /srv/blog
