
WORK_HOME=kafka/trifecta/cli

deploy()
{
    ssh $1 "rm -rf $WORK_HOME"
    ssh $1 "mkdir -p $WORK_HOME"
    scp trifecta-cli-0.22.0rc10c-0.8.2.0.bin.jar $1:$WORK_HOME/
    scp start.sh $1:$WORK_HOME/
    echo
}

deploy $1

