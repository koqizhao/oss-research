# manual ops

1 配置ip/server-name映射

对每台机器修改/etc/hosts文件，加入每台机器IP与host name的映射

```sh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

2 name node ssh no pass

在name node上生成ssh密钥，并对每个node配置公钥，使name node能ssh到每台机器（包括自己）
