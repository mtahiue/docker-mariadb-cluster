FROM mariadb:10.1
MAINTAINER toughiq@gmail.com

RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*
    
COPY scripts/ /docker-entrypoint-initdb.d/.

# we need to touch and chown config files, since we cant write as mysql user
RUN touch /etc/mysql/conf.d/galera.cnf \
    && chown mysql.mysql /etc/mysql/conf.d/galera.cnf \
    && chown mysql.mysql /docker-entrypoint-initdb.d/*.sql

# we set some defaults
ENV GALERA_USER=galera \
    GALERA_PASS=galerapass \
    MAXSCALE_USER=maxscale \
    MAXSCALE_PASS=maxscalepass \ 
    CLUSTER_NAME=docker_cluster \
    MYSQL_ALLOW_EMPTY_PASSWORD=1
    


