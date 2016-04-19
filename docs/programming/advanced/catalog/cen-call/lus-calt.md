---
sort: 6
---

# `:calt, %+, "cenlus", {$calt p/seed q/seed r/seed}`

Call a gate (function), with a cell sample.

## Expands to

`:call(p [q r])`.

## Syntax

Regular: *3-fixed*.

## Examples

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %+(add-triple 1 [2 3])
6

