#!/bin/bash

region=lab
zones=(zone1 zone2)

zone1_servers=(192.168.56.11)
zone2_servers=()

servers=(`merge_array ${zone1_servers[@]} ${zone2_servers[@]}`)
