---
navhome: /docs/
next: true
sort: 5
title: =- "tishep"
---

# `=- "tishep"`

`[%tshp p=hoon q=hoon]`: combine a new noun with the subject, inverted.

## Expands to

```
=>([q .] p)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`=-` looks better than `=+` when the hoon you're pinning 
is much smaller than the hoon that uses it.

## Examples
 
```
~zod:dojo> =foo  |=  a=@
                 =+  b=1
                 =-  (add a b c)
                 c=2 
~zod:dojo> (foo 5)
8
```
