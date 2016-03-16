---
next: true
sort: 2
title: Administration
---

# Administration

## Shutdown

You can turn your Urbit off with `^D` from the `dojo>` prompt.

## Restart

To restart your Urbit simply pass the name of your pier:

    bin/urbit some-planet

or

    bin/urbit comet

## Moving your pier

Piers are designed to be portable, but it must be done while the Urbit is turned off.  Urbit networking is stateful, so you can't run two copies of the same Urbit in two places.  

To move a pier, simply move the contents of the directory it lives in.  To keep these files as small as possible we usually use the `--sparse` option in `tar`.  With a pier `fintud-macrep/` something like this (from inside `urbit/`) should work:

    tar -Scvzf fintud-macrep.tar.gz ./fintud-macrep/

## Continuity breaches

While the Urbit network is in this alpha state we sometimes have to reboot the whole network.  This happens either when major changes need to be shipped or we hit a bug that can't be fixed over the air.

Because Urbit networking is stateful we call this a 'continuity breach'.  Everything has to be restarted from scratch.  Your pier will continue to function, but it wont connect to the rest of the Urbit network.  

When this happens, back up any files you'd like to save, shut down your Urbit and recreate your it (as if you were starting for the first time).
