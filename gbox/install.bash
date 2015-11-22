#!/usr/bin/env bash
set -e

# prepare env
echo ==running as root user
source /etc/rbenv.sh
gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
gem install bundler
bundle config mirror.https://rubygems.org https://ruby.taobao.org

app_root=/apps/grack
repos_root=/data/repos
url=${REPO_URL:-https://github.com/grackorg/grack}
pidfile=/var/run/grack.pid

mkdir -p $(dirname $app_root)
mkdir -p $repos_root
[ -d $repos_root/test.git ] || {
  git init --bare $repos_root/test.git
}

[ -d $app_root ] || {
  git clone $url $app_root 
  cd $app_root
  cp -b /vagrant/gbox/config.ru $app_root/config.ru
}

cd $app_root
#git pull
bundle install --without development test
[ -s $pidfile ] && kill -9 `cat $pidfile`
bundle exec rackup --host 0.0.0.0 --port 80 -D -P $pidfile config.ru
echo ==run rack pid: `[ -s $pidfile ] && cat $pidfile`
