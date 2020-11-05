echo -n "password: "
read -s PASSWORD
echo

zk_file=apache-zookeeper-3.6.1-bin

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

deploy()
{
    echo "deploy $1 started"

    ssh $1 "mkdir -p ~/zookeeper/data"

    ssh $1 "echo '$PASSWORD' | sudo -S systemctl stop zookeeper.service || echo 'not deployed'"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f ~/zookeeper/data/zookeeper_server.pid"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -f ~/zookeeper/data/myid"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/zookeeper"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/zookeeper/conf/zoo.cfg"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf ~/zookeeper/zookeeper/conf/java.env"

    scp ~/Software/${zk_file}.tar.gz $1:./zookeeper/
    ssh $1 "cd ~/zookeeper; tar xf ${zk_file}.tar.gz; mv $zk_file zookeeper; rm ${zk_file}.tar.gz"
    scp zoo.cfg.$scale $1:./zookeeper/zookeeper/conf/zoo.cfg
    scp java.env $1:./zookeeper/zookeeper/conf/

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root ~/zookeeper/data"
    ssh $1 "echo $2 > myid; echo '$PASSWORD' | sudo -S mv myid ~/zookeeper/data"
    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root ~/zookeeper/data"

    scp zookeeper.service $1:./zookeeper
    ssh $1 "echo '$PASSWORD' | sudo -S mv zookeeper/zookeeper.service /etc/systemd/system/"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl start zookeeper.service"
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl enable zookeeper.service"

    echo "deploy $1 finished"
}

source servers-$scale.sh
machine_count=`echo ${#servers[@]}`

for i in `let machine_count=machine_count-1; seq 0 $machine_count`
do
    deploy ${servers[$i]} $i
    echo
done
