#!/bin/sh

top=/home/tuomov/coding/releases/

##
## Versioning
##

pwd=`pwd`
dir=`basename "$pwd"`

release=`echo "$dir"|sed 's/^.\+-\([^-]\+-[0-9]\+\)$/\1/p; d'`

if test "$release" == ""; then
    echo "Invalid package name $dir."
    exit 1
fi


##
## Build
##

set -e

d=`echo $release|sed 's/\(....\)\(..\)\(..\)/\1-\2-\3/'`
perl -p -i -e "s/%%DATE/\\\\date{$d}/" ionconf.tex
sed 's:^TOPDIR=.*:TOPDIR='$top'/ion-'$release':' Makefile > Makefile.tmp
make -f Makefile.tmp all
make -f Makefile.tmp all-ps
make -f Makefile.tmp clean
rm Makefile.tmp
gzip *.dvi *.ps
