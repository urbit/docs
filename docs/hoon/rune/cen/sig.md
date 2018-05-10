---
navhome: /docs/
next: true
sort: 6
title: %~ "censig"
---

# `%~ "censig"`

`[%cnsg p=wing q=hoon r=(list hoon)]`: call with multi-armed door.

## Expands to

```
=+  a=q
=<(p %=(a +6 r))
```

> Note: the expansion implementation is hygienic -- it doesn't actually add the
> `a` face to the subject. It's shown here because `%=` ("centis") requires a `wing`.

## Syntax

Regular: *3-fixed*.

Irregular: `~(a b c)` is `%~(a b c)`; `~(a b c d e)` is `%~(a b
[c d e])`.

## Discussion

`%~` ("censig") is the general case of a function call, `%-` ("cenhep").  In
both, we replace the sample (`+6`) of a core.  In `%-` the
core is a gate and we pull the `$` arm. In `%~` the
core is a door and we can pull any of its arms.

Most languages do not have cores, doors, or `%~`.  "Just
learn to step outside your linear, Western way of thinking."

## Examples

See [`|_`](../../bar/cab).

