#!/bin/bash

WORK_DIR=zookeeper/zktop

deploy()
{
    ssh $1 "rm -rf $WORK_DIR"
    ssh $1 "mkdir -p $WORK_DIR"

    scp setup.cfg $1:$WORK_DIR/
    scp setup.py $1:$WORK_DIR/
    scp zktop.py $1:$WORK_DIR/
    scp zktop.sh $1:$WORK_DIR/

    echo
}

deploy $1


