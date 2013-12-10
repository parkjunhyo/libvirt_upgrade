#! /usr/bin/env bash

## look for the source file from http://libvirt.org/sources/
## change the source path
env_source_path=$(find `pwd` -name source_code.path)
source $env_source_path
working_directory=$(pwd)

## download source default version information
source_version=${source_version:='libvirt-1.1.3'}
source_file=$source_version.tar.gz
source_file_path="http://libvirt.org/sources/$source_file"

## installation necessary package
apt-get install -qqy --force-yes zip gcc pkg-config libxml2-dev libdevmapper-dev libpciaccess-dev python-dev make libnl-dev libyajl-dev libvirt-bin

## download the source code and build up for upgrade for qemu
if [[ ! -d $working_directory/$source_version ]]
then
 wget $source_file_path
 gunzip -c $working_directory/$source_file | tar xvf -
 rm -rf $working_directory/$source_file
 # upgrade
 cd $working_directory/$source_version
 ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-qemu=yes
 make
 sudo make install
 cd $working_directory
fi

## restart the libvirtd
initctl stop libvirt-bin  
initctl start libvirt-bin 
