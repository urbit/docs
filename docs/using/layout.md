---
navhome: /docs/
sort: 9
title: Source layout
---

<div class="row">
<div class="col-md-8">

# Arvo source

When you boot an Urbit we transfer the current version of the Arvo operating environment to your Urbit over our network.  That is, the source for the system lives on your Urbit.  Here we'll take a brief tour through the structure of a base Arvo desk.  

</div>
</div>

Looking at the top level of [the Arvo repo](http://github.com/urbit/arvo), or any Urbit desk that has been mounted to Unix we see something like:

    app/
    arvo/
    gen/
    lib/
    mar/
    ren/
    sec/
    sur/
    web/
    web.md

Let's step through directory by directory.

## `app/` 

This is where `%gall` apps live.  `%gall` apps are stateful servers, sort of like unix daemons.  One familiar one is `app/talk.hoon` which is the source code for `:talk` the urbit messaging transport layer.  And there's also `app/dojo.hoon` — that's your shell.

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

`%hoon` is our programming langauge.  Since Hoon compiles itself the language is actually specified in this source file.

### `arvo/zuse.hoon`

`%zuse` is the Hoon library.  

That's it.  That's the whole system. 

## `gen/`

`gen/` holds generators.  Generators are short `:dojo` scripts.

## `lib/`

`lib/` holds shared libraries for programs. `lib/sole` is a good example — that's the console library that's shared by both `:dojo` in the command line, and the `dojo` web client.

## `mar/`

This is where marks live.  Marks are data type definitions used by `%ford`.  A mark is like a mime-type, but specified in executable code.  

## `ren/`

These are web renderers.  A renderer handles web requests of a particular type.  

Default web requests in urbit are handled as a `.urb`, which is caught by the `urb.hoon` renderer.  This wraps the request in our default `css` and `js` and adds some routing magic for certain paths.

## `sur/`

`sur/` contains shared data structures.  Files in `sur` are like header files in C.

## `web/`

There are the files publicly accessible to the web, as made possible by `%eyre`.

## `web.md`

This is the homepage for your urbit.  You'll see it at `http://localhost:8080/` or `http://fintud-macrep.urbit.org/`.

