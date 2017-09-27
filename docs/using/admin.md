---
navhome: /docs/
next: true
sort: 3
title: Administration and Operation
---

# Administration

<div class="row">
<div class="col-md-8">

Your Urbit is a persistent Unix process that you mainly control from the console.  For some things, a browser will also work.

</div>
</div>

## Shutdown

You can turn your Urbit off with `ctrl-d` from the `:talk` or `:dojo` prompts.

## Restart

To restart your Urbit simply pass the name of your pier:

    $ urbit some-planet

or

    $ urbit comet


## Logging

To log Urbit's command line output to a file, use `script`:

    $ script urbit.log urbit your-urbit

## Moving your pier

Piers are designed to be portable, but it *must* be done while the Urbit is turned off.  Urbit networking is stateful, so you can't run two copies of the same Urbit in two places.  

To move a pier, simply move the contents of the directory it lives in.  To keep these files as small as possible we usually use the `--sparse` option in `tar`.  With a pier `your-urbit/` something like this (from inside `urbit/`) should work:

    tar -Scvzf your-urbit.tar.gz ./your-urbit/

# Operation

## Console

Your Urbit terminal is separated into two parts: the prompt (the bottom line) and the record (everything above that).  The record is shared; all the output from all the apps in your command set appears in it.  The prompt is multiplexed.

In the CLI Urbit apps can process your input before you hit return.  To see this in action try entering `)` as the first character at the `:dojo` prompt.  Since there is no dojo command or hoon expression that starts with ')', the dojo rejects it.

`ctrl-x` - Switches the prompt between running console apps

`ctrl-c` - Crash current event.  Processed at the Unix layer and prints a stack trace.

`ctrl-d` - From `:talk` or `:dojo` stops your Urbit process.

`↑` / `↓` - History navigation

The following emacs-style key bindings are available:

    ctrl-a    cursor to beginning of the line (Home)
    ctrl-b    cursor one character backward (left-arrow)
    ctrl-e    cursor to the end of the line (End)
    ctrl-f    cursor one character forward (right-arrow)
    ctrl-g    beep; cancel reverse-search
    ctrl-k    kill to end of line
    ctrl-l    clear the screen
    ctrl-n    next line in history (down-arrow)
    ctrl-p    previous line in history (up-arrow)
    ctrl-r    reverse-search
    ctrl-t    transpose characters
    ctrl-u    kill to beginning of line
    ctrl-y    yank from kill buffer

Full coverage of the Urbit shell, the `:dojo` is covered in the [Shell walkthrough](/docs/using/shell).

## Web

On startup Urbit tries to bind to `localhost:8080`.  If you're already running something on `8080` you'll find your Urbit on `8081`, and so on.  For planets only, we also proxy web domains through Urbit's own servers.  Any planet `~your-urbit` is also at
`your-urbit.urbit.org`.

Your Urbit serves a simple homepage from `http://localhost:8080` or `https://your-urbit.urbit.org` that should be self-explanatory.  Since our HTTPS isn't audited / battle tested we just call it "secure" HTTPS.  You can find that on `8443`.  Or `8444` (and so on) if you're already running something on `8443`.

A complete walkthrough of the Urbit web interface is [here](/docs/using/web).

## Moons

Urbit namespace is distributed by having parent nodes sign the keys for child nodes.  If you have a planet, your parent star issued your ticket.  As a planet you, in turn, can sign the keys for moons.  The basic idea is: your planet runs permanently in a data center somewhere and moons run on all your devices.  Each planet can issue ~4 billion (`2^32`) moons.

To generate a random moon from your planet run:

    ~your-urbit:dojo> +moon

You can use the resulting output in the same installation flow from [install](/docs/using/install).  

Moons are automatically synced to their parent `%kids` desk, and can control applications on their parent planet using `|link`.  You can read more about those things in the [filesystem](/docs/using/filesystem) and [console](/docs/using/shell) walkthroughs.

## Continuity breaches

While the Urbit network is in this alpha state we sometimes have to reboot the whole network.  This happens either when major changes need to be shipped or we hit a bug that can't be fixed over the air.

Because Urbit networking is stateful we call this a 'continuity breach'.  Everything has to be restarted from scratch.  Your pier will continue to function after we have breached, but it wont connect to the rest of the Urbit network.  

When this happens, back up any files you'd like to save, shut down your Urbit and recreate it (as if you were starting for the first time).
