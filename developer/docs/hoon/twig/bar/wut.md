---
navhome: /docs
sort: 9
title: |?  "barwut"
---

# `|?  "barwut"`

`{$brwt p/seed}`: form a lead trap.

## Expands to

```
^?  |.  p
```

## Syntax

Regular: *1-fixed*.

## Discussion

See this [discussion of the core variance model](../../../advanced).

## Examples

```
~zod:dojo> =>  ~  ^+  |?(%a)  |.(%a)
<1?pqz $~>
~zod:dojo> =>  ~  ^+  |?(%a)  |.(%b)
nest-fail
```
