#! /bin/bash
set -uo pipefail

display_usage() {
	echo "Usage: $0 <repo> (local|monitor <host> <warning> <critical>|restic arguments)" >&2
}

if [ "$#" -lt 2 ]; then
	display_usage
    	exit 1
fi

TARGET=$1
ACTION=$2
RESTIC=$(which restic)
CURL=$(which curl)

check_config() {
	CONFIG=/etc/backup/$1.repo
	if [ ! -f $CONFIG ]; then
	    	echo "Repo config file $CONFIG not found!"
    	    	exit 1
	else
		set -a
		source $CONFIG
		set +a
        fi


	if [[ ! -x $RESTIC ]]; then
    		echo "Restic binary not found"
    		exit 1
	fi
}

handle_params () {

	. /etc/backup/local.config
	if [ $2 == "local" ]; then
    		do_local_backup
	elif [ $2 == "monitor" ]; then
		do_monitor $@
	else
		shift 1
		# define an empty default if RESTIC_ARGS is not set
		RESTIC_ARGS=${RESTIC_ARGS:-""}
		$RESTIC $RESTIC_ARGS $@
        fi
}

do_monitor () {
	if [ $# -lt 5 ]; then
		display_usage
		exit 1;
	fi
	WARN=$4
	CRIT=$5

	# define an empty default if RESTIC_ARGS is not set
	RESTIC_ARGS=${RESTIC_ARGS:-""}
	SNAPS=`$RESTIC $RESTIC_ARGS snapshots --compact --no-lock -H $3`
	# Get last line and parse into variables. Removes header and is empty when no snapshot exists for host
	LAST=`sed 1,2d <<< $SNAPS | head -n -2 | tail -n 1`
  COUNT=`tail -n 1 <<< $SNAPS | cut -d " " -f 1`
	if [ ! $? -eq 0 ]; then
		echo "WARNING - restic command returned an error"
		exit 1;
	fi

	IFS=' ' read HASH DATE TIME HOST DIR <<< "$LAST"

	if [ -z "$HASH" ]; then
		echo "3 \"Restic Backup\" - No snapshot found for $3"
		exit 4;
	fi


	# Compute time difference since last snapshot
	case $(uname -s) in
		Darwin)
			BACKUP_TST=$(date -j -f "%Y-%m-%d %H:%M:%S" "$DATE $TIME" "+%s")
			;;
		*)
			BACKUP_TST=$(date -d "$DATE $TIME" +"%s" )
			;;
	esac

	NOW_TST=$(date +%s)
	DIFF_S=`expr $NOW_TST - $BACKUP_TST`

	DIFF_H=`expr $DIFF_S / 3600`

	MESSAGE="Last snapshot #$HASH ${DIFF_H}h ago|snapshots=$COUNT; age=$DIFF_H"
        RET=0
	RET_H="OK"

	if [ $DIFF_H -lt $WARN ]; then
		RET=0
		RET_H="OK"
	elif [ $DIFF_H -lt $CRIT ]; then
                RET=1
                RET_H="WARNING"
	else
                RET=2
                RET_H="CRITICAL"

	fi
	echo "$RET \"Restic Backup\" - $MESSAGE"
	return $RET
}

check_config $@
handle_params $@
