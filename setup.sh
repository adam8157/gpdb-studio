#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

[ ! -f env_gpdb.sh ] && echo Please run this script under gpdb-studio directory. && exit 1

ln -sf `pwd`/env_gpdb.sh ~/env_gpdb.sh
source ~/env_gpdb.sh

gpstop -af
killall -9 postgres
rm -f /tmp/.s.PGSQL.*
rm -rf ~/greenplum-db-data ~/gpAdminLogs

mkdir -p ~/greenplum-db-data/primary
mkdir -p ~/greenplum-db-data/mirror

export PGPORT=15432
export MASTER_DATA_DIRECTORY=`echo ~`/greenplum-db-data/gpseg-1

gpssh-exkeys -h `hostname`

hostname > hostfile

cat > gpinitsystem_config <<-EOF
ARRAY_NAME="GPDB"

SEG_PREFIX=gpseg
PORT_BASE=40000

declare -a DATA_DIRECTORY=(~/greenplum-db-data/primary ~/greenplum-db-data/primary ~/greenplum-db-data/primary)
MASTER_HOSTNAME=`hostname`
MASTER_DIRECTORY=~/greenplum-db-data
MASTER_PORT=15432

declare -a MIRROR_DATA_DIRECTORY=(~/greenplum-db-data/mirror ~/greenplum-db-data/mirror ~/greenplum-db-data/mirror)
MIRROR_PORT_BASE=50000
REPLICATION_PORT_BASE=41000
MIRROR_REPLICATION_PORT_BASE=51000

TRUSTED_SHELL=ssh
CHECK_POINT_SEGMENTS=8
ENCODING=UNICODE
MACHINE_LIST_FILE=hostfile
EOF

gpinitsystem -c gpinitsystem_config -h hostfile -a
