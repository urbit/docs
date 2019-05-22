+++
title = "Booting a Ship"
weight = 3
template = "doc.html"
+++
Now the rubber meets the road. You'll be booting your ship with the keyfile that you [downloaded from Bridge](./docs/concepts/azimuth.md).

Note that this document is only for booting a ship that uses the live Arvo network. If you just want to create an unnetworked ship for development purposes, read [this guide](./docs/getting-started/creating-a-development-ship.md) instead.

## Step 1: Find Your Point's Name

This will look something like `~lodleb-ritrul`. You can see the name of your point(s) when you log into your wallet using the Bridge client.

![](https://media.urbit.org/site/bridge-0.png)

## Step 2: Find the path to your keyfile

Find the absolute path to the keyfile that you downloaded from Bridge. Copy it.

## Step 3: Run the boot command

Type `cd` in your terminal to return to your home directory. If you want to
store your ship somewhere besides your home directory, change the terminal's
working directory to the desired directory.

Run the command below, except with `~sample-planet` replaced by the name of your
Urbit identity, and `path/to/my-planet.key` replaced with the path to your
keyfile:

```
urbit -w ~sample-planet -k path/to/my-planet.key
```

Or, if you'd prefer to copy your key in, you can run:

```
urbit -w ~sample-planet -G rAnDoMkEy
```

Either command will create a directory called `sample-planet/` and begin
building your ship. It may take a few minutes.

When your ship is finished booting, you will see the `~sample-planet:dojo>`
prompt. At that point, you should permanently erase your keyfile from your
machine.

## Basic Operations

Welcome to your ship! There's a few things you should do to become oriented.

### The Dojo

Let's try out the Dojo, the Arvo command line and Hoon REPL:

```
~sample-planet:dojo> (add 2 2)
```

Should produce:

```
> (add 2 2)
4
```

Good.

### Mounting

Your ship's filesystem being "mounted" means that its filesystem can be interacted with through Unix. This makes things much easier for you.

The Arvo filesystem isn't mounted to Unix by default. Switch to the Dojo prompt and run:

```
~sample-planet:dojo> |mount %
```

This should produce:

```
> |mount %
>=
```

which indicates that the command was processed.

`|mount %` will cause a `home/` directory to appear inside your _pier_ folder in Unix (the "pier" is our shorthand for the directory whose name corresponds to your Azimuth point). Changes to these files are automatically synced into your ship.

### Shutting Down and Restarting

You can toggle between the Dojo and Talk (chat) prompts with `ctrl-x`. You can turn your ship off with `ctrl-d` from the Talk or Dojo prompts.

To restart your ship, simply pass the name of your pier:

```
urbit some-planet
```
