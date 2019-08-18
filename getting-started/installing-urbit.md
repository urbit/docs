+++
title = "Installing Urbit"
weight = 2
template = "doc.html"
+++

Arvo runs nicely on a Unix-like operating system – Ubuntu, Fedora, macOS, and FreeBSD, for example. If you're using Windows, you'll need to get one of the aforementioned systems. Don't worry: most of them are free. Let's get it onto your machine.

But first, some terminology:

- `vere` or `urbit`: the interpreter that runs when you run a command like `urbit` or `/bin/urbit` in your command line
- `arvo`: the deterministic OS that lives in a directory whose name matches your Azimuth point, ie `~famreb-todmec` lives in `/famreb-todmec`

We have different installation instructions for different platforms. To install and run Arvo, run the commands that are listed for your operating system.

On any platform, you can check your Arvo installation by running the `urbit` command. Installation was successful if you get a block of output that begins with the line below:

```
Urbit: a personal server operating function
```

## Instructions

### macOS (Darwin)

We provide static binaries for macOS. You can grab the latest stable release as follows:

```
curl -O https://bootstrap.urbit.org/urbit-darwin-v0.8.2.tgz
tar xzf urbit-darwin-v0.8.2.tgz
./urbit
```

### Linux (64-bit)

We also provide static binaries for 64-bit Linux distributions (Ubuntu, Debian, Fedora, Arch, etc.). You can get the latest stable release similarly:

```
curl -O https://bootstrap.urbit.org/urbit-linux64-v0.8.2.tgz
tar xzf urbit-linux64-v0.8.2.tgz
./urbit
```

To access your Urbit via HTTP on port 80, you may need to run the following:
`sudo apt-get install libcap2-bin`
`sudo setcap 'cap_net_bind_service=+ep' $(which urbit)`

### Other

We maintain a [Nix](https://nixos.org/nix) derivation for Urbit in [nixpkgs](https://github.com/NixOS/nixpkgs), however we're still in the process of updating it to `v0.8.2`. Once available, you will be able to install and launch it like so:

```
nix-env -i urbit
urbit
```

## Booting a Ship

One you've completed your installation, you can continue on to the instructions for [booting your ship](@/docs/getting-started/booting-a-ship.md) to get on the Arvo network.

Or, if you want to try testing and writing code, check out the guide to [getting an unnetworked development ship](/docs/using/creating-a-development-ship).

## Set Up Swap

If you're running Urbit in the cloud on a small instance, you may need to additionally configure swap space. If you're not, you can safely ignore this section.

Urbit wants to map 2GB of memory when it boots up. We won’t necessarily use all this memory, we just want to see it. On a normal modern PC or Mac, or on a large cloud virtual machine, this is not an issue. On some small cloud virtual machines (Amazon or Digital Ocean), the default memory configuration is smaller than this, and you need to manually configure a swapfile.

Digital Ocean has a post on adding swap [here](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04). For Amazon there’s a StackOverflow thread [here](https://stackoverflow.com/questions/17173972/how-do-you-add-swap-to-an-ec2-instance).

Don’t spend a lot of time tweaking these settings; the simplest thing is fine.
