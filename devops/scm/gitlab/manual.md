# manual steps

## config dns

add gitlab.mydotey.com conf in bind9

## 初始设置

内置用户root，初始访问时，会提示修改密码。可修改为：xx123456XX

可自己注册1个账户。并赋予管理员权限。

## FAQ

1 gitlab 安装/重配置时，卡在ruby_block[wait for redis service socket] action run

解决方案：

另起1个shell，执行：sudo /opt/gitlab/embedded/bin/runsvdir-start

以便未启动的进程启动起来。全部配置完成后，可以重新配置：sudo gitlab-ctl reconfigure

2 安装过程中发生错误，安装中断

解决方案：sudo dpkg --configure -a

3 gitlab-ctl status 里看到部分组件up，部分down

可能是安装过程中#1 问题导致。安装完成后，重启机器后恢复正常。
