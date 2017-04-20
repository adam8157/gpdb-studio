#!/bin/bash

ln -sf `pwd`/env.sh ~/env.sh
source ~/env.sh

gpstop -af
killall -9 postgres
rm -f /tmp/.s.PGSQL.*
rm -rf ~/greenplum-db-data

mkdir -p ~/greenplum-db-data/master

export PGPORT=5432
export MASTER_DATA_DIRECTORY=`echo ~`/greenplum-db-data/master/gpseg-1

gpssh-exkeys -h `hostname`

hostname > hostfile

cat > gpinitsystem_config <<-EOF
ARRAY_NAME="GPDB"

SEG_PREFIX=gpseg
PORT_BASE=40000

declare -a DATA_DIRECTORY=(~/greenplum-db-data ~/greenplum-db-data)
MASTER_HOSTNAME=`hostname`
MASTER_DIRECTORY=~/greenplum-db-data/master
MASTER_PORT=5432

TRUSTED_SHELL=ssh
CHECK_POINT_SEGMENTS=8
ENCODING=UNICODE
MACHINE_LIST_FILE=hostfile
EOF

gpinitsystem -c gpinitsystem_config -h hostfile -a
