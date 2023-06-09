#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

[ ! -f env_gpdb.sh ] && echo Please run this script under gpdb-studio directory. && exit 1

OPTION_STANDBY="false"
OPTION_MIRRORS="false"

while [[ $# -gt 0 ]]
do
	case "$1" in
		--standby)
			OPTION_STANDBY="true"
			shift;;
		--mirrors)
			OPTION_MIRRORS="true"
			shift;;
		--)
			shift
			break;;
		*)
			echo "Only --standby and --mirrors are valid options" >&2
			exit 1;;
	esac
done

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

EOF

if [ "$OPTION_MIRRORS" = "true" ]
then
	cat >> gpinitsystem_config <<-EOF
	declare -a MIRROR_DATA_DIRECTORY=(~/greenplum-db-data/mirror ~/greenplum-db-data/mirror ~/greenplum-db-data/mirror)
	MIRROR_PORT_BASE=50000
	REPLICATION_PORT_BASE=41000
	MIRROR_REPLICATION_PORT_BASE=51000

	EOF
fi

cat >> gpinitsystem_config <<-EOF
TRUSTED_SHELL=ssh
CHECK_POINT_SEGMENTS=8
ENCODING=UNICODE
MACHINE_LIST_FILE=hostfile
EOF

if [ "$OPTION_STANDBY" = "true" ]
then
	gpinitsystem -c gpinitsystem_config -h hostfile -s `hostname` -P 15433 -S ~/greenplum-db-data/standby -a
else
	gpinitsystem -c gpinitsystem_config -h hostfile -a
fi
