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

Use `=dir` to set the current working directory:

    ~fintud-macrep:dojo> =dir %/web

Generators (files in `/gen`) are run with `+`:

    ~fintud-macrep:dojo> +hello 'world'

Save output to a file in `%clay` with `*`:

    ~fintud-macrep:dojo> *foo/bar/hoon 'hello world'

Run system commands from `:hood`, like `reload`, using `|`:

    ~fintud-macrep:dojo> |reload %eyre

## Manual

<h3 class="first child">Sources and sinks</h3>

A dojo command is either a source or a sink.  A source is just something that can be printed to your console or the result of some computation.  A sink is an *effect*: a change to the filesystem, a network message, a change to your environment, or typed message to an app.

Sources can be chained together, but we can only produce one effect per command.

### Sinks

### `=` - Set variable

Set any envronment variable:

    ~fintud-macrep:dojo> =foo 42
    ~fintud-macrep:dojo> (add 2 foo)

    44

(There are a few special variables that the dojo expects.  See below.)

### `:` - Send to app

    ~fintud-macrep:dojo> :hood &helm-hi 'hi'

### `*` - Save in `%clay`

    ~fintud-macrep:dojo> *%/web/foo/md '# hello'

### `.` - Download to Unix

Download a noun to Unix with `.`:

    ~fintud-macrep:dojo> .foo/bar/baz (add 2 2)

### Sources

### `&` - Mark conversion

### `_` - Run a function

    _trip &html &md 'foo'

### `+` `-` - HTTP requests

    +http://google.com is get
    +http://google.com &json (joba %a ~) is post {a:null} 
    -http://localhost:6000/foobar &json (joba %a ~) is put {a:null}

    +curl "http://google.com?q={(urle "my params")}"
    the trivial generator that sends a get request, the baseline on which you could write a scraper

### `+` - Generators

### `[1 2 +hello 'world']` - Tuples

<h3 class="first child">Variables</h3>

You can use `=` to set an environment variable in `:dojo`, but there are a few reserved names that have special uses.  

#### `dir`

Current working `%clay` desk and revision. Read / write.

**Examples:**

    ~fintud-macrep:dojo> =dir %/web
    ~fintud-macrep:dojo> +ls %

    404/hoon docs/ dojo/hoon lib/ listen/hoon md static/md talk/ tree/main/

#### `lib` 

Current set of libraries (`/lib`) in your environment.  Can also be set with `/+`.  Read / write.

**Examples:**

    ~fintud-macrep:dojo> =lib ~[[%react ~]]
    ~fintud-macrep:dojo> ::  this also works:
    ~fintud-macrep:dojo> /+  react
    ~fintud-macrep:dojo> ::  now we can use arms from lib/react.hoon
    ~fintud-macrep:dojo> (react-vale:react %div)

#### `sur`

Current set of structures (`/sur`) in your environment.  Can also be set with `/-`.  Read / write.

**Examples:**

    ~fintud-macrep:dojo> =sur ~[[%sole ~]]
    ~fintud-macrep:dojo> ::  this also works:
    ~fintud-macrep:dojo> /-  sole
    ~fintud-macrep:dojo> ::  now we can use arms in sur/sole.hoon
    ~fintud-macrep:dojo> `sole-effect:sole`[%bel ~]

#### `now`

The current (128-bit `@da`) time.  Read-only.

**Example:**

    ~fintud-macrep:dojo> now

    ~2016.3.21..21.10.57..429a

#### `our`

The current urbit plot.  Read-only.

**Example:**

    ~fintud-macrep:dojo> our

    ~fintud-macrep

#### `eny`

256 bits of entropy.  Read-only.

**Example:**

    ~fintud-macrep:dojo> eny

    0v1o.m2vio.j5ieb.7tq84.5kcnp.gjn04.9gl2e.tkj5v.0oqk3.iugk8.rhu6o

# Generators

#### `+cat`

#### `+curl` / `+curl-hiss`

#### `+hello`

#### `+ls`

#### `+moon`

#### `+pope`

#### `+solid`

#### `+ticket`

#### `+tree`

# Hood

`|hi`

`|ask`

`|begin`

`|link` / `|unlink`

`|mass`

`|reload`

`|reset`

`|start`
