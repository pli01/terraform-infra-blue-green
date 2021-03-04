# Send success status to OpenStack WaitCondition
function notify_success() {
    unset http_proxy
    unset https_proxy
    unset no_proxy

    # if curl is installed
    if type -p curl ; then
    $wc_notify --data-binary \
               "{\"status\": \"SUCCESS\", \"reason\": \"$1\", \"data\": \"$1\"}"
    else
    # use wget
    sed -e 's/curl -i -X/wget -v --content-on-error  -k --method/g; s/ -H / --header /g; s/--data-binary/--body-data/g;' <<EOF | /bin/bash
    $wc_notify --data-binary \
               "{\"status\": \"SUCCESS\", \"reason\": \"$1\", \"data\": \"$1\"}"
EOF
    fi
    exit 0
}

# Send failure status to OpenStack WaitCondition
function notify_failure() {
    unset http_proxy
    unset https_proxy
    unset no_proxy

    # if curl is installed
    if type -p curl ; then
    $wc_notify --data-binary \
               "{\"status\": \"FAILURE\", \"reason\": \"$1\", \"data\": \"$1\"}"
    else
    # use wget
    sed -e 's/curl -i -X/wget -v --content-on-error  -k --method/g; s/ -H / --header /g; s/--data-binary/--body-data/g;' <<EOF | /bin/bash
    $wc_notify --data-binary \
               "{\"status\": \"FAILURE\", \"reason\": \"$1\", \"data\": \"$1\"}"
EOF
    fi
    exit 1
}
