
source env.sh

deploy()
{
    ssh $1 "mkdir -p $KE_DEPLOY_HOME"
    ssh $1 "rm -rf $KE_HOME"
    scp -r $KE_VERSION $1:$KE_DEPLOY_HOME
    scp env.sh $1:$KE_DEPLOY_HOME
    scp start.sh $1:$KE_DEPLOY_HOME
    scp system-config.properties $1:$KE_HOME/conf/
    ssh $1 "$KE_DEPLOY_HOME/start.sh start"
    echo
}

deploy $1

