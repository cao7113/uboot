#!/usr/bin/env bash
# Generated at 2015-11-22 06:49:13, DO NOT EDIT THIS SCRIPT!!!
set -e

t0=`date`
which git > /dev/null || { echo No git command available; exit 1; }

## Get rbenv with common plugins into RBOX_ROOT/rbenv, defalut: /rbox/rbenv

set -e

run_as=`id -un`
perm=$run_as:`id -gn`

#标识本地vagrant-vm开发调试
[ "$run_as" = 'vagrant' -a -d /vagrant ] && vagrant_vm=1

rbox_root=${RBOX_ROOT:-/rbox}

[ -d $rbox_root ] || {
  cmd="mkdir -p $rbox_root" && $cmd &>/dev/null || sudo $cmd 
}
[ "`stat --format '%U:%G' $rbox_root`" = "$perm" ] || { 
  sudo chown -R $perm $rbox_root
  echo ==make $perm permission to dir: $rbox_root
}
cd $rbox_root

rbenv_root=$rbox_root/rbenv
rbenv_repo=${RBENV_REPO:-https://github.com/sstephenson/rbenv.git}
echo ==use rbenv root: $rbenv_root

[ -d $rbenv_root/.git -o -n "$NOT_RBENV_CACHE"  ] || { 
  if [ -n "$vagrant_vm" ]; then
    rbenv_cache_dir=/vagrant/cache/rbox/rbenv
    [ -d $rbenv_cache_dir ] && {
      # use cp not ln to avoid changes to rbenv_cache, repackage
      cp -r $rbenv_cache_dir $rbenv_root
      echo ==using local cache rbenv $rbenv_cache_dir ...
    }
  fi
}

[ -d $rbenv_root/.git ] || { 
  git clone $rbenv_repo $rbenv_root 
  mkdir -p $rbenv_root/shims
  mkdir -p $rbenv_root/cache && echo Enabled ruby-build download package cache to path: $rbenv_root/cache
}

rbenv_plugins_root=$rbenv_root/plugins
[ -d $rbenv_plugins_root ] || {
  mkdir -p $rbenv_plugins_root

  rbenv_plugins=(
  https://github.com/cao7113/rbenv-update.git
  #taobao source first checked
  https://github.com/cao7113/ruby-build.git
  https://github.com/sstephenson/rbenv-gem-rehash.git
  https://github.com/sstephenson/rbenv-default-gems.git
  https://github.com/sstephenson/rbenv-vars.git
  #rbenv bundler on|off #require manually enabled
  #check with: rbenv which rake
  https://github.com/carsomyr/rbenv-bundler.git
  )

  cd $rbenv_plugins_root

  for plug_repo in ${rbenv_plugins[@]}; do
    git clone $plug_repo && echo ==git cloning $plug_repo ...
  done
}

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

  for f in gemrc irbrc railsrc rails.irbrc pryrc; do
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
