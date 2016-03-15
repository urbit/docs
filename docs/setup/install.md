---
next: true
sort: 1
title: Install
---

# Install

Urbit is designed to run on any Unix box with an internet connection.  Debian, OS X, FreeBSD and Fedora all work well.

Urbit is alpha software.  It’s not yet completely stable, its crypto hasn’t been audited and there are plenty of rough edges.  Just so you know what you're getting into.

## Build from source

### Dependencies

Urbit depends on:

    gcc (or clang)
    gmp
    libsigsegv
    openssl
    automake
    autoconf
    ragel
    cmake
    re2c
    libtool
    libssl-dev (Linux only)
    ncurses (Linux only)

Which can usually be installed with the following one-liners:

    # Mac OS X [Homebrew]
    brew install git gmp libsigsegv openssl libtool autoconf automake cmake

    # Mac OS X [Macports]
    sudo port install git gmp libsigsegv openssl autoconf automake cmake

    # Ubuntu or Debian
    sudo apt-get install libgmp3-dev libsigsegv-dev openssl libssl-dev libncurses5-dev git make exuberant-ctags automake autoconf libtool g++ ragel cmake re2c

    # Fedora
    sudo dnf install gcc gcc-c++ git gmp-devel openssl-devel openssl ncurses-devel libsigsegv-devel ctags automake autoconf libtool ragel cmake re2c

    # FreeBSD
    pkg install git gmake gmp libsigsegv openssl automake autoconf ragel cmake re2c libtool

    # AWS
    sudo yum —enablerepo epel install gcc gcc-c++ git gmp-devel openssl-devel ncurses-devel libsigsegv-devel ctags automake autoconf libtool cmake re2c

### Setting up swap

Urbit wants to map 2GB of memory when it boots up.  We won’t
necessarily use all this memory, we just want to see it.  On a
normal modern PC or Mac, this is not an issue.  On some small
cloud virtual machines (Amazon or Digital Ocean), the default
memory configuration is smaller than this, and you need to
manually configure a swapfile.

Digital Ocean has a post on adding swap [here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04).  For Amazon there’s a StackOverflow thread [here](http://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance).

Don’t spend a lot of time tweaking these settings; the simplest
thing is fine.

### Clone and make

Once your dependencies are installed the rest is easy:

    git clone https://github.com/urbit/urbit
    cd urbit
    make
    curl -o urbit.pill https://bootstrap.urbit.org/latest.pill

After running `make` your Urbit executable lives at `bin/urbit`.  The `.pill` file is a compiled binary of Arvo that Urbit uses to bootstrap itself.