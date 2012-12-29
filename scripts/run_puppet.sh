#!/bin/bash
#
echo "#########################################################"
echo "# Running on `hostname -f`"
echo "#########################################################"

environment="${1-production}"

### REQUIRED PACKAGES FOR CENTOS.
if [[ -f /usr/bin/yum && -d /vagrant/packages/centos ]]; then
  echo "Installing extra packages for CentOS"
  if [ `ls /vagrant/packages/centos/*.rpm 2>/dev/null | wc -l` -gt 0 ]; then
    for f in /vagrant/packages/centos/*.rpm; do
      yum localinstall -y `readlink -f $f` || exit 1;
    done
  fi

  echo "Installing extra packages for host"
  if [ -d /vagrant/packages/`hostname -f`/ ]; then
    for f in /vagrant/packages/`hostname -f`/*.rpm; do
      yum localinstall -y `readlink -f $f` || exit 1;
    done
  fi;
  yum clean all
fi;

if [[ -f /usr/bin/dpkg && -d /vagrant/packages/debian/ ]]; then
  echo "Installing extra packages for Debian"
  if [ `ls /vagrant/packages/debian/*.deb 2>/dev/null | wc -l` -gt 0 ]; then
    for f in /vagrant/packages/debian/*.deb; do
      dpkg -i `readlink -f $f` || exit 1;
    done
  fi

  echo "Installing extra packages for host"
  if [ -d /vagrant/packages/`hostname -f`/ ]; then
    for f in /vagrant/packages/`hostname -f`/*.deb; do
      dpkg -i  `readlink -f $f` || exit 1;
    done
  fi;
fi;


## We also need the puppet folder
[ -d /etc/puppet ] || mkdir /etc/puppet

## Sync the puppet tree from the vagrant folder to the puppet folder on the machine.
rsync -alrcWt --del --progress --exclude=.git --exclude=.svn /vagrant/puppet/* /etc/puppet/

#  --debug --verbose \
exec puppet  apply \
  --environment ${environment} \
  --debug --verbose --trace \
  --graph --graphdir /vagrant/graphs \
  --modulepath /etc/puppet/modules/upstream:/etc/puppet/modules/internal:/etc/puppet/modules/dev  \
  /etc/puppet/manifests/site.pp

