#!/bin/bash

_log()
{
	echo "`date +%Y%m%d-%H:%M` $1"
}

_log "start db backup..."
./shell/wp_db_backup.sh
if [ $? -ne 0 ]; then
	_log "mysql backup failed."
	exit 1
fi

_log "start file backup..."
./shell/wp_file_backup.sh
if [ $? -ne 0 ]; then
	_log "file backup failed."
	exit 1
fi

