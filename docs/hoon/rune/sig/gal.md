---
navhome: /docs/
sort: 12
title: ~< "siggal"
---

# `~< "siggal"` 

`[%sggl p=$@(term [p=term q=hoon]) q=hoon]`: raw hint, applied to 
product.

## Expands to

`q`.

## Syntax

Regular: *2-fixed*.  For the dynamic form, write `%term.hoon`.

## Discussion

`~<` ("siggal") is only used for jet hints ([`~/` ("sigfas")](../fas/) 
and [`~%` ("sigcen")](../cen/)) at the moment; we are not telling the 
interpreter something about the computation we're about to perform, but 
rather about its product.

## Examples

```
~zod:dojo> (make '~<(%a 42)')
[%7 p=[%1 p=42] q=[%10 p=97 q=[%0 p=1]]]
~zod:dojo> (make '~<(%a.+(.) 42)')
[%7 p=[%1 p=42] q=[%10 p=[p=97 q=[%4 p=[%0 p=1]]] q=[%0 p=1]]]
```
