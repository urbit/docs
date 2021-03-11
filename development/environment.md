+++
title = "Environment Setup"
description = "How to set up an environment for Urbit development."
weight = 10
template = "doc.html"
+++

This guide covers best practices for preparing your environment to develop
within the Urbit ecosystem.

## Creating a development ship 

To do work with Hoon, we recommended using a "fake" ship -- one that's not
connected to the network.

Because such a ship has no presence on the network, you don't need an Azimuth
identity. You just need to have [installed the Urbit binary](/using/install).

To create a fake ship named `~zod`, run the command below. You can replace `zod`
with any valid Urbit ship-name.

```
./urbit -F zod
```

This should take a couple of minutes, during which you should see a block of boot
messages, starting with the Urbit version number. 


## Hoon support in text editors

A variety of plugins have been built to provide support for the Hoon language in
different text editors:

#### Atom
Atom is free and open-source and runs on all major operating systems. It is
available [here](https://atom.io/). A package for Hoon support is maintained by
Tlon and may be obtained using the package manager within the editor by
searching for `Hoon`.

#### Sublime Text
Sublime Text is closed-source, but may be downloaded for free and there is no
enforced time limit for evaluation. It runs on all major operating systems. It
is available [here](https://www.sublimetext.com/).

#### Visual Studio Code
Visual Studio Code is free and open-source and runs on all major operating
systems. It is available [here](https://code.visualstudio.com/). Hoon support
may be acquired in the Extensions menu within the editor by searching for
`Hoon`.

#### Emacs

Emacs is free and open-source and runs on all major operating systems. It is
available [here](https://www.gnu.org/software/emacs/). Hoon support is available
with [hoon-mode.el](https://github.com/urbit/hoon-mode.el).

#### Vim

Vim is free and open-source and runs on all major operating systems. It is
available [here](https://www.vim.org/). Hoon support is available with
[hoon.vim](https://github.com/urbit/hoon.vim) and is maintained by Tlon.
