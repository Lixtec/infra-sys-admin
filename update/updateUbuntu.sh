#!/bin/bash
#
# Ce script update un système linux de type Ubuntu

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

echo "Update $HOST"
apt-get update
apt-get upgrade -y
