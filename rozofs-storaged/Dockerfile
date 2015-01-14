# Dockerizing RozoFS: Dockerfile for building rozofs-storaged images
# Based on rozofs-base, itself based on the official Debian image
# Installs rozofs-storaged following the instructions from:
# http://rozofs.github.io/rozofs/master/InstallingRozoFS.html

# Based on the rozofs-base image provided by denaitre
FROM denaitre/rozofs-base
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Avoid warning during packet installations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Installation:
# Make sure the package repository is up to date before installing storaged
RUN apt-get -y update && apt-get install -y \
    rozofs-storaged

# Create the RozoFS projection data directory
RUN mkdir -p /srv/rozofs/storages

# Expose port 51000 from the container to the host
# storio, the storaged sub-process requires to expose port 41001 to
# be linked to stocli (sub-process of rozofsmount)
EXPOSE 51000 41001

# Add the rozofs-storaged configuration file
# which will need to be edited inside the container
ADD storage.conf /etc/rozofs/storage.conf

# Add the script launched when the container starts
ADD rozofs-storaged.sh /usr/local/bin/storaged_init.sh
RUN chmod +x /usr/local/bin/storaged_init.sh

CMD /usr/local/bin/storaged_init.sh && tail -f /var/log/dmesg
