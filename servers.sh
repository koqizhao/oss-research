
server_count=5
for i in `seq 1 $server_count`
do
    let "index=i-1"
    servers[$index]="192.168.56.1$i"
done
