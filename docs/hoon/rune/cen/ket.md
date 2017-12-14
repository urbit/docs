---
navhome: /docs/
next: true
sort: 5
title: %^ "cenket"
---

# `%^ "cenket"` 

`[%cnkt p=hoon q=hoon r=hoon s=hoon]`: call with triple sample.

## Expands to

```
%-(p [q r s])
```

## Syntax

Regular: *4-fixed*.

## Examples

```
~zod:dojo> =add-triple |=([a/@ b/@ c/@] :(add a b c))
~zod:dojo> %^(add-triple 1 2 3)
6
```
