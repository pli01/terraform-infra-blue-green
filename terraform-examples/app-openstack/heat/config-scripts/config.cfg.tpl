#!/bin/bash
# configuration file for all scripts
# place here all variables
cat <<EOF >/home/debian/config.cfg
export ssh_authorized_keys='${ssh_authorized_keys}'
export no_proxy="${no_proxy}"
EOF
