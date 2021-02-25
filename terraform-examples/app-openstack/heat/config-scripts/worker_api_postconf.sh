#!/bin/bash
echo "# RUNNING: $(dirname $0)/$(basename $0)"
set -xe -o pipefail
function clean() {
	ret=$?
	[ "$ret" -gt 0 ] && notify_failure "Deploy $0: $?"
	exit $ret
}
trap clean EXIT QUIT KILL

libdir=/home/debian
[ -f ${libdir}/common_functions.sh ] && source ${libdir}/common_functions.sh

# Install minimal package
PACKAGE_CUSTOM="sudo curl jq"
apt-get -q update
apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM

# Add authorized_keys (better use cloud-init)
echo "## add authorized_keys"
HOME=/home/debian
if [ ! -d $HOME/.ssh ] ; then mkdir -p $HOME/.ssh ; fi
echo '$ssh_authorized_keys' |  jq -r ".[]" >> $HOME/.ssh/authorized_keys
chown debian. -R $HOME/.ssh
HOME=/root

# enable ssh forwarding
echo "## AllowTcpForwarding yes"
sed -i.orig -e 's/^AllowTcpForwarding.*//g; $a\AllowTcpForwarding yes' /etc/ssh/sshd_config
grep "^AllowTcpForwarding yes" /etc/ssh/sshd_config || exit 1

echo "## AllowAgentForwarding yes"
sed -i.orig -e 's/^AllowAgentForwarding.*//g; $a\AllowAgentForwarding yes' /etc/ssh/sshd_config
grep "^AllowAgentForwarding yes" /etc/ssh/sshd_config || exit 1

# restart ssh
service ssh restart

# config here
apt-get install -qy --no-install-recommends python

cat > /home/debian/api.py <<EOF
from wsgiref.simple_server import make_server
import os

myhost = os.uname()[1]

app_port = int(os.environ.get('APP_PORT', 9000))
hello_target = os.environ.get('COLOR', 'World')

GREETING = 'Hello, '+hello_target+' from '+myhost+'\n'

def hello(environ, start_response):
	start_response('200 OK', [('Content-Type', 'text/plain')])
	return [GREETING.encode("utf-8")]

make_server('0.0.0.0', app_port, hello).serve_forever()
EOF

( cd /home/debian && nohup python /home/debian/api.py & )


echo "## End post installation"
