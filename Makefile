.PHONY: all build cluster rozofs-base rozofs-exportd rozofs-storaged \
	rozofs-rozofsmount rozofs-allinone start-cluster mount-cluster add-client \
	stop-cluster

all: stop-cluster build cluster start-cluster

build cluster: rozofs-base rozofs-exportd rozofs-storaged rozofs-rozofsmount

rozofs-base:
	docker build -t "denaitre/rozofs-base" rozofs-base/
	
rozofs-exportd:
	docker build -t "denaitre/rozofs-exportd" rozofs-exportd/
	
rozofs-storaged:
	docker build -t "denaitre/rozofs-storaged" rozofs-storaged/

rozofs-rozofsmount:
	docker build -t "denaitre/rozofs-rozofsmount" rozofs-rozofsmount/
	
rozofs-allinone:
	docker build -t "denaitre/rozofs-allinone" rozofs-allinone/
	
start-cluster:
	./start_cluster.sh

mount-cluster:
	./mount_cluster.sh /mnt/rozofs

add-client:
	./add_client.sh

stop-cluster:
	./stop_cluster.sh
