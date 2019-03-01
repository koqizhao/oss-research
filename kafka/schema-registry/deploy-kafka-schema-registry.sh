
WORK_HOME=kafka/kafka-schema-registry

deploy()
{
    ssh $1 "rm -rf $WORK_HOME"
    ssh $1 "mkdir -p $WORK_HOME"
    scp -r 4.1.0 $1:$WORK_HOME/
    scp start.sh $1:$WORK_HOME/
    scp schema-registry.properties $1:$WORK_HOME/
    ssh $1 "bash $WORK_HOME/start.sh"
    echo
}

deploy $1

