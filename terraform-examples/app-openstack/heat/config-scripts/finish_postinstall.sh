#!/bin/bash
#
# trigger wait condition
#
echo "# RUNNING: $(dirname $0)/$(basename $0)"
set -xe -o pipefail
function clean() {
  ret=$?
  [ "$ret" -gt 0 ] && notify_status FAILURE "Deploy $0: $message ($ret)"
  exit $ret
}
trap clean EXIT QUIT KILL

libdir=/home/debian
[ -f ${libdir}/config.cfg ] && source ${libdir}/config.cfg
[ -f ${libdir}/common_functions.sh ] && source ${libdir}/common_functions.sh

export no_proxy=$no_proxy

ret=0
echo "# end postconf"
if [ "$ret" -gt 0 ] ;then
  notify_status FAILURE "postconf failed ($ret)"
else
  notify_status SUCCESS "postconf success ($ret)"
fi

