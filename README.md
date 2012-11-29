# Introduction

This is my setup for developing on puppet.

# Requirements

* Vagrant

# Puppet

Running puppet is done by a shell script. This allows me to perform some
basic changes to the box before provisioning with puppet. Installing extra
packages for example that are not present on the basebox.

As you will notice, the module dirs are split out in upstream/internal/dev.
This should be pretty self-explaining.

The complete puppet tree is in a subfolder puppet which gets copied to the
box so puppet can run from it's default dir /etc/puppet. We messed with file()
once which was the main reason for implementing it this way. But it stuck.
I kinda like it.

Another cool option is probably graphing. They are stored in the graphs folder.
This is especially useful when you are trying to debug dependencies.

