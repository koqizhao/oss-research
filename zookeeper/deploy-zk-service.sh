echo -n "password: "
read -s PASSWORD
echo

deploy()
{
    ssh $1 "mkdir -p ~/zookeeper"
    ssh $1 "echo '$PASSWORD' | sudo -S mkdir -p /var/data/zookeeper"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl stop zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /var/data/zookeeper/zookeeper_server.pid"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f /var/data/zookeeper/myid"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/3.4.11"

    scp zookeeper.service $1:./zookeeper
    scp -r 3.4.11 $1:./zookeeper/
    ssh $1 "echo $2 > ./zookeeper/myid"
    ssh $1 "echo '$PASSWORD' | sudo -S mv ./zookeeper/myid /var/data/zookeeper/"
    ssh $1 "echo '$PASSWORD' | sudo -S chown root:root /var/data/zookeeper/myid"

    ssh $1 "echo '$PASSWORD' | sudo -S mv zookeeper/zookeeper.service /etc/systemd/system/"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable zookeeper.service"
}

source ~/Research/servers.sh

INDEX_MAX=`expr ${#servers[@]} - 1`
for i in `seq 0 $INDEX_MAX`
do
    deploy ${servers[$i]} $i
    echo
done

