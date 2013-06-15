#!/bin/bash

db=`ls data/wp_db_*.tar.gz  | tail -n 1`
filename=`echo $db | cut -d'/' -f2 | cut -d'.' -f1`
last=`cat data/last`
sql="data/${filename}/wp_blog.sql"

date +%Y%m%d:%H%M

if [ -z $filename ]; then 
	echo "database name is empty"
	exit 1
fi

if [ ! -z $last ] && [ $filename == $last ]; then
	echo "wordpress database is last."
	exit 1
fi

tar -zxvf $db -C data/ 
if [ -f $sql ]; then
	echo "Find sql file"
	mysql -h localhost -u wp --password=s2G4wuaept7sYW7K < $sql
	if [ $? -ne 0 ]; then
		echo "mysql restore failed"
		exit 1
	fi
fi

rm -rf data/$filename

echo $filename > data/last

echo "succeed."
