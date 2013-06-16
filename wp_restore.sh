#!/bin/bash

db=`ls data/wp_db_*.tar.gz  | tail -n 1`
filename=`echo $db | cut -d'/' -f2 | cut -d'.' -f1`
last=`cat data/last`
sql="data/${filename}/wp_blog.sql"

_log()
{
	echo "`date +%Y%m%d-%H:%M` $1"
}

_log "start restore..."
cd /home/vincent

if [ -z $filename ]; then 
	_log "database name is empty"
	exit 1
fi

if [ ! -z $last ] && [ $filename == $last ]; then
	_log "wordpress database is last."
	exit 1
fi

tar -zxvf $db -C data/ 
if [ -f $sql ]; then
	_log "Find sql file"
	mysql -h localhost -u wp --password=s2G4wuaept7sYW7K < $sql
	if [ $? -ne 0 ]; then
		_log "mysql restore failed"
		exit 1
	fi
fi

rm -rf data/$filename

echo $filename > data/last

_log "succeed."
