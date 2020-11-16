#!/bin/bash

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

source ~/Research/lang/shell/util.sh
source ~/Research/lab/deploy/remote.sh
source ~/Research/lab/deploy/deploy.sh
