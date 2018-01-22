---
navhome: /docs/
next: true
sort: 5
title: |- "barhep"
---

# `|- "barhep"`

`[%brhp p=hoon]`: form a trap and kick ("*call*") it.

## Expands to

```
=<($ |.(p))
```

## Syntax

Regular: *1-fixed*.

## Discussion

The `|-` ("barhep") rune can be thought of as a "recursion 
point". Since `|-` makes a `|.` (["bardot"](../dot), a core 
with one arm named `$`, we can recurse back into it with `$()`.

> `$()` expands to `%=($)` (["centis"](../../cen/tis)), 
> accepting a *jogging* body containing a list of changes to 
> the subject.

## Examples

A trivial loop doesn't even recurse:

```
~zod:dojo> |-(42)
42
```

The classic loop is a decrement:

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
