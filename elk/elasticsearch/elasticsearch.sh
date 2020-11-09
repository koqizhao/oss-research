#!/bin/bash

TIMEOUT_SEC=60
if [ "$2" != "" ]
then
    TIMEOUT_SEC=$2
fi

getPS()
{
    ps ax | grep 'elasticsearch' | grep java | grep -v grep | awk '{print $1}'
}

startServer() {
    echo "start elasticsearch server ..."
    if [ "$1" = "daemon-start" ]
    then
        bin/elasticsearch > /dev/null 2>&1 &
        echo "elasticsearch started"
        echo
    else
        bin/elasticsearch > /dev/null 2>&1
    fi
}

stopServer() {
    ES_PS=`getPS`
    echo "elasticsearch ps: $ES_PS"
    echo

    if [ "$ES_PS" != "" ]
    then
        echo "stop elasticsearch server ..."
        echo
        kill -SIGTERM $ES_PS

        SLEEP_TIME=0
        while [ "$ES_PS" != "" ] && [ $SLEEP_TIME -lt $TIMEOUT_SEC ]
        do
            echo "sleep 5s for complete"
            echo
            sleep 5
            SLEEP_TIME=`expr $SLEEP_TIME + 5`

            ES_PS=`getPS`
        done

        echo "total time: $SLEEP_TIME"
        echo

        if [ "$ES_PS" != "" ]
        then
            echo "elasticsearch has not yet been stopped, force kill!"
            echo
            kill -9 $ES_PS
        fi
    fi

    echo "elasticsearch server stopped"
    echo
}

case $1 in
    "start")
        startServer
        ;;
    "daemon-start")
        startServer daemon-start
        ;;
    "stop")
        stopServer
        ;;
    *)
        echo "do nothing"
        ;;
esac
