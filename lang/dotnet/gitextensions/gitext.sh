#!/bin/bash

current_dir=`pwd`
work_dir=WORK_DIR

cd $work_dir
mono GitExtensions.exe $@ > GitExtensions.out 2>&1 &

cd $current_dir
