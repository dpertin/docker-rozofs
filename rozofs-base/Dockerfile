# Install RozoFS master branch

# Use the debian base image provided on Docker Hub
FROM debian:latest
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Make sure the package repository is up to date and install required packages
RUN apt-get -y update && apt-get install -y \
    wget \
    lsb-release

# Avoid warning during packet installations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install the release key
#RUN wget -O - http://dl.rozofs.org/debian/devel@rozofs.com.gpg.key | apt-key add -
RUN wget -O - http://54.225.196.202/debian/devel@rozofs.com.gpg.key | apt-key add -

# Set the RozoFS repository to access RozoFS packages
#RUN echo deb  http://dl.rozofs.org/debian/master $(lsb_release -sc) main | tee /etc/apt/sources.list.d/rozofs.list
RUN echo deb  http://54.225.196.202/debian/master $(lsb_release -sc) main | tee /etc/apt/sources.list.d/rozofs.list

# Install RozoFS manager (optionally) required for all nodes
RUN apt-get -y update && apt-get install -y \
    rozofs-manager*

CMD tail -f /var/log/dmesg
