---
navhome: /docs/
next: true
sort: 13
title: =, "tiscom"
---

# `=, "tiscom"` 

`[%tscm p=hoon q=hoon]`: expose namespace of core.

Let `p` evaluate to a core; from within `q` you may call the arms of 
that core without using the core's name.  This is useful for calling arms 
from an imported library or for calling arms within an stdlib core repeatedly.

## Syntax

Regular: *2-fixed*.

## Examples

```
> (sum -7 --7)
-find.sum
[crash message]

> (sum:si -7 --7)
--0

> =,  si  (sum -7 --7)
--0
```
