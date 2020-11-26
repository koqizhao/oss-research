# Manual steps

## Create runtime user

useradd nexus

## Increase max open files

Edit: /etc/security/limits.conf

nexus - nofile 65536

## Change password

程序启动后，自动在文件sonatype-work/nexus3/admin.password生成密码。

登陆用户界面[nexus](http://&lt;host&gt;:8081)，修改密码。如：amdin/xx123456XX
