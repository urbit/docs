---
sort: 4
---

# `:lace, %., "cendot", {$lace p/seed q/seed}`

Call a gate (function), reversed.

## Expands to

`:call(q p)`.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %.([1 2 3] add-triple)
6
```

