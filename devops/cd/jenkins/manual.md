# manual steps

## 初始设置

初始密码在目录：/var/lib/jenkins/secrets/initialAdminPassword

初始访问时，会提示修改密码。可修改为：xx123456XX

## 插件镜像设置

初始化时，注意不要安装任何插件。在 "Manage Jenkins / Manage Plugins / Advanced / Update Site" 里，配置国内插件更新地址：https://mirrors.aliyun.com/jenkins/updates/update-center.json 。

原始地址为：https://updates.jenkins.io/update-center.json 。

在可用插件栏目，输入插件关键字，会出现相关插件供安装使用。
