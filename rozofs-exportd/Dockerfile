# Dockerizing RozoFS: Dockerfile for building rozofs-exportd images
# Based on rozofs-base, itself based on the official Debian image
# Installs rozofs-exportd following the instructions from:
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
    rozofs-exportd

# Create the RozoFS projection data directory
RUN mkdir -p /srv/rozofs/exports

# Expose port 53000 from the container to the host
EXPOSE 53000

# Add the rozofs-storaged configuration file
# which will need to be edited inside the container
ADD export.conf /etc/rozofs/export.conf

# Add the script launched when the container starts
ADD rozofs-exportd.sh /usr/local/bin/exportd_init.sh
RUN chmod +x /usr/local/bin/exportd_init.sh

CMD /usr/local/bin/exportd_init.sh && tail -f /var/log/dmesg
