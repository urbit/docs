---
sort: 3
---

# `:conq, :^, "colket", {$conq p/seed q/seed r/seed s/seed}`

Construct a quadruple (4-tuple).

## Expands to

```
:cons(p :cons(q :cons(r s)))
```

## Syntax

Regular: *4-fixed*.

## Examples

```
/~zod:dojo> :^(1 2 3 4)
[1 2 3 4]
/~zod:dojo> :^  5  6
              7
            8
[5 6 7 8]
```
