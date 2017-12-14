---
navhome: /docs/
navuptwo: true
next: true
sort: 1
title: Install
---

# Install

Installing Urbit is easy.  It just takes a few minutes to get an
instance up and running on the network.  

Urbit is designed to run on any Unix box with an internet connection.
Debian (jessie), Mac OS X, FreeBSD and Fedora all work well.

If you run into trouble installing Urbit, please let us know via
email, [questions@urbit.org](mailto:questions@urbit.org), or on the
forum: [urbit.org/fora](https://urbit.org/fora).  You can also chat
with us at [urbit.org/stream](https://urbit.org/stream).

> Urbit is alpha software.  It’s not yet completely stable, its crypto
> hasn’t been audited, and there are plenty of rough edges.  Urbit is
> lots of fun to play with, but not quite ready for your important or
> sensitive data.

### Update: `~2017.12.7`

Urbit `0.5.1` is now live! We expect there to be a delay in getting our
updated `urbit-0.5.1` binary packages propagated to Homebrew, APT and
the other various package managers. So for now, **please
build and install Urbit from source**. The instructions below will walk
you through how to do that. You'll then be free to continue the boot 
and setup process as normal, per the rest of this Using docs section.

## Build from source

### Dependencies

Urbit depends on:

    C compiler (gcc or clang)
    automake
    autoconf
    libtool
    cmake
    ragel
    re2c
    libcurl
    curses
    gmp
    libsigsegv
    openssl 1.0.0

Which can usually be installed with the following one-liners:

    # Mac OS X [Homebrew]
    $ brew install gmp libsigsegv openssl libtool autoconf automake cmake

    # Mac OS X [Macports]
    $ sudo port install gmp libsigsegv openssl autoconf automake cmake

    # Ubuntu or Debian
    $ sudo apt-get install libgmp3-dev libsigsegv-dev openssl libssl-dev libncurses5-dev make exuberant-ctags automake autoconf libtool g++ ragel cmake re2c libcurl4-gnutls-dev

    # Fedora
    $ sudo dnf install gcc gcc-c++ gmp-devel openssl-devel openssl ncurses-devel libsigsegv-devel ctags automake autoconf libtool ragel cmake re2c libcurl-devel

    # FreeBSD
    $ pkg install gmake gmp libsigsegv curl python automake autoconf ragel cmake re2c libtool curl

    # Arch
    $ pacman -S gcc gmp libsigsegv openssl automake autoconf ragel cmake re2c libtool ncurses curl

    # AWS
    $ sudo yum --enablerepo epel install gcc gcc-c++ gmp-devel openssl-devel ncurses-devel libsigsegv-devel ctags automake autoconf libtool cmake re2c libcurl-devel

### Clone and make

Once your dependencies are installed the rest is easy.

If you're cloning the `urbit/urbit` Git repository for the first time, run:

    $ git clone https://github.com/urbit/urbit
    $ cd urbit
    $ make # gmake on FreeBSD

_**Updated for the `2017.12.7` continuity breach**_

If you already have a clone of the `urbit/urbit` Git repository, assuming
your `origin` upstream is the `urbit/urbit` repository on Github, run the
following commands to make sure you're on the correct, clean Git branch:

    $ cd urbit
    $ git fetch --all
    $ git checkout master
    $ git reset --hard origin/master
    $ make # gmake on FreeBSD

After running `make`, your Urbit executable is in `bin/urbit`. Install it wherever you'd like.

    # sudo install -m 0755 bin/urbit /usr/local/bin

Test that it works:

    $ urbit
    simple usage:
       urbit -c <mycomet> to create a comet (anonymous urbit)
       urbit -w <myplanet> -t <myticket> if you have a ticket
       urbit <myplanet or mycomet> to restart an existing urbit

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
