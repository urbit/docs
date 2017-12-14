---
navhome: /docs/
sort: 10
title: $- "buchep"
---

# `$- "buchep"`

`[%bchp p=model q=model]`: mold which normalizes to an example gate.

## Expands to

```
$_  ^|
|=(p $:q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

Since a `$-` ("buchep") is a [`$_` ("buccab")](../cab/), it is not useful for 
normalizing, just for typechecking.  In particular, the existence of `$-`s does 
*not* let us send gates or other cores over the network!

## Examples

```
~zod:dojo> =foo $-(%foo %bar)

~zod:dojo> ($:foo %foo)
%bar
```
