# Introduction

This is my setup for developing on puppet.

# Requirements

* Vagrant


# Usage

## Puppet

Running puppet is done by a shell script. This allows me to perform some
basic changes to the box before provisioning with puppet. Installing extra
packages for example that are not present on the basebox.

As you will notice, the module dirs are split out in upstream/internal/dev.
This should be pretty self-explaining.

The complete puppet tree is in a subfolder puppet which gets copied to the
box so puppet can run from it's default dir /etc/puppet. We ran into trouble
with the (puppet) file function once which is the main reason for implenting
it this way. We no longer use 'file()' but the method stuck.

On each puppet run, we also create a dependency graph. They are stored in the
graphs folder. This is especially useful for debugging dependencies.

## Additional Packages

If a directory `./packages/centos exists`, each rpm in this directory will be
installed if the guest operating system uses yum. The same goes for
`./packages/debian` if your system has dpkg installed.

If a directory `./packages/<fqdn>` exists, packages inside this folder will
also be installed.

