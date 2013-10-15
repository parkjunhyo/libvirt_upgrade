#! /usr/bin/env bash

## look for the source file from http://libvirt.org/sources/
## change the source path
source $(pwd)/source_code.path

## installation necessary package
apt-get install -y zip gcc pkg-config libxml2-dev libdevmapper-dev libpciaccess-dev python-dev make libnl-dev libyajl-dev

## download the source code
if [[ ! -d $(pwd)/$source_name ]]
then
 wget $source_code
 gunzip -c $(pwd)/libvirt-1.1.3.tar.gz | tar xvf -
fi

## build up the source code (for qemu)
working_directory=$(pwd)
cd $(pwd)/$source_name
./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-qemu=yes
make
sudo make install
cd $working_directory

## libvirt restart
initctl stop libvirt-bin  
initctl start libvirt-bin 
