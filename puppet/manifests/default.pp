Exec { path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'] }

if $operatingsystem == 'Ubuntu' {
  notice("==Running on ubuntu...")
}

include apache
include system-update
