---
navhome: /docs/
sort: 3
---

# `:open  %~  "censig"`

`{$cnsg p/wing q/seed r/seed}`: call with multi-armed door.

## Expands to

```
:pin  :name(a q)
:rap(p :make(a +6 r))
```

```
=+  a=q
=<(p %=(a +6 r))
```

> Note: the expansion implementation is hygienic -- it doesn't actually add the
> `a` face to the subject. It's shown here because `:make` requires a `wing`.

## Syntax

Regular: *3-fixed*.

Irregular: `~(a b c)` is `%~(a b c)`; `~(a b c d e)` is `%~(a b
[c d e])`.

## Discussion

`:open` is the general case of a function call, `:call`.  In
both, we replace the sample (`+6`) of a core.  In `:call` the
core is a gate and we pull the `$` arm, in `:open` the
core is a door and we can pull any of its arms.

Most languages do not have cores, doors, or `:open`.  "Just
learn to step outside your linear, Western way of thinking."

## Examples

See [`:door`](../../bar-core/cab-door).

