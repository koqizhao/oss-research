
WORK_DIR=~/kafka/kafka-offset-monitor
JAR=KafkaOffsetMonitor-assembly-0.3.0-SNAPSHOT.jar

cd $WORK_DIR
nohup java -cp $JAR com.quantifind.kafka.offsetapp.OffsetGetterWeb --offsetStorage kafka --zk 192.168.56.101,192.168.56.102,192.168.56.103 --port 28082 --refresh 10.seconds --retain 2.days > run.log &

