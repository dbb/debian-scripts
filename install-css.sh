#!/bin/sh

##
## https://github.com/dbb
##
## This version was modified by dbbolton on 30 Dec 2011. Reasons for 
## modifications include:
##  - Add new mirror
##  - Remove depracated dpkg flag
##  - Move build dir out of /tmp in case it is mounted with the noexec opt
##  - Add message to remind user to remove build directory
##  - Other minor fixes

# Shell script to install libdvdcss under Debian GNU Linux
# Many DVDs use css for encryption.  To play these discs, a special library
# is needed to decode them, libdvdcss.  Due to legal problems, Debian and most
# Linux distibutions cannot distribute libdvdcss
# Use this shell script to install the libdvdcss under DEBIN GNU/Linux
# --------------------------------------------------------------------------
# Refer url for more info:
# Copyright info -  http://www.dtek.chalmers.se/~dvd/
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------


set -e

site=http://ftp.nc.debian.org/videolan/debian/sources/
arch=$(dpkg --print-architecture)

soname=2
uversion=1.2.5
#available="alpha hppa i386 ia64 powerpc s390 sparc"
available="i386"
version=${uversion}-1

if ! type wget > /dev/null ; then
    echo "Install wget and run this script again"
    exit 1
fi

for a in $available; do
    if [  "$a" = "$arch" ]; then
    wget ${site}libdvdcss${soname}_${version}_${arch}.deb -O /tmp/libdvdcss.deb
    dpkg -i /tmp/libdvdcss.deb
    exit $?
    fi
done

echo "No binary deb available.  Will try to build $uversion and install it."
echo "Edit var \$uversion to install another version. Visit $site to see what is available."
echo
echo "You need to have debhelper, dpkg-dev and fakeroot installed."
echo "If not, interrupt now, install them and rerun this script."
echo
echo "This is higly experimental; look out for what happens below."
echo "If you want to stop, interrupt now (control-c), else press"
echo "return to proceed"
read dum

mkdir -p tmp/dvd
cd tmp/dvd
wget ${site}libdvdcss_${uversion}.orig.tar.gz
wget ${site}libdvdcss_${version}.diff.gz
wget ${site}libdvdcss_${version}.dsc
dpkg-source -x libdvdcss_${version}.dsc
cd libdvdcss-${uversion}
fakeroot ./debian/rules binary
echo "Any problems?  Interrupt now (control-c) and try to fix"
echo "manually, else go on and install (return)."
dpkg -i ../libdvdcss${soname}_${version}_${arch}.deb

## Add final message
echo -e "Build completed. You may want to run:\n\n\trm -rf ./tmp\n"

