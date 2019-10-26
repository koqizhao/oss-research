#!/bin/bash

current=`pwd`
source=$1
target=$2

cd $source
source=`pwd`
cd $current

cd $target
target=`pwd`
cd $current

for file in `ls $source`
do
	mv $source/$file $target
	ln -s $target/$file $source/$file
done
