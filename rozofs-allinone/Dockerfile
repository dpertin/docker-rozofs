# Set RozoFS all-in-one container

# Use rozofs-base image provided by denaitre
FROM denaitre/rozofs-base
MAINTAINER denaitre, dimitri.pertin@univ-nantes.fr

ENV DEBIAN_FRONTEND noninteractive
# Allow services to start after installation
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Make sure the package repository is up to date
RUN apt-get -y update && apt-get install -y \
    rozofs-*

# Add two script:
#       * bootstrap.sh required for image building
#       * rozofs.sh required for container booting
ADD bootstrap.sh /tmp/bootstrap.sh
ADD rozofs.sh /tmp/rozofs.sh
RUN chmod +x /tmp/bootstrap.sh
RUN chmod +x /tmp/rozofs.sh

ENV ROZO_EXPORT_HOSTNAME localhost
          
RUN /tmp/bootstrap.sh

EXPOSE 50027 51000 50028 41001 50000 53000 52000 50003 50004

CMD /tmp/rozofs.sh && tail -F /var/log/dmesg

