---
navhome: /docs/
next: true
sort: 3
title: |_ "barcab"
---

# `|_ "barcab"` 

`[%brcb p=model q=(map term foot)]`: form a door, a many-armed core
with a sample.

## Expands to

```
=|  p
|%  q
==
```

## Syntax

Regular: *1-fixed*, then *battery*.

## Discussion

A door is the general case of a gate (function).  A gate is a
door with only one arm, the empty name `$`.

Other languages have no real equivalent of a door, but we often
see the pattern of multiple functions with the same argument
list, or with shared argument structure.  In Hoon, this shared
structure becomes a door.

Calling a door is just like calling a gate, but the caller needs
to specify the arm.  For instance, to call the gate `foo` as a
door, instead of `(foo bar)` we would write `~($ foo bar)`.  This
is an irregular form for `%~($ foo bar)`, ["censig"](../../cen/sig).

## Examples

A trivial door:

```
/~zod:dojo> =mol  |_  a=@ud
                  ++  succ  +(a)
                  ++  prev  (dec a)
                  --
/~zod:dojo> ~(succ mol 1)
2
/~zod:dojo> ~(succ mol ~(succ mol ~(prev mol 5)))
6
```

A more interesting door, from the kernel library:

```
++  ne
  |_  tig=@
  ++  d  (add tig '0')
  ++  x  ?:((gte tig 10) (add tig 87) d)
  ++  v  ?:((gte tig 10) (add tig 87) d)
  ++  w  ?:(=(tig 63) '~' ?:(=(tig 62) '-' ?:((gte tig 36) (add tig 29) x)))
  --
```

The `ne` door prints a digit in base 10, 16, 32 or 64:

```
~zod:dojo> `@t`~(x ne 12)
'c'
```
