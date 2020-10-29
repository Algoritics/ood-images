#!/bin/bash
set -e

yum install -y centos-release-scl https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-6.noarch.rpm
yum install -y ondemand ondemand-dex
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell
echo "DEFAULT_SSHHOST=head" > /etc/ood/config/apps/shell/env
PORT=${1:-8080}
cat > /etc/ood/config/ood_portal.yml <<EOF
listen_addr_port: ${PORT}
port: ${PORT}
servername: localhost
host_regex: "[^/]+"
node_uri: '/node'
rnode_uri: '/rnode'
EOF
/opt/ood/ood-portal-generator/sbin/update_ood_portal
cp /build/launch-ood /usr/local/sbin/launch

# setup interactive desktop
mkdir -p /etc/ood/config/apps/bc_desktop
cat > /etc/ood/config/apps/bc_desktop/example.yml << EOF
title: "Example Desktop"
cluster: "example"
EOF

# setup jupyter app
git clone https://github.com/OSC/bc_example_jupyter.git /var/www/ood/apps/sys/jupyter
sed -i 's/cluster: ""/cluster: "example"/g' /var/www/ood/apps/sys/jupyter/form.yml

yum clean all && rm -rf /var/cache/yum/*
