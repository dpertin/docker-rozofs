# Dockerizing RozoFS: Dockerfile for building rozofs-exportd images
# Based on rozofs-base, itself based on the official Debian image
# Installs rozofs-exportd following the instructions from:
# http://rozofs.github.io/rozofs/master/InstallingRozoFS.html

# Based on the rozofs-base image provided by denaitre
FROM denaitre/rozofs-base
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Installation:
# Make sure the package repository is up to date before installing storaged
RUN apt-get -y update && apt-get install -y \
    rozofs-exportd \
    rsyslog

# Expose port 53000 from the container to the host
EXPOSE 53000

ADD rozofs-exportd.sh /usr/share/local/bin/rozofs-exportd-init.sh
RUN chmod +x /usr/share/local/bin/rozofs-exportd-init.sh

CMD /usr/share/local/bin/rozofs-exportd-init.sh

