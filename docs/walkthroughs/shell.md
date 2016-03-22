---
next: true
sort: 2
title: Shell
---

# `:dojo` (Shell)

The dojo is a typed functional shell.

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

#### `=` - Set variable

Set any envronment variable:

    ~fintud-macrep:dojo> =foo 42
    ~fintud-macrep:dojo> (add 2 foo)

    44

(There are a few special variables that the dojo expects.  See below.)

#### `:` - Send to app

`:app` goes to a local `app`, `:~ship/app` goes to the `app` on `~ship`.

Send a `helm-hi` message to `hood`:

    ~fintud-macrep:dojo> :hood &helm-hi 'hi'

App usually expect marked data, so `&` is often used here.  

#### `*` - Save in `%clay`

Save a new `md` file in `web`:

    ~fintud-macrep:dojo> *%/web/foo/md '# hello'

The last component of the path is expected to be the mark (or mime type).

#### `.` - Download to Unix

Download a noun to Unix with `.`:

    ~fintud-macrep:dojo> .foo/bar/baz (add 2 2)

Which creates a file at `pier/.urb/put/foo/bar.baz`.

This is very often used with `+solid`:

    ~fintud-macrep:dojo> .urbit/pill +solid

Which outputs a new `urbit.pill` to `pier/.urb/put/urbit.pill`

### Sources

#### `&` - Mark conversion

Convert between marks using `&`:

    ~fintud-macrep:dojo> &html &md '# hello'
    :: produces
    '<html><head></head><body><div><h1 id="-hello">hello</h1></div></body></html>'

#### `_` - Run a function

Use `_` to run a gate (or function):

    :: assign an arbitrary function and pass data to it
    ~fintud-macrep:dojo> _|=({a/@} (mul a 3)) 3
    :: produces
    9
    :: assign an arbitrary function to get the status code from an http request
    ~fintud-macrep:dojo> _|=({p/@ud q/* r/*} p) +http://google.com
    :: produces
    301

#### `+` `-` - HTTP requests

`+http[s]://example.com` - sends a GET request

`+http[s]://example.com &json [%s 'hi']` - sends a POST request with the JSON `"hi"` in the body.

`-http[s]://example.com &json [%s 'hi']` - sends a PUT request with the JSON `"hi"` in the body.

#### `+` - Generators

Generators are simple hoon scripts loaded from the filesystem.  They live in `gen/`.

Create a random moon (from any planet):

    ~fintud-macrep:dojo> +moon
    :: produces
    "moon: ~docsun-tamtem-fintud-macrep; ticket: ~bartug-hodbyr-fognum-ralmud"

### Variables 

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
    :: produces
    ~2016.3.21..21.10.57..429a

#### `our`

The current urbit plot.  Read-only.

**Example:**

    ~fintud-macrep:dojo> our
    :: produces
    ~fintud-macrep

#### `eny`

256 bits of entropy.  Read-only.

**Example:**

    ~fintud-macrep:dojo> eny
    :: produces
    0v1o.m2vio.j5ieb.7tq84.5kcnp.gjn04.9gl2e.tkj5v.0oqk3.iugk8.rhu6o

### Generators

**`+cat`** - Similar to Unix `cat`.  Accepts a path.

    ~fintud-macrep:dojo> +cat %/web/md
    ~fintud-macrep:dojo> +cat /~talsur-todres/home/2/web/notes/md

**`+curl`** - Similar to Unix `curl`.  Accepts a `tape`.

    ~fintud-macrep:dojo> +curl "http://nyt.com"

**`+hello`** - Just prints the argument.  Accepts a `@ta`.

    ~fintud-macrep:dojo> +hello 'mars'

**`+ls`** - Similar to Unix `ls`.  Accepts a path.

    ~fintud-macrep:dojo> +ls %/web
    ~fintud-macrep:dojo> +ls /~talsur-todres/home/2/web/notes

**`+moon`** - Generate a random moon from a planet.  No arguments.

**`+solid`** - Compile the current state of the kernel and output a noun.  Usually downloaded to a file in unix.  No arguments.
    
    ~fintud-macrep:dojo> .urbit/pill +solid

**`+ticket`** - Generate a ticket for an Urbit plot.  Takes an Urbit name (`@p`).

    ~fintud-macrep:dojo> +ticket ~talsur-todres-fintud-macrep

**`+tree`** - Generate a recursive directory listing.  Takes a path.

    ~fintud-macrep:dojo> +tree %/web

### Hood

The hood is the system daemon.  See `gen/hood` and `app/hood`.

**`|hi`** - Sends a direct message.  Sort of like `finger`.  Accepts an urbit name (`@p`) and a string (`cord`).

    ~fintud-macrep:dojo> |hi ~doznec 'you there?'

**`|link`** / **`|unlink`** - Link / unlink a remote app.  Accepts an Urbit name and an app name.

    ~fintud-macrep:dojo> |link ~talsur-todres %octo

**`|mass`** - Prints the current memory usage of all the kernel modules.  No arguments.

**`|reload`** - Reloads a kernel module (vane) from source.  Accepts any number of vane names.

    ~fintud-macrep:dojo> |reload %clay %eyre

**`|reset`** - Reloads `hoon.hoon`.  No arguments.

**`|start`** - Starts an app.  Accepts an app name.

    ~fintud-macrep:dojo> |start %curl
