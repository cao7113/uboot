echo ==Init user
uname=${BOOT_INIT_USER:-doger}
if grep -q "$uname" /etc/passwd; then
  echo Warning: directly use already existed user: $uname!
else
  sudo useradd --create-home --shell /bin/bash --groups sudo $uname
  #sudo passwd $uname
  echo ==created a user: $uname
fi
