# Install RozoFS master branch
#
# $ (sudo) docker.io build -t ubuntu:rozofs_master - < rozofs_install
#
# VERSION 0.1

# Use the debian base image provided by the Docker Hub
FROM debian:latest
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Make sure the package repository is up to date
RUN apt-get -y update
RUN apt-get -y updade

# Install wget
RUN apt-get install -y wget

# Install the release key
RUN wget -O - http://dl.rozofs.org/debian/devel@rozofs.com.gpg.key | apt-key add -

# Add the release package
RUN echo deb http://dl.rozofs.org/debian/master $(lsb_release -sc) main | tee /etc/apt/sources.list.d/rozofs.list

# Update the package repository
RUN apt-get -y update

