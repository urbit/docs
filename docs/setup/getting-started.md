---
next: true
sort: 2
title: Getting started
---

# Getting started

On disk your Urbit is an append-only log and a checkpoint.  Or, in simpler terms, a directory where we keep all of your Urbit’s state.  We call this a ‘pier’.

## Initialize

When you first start an Urbit we create this pier directory and write to it.

To start with a planet (`~fintud-macrep`) and ticket (`~fortyv-tombyt-tabsen-sonres`):

    bin/urbit -w fintud-macrep -t fortyv-tombyt-tabsen-sonres

This will create a directory `fintud-macrep/` and begin the initialization process for that planet.  Be patient, it can take a few minutes.  

Without a planet anyone can create a comet:

    bin/urbit -c comet

This will create a directory `any-name/` and start up a random 64-bit comet.

## Orientation

When your Urbit is finished booting you should see a `dojo>` prompt.

## Shutdown

You can turn your Urbit off with `^D` from the `dojo>` prompt.

## Restart

To restart your Urbit simply pass the name of your pier:

    bin/urbit some-planet

or

    bin/urbit comet
