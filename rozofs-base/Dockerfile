# Install RozoFS master branch
#
# $ (sudo) docker.io build -t ubuntu:rozofs_master - < rozofs_install
#
# VERSION 0.1

# Use the ubuntu base image provided by dotCloud
FROM ubuntu:latest
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Make sure the package repository is up to date
RUN apt-get -y update
RUN apt-get -y updade

# Fake fuse (otherwise package install fails)
# https://gist.github.com/henrik-muehe/6155333
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# Install wget
RUN apt-get install -y wget

# Install the release key
RUN wget -O - http://54.225.196.202/debian/devel@rozofs.com.gpg.key | apt-key add -

# Add the release package
RUN echo deb http://54.225.196.202/debian/master wheezy main | tee /etc/apt/sources.list.d/rozofs.list

# Update the package repository
RUN apt-get -y update

# Install the RozoFS packages
RUN apt-get install -y rozofs*

