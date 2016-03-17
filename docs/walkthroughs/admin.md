---
next: true
sort: 1
title: Basic operation
---

# Basic operation

<div class="row">
<div class="col-md-8">

Here we'll cover the basic administrative tasks you'll encounter running your Urbit and the primary interfaces to control it.  

</div>
</div>

## Shutdown

You can turn your Urbit off with `^D` from the `:talk` or `:dojo` prompts.

## Restart

To restart your Urbit simply pass the name of your pier:

    bin/urbit some-planet

or

    bin/urbit comet

## Console

The Urbit command line is pretty similar to Unix, with a few slight differences.  Your Unix terminal is separated into two parts: the prompt (the bottom line) and the record (everything above that).

The record is shared; all the output from all the apps in your
command set appears in it.  So you'll see `:talk` messages while
working in the dojo.

The prompt is multiplexed; you switch the prompting app with
`^X`.  Pressing return sends the prompt line to the app.  Urbit
does not automatically echo your input line into the record,
the way a normal Unix console does.

Also unlike a normal Unix console, the application can process
your input before you hit return.  In general, invalid input is
rejected with a beep.  Incorrect input may even be corrected.

Like many but not all Unix command lines, Urbit has built-in
history editing.  The following emacs-style key bindings are available:

    ^A    cursor to beginning of the line (Home)
    ^B    cursor one character backward (left-arrow)
    ^E    cursor to the end of the line (End)
    ^F    cursor one character forward (right-arrow)
    ^G    beep; cancel reverse-search
    ^K    kill to end of line
    ^L    clear the screen
    ^N    next line in history (down-arrow)
    ^P    previous line in history (up-arrow)
    ^R    reverse-search
    ^T    transpose characters
    ^U    kill to beginning of line
    ^Y    yank from kill buffer

`^C` is processed at the Unix layer, not within Urbit.  If
there's an event currently running, ^C interrupts it and prints a
stack trace -- useful for finding infinite loops.

`^D` from `:talk` or `:dojo` stops your Unix process.  From any
other app, it removes the prompting app from the command set.

Pressing left-arrow or `^B` at the start of a line is an input
operation with the metaphorical meaning "get me out of here,"
ie, escape.  The exact semantics of an escape are application
dependent.

Full coverage of the Urbit shell is covered in the [Shell walkthrough](/docs/walkthroughs/dojo).

## Web

On startup Urbit tries to bind to `localhost:8080`.  If you're already running something on `8080` you'll find your Urbit on `8081`, and so on.  For planets only, we also proxy web domains through Urbit's own servers.  Any planet `~fintud-macrep` is also at
`fintud-macrep.urbit.org`.  Please use this proxy as little as
possible; it's not well-optimized.

Your Urbit serves a simple homepage from `http://localhost:8080` or `https://fintud-macrep.urbit.org` that should be self-explanatory.  Locally we don't yet serve HTTPS, but we do serve "secure" HTTPS (meaning it hasn't been audiented) on `8443`.  Or `8444` (and so on) if you're already running something on 8443.

A complete walkthrough of the Urbit web interface is [here](/docs/walkthroughs/web).

## Moons

Urbit namespace is distributed by having parent nodes sign the keys for child nodes.  If you have a planet your parent star issued your ticket.  As a planet you, in turn, can sign the keys for moons.  The basic idea is: your planet runs permanently in a data center somewhere and moons run on all your devices.  Each planet can issue ~4 billion (`2^32`) moons.

To generate a random moon from your planet run:

    ~fintud-macrep:dojo> +moon

You can use the resulting output in the same installation flow from earlier.  

Moons are automatically synced to their parent `%kids` desk, and can control applications on their parent planet using `|link`.  You can read more about those things in the [filesystem](/docs/walkthroughs/filesystem) and [console](/docs/walkthroughs/console) walkthroughs.

## Moving your pier

Piers are designed to be portable, but it must be done while the Urbit is turned off.  Urbit networking is stateful, so you can't run two copies of the same Urbit in two places.  

To move a pier, simply move the contents of the directory it lives in.  To keep these files as small as possible we usually use the `--sparse` option in `tar`.  With a pier `fintud-macrep/` something like this (from inside `urbit/`) should work:

    tar -Scvzf fintud-macrep.tar.gz ./fintud-macrep/

## Continuity breaches

While the Urbit network is in this alpha state we sometimes have to reboot the whole network.  This happens either when major changes need to be shipped or we hit a bug that can't be fixed over the air.

Because Urbit networking is stateful we call this a 'continuity breach'.  Everything has to be restarted from scratch.  Your pier will continue to function, but it wont connect to the rest of the Urbit network.  

When this happens, back up any files you'd like to save, shut down your Urbit and recreate it (as if you were starting for the first time).
