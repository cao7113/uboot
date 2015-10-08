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
echo ==rbenv root: $rbenv_root

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

[ -n "$LOCAL_RBENV_CACHE" ] || sudo ln -sb $rbenv_root /rbenv

rbenv_plugins_root=$rbenv_root/plugins
[ -d $rbenv_plugins_root ] || {
  mkdir -p $rbenv_plugins_root

  rbenv_plugins=(
  https://github.com/cao7113/rbenv-update.git
  https://github.com/cao7113/ruby-build.git
  https://github.com/sstephenson/rbenv-gem-rehash.git
  https://github.com/sstephenson/rbenv-default-gems.git
  https://github.com/sstephenson/rbenv-vars.git
  https://github.com/carsomyr/rbenv-bundler.git
  )

  cd $rbenv_plugins_root

  for plug_repo in ${rbenv_plugins[@]}; do
    git clone $plug_repo && echo ==git cloning $plug_repo ...
  done
}

