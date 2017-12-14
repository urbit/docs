---
navhome: /docs/
next: true
sort: 9
title: =* "tistar"
---

# `=* "tistar"`

`[%tstr p=term q=hoon r=hoon]`: define an alias.

## Produces

`r`, compiled with a subject in which `p` is aliased to `q`.

## Syntax

Regular: *3-fixed*.

## Discussion

The difference between aliasing and pinning is that the subject
noun stays the same; the alias is just recorded in its type.
`q` is calculated every time you use the `p` alias, of course.

## Examples

```
~zod:dojo>
    =+  a=1
    =*  b  a
    [a b]
[1 1]

~zod:dojo>
    =+  a=1
    =*  b  a
    =.  a  2
    [a b]
[2 2]
```
