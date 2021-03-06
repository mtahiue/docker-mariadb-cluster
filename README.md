# docker-mariadb-cluster
Dockerized MariaDB Galera Cluster

Build for use with Docker __1.12__+

# WORK in Progress!!

## Setup
### Init Swarm Nodes/Cluster

Swarm Master:
		
		docker swarm init
		
Additional Swarm Node(s):

		docker swarm join <MasterNodeIP>:2377

### Create DB network

		docker network create -d overlay mydbnet

### Fire up Bootstrap node
		
		docker service create --name bootstrap \
		--network mydbnet \
		--replicas=1 \
		--env MYSQL_ALLOW_EMPTY_PASSWORD=0 \
		--env MYSQL_ROOT_PASSWORD=rootpass \
		--env DB_BOOTSTRAP_NAME=bootstrap \
		toughiq/mariadb-cluster --wsrep-new-cluster

### Fire up Cluster Members

		docker service create --name dbcluster \
		--network mydbnet \
		--replicas=3 \
		--env DB_SERVICE_NAME=dbcluster \
		--env DB_BOOTSTRAP_NAME=bootstrap \
		toughiq/mariadb-cluster

### Startup MaxScale Proxy

		docker service create --name maxscale \
		--network mydbnet \
		--env DB_SERVICE_NAME=dbcluster \
		--env ENABLE_ROOT_USER=1 \
		--publish 3306:3306 \
		toughiq/maxscale

## After successful startup of Cluster
### Remove Bootstrap Service

		docker service rm bootstrap
