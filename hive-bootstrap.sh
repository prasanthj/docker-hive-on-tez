#!/bin/bash

service postgresql start

if [[ $1 == "-d" ]]; then
  /etc/bootstrap.sh -d
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /etc/bootstrap.sh
  /bin/bash
fi
