---
navhome: /docs
next: true
sort: 5
title: Shell (:dojo)
---

# Shell (`:dojo`)

<div class="row">
<div class="col-md-8">

The `:dojo` is the place to quickly experiment with Urbit.  On
the surface the `:dojo` is just a Hoon REPL.  On the inside, the
`:dojo` is a system for operating on and transforming data in
Urbit.  

</div>
</div>

## Quickstart

Evaluate a hoon expression:

    ~your-urbit:dojo> (add 2 2)
    ~your-urbit:dojo> %+  add  2  2

Tall form Hoon may require multiple lines:

    ~your-urbit:dojo> %+  add
    ~your-urbit:dojo< 2
    ~your-urbit:dojo< 2

Use `=var` to save a shell variable:

    ~your-urbit:dojo> =foo (add 2 2)

Use `=dir` to set the current working directory:

    ~your-urbit:dojo> =dir %/web

Generators (files in `/gen`) are run with `+`:

    ~your-urbit:dojo> +hello 'world'

Save output to a file in `%clay` with `*`:

    ~your-urbit:dojo> *some/file/path/hoon 'hello world'

Run system commands from `:hood`, like `reload`, using `|`:

    ~your-urbit:dojo> |reload %eyre


### Generators

**`+cat`** - Similar to Unix `cat`.  Accepts a path.

    ~your-urbit:dojo> +cat %/web/md
    ~your-urbit:dojo> +cat /~talsur-todres/home/2/web/notes/md

**`+curl`** - Similar to Unix `curl`.  Accepts a `tape`.

    ~your-urbit:dojo> +curl "http://nyt.com"

**`+hello`** - Just prints the argument.  Accepts a `@ta`.

    ~your-urbit:dojo> +hello 'mars'

**`+ls`** - Similar to Unix `ls`.  Accepts a path.

    ~your-urbit:dojo> +ls %/web
    ~your-urbit:dojo> +ls /~talsur-todres/home/2/web/notes

**`+moon`** - Generate a random moon from a planet.  No arguments.

**`+solid`** - Compile the current state of the kernel and output a noun.  Usually downloaded to a file in unix.  No arguments.
    
    ~your-urbit:dojo> .urbit/pill +solid

**`+ticket`** - Generate a ticket for an Urbit plot.  Takes an Urbit name (`@p`).

    ~your-urbit:dojo> +ticket ~talsur-todres-your-urbit

**`+tree`** - Generate a recursive directory listing.  Takes a path.

    ~your-urbit:dojo> +tree %/web

### Hood

The hood is the system daemon.  See `gen/hood` and `app/hood`.

**`|hi`** - Sends a text message.  Sort of like Unix `write`.  Accepts an urbit name (`@p`) and a string ("tape").

    ~your-urbit:dojo> |hi ~doznec "hello, ~doznec"

**`|link`** / **`|unlink`** - Link / unlink a remote app.  Accepts an Urbit name and an app name.

    ~your-urbit:dojo> |link ~talsur-todres %octo

**`|mass`** - Prints the current memory usage of all the kernel modules.  No arguments.

**`|reload`** - Reloads a kernel module (vane) from source.  Accepts any number of vane names.

    ~your-urbit:dojo> |reload %clay %eyre

**`|reset`** - Reloads `hoon.hoon`.  No arguments.

**`|start`** - Starts an app.  Accepts an app name.

    ~your-urbit:dojo> |start %curl

## Manual

<h3 class="first child">Sources and sinks</h3>

A dojo command is either a source or a sink.  A source is just something that can be printed to your console or the result of some computation.  A sink is an *effect*: a change to the filesystem, a network message, a change to your environment, or typed message to an app.

Sources can be chained together, but we can only produce one effect per command.

### Sinks

#### `=` - Set variable

Set any envronment variable:

    ~your-urbit:dojo> =foo 42
    ~your-urbit:dojo> (add 2 foo)

    44

(There are a few special variables that the dojo expects.  See below.)

#### `:` - Send to app

`:app` goes to a local `app`, `:~ship/app` goes to the `app` on `~ship`.

Send a `helm-hi` message to `hood`:

    ~your-urbit:dojo> :hood &helm-hi 'hi'

App usually expect marked data, so `&` is often used here.  

#### `*` - Save in `%clay`

Save a new `md` file in `web`:

    ~your-urbit:dojo> *%/web/foo/md '# hello'

The last component of the path is expected to be the mark (or mime type).

#### `.` - Download to Unix

Download a noun to Unix with `.`:

    ~your-urbit:dojo> .foo/bar/baz (add 2 2)

Which creates a file at `pier/.urb/put/foo/bar.baz`.

This is very often used with `+solid`:

    ~your-urbit:dojo> .urbit/pill +solid

Which outputs a new `urbit.pill` to `pier/.urb/put/urbit.pill`

### Sources

#### `&` - Mark conversion

Convert between marks using `&`:

    ~your-urbit:dojo> &html &md '# hello'
    :: produces
    '<html><head></head><body><div><h1 id="-hello">hello</h1></div></body></html>'

#### `_` - Run a function

Use `_` to run a gate (or function):

    :: assign an arbitrary function and pass data to it
    ~your-urbit:dojo> _|=({a/@} (mul a 3)) 3
    :: produces
    9
    :: assign an arbitrary function to get the status code from an http request
    ~your-urbit:dojo> _|=({p/@ud q/* r/*} p) +http://google.com
    :: produces
    301

#### `+` `-` - HTTP requests

`+http[s]://example.com` - sends a GET request

`+http[s]://example.com &json [%s 'hi']` - sends a POST request with the JSON `"hi"` in the body.

`-http[s]://example.com &json [%s 'hi']` - sends a PUT request with the JSON `"hi"` in the body.

Note that the first of these is a source while the last two are
sinks.

#### `+` - Generators

Generators are simple hoon scripts loaded from the filesystem.  They live in `gen/`.

Create a random moon (from any planet):

    ~your-urbit:dojo> +moon
    :: produces
    "moon: ~docsun-tamtem-your-urbit; ticket: ~bartug-hodbyr-fognum-ralmud"

### Variables 

You can use `=` to set an environment variable in `:dojo`, but there are a few reserved names that have special uses.  

#### `dir`

Current working `%clay` desk and revision. Read / write.

**Examples:**

    ~your-urbit:dojo> =dir %/web
    ~your-urbit:dojo> +ls %

    404/hoon docs/ dojo/hoon lib/ listen/hoon md static/md talk/ tree/main/

#### `lib` 

Current set of libraries (`/lib`) in your environment.  Can also be set with `/+`.  Read / write.

**Examples:**

    ~your-urbit:dojo> =lib ~[[%react ~]]
    ~your-urbit:dojo> ::  this also works:
    ~your-urbit:dojo> /+  react
    ~your-urbit:dojo> ::  now we can use arms from lib/react.hoon
    ~your-urbit:dojo> (react-vale:react %div)

#### `sur`

Current set of structures (`/sur`) in your environment.  Can also be set with `/-`.  Read / write.

**Examples:**

    ~your-urbit:dojo> =sur ~[[%sole ~]]
    ~your-urbit:dojo> ::  this also works:
    ~your-urbit:dojo> /-  sole
    ~your-urbit:dojo> ::  now we can use arms in sur/sole.hoon
    ~your-urbit:dojo> `sole-effect:sole`[%bel ~]

#### `now`

The current (128-bit `@da`) time.  Read-only.

**Example:**

    ~your-urbit:dojo> now
    :: produces
    ~2016.3.21..21.10.57..429a

#### `our`

The current urbit plot.  Read-only.

**Example:**

    ~your-urbit:dojo> our
    :: produces
    ~your-urbit

#### `eny`

256 bits of entropy.  Read-only.

**Example:**

    ~your-urbit:dojo> eny
    :: produces
    0v1o.m2vio.j5ieb.7tq84.5kcnp.gjn04.9gl2e.tkj5v.0oqk3.iugk8.rhu6o
