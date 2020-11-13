#!/bin/bash

echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "vm.swappiness=0" >> /etc/sysctl.conf

echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

echo "* soft nproc 4096" >> /etc/security/limits.conf
echo "* hard nproc 4096" >> /etc/security/limits.conf
