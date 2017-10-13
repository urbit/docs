---
navhome: /docs/
sort: 4

---

# `:loop  |-  "barhep"`

`{$loop p/seed}`: form a trap and kick ("*call*") it.

## Expands to

```
:rap  $
:trap  p
```

```
=<($ |.(p))
```

## Syntax

Regular: *1-fixed*.

## Discussion

The `:loop` keyword (and `|-` rune) can be thought of as a "recursion point" -
since `:loop` makes a `:trap` (a core with one arm named `$`), we can recurse
back into it with `:moar()` or `$()`.

> `:moar()` expands to `:make($)`, accepting a *jogging* body containing a list
> of changes to the subject.

> `$()` expands to `%=($)`, accepting a *jogging* body containing a
> list of changes to the subject.

## Examples

A trivial loop doesn't even recurse:

```
~zod:dojo> :loop(42)
42
```

```
~zod:dojo> |-(42)
42
```

The classic loop is a decrement:

```
~zod:dojo> =foo  :var  a  42
                 :var  b  0
                 :loop
                 :if  =(a +(b))
                   b
                 :moar(b +(b))
~zod:dojo> foo
41
```

```
~zod:dojo> =foo  =/  a  42
                 =/  b  0
                 |-
                 ?:  =(a +(b))
                   b
                 $(b +(b))
~zod:dojo> foo
41
```
