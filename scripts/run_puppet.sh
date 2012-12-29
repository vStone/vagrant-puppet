#!/bin/bash
#
echo "#########################################################"
echo "# Running on `hostname -f`"
echo "#########################################################"

environment="${1-production}"

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

