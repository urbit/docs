---
navhome: /docs/
navuptwo: true
next: true
sort: 3
title: Administration and operation
---

# Administration and operation

Your Urbit is a persistent Unix process that you mainly control from the
console. For some things, a browser will also work.

## Shutdown

You can turn your Urbit off with `Ctrl-d` from the Talk or Dojo prompts.

## Restart

To restart your Urbit simply pass the name of your pier:

```
$ urbit some-planet
```

or

```
$ urbit comet
```

## Logging

To log Urbit's command line output to a file, use `script`:

```
$ script urbit.log urbit your-urbit
```

## Moving your pier

Piers are designed to be portable, but it _must_ be done while the Urbit
is turned off. Urbit networking is stateful, so you can't run two copies
of the same Urbit in two places.  

To move a pier, simply move the contents of the directory it lives in.
To keep these files as small as possible we usually use the `--sparse`
option in `tar`. With a pier `your-urbit/` something like this (from
inside `urbit/`) should work:

```
tar -Scvzf your-urbit.tar.gz ./your-urbit/
```

## Console

Your Urbit terminal is separated into two parts: the prompt (the bottom
line) and the record (everything above that). The record is shared; all
the output from all the apps in your command set appears in it. The
prompt is multiplexed.

In the CLI Urbit apps can process your input before you hit return. To
see this in action try entering `)` as the first character at the Dojo
prompt. Since there is no Dojo command or Hoon expression that starts
with ')', the Dojo rejects it.

`Ctrl-x` - Switches the prompt between running console apps

`Ctrl-c` - Crash current event.  Processed at the Unix layer and prints a stack trace.

`Ctrl-d` - From Talk or Dojo stops your Urbit process.

`↑` / `↓` - History navigation

The following emacs-style key bindings are available:

```
Ctrl-a    Cursor to beginning of the line (Home)
Ctrl-b    Cursor one character backward (left-arrow)
Ctrl-e    Cursor to the end of the line (End)
Ctrl-f    Cursor one character forward (right-arrow)
Ctrl-g    Beep; cancel reverse-search
Ctrl-k    Kill to end of line
Ctrl-l    Clear the screen
Ctrl-n    Next line in history (down-arrow)
Ctrl-p    Previous line in history (up-arrow)
Ctrl-r    Reverse-search
Ctrl-t    Transpose characters
Ctrl-u    Kill to beginning of line
Ctrl-y    Yank from kill buffer
```

Full coverage of the Urbit shell, the Dojo is covered in the
[Shell walkthrough](../shell/).

## Web

On startup Urbit tries to bind to `localhost:8080`.  If you're already
running something on `8080` you'll find your Urbit on `8081`, and so on.
For planets only, we also proxy web domains through Urbit's own servers.
Any planet `~your-urbit` is also at `your-urbit.urbit.org`.

Your Urbit serves a simple homepage from `http://localhost:8080` or
`https://your-urbit.urbit.org` that should be self-explanatory. Since
our HTTPS isn't audited / battle tested we just call it "secure" HTTPS.
You can find that on `8443`. Or `8444` (and so on) if you're already
running something on `8443`.

A complete walkthrough of the Urbit web interface is
[here](../web/).

## Continuity breaches

While the Urbit network is in this alpha state we sometimes have to
reboot the whole network. This happens either when major changes need
to be shipped or we hit a bug that can't be fixed over the air.

Because Urbit networking is stateful we call this a _continuity breach_.
Everything has to be restarted from scratch. Your pier will continue to
function after we have breached, but it wont connect to the rest of the
Urbit network. 

When this happens, back up any files you'd like to save, shut down your
Urbit and recreate it (as if you were starting for the first time).
