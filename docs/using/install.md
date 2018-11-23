---
navhome: /docs/
navuptwo: true
next: true
sort: 1
title: Install
---

# Install

Installing Urbit is easy. It just takes a few minutes to get an
instance up and running on the network. 

Urbit is designed to run on any Unix box with an internet connection.
macOS, Ubuntu/Debian, FreeBSD, and Fedora all work well.

If you run into trouble installing Urbit, please let us know via
email, [questions@urbit.org](mailto:questions@urbit.org), or on the
forum: [fora.urbit.org](https://fora.urbit.org). You can also chat
with us at [urbit.org/stream](https://urbit.org/stream).

> Urbit is alpha software. It’s not yet completely stable, its crypto
> hasn’t been audited, and there are plenty of rough edges. Urbit is
> lots of fun to play with, but not quite ready for your important or
> sensitive data.

## Build from source

### Dependencies

Urbit depends on:

```
autoconf
automake
C compiler (gcc or clang)
cmake
curses
git
gmp
libcurl
libsigsegv
libtool
libuv
meson
ninja
openssl
pkg-config
python2
ragel
re2c
```

### Instructions

First, you'll install the required dependencies to build Urbit from source. Then, you'll clone the Urbit source code, hosted on Github. Next, you'll bootstrap the Git submodules needed for the build. Lastly, you'll run a [Meson](https://github.com/mesonbuild/meson) build on the Urbit source to create your Urbit binary for your host operating system. Then, finally, you'll be able to boot your urbit.

For your host OS platform and relevant package installer, run the respective Bash shell commands listed below in a fresh terminal window to get Urbit installed:

> For those new to the command line, see:
>
> - Mac: [Introduction to the Mac OS X Command Line](http://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line)
> - Linux: [An Introduction to the Linux Terminal](https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal) 

#### macOS 

##### Homebrew

> [Homebrew installation guide](https://treehouse.github.io/installation-guides/mac/homebrew)

```
# Bash

brew update
brew install autoconf automake cmake gcc git gmp libsigsegv libtool meson ninja pkg-config python2 openssl re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

##### Macports

```
# Bash
 
sudo port selfupdate
sudo port install autoconf automake cmake gmp libsigsegv meson openssl
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

#### Linux

##### Linuxbrew

> [Linuxbrew](http://linuxbrew.sh/)

```
# Bash

brew update
brew install autoconf automake cmake gcc git gmp libsigsegv libtool meson ninja pkg-config python2 openssl re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo env "PATH=$PATH" ninja -C ./build/ install
urbit
```

N.B. if the step `./scripts/build` fails when attempting to
build libh2o, it could be caused by a bug in version 0.46 of meson (the bug 
is not present in 0.45 and is fixed in 0.47).

If the command `meson -v` returns a version starting with 0.46, try these steps:


```
brew uninstall meson
pip install meson=0.47.0
rm -rf build
build/scripts
```

If that is successful, resume the above instructions after the `build` step.



##### Ubuntu or Debian

```
# Bash

sudo apt-get update
sudo apt-get install autoconf automake cmake exuberant-ctags g++ git libcurl4-gnutls-dev libgmp3-dev libncurses5-dev libsigsegv-dev libssl-dev libtool make openssl pkg-config python python3 python3-pip ragel re2c zlib1g-dev
sudo -H pip3 install --upgrade pip
sudo -H pip3 install meson==0.29

# we need ninja 1.5.1
# 'apt-get install ninja-build' gives us 0.1.3
# 'apt-get install ninja-build' gives us 1.3.4
# 
git clone git://github.com/ninja-build/ninja.git
pushd ninja
	git checkout release
	./configure.py --bootstrap
	sudo cp ./ninja /usr/local/bin
popd


git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ install
urbit
```



(tested on Google Cloud Platform
   * Ubuntu Trusty Linux (14.04 LTS) 
   * Ubuntu Xenial Linux (16.04 LTS)
   * Debian 8 (Jessie)
   * Debian 9 (Stretch)
on 6 July 2018)

##### Fedora / Redhat

```
# Bash 

sudo yum upgrade
sudo yum install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel ninja-build openssl openssl-devel pkgconfig python2 python3 ragel re2c wget

# meson requires python 3.5; RHEL supplies wrong version
pushd /usr/src
	sudo wget https://www.python.org/ftp/python/3.5.5/Python-3.5.5.tgz
	sudo tar xzf Python-3.5.5.tgz
	cd Python-3.5.5
	sudo ./configure --enable--optimizations
	sudo make altinstall
	which python3.5
	cd /usr/local/bin
	sudo ln -s python3.5 python3
	hash python3
popd

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo /usr/local/bin/python3 get-pip.py
# downgrade meson to avoid dependencies that redhat can't meet
sudo -H /usr/local/bin/pip3 install meson==0.29


git clone git://github.com/ninja-build/ninja.git && cd ninja
git checkout release
./configure.py --boostrap
sudo cp ./ninja /usr/local/bin

git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo /usr/local/bin/ninja -C ./build/ install
urbit

```

(tested on Google Cloud Platform
    * Red Hat Enterprise Linux 6.1
	* Red Hat Enterprise Linux 7.1
on 5 July 2018)


##### FreeBSD

```
# Bash or Sh

pkg upgrade
sudo pkg install autoconf automake cmake curl gcc git gmake gmp libsigsegv libtool python python3 ragel re2c ncurses openssl gmp 
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo -H pip install --upgrade pip
sudo -H pip install meson
sudo pkg install ninja
git clone https://github.com/urbit/urbit
cd urbit
sh ./scripts/bootstrap
sh ./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

(tested on Google Cloud Platform
    * FreeBSD 10.4
	* FreeBSD 11.2
on 4 July 2018)

##### Arch

```
# Bash

sudo pacman -Syu
sudo pacman -S autoconf automake cmake curl gcc git gmp libsigsegv libtool ncurses ninja openssl python ragel re2c meson pkgconf
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

(tested on Amazon EC2 using Amazon Machine Image
    *  Release 2018.06.15 / ebs hvm x86_64 lts (  ami-a40a47db via  https://www.uplinklabs.net/projects/arch-linux-on-ec2/ )
on 6 July 2018)



##### AWS

```
# Bash

sudo yum update
sudo yum install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel openssl openssl-devel pkgconfig python2 python3 python3-pip ragel re2c wget git 
sudo env "PATH=$PATH" pip3 install --upgrade pip
sudo env "PATH=$PATH" pip3 install meson


# we need libsigsegv
#

wget http://dl.fedoraproject.org/pub/fedora/linux/releases/25/Everything/x86_64/os/Packages/l/libsigsegv-2.10-10.fc24.x86_64.rpm
wget http://dl.fedoraproject.org/pub/fedora/linux/releases/25/Everything/x86_64/os/Packages/l/libsigsegv-devel-2.10-10.fc24.x86_64.rpm
sudo yum localinstall libsigsegv-2.10-10.fc24.x86_64.rpm
sudo yum localinstall libsigsegv-devel-2.10-10.fc24.x86_64.rpm

# we need re2c
#
wget https://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/re2c-0.13.5-1.el6.rf.x86_64.rpm
sudo yum localinstall re2c-0.13.5-1.el6.rf.x86_64.rpm

git clone git://github.com/ninja-build/ninja.git
pushd ninja
	git checkout release
	./configure.py --bootstrap
	sudo cp ./ninja /usr/local/bin
popd


git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo env "PATH=$PATH" ninja -C ./build/ install

urbit
```

(tested on Amazon EC2 using Amazon Machine Image
    *  Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-b70554c8
on 6 July 2018)


### Test for successful installation

After running your installed `urbit` command, check to see if the following output was printed:

```
$ urbit
Urbit: a personal server operating function
https://urbit.org
Version 0.5.1

Usage: urbit [options...] ship_name
where ship_name is a @p phonetic representation of an urbit address
without the leading '~', and options is some subset of the following:

-A dir        Use dir for initial galaxy sync
-b            Batch create
-B pill       Bootstrap from this pill
-c pier       Create a new urbit in pier/
-d            Daemon mode
-D            Recompute from events
-F            Fake keys; also disables networking
-f            Fuzz testing
-g            Set GC flag
-H domain     Set ames bootstrap domain (default urbit.org)
-I galaxy     Start as ~galaxy
-k stage      Start at Hoon kernel version stage
-l port       Initial peer port
-M            Memory madness
-n host       Set unix hostname
-N            Enable networking in fake mode (-F)
-p ames_port  Set the HTTP port to bind to
-P            Profiling
-q            Quiet
-r host       Initial peer address
-R            Report urbit build info
-s            Pill URL from arvo git hash
-t ticket     Use ~ticket automatically
-u url        URL from which to download pill
-v            Verbose
-w name       Immediately upgrade to ~name
-x            Exit immediately
-Xwtf         Skip last event

Development Usage:
   To create a development ship, use a fakezod:
   urbit -FI zod -A /path/to/arvo/folder -B /path/to/pill -c zod

   For more information about developing on urbit, see:
   https://github.com/urbit/urbit/blob/master/CONTRIBUTING.md

Simple Usage:
   urbit -c <mycomet> to create a comet (anonymous urbit)
   urbit -w <myplanet> -t <myticket> if you have a ticket
   urbit <myplanet or mycomet> to restart an existing urbit
```

If so, then you're ready to boot your urbit. If not, check that you entered each Bash command correctly for your host OS platform. If you're still experiencing issues, feel free to drop into [Urbit chat](https://urbit.org/stream) for troubleshooting help.

### Boot your urbit

You've now installed the Urbit binary. If you're running Urbit on a normal modern PC or Mac, or
on a large cloud instance, move onto the next [setup](../setup/) section. 

If you're running Urbit in the cloud on a small instance, read
the below section, as you may need to additionally configure swap space, then continue.

### (Set up swap)

Urbit wants to map 2GB of memory when it boots up.  We won’t necessarily 
use all this memory, we just want to see it.  On a normal modern PC or Mac, 
or on a large cloud virtual machine, this is not an issue.  On some small 
cloud virtual machines (Amazon or Digital Ocean), the default memory 
configuration is smaller than this, and you need to manually configure a 
swapfile.

Digital Ocean has a post on adding swap 
[here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04).
For Amazon there’s a StackOverflow thread 
[here](http://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance).

Don’t spend a lot of time tweaking these settings; the simplest
thing is fine.

