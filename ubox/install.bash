#!/usr/bin/env bash
# Generated at Sun Oct 25 05:44:33 UTC 2015, DO NOT EDIT THIS SCRIPT!!!

#export BOOT_UPDATE_APT=1"
export BOOT_INIT_USER=doger

echo ==Installing basic tools
if [ -n "$BOOT_UPDATE_APT" ]; then
  sudo apt-get -y update
fi
sudo apt-get -y install curl git vim htop tree
echo ==Init user
uname=${BOOT_INIT_USER:-doger}
if grep -q "$uname" /etc/passwd; then
  echo Warning: directly use already existed user: $uname!
else
  sudo useradd --create-home --shell /bin/bash --groups sudo $uname
  #sudo passwd $uname
  echo ==created a user: $uname
fi
echo ==finished
