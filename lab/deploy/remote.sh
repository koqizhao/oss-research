#!/bin/bash

remote_reboot()
{
    ssh $1 "echo '$2' | sudo -S reboot" || echo
}

remote_enable()
{
    ssh $1 "echo '$3' | sudo -S systemctl enable $2"
    echo
    ssh $1 "echo '$3' | sudo -S systemctl start $2"
    echo
}

remote_disable()
{
    ssh $1 "echo '$3' | sudo -S systemctl stop $2"
    echo
    ssh $1 "echo '$3' | sudo -S systemctl disable $2"
    echo
}

remote_systemctl()
{
    ssh $1 "echo '$4' | sudo -S systemctl $2 $3"
    echo
}

remote_update()
{
    ssh $1 "echo '$2' | sudo -S apt update"
    ssh $1 "echo '$2' | sudo -S apt upgrade -y"
    ssh $1 "echo '$2' | sudo -S apt autoremove --purge -y"
    ssh $1 "echo '$2' | sudo -S reboot" || echo
}

remote_apt()
{
    ssh $1 "echo '$3' | sudo -S apt $2"
}

remote_ps()
{
    ssh $1 "ps aux | grep $2 | grep -v grep"
}

remote_kill()
{
    ssh $1 "pid=(\`ps aux | grep $2 | grep -v grep | awk '{ print \$2 }'\`); \
        for p in \${pid[@]}; do kill \$p; done; "
}
