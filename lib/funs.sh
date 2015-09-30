## DEPENDENCY CHECKING
# http://www.cyberciti.biz/faq/find-out-if-package-is-installed-in-linux/#debian
function check_pkg(){
  [ $# -lt 1 ] && echo Usage: $FUNCNAME PKG_NAME && return 1
  pkg=$1
  if ! dpkg-query -W -f='${Status} ${Version}\n' "$pkg" >/dev/null; then
    echo Require package: $pkg ...
    exit 1
  fi
}

function check_pkgs(){
  [ $# -lt 1 ] && echo "Usage: $FUNCNAME PKG1 [PKG2 ...]" && return 1
  for p in $@; do
    check_pkg $p
  done
}
