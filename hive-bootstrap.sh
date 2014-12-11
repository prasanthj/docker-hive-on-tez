#!/bin/bash

echo "Starting postgresql server..."
sudo -u postgres $POSTGRESQL_BIN --config-file=$POSTGRESQL_CONFIG_FILE &

/etc/bootstrap.sh
echo "Leaving namenode safemode..."
$HADOOP_PREFIX/bin/hdfs dfsadmin -safemode leave
/bin/bash
