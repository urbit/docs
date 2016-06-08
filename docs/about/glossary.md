---
sort: 3
title: Glossary of Urbit Terms
---

# Glossary of Urbit Terms

Here is a simple overview of the most common Urbit terms. Once you understand this, you know almost everything you need to start using Urbit.

## The Universe in a Table

    Size   Name    Parent  Object      Example
    -----  ------  ------  ------      -------
    2^8    galaxy  ~       datacenter  ~zod
    2^16   star    galaxy  sysadmin    ~doznec
    2^32   planet  star    user        ~tasfyn-partyv
    2^64   moon    planet  device      ~sigsam-nimbot-tasfyn-partyv
    2^128  comet   ~       bot         ~racmus-mollen-fallyt-linpex--watres-sibbur-modlux-rinmex
    any    urbit   *       *           ~somnym-anynym

> The below summary is also available [here](http://urbit.org/posts/address-space/).

An Urbit identity is a string like `~firbyr-napbes`.  It
means nothing, but it's easy to remember and say out loud.
`~firbyr-napbes` is actually just a 32-bit number, like an IP address,
that we turn into a human-memorable string.

Technically, an urbit is a secure digital identity that you own and
control with a cryptographic key, like a Bitcoin wallet.  As in
Bitcoin, the supply of urbits is mathematically limited.  This keeps
the network friendly, by making spam and abuse expensive.

An urbit name is just a number; smaller numbers make shorter names.
Shorter names are easier to remember, so they're more valuable.  So
urbits are classified by the number of bits in their name.  (A ship
name is just a scrambled base-256 representation of the number.)

A 32-bit urbit (like `~firbyr-napbes`) is called a "planet." A 16-bit
urbit (like `~pollev)` is a "star." An 8-bit ship (like `~mun`) is a
"galaxy." A planet is an identity for an independent, adult human.
Stars and galaxies are network infrastructure.

Each planet or star is launched by its "parent," the star or galaxy
whose number is its bottom half.  So the planet `~firbyr-napbes`,
`0xdead.beef` or `3.735.928.559`, is the child of `~pollev`, `0xbeef`
or `48.879`, whose parent is `~mun`, `0xef`, `239`.  The parent of
`~mun` and all galaxies is `~zod`, `0`.


