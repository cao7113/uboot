echo ==Installing basic tools
if [ -n "$BOOT_UPDATE_APT" ]; then
  sudo apt-get -y update
fi
sudo apt-get -y install curl htop vim git tree
