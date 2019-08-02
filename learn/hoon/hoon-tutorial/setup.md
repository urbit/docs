+++
title = "1.1 Setup"
weight = 1
template = "doc.html"
+++
Before we begin working on Hoon, you should first (1) have Urbit installed and (2) boot a ship that you can use for trying out Hoon examples. Interactive learning is far superior to passive reading.

## What is an urbit?

An **urbit** is an Urbit virtual computer with persistent state that can connect to the Urbit network.  (Note the lowercase 'u' here.  'Urbit' is the entire software stack, whereas 'an urbit' is a local instance.)  Each urbit is associated with a unique number that plays three distinct roles: (1) it's an address on the Urbit network, (2) it's a cryptographic identity, and (3) it's (in principle) a human memorable name.  Normally an urbit's name is represented as a string starting with `~`, as in `~zod` or `~taglux-nidsep`.

These may not look like numbers, but they are.  Each urbit name is written in a base-256 format, where each 'digit' is a syllable.  Imagine your phone number as a pronounceable string which sounds like a name in a foreign language.  An ordinary user-level urbit is a 'planet', and it's named by a 32-bit number.  The latter is represented as a four-syllable string; e.g., the planet name `~taglux-nidsep` is the number 6,095,360.

## Installing Urbit

You can install Urbit on any Mac or Unix machine; if you're just trying out Urbit or creating a development ship, you can follow the steps for creating a development ship [here](/docs/using/creating-a-development-ship).  On Windows, make a virtual Linux machine using VirtualBox or a similar tool.

Once you're finished, you can [boot your very own ship](/docs/getting-started/booting-a-ship/#step-3-run-the-boot-command). While you can develop in Hoon on your own ship on the live network, we strongly suggest developing on a development ship first.

## Getting started

Once you've created your development ship, let's try a basic command. Type `(add 2 2)` at the prompt and hit return.  Your screen now shows:

```
fake: ~zod
ames: czar: ~zod on 31337 (localhost only)
http: live (insecure, public) on 80
http: live (insecure, loopback) on 12321
> (add 2 2)
4
~zod:dojo>
```

You just used a function from the Hoon standard library, `add`.  Next, quit Urbit with `ctrl-d`:

```
> (add 2 2)
4
~zod:dojo>
$
```

Your ship isn't running anymore and you're back at your computer's normal terminal prompt. If your ship is `~zod`, then you can restart the ship by typing:

```
urbit zod
```

## Another Noun

You've already used a standard library function to produce one value, in the dojo.  Now that your ship is running again, let's try another.  Enter the number `17`.

> We won't show the `~zod:dojo> ` prompt from here on out.  We'll just show the echoed command along with its result.

You'll see:

```
> 17
17
```

You asked dojo to evaluate `17` and it echoed the number back at you.  This value is a 'noun'.  We'll talk more about nouns in [Chapter 1.2](docs/learn/hoon/hoon-tutorial/nouns/), but first let's write a very basic program.

## Generators

Generators are the most straightforward way to write Hoon programs. They are a concept in Arvo, and involve saving Hoon code in a `.hoon` text file. While they aren't strictly part of the Hoon language, we'll be dealing with generators throughout this tutorial.

The simplest type of generator is the **naked generator**. All naked generators are `gates`: functions that take an argument and produce an output. So, to create a generator, all you need to do is write a `gate` and put it into a file in the `/home/gen` directory of your ship as a `.hoon` file. To run a generator named `mygen.hoon`, you would type `+mygen <argument>` in your ship's Dojo.

If this doesn't make sense yet, that's okay. In the [next lesson](../list-of-numbers), we will walk you through an example `gate` that is run as a generator.

## Text editors

Writing code in any language is typically done using a text editor, but common programs like Notepad, Microsoft Word, or OpenOffice Writer are not suitable for programming. You'll want instead a text editor that is specifically designed for writing code. This will assist with things such as colorizing keywords, finding patterns, matching parentheses and brackets, etc.

Below is a complete list of text editors that have support for Hoon [syntax highlighting](https://en.wikipedia.org/wiki/Syntax_highlighting) -- an important tool for any programming language. For each of these editors, you'll need to download the editor and then you'll need to install some additional syntax-highlighter package. The process for adding Hoon support differs for every editor. For most newbie-friendly text editors, this is easily accomplished from within the editor itself, and you'll learn how to do so following a newbie tutorial for that editor.

If you are brand new to programming, don't think too much about which editor to use; any of the newbie-friendly options will suit you.

### Newbie-friendly text editors

These editors are easy to use for first-time coders.

#### Atom
Atom is free and open-source and runs on all major operating systems. It is available [here](https://atom.io/). A package for Hoon support is maintained by Tlon and may be obtained using the package manager within the editor by searching for `Hoon`.

#### Sublime
Sublime is closed-source, but may be downloaded for free and there is no enforced time limit for evaluation. It runs on all major operating systems. It is available [here](https://www.sublimetext.com/).

#### Visual Studio Code
Visual Studio Code is free and open-source and runs on all major operating systems. It is available [here](https://code.visualstudio.com/). Hoon support may be acquired in the Extensions menu within the editor by searching for `Hoon`.

### Advanced text editors

These text editors have a high learning curve and are only recommended for experienced programmers.

#### Emacs

Emacs is free and open-source and runs on all major operating systems. It is available [here](https://www.gnu.org/software/emacs/). Hoon support is available with [hoon-mode.el](https://github.com/urbit/hoon-mode.el).

#### Vim

Vim is free and open-source and runs on all major operating systems. It is available [here](https://www.vim.org/). Hoon support is available with [hoon.vim](https://github.com/urbit/hoon.vim) and is maintained by Tlon.


### [Next Up: Walkthrough -- List of Numbers](../list-of-numbers)
