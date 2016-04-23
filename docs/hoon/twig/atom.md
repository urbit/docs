---
sort: 1
next: true
---

# Atoms, constants, quasi-constants

A constant is a twig whose product does not depend on the
subject.  If you know Nock, the formula produced is always
is always `[1 constant]`.

(Some of the "constant" syntax below can interpolate dynamic
twigs.  When it does, it obviously isn't constant at all.)

## Twigs

```
|%
++  twig
  {$rock p/@tas q/@}
  {$sand p/@tas q/@}
  {$knit p/(list $@(@ {$~ p/twig}))}
  {$path p/(list (each @tas twig))
--
```

## Syntax

All Hoon constants are irregular; they have no rune form.  The
stems described below are `$rock` (cold / constant), `$sand`
(warm / open), `$knit` (iterative string), and `$path` (Unix
style path).

### Atoms

Recall the `$atom` span, `{$atom p/aura q/(unit @)}`.

Each atom constant syntax implies an aura.  Note that the aura is
used indiscriminately to convey physical units, semantic
interpretations, parsing syntax, and/or printing syntax.

### Hardcoded auras

### Cold or warm, single or arbitrary

A span is a set of nouns; an `$atom` span contains either one
atom (*cold*) or all atoms (a *warm*).

In general, the `%` prefix is added to indicate coldness.  `42`
is warm and `%42` is cold.  `@tas` symbols (which start with `%`
already, see below) are always cold.

### Unsigned integer: `@ud`, `@ux`, `@uw`.

Unsigned integers are broken into groups of 3 for decimals, and 4
for non-decimals, separated German style by `.`; `420` plus `999`
is `1.419`, a `@ud`.

A hex (`@ux`) favorite is `0xcafe.babe`.

`0w` is base64: `0-9`, `a-z` + 10, `A-Z` + 36, `-` and `~`.  For
giant numbers, you can put whitespace/newlines after the `.`.

### Boolean and null: `@f`, `@n`.

Booleans in Hoon (`@f`) are `&` for yes (`@f`) and `|` for no.
Remember that `&` is `0` and `|` is `1` (which is why we say
"yes" and "no" rather than "true" and "false").

Nil (aura `@n`) is `~` (with the value `0`).

### Atomic string

`'text'` in single quotes, `@t`, is a UTF-8 string LSB first.

`%symbol`, `@tas`, containing only `a-z`, `0-9` and `-`, starting
with `a-z`, and ending with `a-z0-9`, is a valid symbolic name.

`%$` is an empty `@tas`, ie, `0` with span `@tas`.

### Signed integer: `@sd`

Signed integers (`@sd`) are encoded with sign bit *low*.  This
means we need a special syntax for positive signed integers,
since their atomic value can't be their unsigned value.  For
example, `-3` is the atom `7`, whereas `--3` encodes to `6`.

### Iterative string

Hoon also has list-shaped strings (less compact, more editable).
Use double quotes: `"hello, world"`.  The mold is `tape` or
`(list char)`, where `char` is a UTF-8 byte.

Within a quoted string, interpolate with `{}`: `"hello, {(weld
"wo" "rld")}"`.  It's also worth noting that `<`, `gar`, and `>`,
`gal` (angle brackets) stringify any twig: `"hello, {<mul 6
7>}"`.  (Obviously, an interpolated string is not a constant.)

### Path
 
The path `/foo/bar/baz` is the constant `[%foo %bar %baz ~]`.
A path can be dynamically interpolated with `[]`: 

```
/foo/[:(if & %bar %rab)]/baz`
```

equals `/foo/bar/baz`.


