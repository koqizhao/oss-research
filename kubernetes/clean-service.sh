echo -n "password: "
read -s PASSWORD
echo

scale="dist"
if [ -n "$1" ]
then
    scale=$1
fi

rp=`realpath $0`
work_path=`dirname $rp`
cd $work_path

source servers-$scale.sh

kubernetes_packages=(kubeadm kubectl kubelet)

clean()
{
    echo -e "clean started: $1"
    for i in ${kubernetes_packages[@]}
    do
        ssh $1 "echo '$PASSWORD' | sudo -S apt-mark unhold $i"
        ssh $1 "echo '$PASSWORD' | sudo -S apt remove -y $i"
    done
    ssh $1 "echo '$PASSWORD' | sudo -S systemctl daemon-reload"
    ssh $1 "echo '$PASSWORD' | sudo -S apt update"
    ssh $1 "echo '$PASSWORD' | sudo -S apt autoremove -y --purge"
    echo -e "\nclean finished: $1"
}

for server in ${servers[@]}
do
    clean $server
done

echo
