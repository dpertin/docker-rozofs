# Rozofs all-in-one container

To build the image: 

~~~
$ sudo docker build -t="denaitre/rozofs-allinone" .
~~~

Then run the image with 'privileged' parameter set as a daemon:

~~~
$ sudo docker run -d --privileged --name rozofs denaitre/rozofs-allinone
~~~

You can connect on the container (requires docker >= 1.3) and check that RozoFS
is locally mounted:

~~~
$ sudo docker exec -it rozofs bash

root@910c08001ae9:/# df -h
Filesystem                                                                                       Size  Used Avail Use% Mounted on
rootfs                                                                                           9.8G  263M  9.0G   3% /
/dev/mapper/docker-202:1-18843-910c08001ae950281a070f40f744062742fdc5845bfdd3805a24295b282f8543  9.8G  263M  9.0G   3% /
tmpfs                                                                                            497M     0  497M   0% /dev
shm                                                                                               64M     0   64M   0% /dev/shm
/dev/disk/by-uuid/aef583e5-28c9-4161-ac41-bc0f2c3f6b61                                           7.8G  7.1G  306M  96% /etc/resolv.conf
/dev/disk/by-uuid/aef583e5-28c9-4161-ac41-bc0f2c3f6b61                                           7.8G  7.1G  306M  96% /etc/hostname
/dev/disk/by-uuid/aef583e5-28c9-4161-ac41-bc0f2c3f6b61                                           7.8G  7.1G  306M  96% /etc/hosts
rozofs                                                                                            26G     0   26G   0% /mnt

root@910c08001ae9:/# cd /mnt/
root@910c08001ae9:/mnt# echo 'Hello Rozo !' > foo
root@910c08001ae9:/mnt# cat foo
Hello Rozo !

root@910c08001ae9:/mnt# df -h | grep rozofs
rozofs                                                                                            26G  8.0K   26G   1% /mnt
~~~

Now we can create a second container that can act as a *client*, mounting remotely RozoFS:

~~~
$ sudo docker run -it --privileged --name client --link rozofs:rozofs denaitre/rozofs-allinone bash

root@3413df095b3b:/# mkdir /mnt/rozofs; rozofsmount -H rozofs -E /srv/rozofs/exports/export_1 /mnt/rozofs

root@3413df095b3b:/# cd /mnt/rozofs/
root@3413df095b3b:/mnt/rozofs# ls
foo
root@3413df095b3b:/mnt/rozofs# cat foo 
Hello Rozo !
~~~

