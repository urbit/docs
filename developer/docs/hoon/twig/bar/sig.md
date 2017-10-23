---
navhome: /docs
sort: 10
title: |~  "barsig"
---

# `|~  "barsig"`

`{$brsg p/moss q/seed}`: form an iron gate.

## Expands to

```
^|  |=(p q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

See [this discussion of core variance models](../../../advanced)

## Examples

```
~zod:dojo> =>  ~  ^+(|~(a/@ *@) |=(a/* *@))
<1|usl {a/@ $~}>
```
