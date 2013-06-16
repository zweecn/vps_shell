#!/bin/bash

filename=`ls data/wp_file_*.tar.gz  | tail -n 1 | cut -d'/' -f2 | cut -d'.' -f1`
last=`cat data/last_file`

_log()
{
	echo "`date +%Y%m%d-%H:%M` $1"
}

_log "start restore..."
cd /home/vincent

if [ -z $filename ]; then
	_log "no wordpress file"
	exit 1
fi

if [ ! -z $last ] && [ $filename == $last ]; then
	_log "wordpress file is newest"
	exit 1
fi

if [ ! -d tmp ]; then
	mkdir tmp
fi

_log "depress data/${filename}.tar.gz ..."
tar -zxf data/${filename}.tar.gz -C ./tmp
if [ $? -ne 0 ]; then
	_log "tar failed."
	exit 1
fi

_log "cp to host..."
sudo cp -r ./tmp/${filename}/blog.favorbook.com/* /home/wwwroot/blog.favorbook.com/
if [ $? -ne 0 ]; then
	_log "cp failed."
	exit 1
fi

rm -rf tmp

echo $filename > data/last_file


_log "succeed."
