#!/bin/bash

source ../common.sh

component=nodejs
servers=(${servers[@]})

remote_status()
{
    ssh $1 "echo -e -n 'node version: '; node --version;"
    ssh $1 "echo -e -n 'npm version: '; npm --version;"
}
