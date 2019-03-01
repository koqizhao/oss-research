#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo '$PASSWORD' | sudo -S systemctl stop kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S rm -rf ~/kafka/kafka-exporter"
    ssh $server "mkdir -p ~/kafka/kafka-exporter"

    scp kafka_exporter $server:./kafka/kafka-exporter/
    scp stop.sh $server:./kafka/kafka-exporter/
    scp kafka-exporter.service $server:./kafka/kafka-exporter/

    ssh $server "echo '#!/bin/bash' > ~/kafka/kafka-exporter/start.sh"
    ssh $server "echo './kafka_exporter --kafka.server=$server:9092 > kafka_exporter.out' >> ~/kafka/kafka-exporter/start.sh"
    ssh $server "chmod +x ~/kafka/kafka-exporter/start.sh"

    ssh $server "echo '$PASSWORD' | sudo -S mv ~/kafka/kafka-exporter/kafka-exporter.service /etc/systemd/system/"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl start kafka-exporter.service"
    ssh $server "echo '$PASSWORD' | sudo -S systemctl enable kafka-exporter.service"

    echo -e "\ndeploy server finished: $server"
}

deploy $1

