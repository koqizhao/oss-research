# misc deploy hints

## 机器初始化

comment /swap in /etc/fstab

echo "vm.swappiness=0" >> /etc/sysctl.conf

## 访问dashboard

https://github.com/kubernetes/dashboard/tree/master/docs/user/accessing-dashboard

1 配置service为NodePort，通过node ip访问。

```sh
kubectl -n kubernetes-dashboard edit service kubernetes-dashboard
```

Change type: ClusterIP to type: NodePort and save file.

2 获取主机端口：

```sh
kubectl -n kubernetes-dashboard get service kubernetes-dashboard
```

3 通过主机端口访问，如：https://192.168.56.13:30672/

注意：chrome无法访问https，需要换成firefox浏览器。
