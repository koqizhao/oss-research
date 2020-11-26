# manual steps

## config dns

add gitlab.mydotey.com conf in bind9

## install postfix

apt install -y postfix

## 初始设置

初始访问时，会提示修改密码。可修改为：xx123456XX

可自己注册1个账户。并赋予root权限。

## 卸载

需手工进行：

```sh
sudo gitlab-ctl cleanse
sudo gitlab-ctl uninstall
```
