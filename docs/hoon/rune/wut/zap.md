---
navhome: /docs/
next: true
sort: 7
title: ?! "wutzap"
---

# `?! "wutzap"`

`[%wtzp p=hoon]`: logical not.

## Expands to

```
.=(| p)
```

Produces the logical "not" of `p`.

## Syntax

Regular: *1-fixed*.

Irregular: `!foo` is `?!(foo)`.

## Examples

```
~zod:dojo> ?!(.=(1 2))
%.y

~zod:dojo> !&
%.n

~zod:dojo> !|
%.y

~zod:dojo> !(gth 5 6)
%.y
```
