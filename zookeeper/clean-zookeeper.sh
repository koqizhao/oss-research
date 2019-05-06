echo -n "password: "
read -s PASSWORD
echo

clean()
{
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl stop zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl disable zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper"
    ssh $1 "echo '$PASSWORD' | sudo -S rm /etc/systemd/system/zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
}

clean $1

echo
