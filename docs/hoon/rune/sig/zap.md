---
navhome: /docs/
next: true
sort: 3
title: ~! "sigzap"
---

# `~! "sigzap"` 

`[%sgzp p=hoon q=hoon]`: print type on compilation fail.

## Expands to

`q`.

## Convention

If compilation of `q` fails, prints the type of `p` in the trace.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> a
! -find.a

~zod:dojo> ~!('foo' a)
! @t
! find.a

~zod:dojo> ~!  'foo' 
           a
! @t
! find.a
```
