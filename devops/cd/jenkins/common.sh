#!/bin/bash

source ../common.sh

component=jenkins

remote_status()
{
    remote_systemctl $1 status $2 $PASSWORD
}

remote_start()
{
    remote_systemctl $1 start $2 $PASSWORD
}

remote_stop()
{
    remote_systemctl $1 stop $2 $PASSWORD
}
