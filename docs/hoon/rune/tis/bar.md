---
navhome: /docs/
next: true
sort: 8
title: =| "tisbar"
---

# `=| "tisbar"`

`[%tsbr p=model q=value]`: combine a defaulted mold with the subject.

## Expands to

```
=+(*p q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`=|` "declares a variable" which is "uninitialized," presumably 
because you'll set it in a loop or similar.

## Examples

```
~zod:dojo> =foo  |=  a=@
                 =|  b=@
                 =-  :(add a b c)
                 c=2 
~zod:dojo> (foo 5)
7
```
