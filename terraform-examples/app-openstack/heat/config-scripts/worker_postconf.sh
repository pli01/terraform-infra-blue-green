#!/bin/bash
echo "# RUNNING: $(dirname $0)/$(basename $0)"
set -xe -o pipefail
function clean() {
	ret=$?
	[ "$ret" -gt 0 ] && notify_status FAILURE "Deploy $0: $?"
	exit $ret
}
trap clean EXIT QUIT KILL

libdir=/home/debian
[ -f ${libdir}/config.cfg ] && source ${libdir}/config.cfg
[ -f ${libdir}/common_functions.sh ] && source ${libdir}/common_functions.sh

# Install minimal package
PACKAGE_CUSTOM="sudo curl jq"
apt-get -q update
apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM

# Add authorized_keys (better use cloud-init)
echo "## add authorized_keys"
HOME=/home/debian
if [ ! -d $HOME/.ssh ] ; then mkdir -p $HOME/.ssh ; fi
echo "$ssh_authorized_keys" |  jq -r ".[]" >> $HOME/.ssh/authorized_keys
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

apt-get install -qy --no-install-recommends nginx

cat > /home/debian/update_nginx.py <<'EOF_UPDATE'
#!/usr/bin/python
import sys
import json
import subprocess
from string import Template

metadata = json.loads(sys.stdin.read())
new_api_server = metadata.get('meta', {}).get('api_server')
new_color = metadata.get('meta', {}).get('color')

if not new_api_server:
    sys.exit(1)  # bad metadata


try:
  # compare against known list of servers
  with open('api_server.json','r') as api_file:
    current_api_server = json.loads(api_file.read())
    if current_api_server == new_api_server:
       print('no diff')
       sys.exit(0)  # no changes
except IOError:
  pass

# record updated list of servers
open('api_server.json', 'wt').write(json.dumps(new_api_server))
open('color.json', 'wt').write(json.dumps(new_color))

# generate a new nginx config file from template
t = Template("""
# auto generated nginx config
upstream api-$color {
  # generate a list of server:
  # server name1:port; server name2:port;
  $api_server
}
server {
  listen 80;
  location / {
     proxy_pass http://api-$color;
  }
}
""")
result = t.substitute(color=new_color,api_server=new_api_server)

f = open('/etc/nginx/conf.d/default.conf', 'wt')
f.write(result)
f.close()
# reload nginx's configuration
print('Reloading nginx with color: ' + new_color + ', servers: ' + new_api_server)
subprocess.call(['service', 'nginx', 'restart'])
EOF_UPDATE

rm -rf /etc/nginx/sites-enabled/default

chmod +x /home/debian/update_nginx.py
curl -qs http://169.254.169.254/openstack/latest/meta_data.json | /home/debian/update_nginx.py

# add a cron job to monitor the metadata and update nginx
crontab -l >_crontab || true
echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin" >_crontab
echo "* * * * * curl -qs http://169.254.169.254/openstack/latest/meta_data.json | /home/debian/update_nginx.py | /usr/bin/logger -t nginx_update" >>_crontab
crontab <_crontab
rm _crontab

echo "## End post installation"
