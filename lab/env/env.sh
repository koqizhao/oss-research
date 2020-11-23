#!/bin/bash

read_server_pass()
{
    if [ -z "$PASSWORD" ]; then
        echo -n "server password: "
        read -s PASSWORD
        echo

        export PASSWORD
    fi
}
