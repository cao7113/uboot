# Setting vagrant vm box profile
# link this into /etc/profile.d
# todo refactor

# default pwd
cd /vagrant 

# base
alias e='exit'

# rails box aliases
alias rs='rails s -b 0.0.0.0'
alias rc='rails c'
alias rdb='rails dbconsole'

# db
alias rsql='mysql -uroot -proot'

function vbox(){
  url=https://github.com/cao7113/uboot/blob/master/vbox-init.sh
  vinit=~/vbox-init.sh
  curl $url > $vinit
  source $vinit~
  echo ==updated file $vinit
}
export -f vbox
