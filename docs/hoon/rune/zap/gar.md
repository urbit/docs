---
navhome: /docs/
next: true
sort: 3
title: !> "zapgar"
---

# `!> "zapgar"`

`[%zpgr p=hoon]`: wrap a noun in its type.

## Produces

A cell whose tail is `p`, and whose head is the static type of p.

## Syntax

Regular: *1-fixed*.

## Discussion

In Hoon, dynamic type is static type compiled at runtime.  This
type-noun cell is generally called a `vase`.

## Examples

```
~zod:dojo> !>(1)
[p=#t/@ud q=1]
```
