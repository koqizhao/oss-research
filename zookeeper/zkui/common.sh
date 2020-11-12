#!/bin/bash

source ../common.sh

component=zkui
servers=${zkui_servers[@]}

status()
{
    remote_ps $1 $2
}
