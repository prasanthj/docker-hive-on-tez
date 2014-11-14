Docker image to run Apache Hive on Tez
======================================

This repository contains a docker file to build a docker image to run Apache Hive on Tez. This docker file depends on my other repos containing [docker-tez] and [docker-hadoop] base images.

## Current Version
* Apache Hive 0.14.0
* Apache Tez 0.5.2
* Apache Hadoop 2.5.0
* PostgreSQL 9.3 (Hive metastore backend)

## Running on Mac OS X

This step is required only for Mac OS X as docker is not natively supported in Mac OS X. To run docker on Mac OS X we need Boot2Docker. Boot2Docker installs headless virtual box, runs a lightweight linux distribution and sets up to run docker daemon.

### Setting up docker

* Install Boot2Docker from [here].
* After installing, from terminal, run `boot2docker init` to initialize boot2docker.
* Run `boot2docker start` to start boot2docker and export `DOCKER_HOST` and `DOCKER_CERT_PATH` as shown at the end of command.
* After exporting `DOCKER_HOST` and `DOCKER_CERT_PATH` we can run docker commands.

*NOTE:* docker 1.3.0 versions require --tls to be passed to all docker command

## Pull the image
You can either pull the image that is already pre-built from Docker hub or build the image locally (refer next section)

> docker --tls pull prasanthj/hive-on-tez


## Building the image

If you do not want to pull the image from Docker hub, you can build it locally using the following steps
* To build the hive-on-tez docker image locally from Dockerfile, first checkout source using
`git clone https://github.com/prasanthj/docker-hive-on-tez.git`
* Change to docker-hive-on-tez directory `cd docker-hive-on-tez`

> docker --tls build  -t prasanthj/hive-on-tez .


## Running the image

> docker --tls run -i -t -P prasanthj/hive-on-tez /etc/hive-bootstrap.sh -bash


## Testing Hive on Tez
After launching the container using the command from "Running the image" section, bash is launched. On the bash prompt type the following to run a sample hive query

> hive -f /opt/files/store_sales.sql

Running the above command should show output like below after successful execution

    Status: Running (Executing on YARN cluster with App id application_1415171696020_0001)
    
    --------------------------------------------------------------------------------
            VERTICES      STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED
    --------------------------------------------------------------------------------
    Map 1 ..........   SUCCEEDED      1          1        0        0       0       0
    Reducer 2 ......   SUCCEEDED      1          1        0        0       0       0
    Reducer 3 ......   SUCCEEDED      1          1        0        0       0       0
    --------------------------------------------------------------------------------
    VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 1.65 s     
    --------------------------------------------------------------------------------
    OK
    2452143 30
    2451524 25
    2452274 25
    2452187 20
    2450952 16
    2451942 16
    2451083 15
    2451390 15
    2451415 15
    2452181 15
    Time taken: 2.566 seconds, Fetched: 10 row(s)

## Testing Hive on MapReduce v2 (YARN)
Run the same example above with the following additional hive config
> hive -f /opt/files/store_sales.sql -hiveconf hive.execution.engine=mr -hiveconf mapreduce.framework.name=yarn -hiveconf yarn.resourcemanager.address=localhost:8032

Running the above command should show output like below after successful execution

    MapReduce Jobs Launched: 
    Stage-Stage-1: Map: 1  Reduce: 1   Cumulative CPU: 3.17 sec   HDFS Read: 36073 HDFS Write: 1830 SUCCESS
    Stage-Stage-2: Map: 1  Reduce: 1   Cumulative CPU: 33.47 sec   HDFS Read: 2234 HDFS Write: 110 SUCCESS
    Total MapReduce CPU Time Spent: 36 seconds 640 msec
    OK
    2452143 30
    2451524 25
    2452274 25
    2452187 20
    2450952 16
    2451942 16
    2451083 15
    2451390 15
    2451415 15
    2452181 15
    Time taken: 53.967 seconds, Fetched: 10 row(s)

## Viewing Web UI
If you are running docker using Boot2Docker then do the following steps

 * Setup routing on the host machine (Mac OS X) using the following
   command `sudo route add -net 172.17.0.0/16 192.168.59.103`
_NOTE_: 172.17.0.X is usually the ipaddress of docker container. 192.168.59.103 is the ipaddress exported in `DOCKER_HOST`

 * Get containers IP address
    * To get containers IP address we need CONTAINER_ID. To get container id use the following command which should list all running containers and its ID
    `docker --tls ps`
    * Use the following command to get containers IP address (where CONTAINER_ID is the container id of prasanthj/hive-on-tez image)
    `docker --tls inspect -f=“{{.NetworkSettings.IPAddress}}” CONTAINER_ID`

 * Launch a web browser and type `http://<container-ip-address>:8088` to view hadoop cluster web UI.

[here]:https://github.com/boot2docker/osx-installer/releases
[docker-tez]:https://github.com/prasanthj/docker-tez.git
[docker-hadoop]:https://github.com/prasanthj/docker-hadoop.git
