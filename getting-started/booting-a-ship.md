+++
title = "Booting a Ship"
weight = 3
template = "doc.html"
+++
Now the rubber meets the road. You'll be booting your ship with the keyfile that you [downloaded from Bridge](@/docs/concepts/azimuth.md).

Note that this document is only for booting a ship that uses the live Arvo network. If you just want to create an unnetworked ship for development purposes, read [this guide](@/docs/using/creating-a-development-ship.md) instead.

## Step 1: Find Your Point's Name

This will look something like `~lodleb-ritrul`. You can see the name of your point(s) when you log into your wallet using the Bridge client.

![](https://media.urbit.org/site/bridge-0.png)

## Step 2: Find the path to your keyfile

Find the absolute path to the keyfile that you downloaded from Bridge. Copy it.

## Step 3: Run the boot command

Type `cd` in your terminal to return to your home directory. If you want to
store your ship somewhere besides your home directory, change the terminal's
working directory to the desired directory.

Run the command below, except with `sample-planet` replaced by the name of your
Urbit identity, and `path/to/my-planet.key` replaced with the path to your
keyfile:

```
./urbit -w sample-planet -k path/to/my-planet.key
```

Or, if you'd prefer to copy your key in, you can run:

```
./urbit -w sample-planet -G rAnDoMkEy
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

`|mount %` will cause a `home/` directory to appear inside your _pier_ folder in Unix (the "pier" is our shorthand for the directory whose name corresponds to your Azimuth point). Once you've changed a file, `|commit %home` to synchronize changes to your pier.

**Note:** Do not delete your pier. Doing so will make your ship unusable, because deleted piers normally cannot be recovered. The exception is during a network breach (a reset) -- in such a rare event, you must delete your pier to update your ship to the new era, and ships with previously deleted piers can be recovered.

### Shutting Down and Restarting

You can toggle between the Dojo and Talk (chat) prompts with `ctrl-x`. You can turn your ship off with `ctrl-d` from the Talk or Dojo prompts.

To restart your ship, simply pass the name of your pier:

```
./urbit some-planet
```

### Using Landscape

Landscape is the Urbit web interface, and it's the best way to interact with your ship. Chrome and Brave are the recommended browsers for using Landscape. To get onto Landscape:

1. Start your ship. In the boot messages, look for a line that says something like `http: live (insecure, public) on 80`. The number given is the port that your ship is using.
2. If the port given is 80, simply type `localhost` into your browser's address bar. If the given port is a different number, such as `8080`, you would type `localhost:8080`.
3. Type `+code` into your ship's Dojo. Copy-paste the returned code into the field asking for it.
4. You're in! Now you can explore apps such as Chat for messages, Publish for blogging, and Weather.
