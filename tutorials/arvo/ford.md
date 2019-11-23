+++
title = "Ford"
weight = 6
template = "doc.html"
aliases = ["/docs/learn/arvo/ford/"]
+++
Our typed and marked computation engine.

A variety of different services are provided by `%ford`, but they mostly
involve compiling hook files, slapping/slamming code with marked data,
and converting data between marks, including validating data to a mark.
Throughout every computation, `%ford` keeps track of which resources are
dependencies so that the client may be aware when one or more
dependencies are updated.

`%ford` neither accepts unix events nor produces effects. It exists
entirely for the benefit of applications and other vanes, in particular
`%gall`. `%eyre` exposes the functional publishing aspects of `%ford`
while `%gall` uses `%ford` to control the execution of applications.
`%clay` is intended to use `%ford` to managed marked data, but this is
not yet reality.

## Cards

`%ford` accepts just one card, `%exec`. This is misleading, however,
since there are fourteen different `silk`s that may be used with it. In
every case, the expected response to a `%exec` card is a `%made` gift
with either an error or the produced result along with its set of
dependencies.

Silks may autocons, so that the product of a cell of silks is a cell of
the product of the two silks.

### `%bake`

Tries to functionally produce the file at a given beam with the given
mark and heel. It fails if there is no way to translate at this level.

### `%boil`

Functionally produces the file at a given beam with the given mark and
heel. If there is no way to translate at this beam, we pop levels off
the stack and attempt to bake there until we find a level we can bake.
This should almost always be called instead of `%bake`.

### `%call`

Slams the result of one silk against the result of another.

### `%cast`

Translates the given silk to the given mark, if possible. This is one of
the critical and fundamental operations of ford.

### `%diff`

Diffs the two given silks (which must be of the same mark), producing a
cage of the mark specified in `++mark` in `++grad` for the mark of the
two silks.

### `%done`

Produces exactly its input. This is rarely used on its own, but many
silks are recursively defined in terms of other silks, so we often need
a silk that simply produces its input. A monadic return, if you will.

### `%dude`

Computes the given silk with the given tank as part of the stack trace
if there is an error.

### `%dune`

Produces an error if the cage is empty. Otherwise, it produces the value
in the unit.

### `%mute`

Takes a silk and a list of changes to make to the silk. At each wing in
the list we put the value of the associated silk.

### `%pact`

Applies the second silk as a patch to the first silk. The second silk
must be of the mark specified in `++mark` in `++grad` for the mark of
the first silk.

### `%plan`

Performs a structured assembly directly. This is not generally directly
useful because several other silks perform supersets of this
functionality. We don't usually have naked hoods outside ford.

### `%reef`

Produces a core containing the entirety of Zuse and Hoon, suitable for
running arbitrary code against. The mark is `%noun`.

### `%ride`

Slaps a hoon against a subject silk. The mark of the result is `%noun`.

### `%vale`

Validates untyped data from a ship against a given mark. This is an
extremely useful function.

## Ford runes

One of the most common ways to use ford is through ford's runes, all of which begin with `/` ("fas"). A ford rune runs a step of a ford build and places the result in the subject. There are various kinds of build steps, some of which take other build steps as parameters. The most common pattern is to have a sequence of ford runes at the top of a hoon source file that import the results of evaluating other hoon files. This is how we "import a library" in urbit: we add the result of compiling another hoon file into the current subject, possibly renaming it by wrapping a face around it.

Another common use case is assembling and rendering markdown templates into a single HTML file, to be sent as an HTTP response in urbit's web server `%eyre`. It's important to keep in mind that %ford is quite flexible and generic, and is used in other parts of urbit -- such as the dojo -- that would not traditionally fall under the purview of a build system.

### `/+` "faslus"

The `/+` rune accepts a filename as an argument. It interprets that filename
as a hoon source file within the `lib` directory. This is how we import a shared
library in urbit.

To run this example, put this code in your desk at `gen/faslus.hoon` and run
`+faslus` in your dojo. This example is a generator. For more information on
generators, see the [generator docs](@/docs/tutorials/hoon/generators.md).

```hoon
/+  time-to-id
::
:-  %say
|=  {{now/@da * *} $~ $~}
:-  %noun
(time-to-id now)
```

produces: `"c.314d"` (or something similar depending on when you run it)

You can import multiple libraries with a single `/+` rune by separating them
with commas.

Replace the code in `gen/faslus.hoon` with the following:

```hoon
/+  time-to-id, hep-to-cab
::
:-  %say
|=  {{now/@da * *} $~ $~}
:-  %noun
=/  id  (time-to-id now)
=/  str  "my-id-is-{id}"
(hep-to-cab (crip str))
```

This should print something like `my_id_is_c.3588`.

Another feature of the
`/+` and `/-` runes is the ability to specify the ship and case from which to
load the library.

Example:

```
/+  time-to-id, hep-to-cab/4/~zod
```

will load the `hep-to-cab` library from `~zod` at `%clay` revision `4`.

### `/-` "fashep"

The `/-` rune accepts a filename as an argument. It interprets that filename as
a hoon source file within the `sur` directory. The `sur` directory contains
shared structures that can be used by other parts of urbit. This is somewhat
similar to including a header file in C.

Example:

```hoon
/-  talk
::
*serial:talk
```

produces: `0v0`

`/-` can also take multiple files as arguments, and the ship and case of those
arguments can be specified. See the `/+` docs for more details about the syntax
for those features.

### `/~` "fassig"

`/~  <twig>` produces a "horn" that evaluates a twig and places the product in
the subject. Arbitrary hoon can be in the twig. A
horn is a data
structure representing a `%ford` static resource.

Example:

```hoon
/~  [a=0 b=1]
[a b]
```

produces: `[0 1]`

In wide-form, `/~` always takes a tuple (which may be a degenerate tuple of one element), and produces it.

Example:
```hoon
/~[%something]
```
produces: `%something`

```hoon
/~[%a %b]
```
produces: `[%a %b]`

### `//` "fasfas"

`// <rel-path>` parses `rel-path` as a hoon twig, and then adds the resulting
twig to the subject. Note that the result type of this rune is not a horn, but
just a hoon twig, so its result can't be used as an argument to other runes
that expect a horn. There is no wide-form for this rune.

Example:
```hoon
//  %/file-to-include
::
(frobnicate:file-to-include %.n)

::  contents of file-to-include.hoon
|%
++  frobnicate
  |=  a/?  ^+  a
  !a
--
```
produces: `%.y`

_Note: `%` means current directory, which in a hoon file will resolve to the
"directory" containing that file. Also, %clay doesn't have first-class
directories the way unix filesystems do. Whereas in unix, a directory is a
special kind of file, in %clay it's just a path prefix, and there is no file
stored at that path._

### `/=` "fastis"

`/=` runs a horn (usually produced by another ford rune), takes the result of
that horn, and wraps a face around it.

Example:
```hoon
/=  foo  /~  [a=0 b=1]
::
[a.foo b.foo]
```
produces: `[0 1]`

In wide-form, `/=` uses `=` as a delimiter: `/=foo=/~[a=0 b=1]`

### `/:` "fascol"

`/:` takes a path and a horn, and evaluates the horn with the current path set to the supplied path.
`/mar/` renders the mark 'mar' at the current path.

Example:
```hoon
/=  hoo-source  /:  /path/to/hoon-file  /hoon/
::
`@t`hoo-source
```

produces the text of the hoon file at "/path/to/hoon-file/hoon".

`/hoon/` renders the current path using the `%hoon` mark, which in this case
passes the contents through unchanged.  In general, rendering a file with a
mark will potentially run the contents through a series of conversion
operations. For details on marks, see the
[Gall docs](gall).

Here's an example that includes a mark conversion:
```hoon
/=  page  /:  /path/to/html/file  /mime/
::
page

::  contents of /path/to/html/file:
<html><head><title>My Fascinating Blog</title></head></html>
```
produces:
`[[%text %html ~] 60 '<html><head><title>My Fascinating Blog</title></head></html>']`

This result includes the MIME type ('text/html'), the content length in bytes,
and the HTML itself.

In wide-form, `/:` uses `:` as a delimiter: `/=page=/:/path/to/html/file:/mime/`

### `/!mark/` "faszap"

Example:
```hoon
/=  mime  /:  /%/some-hoon-file  /!mime/
::
mime

:: contents of /%/some-hoon-file:
%produces-a-cord
```
produces: `[[%text %plain ~] 15 'produces-a-cord']`

### `/&` "faspam"

`/&` passes a horn through multiple marks, right-to-left. It has both a
wide-form and a tall-form syntax. In wide-form, it takes a series of mark
arguments followed by a horn. In tall-form, it takes a single mark followed by
a horn.

```hoon
/=  some-text  /:  /%/text-file  /&mime&/txt/
::
some-text
```
produces: `[[%text %plain ~] p=17 q='Hi I\'m some text\0a']`

This example shows two of the ways marks are used. The first way is what
happens with the `/txt/` mark: we use it to find a file in clay with that
extension, without performing any conversions.  Since this file is stored with
the `%txt` mark in `%clay`, its type is a `wain`: a list of cords, where each
cord is a single line. Once we've read the file, the `%mime` mark converts the
`wain` to a triple that includes the MIME type ("text/plain"), the content
length in bytes, and the content itself as a cord.

```hoon
/=  page  /&html&elem&/~[;div.foo;]
::
page
```
produces: `'<html><head></head><body><div class="foo"></div></body></html>'`

This runs the sail expression `;div.foo;` through the `%elem` mark, then
through the `%html` mark.  The `/~` rune produces an item of mark `noun`.  The
`%elem` mark converts the mark of the expression from `noun` to `elem` by
checking that the type fits in `manx` (a hoon/sail type indicating an XML
element). The `%html` mark recognizes the `%elem` and converts it to an HTML
string with enclosing `<html>`, `<head>`, and `<body>` tags.

It's possible to use wide-form `/&` with more than two marks, by using `&` as a
delimiter between marks and adding a `/` before the last mark, like:
`/&d&c&b&/a/`. The last argument here can actually be any arbitrary horn, not
just a mark: `/&c&b&/:path:/mark/`

Tall-form `/&` takes only two arguments: a mark and a horn. The mark does not
need to be enclosed in `/`'s: `/&  html  /elem/`

### `/|` "fasbar"

`/|` takes a series of horns and produces the first one (left-to-right) that
succeeds. If none succeed, it produces stack traces from all of its arguments.

Example:
```hoon
/=  res  /:  /%/path/to/file
/|
  /!elem/
  /elem/
==
::
res
```
tries to parse the file at `/%/path/to/file` as a hoon expression and evaluate
it (`/!elem/`), and then if that fails, tries to convert the file to an HTML
element directly (`/elem/`). This is used in urbit's `tree` publishing system
to enable a user to place either a hoon file or a static file in a directory,
and have them both result in webpages, with preference given to treating the
file as hoon to be evaluated.

Wide-form `/|` encloses its arguments in parentheses, with a single space as a delimiter:
`/|(/!elem/ /elem/)`

### `/_` "fascab"

`/_` can be used in two ways: filtered and unfiltered.

Unfiltered `/_` takes a horn as an argument. It produces a new horn representing the
result of mapping the supplied horn over the list of files in the current
directory. The keys in the resulting map are the basenames of the files in the
directory, and each value is the result of running that horn on the contents of
the file.

Example:
```hoon
/=  kids  /_  /hoon/
::
`(map term cord)`kids
```

produces a value of type `(map term cord)`, where each key is the basename (the
filename without the prefix), and each value is the result of running the
contents of the file through the `%hoon` mark, which validates the
hoon code and returns it unmodified. So, the resulting map associates basenames
with file contents.

Wide-form unfiltered `/_` doesn't need a delimiter: `/=  kids  /_/hoon/`

### `/_` filtered: run a horn on each file in the directory matching an aura

Filtered `/_` takes an aura and a horn, and filters the list of files in the
current directory by whether their filenames can be parsed to an atom of that
aura. It then produces a map where each key is the filename after parsing into
that atom type, and each value is the result of running the horn on the
contents of that file.

Example:
```hoon
/=  timed-posts  /_  @da  /md/
`(map @da @t)`timed-posts
```
produces a map from dates to cords. This product will only contain files whose
names are parsable into `@da` dates. The values are the file contents converted
to a cord of markdown-formatted text.

Wide-form filtered `/_` uses `_` as a delimiter: `/=  timed-posts  /_@da_/md/`

### `/;` "fasmic"

`/;` takes a twig and a horn. The twig should evaluate to a gate, which is then slammed
with the result of the horn as its sample.

Example:
```hoon
/=  goo
    /;  |=({a/@ b/@} +(b))
    /~  [a=0 b=1]
::
goo
```

produces: `2`

Here's a slightly more complex example with runes that use the filesystem:
```hoon
/=  file-length
    /;  |=(a/@t (lent (crip a)))
    /:  /%/path/to/hoon/file  /hoon/
::
file-length
```
produces the number of bytes in the file "/%/path/to/hoon/file."

### `/,` "fascom"

`/,` is a switch statement, which picks a branch to evaluate based on
whether the current path matches the path in the switch statement.
Takes a sequence of pairs of (path, horn) terminated by a `==`. No wide-form.

Example:
```hoon
/=  just-right
    /:  /===/right-path                                 ::  set path to /%/right-path
    /,
      /wrong-path  /~  ~
      /another-wrong-path  /~  ~
      /right-path  /~  %evaluate-me                     ::  only evaluate this horn
    ==
::
`@t`just-right
```

produces: `'evaluate-me'`

### `/.` "fasdot"

Produce a null-terminated list from a sequence of horns, terminated by a `==`. No wide-form.

Example:
```hoon
/=  vanes
    /.
      /~  %ames
      /~  %behn
      /~  %clay
      /~  %dill
      /~  %eyre
      /~  %ford
      /~  %gall
    ==
::
vanes
```
produces: `[%ames %behn %clay %dill %eyre %ford %gall ~]`.

### `/^` "fasket"

`/^` takes a mold and a horn, and casts the result of the horn to the mold.

Example:
```hoon
/=  liz  /^  (list @)                                   ::  cast to real list
         /~  ~[1 2 3]                                   ::  no 'i' or 't' faces
::
?<  ?=($~ liz)                                          ::  prevent find-fork
i.liz
```

produces: `1`

Without the cast, we wouldn't be able to access the 'i' face of the list.

Wide-form `/^` uses `^` as a delimiter: `/^(list @)^/~[1 2 3 ~]`

### `/#` "fashax"

`/#` takes a horn and produces a cell of the dependency
hash of the result of the horn, and the result itself.

Example:
```hoon
/=  inline  /^  {dep/@uvH txt/@t}  /#  /:  /%/my-script  /js/
::
;=  ;script: (trip txt.inline)                          ::  set script contents
    ;script@"/~/on/{<dep.inline>}.js";                  ::  set script src
==
```
produces two `<script>` tags. The first has its contents set to the contents
of the JavaScript file we loaded from clay. The second is an auto-update
script that polls the server to check whether the dependency hash has changed.
This pattern is used in urbit's `tree` web publishing system.

Wide-form `/#` does not need a delimiter:
`/=  inline  /^  {dep/@uvH txt/@t}  /#/:/%/my-script:/js/`

### `/$` "fasbuc"

`/$` will slam a gate on whatever extra arguments have been supplied to this build.
At the moment, only HTTP requests forwarded by `%eyre` contain any extra arguments,
and using this rune outside of that context will cause an error. Requests from `%eyre`
contain an argument representing the query string, which can be parsed using the
standard library gate `++fuel:html`.

Example:
```hoon
/=  gas  /$  fuel:html
::
:*
  %who    {<(~(get ju aut.ced.gas) 0)>}
  %where  {(spud s.bem.gas)}
  %case   {(scow %ud p.r.bem.gas)}
==
```
produces: [%who '~zod' %where /ford/pages/web %case 60]

Wide-form `/$` takes its arguments inside brackets, like `/~`:
`/=gas=/$[fuel:html]`

### `/%` "fascen"

`/%` will forward extra arguments (usually from `%eyre`) on to any enclosed `/renderer/`'s. Without this,
renderers that use `/$` to read the extra arguments will crash.

Example:
```hoon
/=  dat  /%  /tree-json/
::
dat
```
produces the results of running `ren/tree-json` on the current path. This renderer needs the query string,
which is one of the extra arguments passed in from `%eyre`.

Wide-form `/%` has no delimiter: `/%/tree-json/`
