---
sort: 2
---

# `:cont, :+, "collus", {$cont p/seed q/seed r/seed}`

Construct a triple (3-tuple).

## Expands to:

```
:cons(p :cons(q r))
```

## Syntax

Regular: *3-fixed*.

## Examples

```
/~zod:dojo> :+  1
              2
            3
[1 2 3]
/~zod:dojo> :+(%a ~ 'b')
[%a ~ 'b']
```
