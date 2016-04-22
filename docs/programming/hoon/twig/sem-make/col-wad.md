---
sort: 3
---

# `:wad ;: "semcol" {$wad p/seed q/(list seed)}`

Call binary function as n-ary function.

## Expands to

```
|-(?~(q !! ?~(t.q !! ?~(t.t.q :call(p i.q i.t.q) :call(p i.q $(q t.q))))))
```

## Syntax

Regular: *1-fixed*, then *running*.

Irregular: `:(add a b c)` is `;:(add a b c)`.

## Examples

```
~zod:dojo> (add 3 (add 4 5))
12
~zod:dojo> ;:(add 3 4 5)
12
~zod:dojo> :(add 3 4 5)
12
```
