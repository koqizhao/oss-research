#!/bin/bash

source ../common.sh

component=nodejs
servers=(${servers[@]})

package="nodejs npm"

remote_status()
{
    ssh $1 "echo -e -n 'nodejs version: '; nodejs --version;"
    ssh $1 "echo -e -n 'npm version: '; npm --version;"
}
