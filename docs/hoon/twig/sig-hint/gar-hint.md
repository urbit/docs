---
navhome: /docs/
sort: 5
---

# `:hint  ~>  "siggar"`

`{$hint p/$@(term {p/term q/seed}) q/seed}`: raw hint, applied
to computation.

## Expands to

`q`.

## Syntax

Regular: *2-fixed*.  For the dynamic form, write `%term.twig`.

## Discussion

Hoon has no way of telling what hints are used and what aren't.
Hints are all conventions at the interpreter level.

## Examples

```
~zod:dojo> :hint(%a 42)
42
```

```
~zod:dojo> ~>(%a 42)
42
```

Running the compiler:

```
~zod:dojo> (make ':hint(%a 42)')
[%10 p=97 q=[%1 p=42]]
~zod:dojo> (make ':hint(%a.+(2) 42)')
[%10 p=[p=97 q=[%4 p=[%1 p=2]]] q=[%1 p=42]]
```

```
~zod:dojo> (make '~>(%a 42)')
[%10 p=97 q=[%1 p=42]]
~zod:dojo> (make '~>(%a.+(2) 42)')
[%10 p=[p=97 q=[%4 p=[%1 p=2]]] q=[%1 p=42]]
```
