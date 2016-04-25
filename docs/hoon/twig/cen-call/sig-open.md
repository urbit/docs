---
sort: 3
---

# `:open  %~  "censig"`

`{$cnsg p/wing q/seed r/seed}`: call with multi-armed door.

## Expands to

```
:rap(p :make(q +6 r))
```

## Syntax

Regular: *3-fixed*.

Irregular: `~(a b c)` is `%~(a b c)`; `~(a b c d e)` is `%~(a b
[c d e])`.

## Discussion

`:open` is the general case of a function call, `:call`.  In
both, we replace the sample (`+6`) of a core.  In `:call` the
core is a gate and we 

Most languages do not have cores, doors, or `:open`.  "Just
learn to step outside your linear, Western way of thinking."

## Examples

See [`:door`](../bar-core/cab-door).

