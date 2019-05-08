+++
title = "Atoms and strings"
weight = 1
template = "doc.html"
+++
The simplest expressions in every language are constants:
atoms, strings, paths.  (Strings and paths aren't all constants per
se, because they have interpolations.)

## Expressions

### `:_ "Cold Atom"`

`[%rock p=term q=@]`; a constant, cold atom.

A cold atom is one whose type is inferred to be of a single atom constant.

##### Produces

A cold (fixed) atom `q` with aura `p`.

##### Syntax

Irregular: any [warm atom](#warm) form, prefixed with `%`.

Irregular: e.g., `%hi`.  Character constraints: `a-z`
lowercase to start, `a-z` or `0-9` thereafter, with infix
hyphens (`hep`), "kebab-case."

Irregular: `~`.

##### Examples

We can see the contrast with warm atoms by using the compiler parser function, `ream`:

```
> (ream '%hi')
[%rock p=%tas q=26.984]

> (ream '\'hi\'')
[%sand p=%t q=26.984]

> (ream '%12')
[%rock p=%ud q=12]
```

### `:_ "Paths"`

`[%path p=(list (each @ta hoon))]`: path with interpolation.

##### Produces

A null-terminated list of the items in `p`, which are either constant
`@ta` atoms (`knots`), or expressions producing a `knot`.

##### Syntax

Irregular: `/this/is/a/path`.

##### Examples

```
> `path`/this/is/a/path
/this/is/a/path

> `path`/this/is/[`@ta`(cat 3 %a- %test)]/path
/this/is/a-test/path

> `path`/this/is/(scot %tas 'test')/path
/this/is/test/path

> /
~
```

### `:_ "Strings with Interpolation"`

`[%knit p=(list (each @t hoon))]`: text string with interpolation.

##### Produces

A tape.

##### Syntax

Irregular: `"abcdefg"`.

Irregular: `"abc{(weld "lmnop" "xyz")}defg"`.

```
> "abcdefg"
"abcdefg"

> "abc{(weld "lmnop" "xyz")}defg"
"abclmnopxyzdefg"

> (ream '"abcdefg"')
[%knit p=~[97 98 99 100 101 102 103]]
```

##### Examples

String:

```
> "hello, world."
"hello, world."
```

String with interpolation:

```
> =+(planet="world" "hello, {planet}.")
"hello, world."
```

String with interpolated prettyprinting:

```
> =+(planet=%world "hello, {<planet>}.")
"hello, %world."
```

### `:_ "Warm Atoms"`

`[%sand p=term q=@]`; a constant, warm atom.

A 'warm' atom is one whose type is inferred to be general, i.e., not just a single atom type.

```
> `@`12
12

> `%12`12
nest-fail
```

##### Produces

A warm (variable) atom `q` with aura `p`.  Use the Hoon compiler parser function `ream` to take a closer look:

```
> (ream '12')
[%sand p=%ud q=12]

> (ream '\'Hello!\'')
[%sand p=%t q=36.762.444.129.608]
```

##### Syntax by example

Irregular.  A table of examples:

```
@c    UTF-32                   ~-foobar
@da   128-bit absolute date    ~2016.4.23..20.09.26..f27b..dead..beef..babe
                               ~2016.4.23
@dr   128-bit relative date    ~s17          (17 seconds)
                               ~m20          (20 minutes)
                               ~d42          (42 days)
@f    loobean                  &             (0, yes)
                               |             (1, no)
@p                             ~zod          (0)
@rd   64-bit IEEE float        .~3.14        (pi)
                               .~-3.14       (negative pi)
@rs   32-bit IEEE float        .3.14         (pi)
                               .-3.14        (negative pi)
@rq   128-bit IEEE float       .~~~3.14      (pi)
@rh   16-bit IEEE float        .~~3.14       (pi)
@sb   signed binary            --0b10        (2)
                               -0b101        (-5)
@sd   signed decimal           --2           (2)
                               -5            (-5)
@sv   signed base32            --0v68        (200)
                               -0vfk         (-500)
@sw   signed base64            --0w38        (200)
                               -0w7Q         (500)
@sx   signed hexadecimal       --0x2         (2)
                               -0x5          -5
@t    UTF-8 text (cord)        'foobar'
@ta   ASCII text (knot)        ~.foobar
@ub   unsigned binary          0b10          (2)
@uc   bitcoin address          0c1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa
@ud   unsigned decimal         42            (42)
                               1.420         (1420)
@uv   unsigned base32          0v3ic5h.6urr6
@uw   unsigned base64          0wsC5.yrSZC
@ux   unsigned hexadecimal     0xcafe.babe
```

The `@uv` characters are `0-9`, `a-v`.  The `@uw` characters are
`0-9`, `a-z`, `A-Z`, `-` and `~`.
