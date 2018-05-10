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
sudo env "PATH=$PATH" ninja -C ./build/ meson-install
urbit
```

##### Ubuntu or Debian

```
# Bash

sudo apt-get update
sudo apt-get install autoconf automake cmake exuberant-ctags g++ git libcurl4-gnutls-dev libgmp3-dev libncurses5-dev libsigsegv-dev libssl-dev libtool make meson openssl python ragel re2c zlib1g-dev
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

##### Fedora

```
# Bash

sudo dnf upgrade
sudo dnf install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool meson ncurses-devel openssl openssl-devel python2 ragel re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

##### FreeBSD

```
# Bash

pkg upgrade
pkg install autoconf automake cmake curl gcc git gmake gmp libsigsegv libtool meson python ragel re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

##### Arch

```
# Bash

pacman -Syu
pacman -S autoconf automake cmake curl gcc git gmp libsigsegv libtool meson ncurses openssl python ragel re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

##### AWS

```
# Bash

sudo yum update
sudo yum install --enablerepo epel autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool meson ncurses-devel openssl-devel python re2c
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

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

