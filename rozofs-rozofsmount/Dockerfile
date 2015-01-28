# Dockerizing RozoFS: Dockerfile for building rozofs-storaged images
# Based on rozofs-base, itself based on the official Debian image
# Installs rozofs-storaged following the instructions from:
# http://rozofs.github.io/rozofs/master/InstallingRozoFS.html

# Based on the rozofs-base image provided by denaitre
FROM denaitre/rozofs-base
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

# Installation:
# Make sure the package repository is up to date before installing storaged
RUN apt-get -y update && apt-get install -y \
    rozofs-rozofsmount

# Create the RozoFS projection data directory
RUN mkdir -p /mnt/rozofs

# Expose port 52000 from the container to the host
EXPOSE 52000

# Add the script launched when the container starts
ADD rozofs-rozofsmount.sh /usr/local/bin/rozofsmount_init.sh
RUN chmod +x /usr/local/bin/rozofsmount_init.sh

CMD /usr/local/bin/rozofsmount_init.sh && tail -f /var/log/dmesg
