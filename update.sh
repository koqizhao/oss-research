#!/bin/bash

set -e

apt update
apt upgrade -y
apt autoremove --purge -y

snap refresh
