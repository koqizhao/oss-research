#!/bin/bash

ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P ""
cd ~/.ssh
cat id_rsa.pub > authorized_keys
chmod 600 authorized_keys
ssh-keyscan HOST >> ~/.ssh/known_hosts

cp id_rsa BASE_DIR
chmod a+r BASE_DIR/id_rsa
