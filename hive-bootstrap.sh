#!/bin/bash

echo "Starting postgresql server..."
sudo -u postgres $POSTGRESQL_BIN --config-file=$POSTGRESQL_CONFIG_FILE &

/etc/bootstrap.sh
/bin/bash
