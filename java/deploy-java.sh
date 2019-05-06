echo -n "password: "
read -s PASSWORD
echo

file_name=jdk-8u161-linux-x64.tar.gz
fold_name=jdk1.8.0_161
priority=800

deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S mkdir -p /usr/java"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf /usr/java/$fold_name"

    scp $file_name $1:./
    ssh $1 "tar xf $file_name"
    ssh $1 "rm $file_name"
    ssh $1 "echo '$PASSWORD' | sudo -S mv $fold_name /usr/java/"

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root /usr/java"
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --install /usr/bin/java java /usr/java/$fold_name/bin/java 800"
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --set java /usr/java/$fold_name/bin/java"
}

source ~/Research/servers.sh

INDEX_MAX=`expr ${#servers[@]} - 1`
for i in `seq 0 $INDEX_MAX`
do
    deploy ${servers[$i]} $i
    echo
done

