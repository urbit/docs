---
next: true
sort: 3
title: What's in the repo
---

# What's in the repo

The `urbit` repo can look a little confusing at first.  Here we'll take a look at the files that live on your `/=home=` desk by default.  

If you `ls urb/zod` from inside the urbit repo you should see something like:

    app/
    arvo/
    gen/
    lib/
    mar/
    ren/
    sur/
    web/
    web.md

Let's step through directory by directory.

## `app/` 

This is where `%gall` apps live.  `%gall` apps are stateful servants.  Sort of like unix daemons.  One very familiar one is `app/talk.hoon` which is the source code for `:talk` the urbit messaging transport layer.  And there's also `app/dojo.hoon` — that's your shell.

## `arvo/`

This is where the `%arvo` vanes live.  Vanes are sort of like kernel modules. These are worth listing one by one:

### `arvo/ames.hoon`

`%ames` is our network protocol.

### `arvo/behn.hoon`

`%behn` is a simple timer.

### `arvo/clay.hoon`

`%clay` is our filesystem.

### `arvo/dill.hoon`

`%dill` is our terminal driver.

### `arvo/eyre.hoon`

`%eyre` is our webserver.

### `arvo/ford.hoon`

`%ford` is our build system.

### `arvo/gall.hoon`

`%gall` is our application model.

### `arvo/hoon.hoon`

`%hoon` is our programming langauge.

### `arvo/jael.hoon`

`%jael` handles secret storage.

### `arvo/kahn.hoon`

`%kahn` stores your contacts / trust graph.

### `arvo/zuse.hoon`

`%zuse` is our standard library.

That's it.  That's the whole system. 

## `gen/`

`gen/` holds generators.  Generators are short command-line scripts.

## `lib/`

`lib/` holds shared libraries for programs. `lib/sole` is a good example — that's the console library that's shared by both `:dojo` in the command line, and the `dojo` web client.

## `mar/`

This is where marks live.  Marks are data type definitions used by `%ford` and `%clay`.  

Marks define how diffs are performed on a particular data type and how they can be translated to different types.  Sort of like file extensions, but much more powerful.

## `ren/`

These are web renderers.  A renderer handles web requests of a particular type.  

Default web requets in urbit are handled as a `.urb`, which is caught by the `urb.hoon` renderer.  This wraps the request in our default `css` and `js` and adds some routing magic for certain paths.

## `sur/`

`sur/` contains shared data structures.  

## `web/`

There are the files publicly accessible to the web, as made possible by `%eyre`.

## `web.md`

This is the homepage for your urbit.  You'll see it at `http://localhost:8080/` or `http://your-urbit.urbit.org/`

