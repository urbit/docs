---
next: true
sort: 2
title: Shell
---

# `:dojo` (Shell)

The dojo is a typed functional shell.

(Goals of a REPL+IFTTT, hood)

## Quickstart

Evaluate a hoon expression:

    ~fintud-macrep:dojo> (add 2 2)
    ~fintud-macrep:dojo> %+  add  2  2

Tall form Hoon will be prompted for:

    ~fintud-macrep:dojo> %+  add
    ~fintud-macrep:dojo< 2
    ~fintud-macrep:dojo< 2

Use `=var` to save a shell variable:

    ~fintud-macrep:dojo> =foo (add 2 2)

Generators (files in `/gen`) are run with `+`:

    ~fintud-macrep:dojo> +hello 'world'

Save output to a file in `%clay` with `*`:

    ~fintud-macrep:dojo> *foo/bar/hoon 'hello world'

A system command to `:hood` using `|`:

    ~fintud-macrep:dojo> |reload %eyre

# dir

## Manual

# special vars

# command prefixes

### `:` send to app

Send a poke message to `:square` as an `atom` mark:

    ~fintud-macrep:dojo> :~fintud-macrep/square &atom (add 2 2)

### `.` download to Unix

Download a noun to Unix with `.`:

    ~fintud-macrep:dojo> .foo/bar/baz (add 2 2)

# generators

# hood