
# Docker-RozoFS

This is a [Docker](http://docker.io) project to bring up a local
[RozoFS](https://github.com/rozofs/rozofs) cluster.


### What is RozoFS?

RozoFS is a scale-out distributed file system providing high performance and
high availability since it relies on an
[erasure code](http://en.wikipedia.org/wiki/Erasure_code) based on the
[Mojette transform](https://hal.archives-ouvertes.fr/hal-00267621/document).
User data is projected into several chunks and distributed across storage
devices. While data can be retrieved even if several pieces are unavailable,
chunks are meaningless alone. Erasure coding brings the same protection as
plain replication but reduces the amount of stored data by two.

### What is Docker?

Docker is an open platform for developers and sysadmins to build, ship, and run
distributed applications. Consisting of Docker Engine, a portable, lightweight
runtime and packaging tool, and Docker Hub, a cloud service for sharing
applications and automating workflows, Docker enables apps to be quickly
assembled from components and eliminates the friction between development, QA,
and production environments. As a result, IT can ship faster and run the same
app, unchanged, on laptops, data center VMs, and any cloud.

### Prerequisites: Install Docker

Follow the [instructions on Docker's
website](https://www.docker.io/gettingstarted/#h_installation)
to install Docker.


### Clone repository and build RozoFS images

```bash
$ git clone https://github.com/denaitre/docker-rozofs.git
$ cd docker-rozofs
$ make images
```

Check the available images:

```bash
root@r2d2:~/atelier/docker/docker-rozofs# docker images 
REPOSITORY                       TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
denaitre/rozofs-rozofsmount      latest              3df0f1ce99d8        About a minute ago   155.7 MB
denaitre/rozofs-storaged         latest              92d17e1ae8b1        About a minute ago   149.7 MB
denaitre/rozofs-exportd          latest              2fce4a7ce19a        About a minute ago   149.6 MB
```

### Launch cluster

```bash
root@r2d2:~/atelier/docker/docker-rozofs# make start-cluster 
./start_cluster.sh

Bringing up cluster storage nodes:

8f60367d42dbe50f06b152fec3caaebd275de2f37711af973a43aa97200cbda8
Successfully brought up [rozofs-storage01]
41da0e7d30fc39b40801cb848ff9d2648ede04e884683df314c17b0647e5ec03
Successfully brought up [rozofs-storage02]
1a153bbc16acb6d9b5e1ff4759cda68a7fcc3c1ccf3c3fe0085a861b41dab5cd
Successfully brought up [rozofs-storage03]
bc28ec30604a9abae6764df4f53ff9919d97cae3c2a5e995d99818d902a74198
Successfully brought up [rozofs-storage04]

Bringing up the exportd node:

e4cf74466ac5007bd7d8821c890f76747bf29b902a3532638ce13618c4e1cd5b
Successfully brought up [rozofs-exportd]
```

Check the running containers:

```
root@r2d2:~/atelier/docker/docker-rozofs# docker ps
CONTAINER ID        IMAGE                             COMMAND                CREATED             STATUS              PORTS                                                NAMES
b9050c21a6f2        denaitre/rozofs-exportd:latest    "/bin/sh -c '/usr/lo   4 seconds ago       Up 3 seconds        0.0.0.0:49179->53000/tcp                             rozofs-exportd      
907d98ed3f08        denaitre/rozofs-storaged:latest   "/bin/sh -c '/usr/lo   4 seconds ago       Up 3 seconds        0.0.0.0:49177->41001/tcp, 0.0.0.0:49178->51000/tcp   rozofs-storaged04   
565c5d837b48        denaitre/rozofs-storaged:latest   "/bin/sh -c '/usr/lo   4 seconds ago       Up 3 seconds        0.0.0.0:49175->41001/tcp, 0.0.0.0:49176->51000/tcp   rozofs-storaged03   
2000a4531fee        denaitre/rozofs-storaged:latest   "/bin/sh -c '/usr/lo   4 seconds ago       Up 3 seconds        0.0.0.0:49173->41001/tcp, 0.0.0.0:49174->51000/tcp   rozofs-storaged02   
c6451700f0b8        denaitre/rozofs-storaged:latest   "/bin/sh -c '/usr/lo   5 seconds ago       Up 4 seconds        0.0.0.0:49171->41001/tcp, 0.0.0.0:49172->51000/tcp   rozofs-storaged01
```

### Add a client

```bash
root@r2d2:~/atelier/docker/docker-rozofs# ./add_client.sh 
c52a48e25abc1540818df5cd5ddd10526f7f2eb14288cd47323bc3a70d27e392
```

Check the new container:

```
root@r2d2:~/atelier/docker/docker-rozofs# docker ps
CONTAINER ID        IMAGE                                COMMAND                CREATED             STATUS              PORTS                                                NAMES
c52a48e25abc        denaitre/rozofs-rozofsmount:latest   "/bin/sh -c '/usr/lo   2 seconds ago       Up 2 seconds        52000/tcp                                            rozofs-client01     
b9050c21a6f2        denaitre/rozofs-exportd:latest       "/bin/sh -c '/usr/lo   18 seconds ago      Up 17 seconds       0.0.0.0:49179->53000/tcp                             rozofs-exportd      
907d98ed3f08        denaitre/rozofs-storaged:latest      "/bin/sh -c '/usr/lo   18 seconds ago      Up 17 seconds       0.0.0.0:49177->41001/tcp, 0.0.0.0:49178->51000/tcp   rozofs-storaged04   
565c5d837b48        denaitre/rozofs-storaged:latest      "/bin/sh -c '/usr/lo   18 seconds ago      Up 18 seconds       0.0.0.0:49175->41001/tcp, 0.0.0.0:49176->51000/tcp   rozofs-storaged03   
2000a4531fee        denaitre/rozofs-storaged:latest      "/bin/sh -c '/usr/lo   18 seconds ago      Up 18 seconds       0.0.0.0:49173->41001/tcp, 0.0.0.0:49174->51000/tcp   rozofs-storaged02   
c6451700f0b8        denaitre/rozofs-storaged:latest      "/bin/sh -c '/usr/lo   19 seconds ago      Up 18 seconds       0.0.0.0:49171->41001/tcp, 0.0.0.0:49172->51000/tcp   rozofs-storaged01   
```

Connect to the container and write stuff into the volume:

```bash
root@r2d2:~/atelier/docker/docker-rozofs# docker exec -it rozofs-client01 bash          

root@c52a48e25abc:/# df
Filesystem                                             1K-blocks     Used Available Use% Mounted on
rootfs                                                  28704764 13910124  13313476  52% /
none                                                    28704764 13910124  13313476  52% /
tmpfs                                                    4018284        0   4018284   0% /dev
shm                                                        65536        0     65536   0% /dev/shm
/dev/disk/by-uuid/b5050053-645f-4982-9d7d-4b5347aa4d8f  28704764 13910124  13313476  52% /etc/resolv.conf
/dev/disk/by-uuid/b5050053-645f-4982-9d7d-4b5347aa4d8f  28704764 13910124  13313476  52% /etc/hostname
/dev/disk/by-uuid/b5050053-645f-4982-9d7d-4b5347aa4d8f  28704764 13910124  13313476  52% /etc/hosts
rozofs                                                  39451984        0  39451984   0% /mnt/rozofs

root@c52a48e25abc:/# echo 'Je suis Charlie' > /mnt/rozofs/foo

root@c52a48e25abc:/# exit
exit
```

### Mount the remote volume locally

**Prerequisites**: `rozofsmount` must be installed on the host machine.

```bash
root@r2d2:~/atelier/docker/docker-rozofs# ./mount_cluster.sh /mnt/rozofs

Trying to mount the remote RozoFS volume...
```

Check that the volume is locally mounted:

```bash
root@r2d2:~/atelier/docker/docker-rozofs# df
Sys. de fichiers blocs de 1K  Utilisé Disponible Uti% Monté sur
/dev/sda1           28704764 13910160   13313440  52% /
none                       4        0          4   0% /sys/fs/cgroup
udev                 4001744        4    4001740   1% /dev
tmpfs                 803660     1596     802064   1% /run
none                    5120        4       5116   1% /run/lock
none                 4018284   266808    3751476   7% /run/shm
none                  102400       60     102340   1% /run/user
/dev/sda2           67154552 52371568   11348644  83% /home
rozofs              39452272        8   39452264   1% /mnt/rozofs

root@r2d2:~/atelier/docker/docker-rozofs# cat /mnt/rozofs/foo 
Je suis Charlie
```

### Destroying

```bash
root@r2d2:~/atelier/docker/docker-rozofs# make stop-cluster 
./stop_cluster.sh
Stopped the cluster and cleared all the running containers.
```
