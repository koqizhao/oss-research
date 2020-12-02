#!/bin/bash

export CAT_HOME=/data/appdatas/cat/

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export CATALINA_OPTS="$CATALINA_OPTS -server -DCAT_HOME=$CAT_HOME -Djava.awt.headless=true \
    -Xmx1g -Xss256k -XX:+UseParNewGC -XX:ParallelGCThreads=4 -XX:MaxTenuringThreshold=13 \
    -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+UseCMSInitiatingOccupancyOnly \
    -XX:+ScavengeBeforeFullGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSParallelRemarkEnabled \
    -XX:CMSFullGCsBeforeCompaction=9 -XX:CMSInitiatingOccupancyFraction=60 \
    -XX:+CMSClassUnloadingEnabled -XX:SoftRefLRUPolicyMSPerMB=0 \
    -XX:-ReduceInitialCardMarks -XX:+CMSPermGenSweepingEnabled \
    -XX:CMSInitiatingPermOccupancyFraction=70 -XX:+ExplicitGCInvokesConcurrent \
    -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -XX:+PrintGCDetails \
    -XX:+PrintGCTimeStamps -XX:+PrintGCApplicationConcurrentTime -XX:+PrintHeapAtGC \
    -Xloggc:/data/applogs/heap_trace.txt -XX:-HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=/data/applogs/HeapDumpOnOutOfMemoryError \
    -Djava.util.Arrays.useLegacyMergeSort=true"

bin/catalina.sh run
