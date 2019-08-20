+++
title = "Shell"
weight = 4
template = "doc.html"
+++
The Dojo is our shell; it processes system commands and returns output. It's a
good place to quickly experiment with Urbit. On the surface the Dojo is just a
Hoon REPL. On the inside, the Dojo is a system for operating on and transforming
data in Urbit.


## Quickstart

You can use the Dojo to run arbitrary Hoon code, as well as non-Hoon system
commands.

### Math

Evaluate a Hoon expression (whitespace matters):

```
~your-urbit:dojo> (add 2 2)
~your-urbit:dojo> %+  add  2  2
```

Tall-form Hoon may require multiple lines:

```
~your-urbit:dojo> %+  add
~your-urbit:dojo< 2
~your-urbit:dojo< 2
```

Hoon uses something called [the subject](@/docs/learn/hoon/hoon-tutorial/the-subject-and-its-legs.md).
The Dojo has its own subject, and that's where Hoon's equivalent of variables,
called faces, are stored.

Use `=var` to save faces to the Dojo subject.

```
~your-urbit:dojo> =foo (add 2 2)
```

Note, however, that `=var` is Dojo syntax, not Hoon syntax. You cannot bind a
face in a `.hoon` file in this way.

### System Commands

Use `=dir` to set the current working directory:

```
~your-urbit:dojo> =dir %/web
```

(`%` represents your current directory. For a complete explanation on urbit
paths, see the [filesystem section](@/docs/using/filesystem.md))

Generators (files in `/gen`) are run with `+`:

```
~your-urbit:dojo> +hello 'world'
```

Save output to a file in `%clay` with `*`:

```
~your-urbit:dojo> *some/file/path/hoon 'hello world'
```

Run system commands from `:hood`, like `reload`, using `|`:

```
~your-urbit:dojo> |reload %eyre
```

## Generators

Generators are short Hoon scripts, saved as `.hoon` files in the `/gen`
directory. Many Dojo commands exist in the form of generators. The syntax for
running a generator is `+genname` for a generator saved as `genname.hoon`.

### +cat

Accepts a path and displays the file. Similar to Unix `cat`.

```
~your-urbit:dojo> +cat %/gen/curl/hoon
```

### +code

Generates a code that is used to remotely log into your ship. No
arguments.

```
~your-urbit:dojo> +code
```

### +curl

Retrives data from a URL. Accepts a `tape`. Similar to Unix `curl`.

```
~your-urbit:dojo> +curl "http://nyt.com"
```

### +hello

Just prints the argument. Accepts a `@ta`.

```
~your-urbit:dojo> +hello 'mars'
```

### +ls

Similar to Unix `ls`. Accepts a path.

```
~your-urbit:dojo> +ls %/web
~your-urbit:dojo> +ls /~talsur-todres/home/2/web/notes
```

### +moon

Generates a random moon from a planet. No arguments.

```
~your-urbit:dojo> +moon
```

### +solid

Compile the current state of the kernel and output a
noun. Usually downloaded to a file in unix. No arguments.

```
~your-urbit:dojo> .urbit/pill +solid
```

### +test

Testrunner. Can test multiple generators at once, conventionally ones
in the `/test` folder. Takes a path.

```
~your-urbit:dojo> +test /lib
```

### +ticket

Generate a ticket for an urbit ship. Takes an urbit name (`@p`).


```
~your-urbit:dojo> +ticket ~talsur-todres-your-urbit
```

### +tree

Generate a recursive directory listing. Takes a path.

```
~your-urbit:dojo> +tree %/web
```

## Hood

The hood is the system daemon. See `gen/hood` and `app/hood`.

`|hi` - Sends a direct message. Sort of like Unix `write`. Accepts
an urbit name (`@p`) and a string (`tape`, which is text wrapped with double-quotes).

```
~your-urbit:dojo> |hi ~binzod "you there?"
```

`|link` / `|unlink` - Link / unlink a remote app. Accepts an
Urbit name and an app name.

```
~your-urbit:dojo> |link ~talsur-todres %octo
```

`|mass` - Prints the current memory usage of all the kernel modules.
No arguments.

```
~your-urbit:dojo> |mass
```

`|reload` - Reloads a kernel module (vane) from source. Accepts any
number of vane names.

```
~your-urbit:dojo> |reload %clay %eyre
```

`|reset` - Reloads `hoon.hoon` and all modules. No arguments.

```
~your-urbit:dojo> |reset
```

`|start` - Starts an app. Accepts an app name.

```
~your-urbit:dojo> |start %curl
```

---

## Manual

## Sources and sinks

A Dojo command is either a **source** or a **sink**. A source is just something
that can be printed to your console or the result of some computation. A
sink is an **effect**: a change to the filesystem, a network message, a
change to your environment, or typed message to an app.

Sources can be chained together, but we can only produce one effect per
command.

### Sinks

#### `=` - Set variable

Set any environment variable:

```
~your-urbit:dojo> =foo 42
~your-urbit:dojo> (add 2 foo)

44
```

Make sure to note that `=var` is Dojo syntax, not Hoon syntax. You cannot bind a
variable in a `.hoon` file in this way.

#### Special Variables

There are a few special variables that the Dojo maintains.

#### `:` - Send to app

`:app` goes to a local `app`, `:~ship/app` goes to the `app` on `~ship`.

Send a `helm-hi` message to `hood`:

```
~your-urbit:dojo> :hood &helm-hi 'hi'
```

Apps usually expect marked data, so `&` is often used here.

#### `*` - Save in `%clay`

Save a new `.udon` ([Udon](@/docs/using/sail-and-udon.md)) file in `web`:

```
~your-urbit:dojo> *%/web/foo/udon '# hello'
```

The last component of the path is expected to be the mark (or mime
type).

#### `.` - Export to Unix

Export a noun to Unix with `.`:

```
~your-urbit:dojo> .foo/bar/baz (add 2 2)
```

Which creates a file at `pier/.urb/put/foo/bar.baz`.

This is very often used with `+solid`:

```
~your-urbit:dojo> .urbit/pill +solid
```

Which outputs a new `urbit.pill` to `pier/.urb/put/urbit.pill`

### Sources

#### `&` - Mark conversion

Convert between marks using `&`, with the destination mark first. You can stack multiple mark conversions together, and some marks can only be converted to specific other marks. In this example, [Udon](@/docs/using/sail-and-udon.md#udon) is converted to `&hymn` (a mark which supplies the `html`, `head`, `body` and closing tags) first, before being converted to HTML:

```
~your-urbit:dojo>&html &hymn &udon ';h1#hello: hello'
'<html><head></head><body><h1 id="hello">hello</h1></body></html>'
```

Performing a conversion straight from Udon to the `&hymn` mark reveals a bit more about its mark conversion:

```
~your-urbit:dojo>&hymn &udon ';h1#hello: hello'
[[%html ~] [[%head ~] ~] [[%body ~] [g=[n=%h1 a=~[[n=%id v="hello"]]] c=~[[g=[n=%$ a=~[[n=%$ v="hello"]]] c=~]]] ~] ~]
```

As does converting straight from Udon to HTML:

```
~your-urbit:dojo>&html &udon ';h1#hello: hello'
';h1#hello: hello'
```

#### `_` - Run a function

Use `_` to run a gate (or function):

Write an arbitrary function and pass data to it:

```
~your-urbit:dojo> _|=([a=@] (mul a 3)) 3
9
```

Use a function to get the status code from an http request:

```
~your-urbit:dojo> _|=([p=@ud q=* r=*] p) +http://google.com
301
```

#### `+` `-` - HTTP requests

`+http[s]://example.com` - sends a GET request

`+http[s]://example.com &json [%s 'hi']` - sends a POST request with the
JSON `"hi"` in the body.

`-http[s]://example.com &json [%s 'hi']` - sends a PUT request with the
JSON `"hi"` in the body.

Note that the first of these is a source while the last two are sinks.

#### `+` - Generators

Generators are simple Hoon scripts loaded from the filesystem. They live
in `gen/`.

An example of a generator that is built into your urbit is `+code`. It produces
the code needed to log into your ship remotely.

```
~your-urbit:dojo> +code
fintyr-haldet-fassev-solhex
```

### Variables

You can use `=` to set an environment variable in Dojo, but there are
a few reserved names that have special uses.

#### dir

Current working `%clay` desk and revision. Read / write.

**Examples:**

```
~your-urbit:dojo> =dir %/web
~your-urbit:dojo> +ls %
404/hoon docs/ dojo/hoon lib/ listen/hoon md static/udon talk/ testing/udon tree/main/ unmark/ womb/
```

#### lib

Current set of libraries (`/lib`) in your environment. Can be set
with `/+`. Read / write.

**Examples:**

```
~your-urbit:dojo> /+  number-to-words
```
Now we can use arms from lib/number-to-words.hoon
```
~your-urbit:dojo> (to-words:eng-us:number-to-words 123.456)
```

#### sur

Current set of structures (`/sur`) in your environment. Can be set
with `/-`. Read / write.

**Examples:**

```
~your-urbit:dojo> /-  sole
```
Now we can use arms in sur/sole.hoon.
```
~your-urbit:dojo> `sole-effect:sole`[%bel ~]
```

#### now

The current (128-bit `@da`) time. Read-only.

**Example:**

```
~your-urbit:dojo> now
~2016.3.21..21.10.57..429a
```

#### our

The current urbit ship. Read-only.

**Example:**

```
~your-urbit:dojo> our
~your-urbit
```

#### eny

512 bits of entropy. Read-only.

**Example:**

```
~your-urbit:dojo> eny
\/0vnt.d474o.gpahj.jcf3o.448fh.2lamb.82ljm.8ol8u.b02vi.mrvvp.b7et2.knb7m.l8he\/
  8.8qb9s.drm36.77n9b.a0qst.30g03.l5lb5.nvsbc.v39tn
\/
```

## Troubleshooting

If you encounter `%dy-edit-busy` while entering commands, it is
because your Dojo is blocked on a timer or an HTTP request. Type backspace
and your Dojo will end the blocked command.
