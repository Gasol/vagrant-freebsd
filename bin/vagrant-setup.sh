#!/bin/sh
################################################################################
# CONFIG
################################################################################

# Packages which are pre-installed
INSTALLED_PACKAGES="ca_root_nss virtualbox-ose-additions bash sudo ezjail"

# Configuration files
MAKE_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/etc/make.conf"
RC_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/etc/rc.conf"
RESOLV_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/etc/resolv.conf"
LOADER_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/boot/loader.conf"
EZJAIL_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/usr/local/etc/ezjail.conf"
PF_CONF="https://raw.github.com/Gasol/vagrant-freebsd/master/etc/pf.conf"

# Message of the day
MOTD="https://raw.github.com/Gasol/vagrant-freebsd/master/etc/motd"

# Private key of Vagrant (you probable don't want to change this)
VAGRANT_PRIVATE_KEY="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

################################################################################
# PACKAGE INSTALLATION
################################################################################

# Setup pkgng
cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
pkg update
pkg upgrade -y

# Install required packages
for p in $INSTALLED_PACKAGES; do
    pkg install -y "$p"
done

################################################################################
# Configuration
################################################################################

# Create the vagrant user
pw useradd -n vagrant -s /usr/local/bin/bash -m -G wheel -h 0 <<EOP
vagrant
EOP

# Enable sudo for this user
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# Authorize vagrant to login without a key
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh

# Get the public key and save it in the `authorized_keys`
fetch -o /home/vagrant/.ssh/authorized_keys $VAGRANT_PRIVATE_KEY
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# Mappings for meta-arrow keys for word moving
cat <<EOF > /home/vagrant/.inputrc
"\e[1;5C": forward-word
"\e[1;5D": backward-word
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word
EOF

# make.conf
fetch -o /etc/make.conf $MAKE_CONF

# rc.conf
fetch -o /etc/rc.conf $RC_CONF

# resolv.conf
fetch -o /etc/resolv.conf $RESOLV_CONF

# loader.conf
fetch -o /boot/loader.conf $LOADER_CONF

# motd
fetch -o /etc/motd $MOTD

# ezjail
fetch -o /usr/local/etc/ezjail.conf $EZJAIL_CONF

# pf
fetch -o /usr/local/etc/pf.conf $PF_CONF


################################################################################
# CLEANUP
################################################################################

# Clean up installed packages
pkg clean -a -y

# Remove the history
cat /dev/null > /root/.history

# Try to make it even smaller
while true; do
    read -p "Would you like me to zero out all data to reduce box size? [y/N] " yn
    case $yn in
        [Yy]* ) dd if=/dev/zero of=/tmp/ZEROES bs=1M; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Empty out tmp directory
rm -rf /tmp/*

# DONE!
echo "We are all done. Poweroff the box and package it up with Vagrant."
