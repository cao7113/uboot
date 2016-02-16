# pluger settings
pluger_repo=${PLUGER_REPO:-https://github.com/cao7113/rbenv-pluger.git}
pluger_root=${PLUGER_ROOT:-$rbenv_plugins_root/rbenv-pluger}
[ -d $pluger_root ] || {
  if [ -n "$vagrant_vm" ];then
    echo ==using local /vagrant/rbenv-pluger
    ln -s /vagrant/rbenv-pluger $pluger_root
  else
    git clone $pluger_repo $pluger_root
  fi

  [ -d $rbenv_plugins_root/rbenv-vars ] && {
    ln -sb $pluger_root/etc/dot.rbenv-vars $rbenv_root/vars
  }

  [ -d $rbenv_plugins_root/rbenv-default-gems ] && {
    ln -sb $pluger_root/etc/default-gems $rbenv_root/default-gems
  }

  for f in gemrc irbrc rails.irbrc pryrc; do
    if [ -e $pluger_root/etc/dot.$f ];then
      ln -sb $pluger_root/etc/dot.$f ~/.$f 
    fi
  done
}

# compatible with common rbenv use pattern as user install type
user_rbenv_root=~/.rbenv
[ -d $user_rbenv_root ] || ln -sb $rbenv_root $user_rbenv_root

## set shell init file
global_rbenv_file=/etc/rbenv.sh #compactible with mac
[ -f $global_rbenv_file ] || {
  tmpfile=/tmp/rbenv.rc
  cat <<-RCFILE >$tmpfile
# GENEREATED by $0 at `date`, DO NOT EDIT THIS! 
# This is meant to sourced by ~/.bashrc or ~/.bash_profile
[ -n "\$RBENV_ROOT" ] && return #avoid twice sourced
export RBENV_ROOT=$rbenv_root #required
export PATH=\$RBENV_ROOT/bin:\$PATH
eval "\$(rbenv init -)"
RCFILE
  sudo mv -b $tmpfile $global_rbenv_file
  echo create global rbenv file: $global_rbenv_file !
}

## interactive bashrc
init_file=~/.bashrc #or .bash_profile
grep -q "rbenv" $init_file || {
  tmpfile=/tmp/my_bashrc
  echo "[ -e $global_rbenv_file ] && source $global_rbenv_file" > $tmpfile
  cat $tmpfile $init_file >$tmpfile.tmp && mv -b $tmpfile.tmp $init_file
  echo Set rbenv into file: $init_file, reopen shell to take effect!
}

## install a ruby
rbenv_bin=$rbenv_root/bin/rbenv
ruby_version=${RUBY_VERSION:-2.2.0} #TODO get latest ruby version?
this_ruby_dir=$rbenv_root/versions/$ruby_version 
if [ -n "$ruby_version" -a -f "$rbenv_plugins_root/ruby-build/share/ruby-build/$ruby_version" ];then
  [ -d $this_ruby_dir ] || {
    export RBENV_ROOT=$rbenv_root  #Note: must before subcommand invoked
    eval "$($rbenv_bin vars)"
    $rbenv_bin install -v $ruby_version 
    $rbenv_bin global $ruby_version
    echo Has installed $ruby_version into $this_ruby_dir
  }
fi

echo ==Install new rbox with ruby: $ruby_version from $t0 to `date`
