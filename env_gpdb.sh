export PGHOST="$(hostname)"
export PGPORT=15432
export MASTER_DATA_DIRECTORY=`echo ~`/greenplum-db-data/gpseg-1

source ~/greenplum-db-devel/greenplum_path.sh
