#!/bin/bash

source ~/Research/lab/deploy/init.sh
init_scale "$1" ..

source common.sh

batch_clean

db_exec apolloportaldb-drop.sql
