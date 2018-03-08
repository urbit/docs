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
Debian (jessie), Mac OS X, FreeBSD and Fedora all work well.

If you run into trouble installing Urbit, please let us know via
email, [questions@urbit.org](mailto:questions@urbit.org), or on the
forum: [urbit.org/fora](https://urbit.org/fora). You can also chat
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
openssl
python2
ragel
re2c
```

Which can usually be installed with the following one-liners:

```
# macOS (Homebrew) https://treehouse.github.io/installation-guides/mac/homebrew
# Linuxbrew http://linuxbrew.sh/
$ brew install autoconf automake cmake gcc git gmp libsigsegv libtool python2 openssl

# macOS (Macports)
$ sudo port install autoconf automake cmake gmp libsigsegv openssl

# Ubuntu or Debian
$ sudo apt-get install autoconf automake cmake exuberant-ctags g++ git libcurl4-gnutls-dev libgmp3-dev libncurses5-dev libsigsegv-dev libssl-dev libtool make openssl python ragel re2c zlib1g-dev

# Fedora
$ sudo dnf install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel openssl openssl-devel python2 ragel re2c

# FreeBSD
$ pkg install autoconf automake cmake curl gcc git gmake gmp libsigsegv libtool python ragel re2c

# Arch
$ pacman -S autoconf automake cmake curl gcc git gmp libsigsegv libtool ncurses openssl python ragel re2c

# AWS
$ sudo yum install --enablerepo epel autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel openssl-devel python re2c
```

### Clone and make

Once your dependencies are installed the rest is easy:

```
$ git clone https://github.com/urbit/urbit
$ cd urbit
$ make # gmake on FreeBSD
```

After running `make`, your Urbit executable is in `bin/urbit`. Install
it wherever you'd like.

```
$ sudo install -m 0755 bin/urbit /usr/local/bin
```

Test that it works:

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

### Boot your urbit

And you're done! If you're running Urbit on a normal modern PC or Mac, or
on a large cloud instance, move onto the next [setup](../setup/) section to 
boot your urbit. 

If you're running Urbit in the cloud on a small instance, however, read
the below section, as you may need to additionally configure swap space.

### (Set up swap)

Urbit wants to map 2GB of memory when it boots up.  We won’t necessarily 
use all this memory, we just want to see it.  On a normal modern PC or Mac, 
or on a large cloud virtual machine, this is not an issue.  On some small 
cloud virtual machines (Amazon or Digital Ocean), the default memory 
configuration is smaller than this, and you need to manually configure a 
swapfile.

Digital Ocean has a post on adding swap 
[here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04).  
For Amazon there’s a StackOverflow thread 
[here](http://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance).

Don’t spend a lot of time tweaking these settings; the simplest
thing is fine.

