#!/bin/bash

name=wiki_file_`date +%Y%m%d`
bak_dir=data/$name
db='wiki_me'
wwwroot='/home/wwwroot'
domain='wiki.favorbook.com'
sql_bak='wiki_me.sql'

_log()
{
	echo "`date +%Y%m%d-%H:%M` $1"
}

_log "start ..."

cd /root
cur=`pwd`

if [ -d $bak_dir ]; then
	_log "dir exist."
	exit 1
fi
mkdir -p $bak_dir

_log "cp wordpress files..."
cp -r ${wwwroot}/${domain} $bak_dir
if [ $? -ne -0 ]; then
	_log "cp failed."
	exit 1
fi

if [ ! -d data ]; then
	mkdir data
fi
cd ./data

_log "tar all files..."
tar -zcf ${name}.tar.gz $name
if [ $? -ne -0 ]; then
	_log "tar failed."
	exit 1
fi
rm -rf $name

_log "scp to remote..."
# scp ${name}.tar.gz vincent@us.favorbook.com:~/data/
if [ $? -ne -0 ]; then
	_log "scp failed."
	exit 1
fi

_log "finished."

