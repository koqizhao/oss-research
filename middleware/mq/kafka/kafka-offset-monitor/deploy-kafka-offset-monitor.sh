
WORK_DIR=kafka/kafka-offset-monitor
JAR=KafkaOffsetMonitor-assembly-0.3.0-SNAPSHOT.jar

deploy()
{
    ssh $1 "rm -rf $WORK_DIR"
    ssh $1 "mkdir -p $WORK_DIR"
    scp $JAR $1:$WORK_DIR/
    scp start.sh $1:$WORK_DIR/
    ssh $1 "bash $WORK_DIR/start.sh"
    echo
}

deploy $1

