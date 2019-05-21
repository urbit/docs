+++
title = "Installing Urbit"
weight = 2
template = "doc.html"
+++
Arvo runs nicely on a Unix-like operating system -- Ubuntu, Fedora, macOS, and FreeBSD, for example. If you're using Windows, you'll need to get one of the aforementioned systems. Don't worry: most of them are free. Let's get it onto your machine.

But first, some terminology:
- `vere` or `urbit`: the interpreter that runs when you run a command like `urbit` or `/bin/urbit` in your command line
- `arvo`: the deterministic OS that lives in a directory whose name matches your Azimuth point, ie `~famreb-todmec` lives in `/famreb-todmec`

We have different installation instructions for different platforms. To install and run Arvo, run the commands that are listed for your operating system.

On any platform, you can check your Arvo installation by running the `urbit` command. Installation was successful if you get a block of output that begins with the line below:

```
Urbit: a personal server operating function
```

## Instructions

### MacOS

We recommend using the Homebrew package manager to run Arvo on MacOS.

```
# Bash

brew update
brew install -v gcc git gmp libsigsegv libtool meson ninja pkg-config openssl
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ meson-install
urbit
```

### Ubuntu or Debian

```
# Bash

sudo apt-get update
sudo apt-get install g++ git libcurl4-gnutls-dev libgmp3-dev libncurses5-dev libsigsegv-dev libssl-dev make openssl pkg-config python python3 python3-pip python3-setuptools zlib1g-dev ninja-build
sudo -H pip3 install --upgrade pip
sudo -H pip3 install meson

git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ install
urbit
```

To access your Urbit via HTTP on port 80, you may need to run the following:

```
sudo apt-get install libcap2-bin
sudo setcap 'cap_net_bind_service=+ep' $(which urbit)
```

### Fedora 23 or earlier

```
# Bash

sudo yum upgrade
sudo yum install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel ninja-build openssl openssl-devel pkgconfig python3 re2c wget

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
sudo -H /usr/local/bin/pip3 install meson


git clone git://github.com/ninja-build/ninja.git && cd ninja
git checkout release
./configure.py --bootstrap
sudo cp ./ninja /usr/local/bin

git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo /usr/local/bin/ninja -C ./build/ install
urbit
```

### Fedora 24 or later

```
# Bash

sudo dnf upgrade
sudo dnf install autoconf automake cmake ctags gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel libtool ncurses-devel meson ninja-build openssl openssl-devel pkgconfig python3 re2c wget

git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
sudo ninja -C ./build/ install
urbit
```

### Arch Linux

```
# Bash

sudo pacman -Syyu
sudo pacman -S --needed curl gcc git gmp libsigsegv ncurses ninja openssl python python-pip meson
git clone https://github.com/urbit/urbit
cd urbit
./scripts/bootstrap
./scripts/build
cd build
ninja
sudo ninja meson-install
urbit
```

### FreeBSD

```
# Bash or Sh

pkg upgrade
sudo pkg install curl gcc git gmake gmp libsigsegv python python3 ncurses openssl gmp
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

### Amazon Web Services

```
# Bash

sudo yum update
sudo yum install gcc gcc-c++ git gmp-devel libcurl-devel libsigsegv-devel ncurses-devel openssl openssl-devel pkgconfig python3 python3-pip wget git
sudo env "PATH=$PATH" pip3 install --upgrade pip
sudo env "PATH=$PATH" pip3 install meson


# we need libsigsegv
#

wget http://dl.fedoraproject.org/pub/fedora/linux/releases/25/Everything/x86_64/os/Packages/l/libsigsegv-2.10-10.fc24.x86_64.rpm
wget http://dl.fedoraproject.org/pub/fedora/linux/releases/25/Everything/x86_64/os/Packages/l/libsigsegv-devel-2.10-10.fc24.x86_64.rpm
sudo yum localinstall libsigsegv-2.10-10.fc24.x86_64.rpm
sudo yum localinstall libsigsegv-devel-2.10-10.fc24.x86_64.rpm

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

## Booting a Ship

One you've completed your installation, you can continue on to the instructions for [booting your ship](./docs/getting-started/booting-a-ship.md) to get on the Arvo network.

Or, if you want to try testing and writing code, check out the guide to [getting an unnetworked development ship](./docs/getting-started/creating-a-development-ship.md).


## Set Up Swap

If you're running Urbit in the cloud on a small instance, you may need to additionally configure swap space. If you're not, you can safely ignore this section.

Urbit wants to map 2GB of memory when it boots up. We won’t necessarily use all this memory, we just want to see it. On a normal modern PC or Mac, or on a large cloud virtual machine, this is not an issue. On some small cloud virtual machines (Amazon or Digital Ocean), the default memory configuration is smaller than this, and you need to manually configure a swapfile.

Digital Ocean has a post on adding swap [here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04). For Amazon there’s a StackOverflow thread [here](https://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance).

Don’t spend a lot of time tweaking these settings; the simplest thing is fine.
