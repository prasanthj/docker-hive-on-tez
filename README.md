Docker image to run Apache Hive on Tez
======================================

This repository contains a docker file to build a docker image to run Apache Hive on Tez. This docker file depends on my other repos containing [docker-tez] and [docker-hadoop] base images.

## Current Version
* Apache Hive (trunk version)
* Apache Tez 0.5.0
* Apache Hadoop 2.5.0
* PostgreSQL 9.3 (Hive metastore backend)

## Running on Mac OS X

This step is required only for Mac OS X as docker is not natively supported in Mac OS X. To run docker on Mac OS X we need Boot2Docker.

### Setting up docker

* Install Boot2Docker from [here].
* After installing, from terminal, run `boot2docker init` to initialize boot2docker.
* Run `boot2docker start` to start boot2docker and export `DOCKER_HOST` as shown at the end of command. It usually will be `export DOCKER_HOST=tcp://192.168.59.103:2375`
* After exporting `DOCKER_HOST` we can run docker commands.

*NOTE:* docker 1.3.0 versions require --tls to be passed to all docker command

## Pull the image
You can either pull the image that is already pre-built from Docker hub or build the image locally (refer next section)
```
docker --tls pull prasanthj/hive-on-tez
```

## Building the image

If you do not want to pull the image from Docker hub, you can build it locally using the following steps
* To build the hive-on-tez docker image locally from Dockerfile, first checkout source using
`git clone https://github.com/prasanthj/docker-hive-on-tez.git`
* Change to docker-hive-on-tez directory `cd docker-hive-on-tez`
```
docker --tls build  -t prasanthj/hive-on-tez .
```

## Running the image
```
docker --tls run -i -t -P prasanthj/hive-on-tez /etc/hive-bootstrap.sh -bash
```

## Testing
After launching the container using the command from "Running the image" section, bash is launched. On the bash prompt type the following to run a sample hive query
```
hive -f /tmp/store_sales.sql
```

Running the above command should show output like below
```
Status: Running (Executing on YARN cluster with App id application_1414304558965_0001)

Map 1: -/-	Reducer 2: 0/1	Reducer 3: 0/1	
Map 1: 0(+1)/1	Reducer 2: 0/1	Reducer 3: 0/1	
Map 1: 1/1	Reducer 2: 0(+1)/1	Reducer 3: 0/1	
Map 1: 1/1	Reducer 2: 1/1	Reducer 3: 0(+1)/1	
Map 1: 1/1	Reducer 2: 1/1	Reducer 3: 1/1	
Status: Finished successfully in 3.13 seconds
OK
2452143	30
2451524	25
2452274	25
2452187	20
2450952	16
2451942	16
2451083	15
2451390	15
2451415	15
2452181	15
Time taken: 4.261 seconds, Fetched: 10 row(s)
```

[here]:https://github.com/boot2docker/osx-installer/releases
[docker-tez]:https://github.com/prasanthj/docker-tez.git
[docker-hadoop]:https://github.com/prasanthj/docker-hadoop.git