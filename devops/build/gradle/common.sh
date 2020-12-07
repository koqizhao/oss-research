#!/bin/bash

source ../common.sh

component=gradle

remote_status()
{
    gradle -v
}
