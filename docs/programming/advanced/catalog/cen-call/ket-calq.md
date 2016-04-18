---
sort: 6
---

# `:calq, %^, "cenket", {$calq p/seed q/seed r/seed s/seed}`

Call a gate (function), with a triple sample.

## Expands to

`:call(p [q r s])`.

## Syntax

Regular: *4-fixed*.

## Examples

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %^(add-triple 1 2 3)
6
```
