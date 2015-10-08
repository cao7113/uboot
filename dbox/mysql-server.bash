#!/usr/bin/env bash
set -e
#Note: blank is invalid!
root_passwd=${ROOT_PASSWORD:-root}
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $root_passwd"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $root_passwd"
sudo apt-get -y install mysql-server
#sudo apt-get -y install libmysqlclient-dev
