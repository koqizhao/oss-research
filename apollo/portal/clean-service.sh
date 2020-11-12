#!/bin/bash

source ~/Research/common/init.sh
init_scale "$1" ..

source common.sh

batch_clean

db_exec apolloportaldb-drop.sql
