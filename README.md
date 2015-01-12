
# Docker-RozoFS

This project is about dockerizing **RozoFS**.

### What is RozoFS?

RozoFS is a scale-out NAS file system. RozoFS aims to provide an open source
high performance and high availability scale out storage software appliance
for intensive disk IO data center scenario. It comes as a free software,
licensed under the GNU GPL v2. RozoFS provides an easy way to scale to
petabytes storage but using erasure coding it was designed to provide very high
availability levels with optimized raw capacity usage on heterogeneous commodity
hardwares.

RozoFS provide a native open source POSIX file system, build on top of a usual
out-band scale-out storage architecture. The RozoFS specificity lies in the way
data is stored. The data to be stored is translated into several chunks named
projections using Mojette Transform and distributed across storage devices in
such a way that it can be retrieved even if several pieces are unavailable. On
the other hand, chunks are meaningless alone. Redundancy schemes based on
coding techniques like the one used by RozoFS allow to achieve significant
storage savings as compared to simple replication.

### What is Docker?

Docker is an open platform for developers and sysadmins to build, ship, and run
distributed applications. Consisting of Docker Engine, a portable, lightweight
runtime and packaging tool, and Docker Hub, a cloud service for sharing
applications and automating workflows, Docker enables apps to be quickly
assembled from components and eliminates the friction between development, QA,
and production environments. As a result, IT can ship faster and run the same
app, unchanged, on laptops, data center VMs, and any cloud.

### Why Dockerizing RozoFS?

Many reasons to do that:
* developers can build RozoFS everywhere, starting it easily and quickly;
* sysadmins can deploy RozoFS with lightweight runtime, adapting the
  infrastructure depending on the demand. It is a good way for them
  to test RozoFS;
* for continuous integration;
* it's fun !
