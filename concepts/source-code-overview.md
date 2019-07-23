+++
title = "Source Code Overview"
weight = 2
template = "doc.html"
description = "An explanation of Urbit's constituent GitHub repos."
+++

We host all our source code on GitHub at [github.com/urbit](https://github.com/urbit).

Since there's quite a number of repos, we'll talk about a few of the most
important ones here:

## [`urbit/urbit`](https://github.com/urbit/urbit)

This is the main Urbit repo. It contains the Urbit interpreter (all of the C code) and is the main entry point if you're going to build from source.

It also contains Arvo, the Urbit operating system (written in Hoon), as a subtree. When you boot your Urbit, you get this over the air. The source code is kept here, and you'll need it if you want to do any heavy development work.

## [`urbit/docs`](https://github.com/urbit/docs)

Interesting in working on Urbit documentation? This repository is where all the collaboration happens. The docs themselves are just markdown files hosted on a live ship.

## [`urbit/urbit.org`](https://github.com/urbit/urbit.org)

This is where the source code for urbit.org lives. Like the docs, the urbit.org website is just a collection of a few markdown files rendered by Tree, the Urbit web publishing system.

We're working on a new Urbit style guide for urbit.org, the docs and Urbit web apps. If you're into visual design or are a CSS fanatic, jump in here.

## [`urbit/azimuth`](https://github.com/urbit/azimuth)

Azimuth is a general-purpose PKI that Urbit uses for network identities.