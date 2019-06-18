+++
title = "1.1 Setup"
weight = 1
template = "doc.html"
+++
Before we begin working on Hoon, you should first (1) have Urbit installed and (2) boot a ship that you can use for trying out Hoon examples. Interactive learning is far superior to passive reading.

## Installing Urbit

You can install Urbit on any Mac or Unix machine; follow the steps for [creating a development ship](/docs/using/creating-a-development-ship).  On Windows, make a virtual Linux machine using VirtualBox or a similar tool.

Once you're finished you can boot your very own ship.

## What is an urbit?

An **urbit** is an Urbit virtual computer with persistent state that can connect to the Urbit network.  (Note the lowercase 'u' here.  'Urbit' is the entire software stack, whereas 'an urbit' is a local instance.)  Each urbit is associated with a unique number that plays three distinct roles: (1) it's an address on the Urbit network, (2) it's a cryptographic identity, and (3) it's (in principle) a human memorable name.  Normally an urbit's name is represented as a string starting with `~`, as in `~zod` or `~taglux-nidsep`.

These may not look like numbers, but they are.  Each urbit name is written in a base-256 format, where each 'digit' is a syllable.  Imagine your phone number as a pronounceable string which sounds like a name in a foreign language.  An ordinary user-level urbit is a 'planet', and it's named by a 32-bit number.  The latter is represented as a four-syllable string; e.g., the planet name `~taglux-nidsep` is the number 6,095,360.

## Getting started 

Once you've installed your development ship (or your own ship on the live network), let's try a basic command. Type `(add 2 2)` at the prompt and hit return.  Your screen now shows:

```
ames: on localhost, UDP 31337.
http: live (insecure, public) on 8080
http: live ("secure", public) on 8443
http: live (insecure, loopback) on 12321
> (add 2 2)
4
~palnul_nocser:dojo>
```

You just used a function from the Hoon standard library, `add`.  Next, quit Urbit with `ctrl-d`:

```
> (add 2 2)
4
~palnul_nocser:dojo>
$
```

Your ship isn't running anymore and you're back at your computer's normal terminal prompt. If your ship is `~palnul_nocser`, then you can restart the ship by typing:

```
urbit palnul_nocser
```

## Another Noun

You've already used a standard library function to produce one value, in the dojo.  Now that your ship is running again, let's try another.  Enter the number `17`.

> We won't show the `~palnul_nocser:dojo> ` prompt from here on out.  We'll just show the echoed command along with its result.

You'll see:

```
> 17
17
```

You asked dojo to evaluate `17` and it echoed the number back at you.  This value is a 'noun'.  We'll talk more about nouns in [Chapter 1.2](docs/learn/hoon/hoon-tutorial/nouns/), but first let's write a very basic program.

## Generators

Generators are the most straightforward way to write Hoon programs. They are a concept in Arvo, and involve saving Hoon code in a `.hoon` text file. While they aren't strictly part of the Hoon language, we'll be dealing with generators throughout this tutorial.

The simplest type of generator is the **naked generator**. All naked generators are `gates`: functions that take an argument and produce an output. So, to create a generator, all you need to do is write a `gate` and put it into a file in the `/home/gen` directory of your ship as a `.hoon` file. To run a generator named `mygen.hoon`, you would type `+myhoon <argument>` in your ship's Dojo.

If this doesn't make sense yet, that's okay. In the next lesson, we will walk you through an example `gate` that is run as a generator.

### [Next Up: Walkthrough -- List of Numbers](../list-of-numbers)
