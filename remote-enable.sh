#!/bin/bash

enable()
{
    ssh $1 "echo '$2' | sudo -S systemctl enable ${3}.service"
    echo
    ssh $1 "echo '$2' | sudo -S systemctl start ${3}.service"
    echo
}

disable()
{
    ssh $1 "echo '$2' | sudo -S systemctl stop ${3}.service"
    echo
    ssh $1 "echo '$2' | sudo -S systemctl disable ${3}.service"
    echo
}
