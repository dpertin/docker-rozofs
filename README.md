
This project is about dockerizing **RozoFS**.

### ABOUT ROZOFS

RozoFS is a scale-out NAS file system. RozoFS aims to provide an open source
high performance and high availability scale out storage software appliance
for  intensive disk IO data center scenario. It comes as a free software,
licensed under the GNU GPL v2. RozoFS provides an easy way to scale to
petabytes storage but using erasure coding it was designed to provide very high
availability levels with optimized raw capacity usage on heterogenous commodity
hardwares.

RozoFS provide a native open source POSIX file system, build on top of a usual
out-band scale-out storage architecture. The RozoFS specificity lies in the way
data is stored. The data to be stored is translated into several chunks named
projections using Mojette Transform and distributed across storage devices in
such a way that it can be retrieved even if several pieces are unavailable. On
the other hand, chuncks are meaningless alone. Redundancy schemes based on
coding techniques like the one used by RozoFS allow to achieve signiﬁcant
storage savings as compared to simple replication.

