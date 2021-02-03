FROM debian:stable
# Build
ARG MIRROR_DEBIAN
ARG PYPI_URL
ARG PYPI_HOST
# ARG PACKAGES="make unzip wget curl jq python-apt python python-pip python-dev python-openstackclient python-heatclient git"
ARG PACKAGES="make unzip wget curl jq software-properties-common apt-transport-https ca-certificates python python-pip python-setuptools gnupg"

# Run
ENV DEBIAN_FRONTEND noninteractive
ENV TERRAFORM_VERSION=0.14.5

# Install default packages
# Use nexus repo to speed up build if MIRROR_DEBIAN defined
RUN echo "$APP_ENV $http_proxy $no_proxy" && set -x && [ -z "$MIRROR_DEBIAN" ] || \
     sed -i.orig -e "s|http://deb.debian.org/debian|$MIRROR_DEBIAN/debian10|g ; s|http://security.debian.org/debian-security|$MIRROR_DEBIAN/debian10-security|g" /etc/apt/sources.list ; \
    apt-get -q update && \
    apt-get install -qy --no-install-recommends --force-yes \
    $PACKAGES && \
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## install pip modules
COPY requirements.txt /tmp/requirements.txt
RUN set -ex && [ -z "$PYPI_URL" ] || pip_args=" --index-url $PYPI_URL " ; \
    [ -z "$PYPI_HOST" ] || pip_args="$pip_args --trusted-host $PYPI_HOST " ; \
    echo "$no_proxy" |tr ',' '\n' | sort -u |grep "^$PYPI_HOST$" || \
      [ -z "$http_proxy" ] || pip_args="$pip_args --proxy $http_proxy " ; \
    pip install $pip_args -I --no-deps -r /tmp/requirements.txt

WORKDIR /terraform

# install docker
ENV MIRROR_DOCKER=${MIRROR_DOCKER:-https://download.docker.com/linux}
RUN curl -fsSL $MIRROR_DOCKER/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - ; \
    add-apt-repository \
     "deb [arch=amd64] $MIRROR_DOCKER/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) \
     stable" ; \
    apt-get update -q ; \
    apt-get install -qy docker-ce

# install terraform version
RUN curl -sO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install cdktf
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -qy nodejs \
    && npm install -g cdktf-cli

# Install tf provider plugins in /usr/local/share/terraform/plugins
COPY provider.tf .
RUN mkdir -p /usr/local/share/terraform/plugins && \
      echo 'plugin_cache_dir = "/usr/local/share/terraform/plugins"' > $HOME/.terraformrc && \
      terraform init -backend=false

ENTRYPOINT ["/bin/bash"]
