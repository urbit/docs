---
navhome: /docs/
sort: 6
---

# `:thin  ~<  "siggal"` 

`{$thin p/$@(term {p/term q/seed}) q/seed}`: raw hint, applied to 
product.

## Expands to

`q`.

## Syntax

Regular: *2-fixed*.  For the dynamic form, write `%term.twig`.

## Discussion

`:thin` is only used for jet hints (`:funk` and `:fast`) at the 
moment; we are not telling the interpreter something about the
computation we're about to perform, but rather about its product.

## Examples

```
~zod:dojo> (make ':thin(%a 42)')
[%7 p=[%1 p=42] q=[%10 p=97 q=[%0 p=1]]]
~zod:dojo> (make ':thin(%a.+(.) 42)')
[%7 p=[%1 p=42] q=[%10 p=[p=97 q=[%4 p=[%0 p=1]]] q=[%0 p=1]]]
```

```
~zod:dojo> (make '~<(%a 42)')
[%7 p=[%1 p=42] q=[%10 p=97 q=[%0 p=1]]]
~zod:dojo> (make '~<(%a.+(.) 42)')
[%7 p=[%1 p=42] q=[%10 p=[p=97 q=[%4 p=[%0 p=1]]] q=[%0 p=1]]]
```
