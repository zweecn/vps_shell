#!/bin/bash

name=wp_`date +%Y%m%d`
bak_dir=data/$name
db='wp_blog'
wwwroot='/home/wwwroot'
domain='blog.favorbook.com'
sql_bak='wp_blog.sql'

if [ -d $bak_dir ]; then
	echo "Dir exists.";
	exit 1
fi
mkdir -p $bak_dir

echo "Backup mysql db..."
mysqldump -u wp --password=s2G4wuaept7sYW7K --database  $db > ${bak_dir}/${sql_bak}
if [ $? -ne 0 ]; then
	echo "mysqldump failed.";
	exit 1
fi

echo "cp wordpress files..."
cp -r ${wwwroot}/${domain} $bak_dir
if [ $? -ne -0 ]; then
	echo "cp failed.";
	exit 1
fi

if [ ! -d data ]; then
	mkdir data
fi
cd data

echo "tar all files..."
tar -zcvf ${name}.tar.gz $name
if [ $? -ne -0 ]; then
	echo "tar failed.";
	exit 1
fi
rm -rf $name

#sz -be ${name}.tar.gz
#if [ $? -ne -0 ]; then
#	echo "sz failed.";
#	exit 1
#fi

scp ${name}.tar.gz vincent@us.favorbook.com:~/data/

echo "Finished."
