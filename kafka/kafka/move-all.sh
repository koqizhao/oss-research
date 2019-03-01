
export zk_list=$1
export target_brokers=$2

export sleep_s=180
if [ "$3" != "" ]; then
    export sleep_s=$3
fi

export exclude_topics=$4

move_topic()
{
    topic=$1

    printf "\ngenerate move-to-json for topic: \n\n" $topic

    printf "
    {
        \"topics\": [
        {\"topic\": \"%s\"}
        ],
        \"version\":1
    }" $topic > topics-to-move.json

    cat topics-to-move.json
    echo
    echo

    bin/kafka-reassign-partitions.sh --zookeeper $zk_list --topics-to-move-json-file topics-to-move.json --broker-list $target_brokers --generate > reassignment-draft.txt
    printf "reassignment draft\n\n"
    cat reassignment-draft.txt
    echo

    tail -1 reassignment-draft.txt > reassignment.json

    printf "new reassignment\n\n"
    cat reassignment.json
    echo

    printf "execute\n\n"
    bin/kafka-reassign-partitions.sh --zookeeper $zk_list --reassignment-json-file reassignment.json --execute
    echo

    printf "sleep %s seconds to wait for execute complete\n\n" $sleep_s
    sleep $sleep_s

    printf "verify\n\n"
    bin/kafka-reassign-partitions.sh --zookeeper $zk_list --reassignment-json-file reassignment.json --verify
    echo
}

topics=`bin/kafka-topics.sh --zookeeper $zk_list --list`
echo -n "" > all-topics.txt
for i in $topics
do
    echo $i >> all-topics.txt
done

printf "move topics start\n\n"

echo -n "" > moved-topics.txt
echo -n "" > excluded-topics.txt
for i in $topics
do
    if [[ $exclude_topics = *"$i"* ]]; then
        printf "skip excluded topic: %s\n\n" $i
        echo $i >> excluded-topics.txt
        continue
    fi

    printf "move topic start: %s\n\n" $i
    move_topic $i
    printf "move topic end: %s\n\n" $i
    echo $i >>  moved-topics.txt
done

rm topics-to-move.json
rm reassignment-draft.txt
rm reassignment.json

printf "move topics complete\n\n"

