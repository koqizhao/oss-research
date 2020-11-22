echo -n "password: "
read -s PASSWORD
echo

file_name=openjdk-12.0.1_linux-x64_bin.tar.gz
fold_name=jdk-12.0.1
priority=800

deploy_dir=/usr/lib/jvm

deploy()
{
    ssh $1 "echo '$PASSWORD' | sudo -S mkdir -p $deploy_dir"
    ssh $1 "echo '$PASSWORD' | sudo -S rm -rf $deploy_dir/$fold_name"

    scp /home/koqizhao/Software/jdk/$file_name $1:./
    ssh $1 "tar xf $file_name"
    ssh $1 "rm $file_name"
    ssh $1 "echo '$PASSWORD' | sudo -S mv $fold_name $deploy_dir"

    ssh $1 "echo '$PASSWORD' | sudo -S chown -R root:root $deploy_dir; sudo -S chmod 755 -R $deploy_dir"
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --install /usr/bin/java java $deploy_dir/$fold_name/bin/java $priority"
    ssh $1 "echo '$PASSWORD' | sudo -S update-alternatives --set java $deploy_dir/$fold_name/bin/java"
}

source ~/Research/lab/env/servers.sh

INDEX_MAX=`expr ${#servers[@]} - 1`
for i in `seq 0 $INDEX_MAX`
do
    deploy ${servers[$i]} $i
    echo
done

