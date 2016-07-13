---
navhome: /docs
sort: 8

---

# `:lamb  $- "buchep"`

`{$lamb p/moss q/moss}`: mold which normalizes to an example gate.

## Expands to

```
:shoe
:iron
:gate  p
$:q
```

## Syntax

Regular: *2-fixed*.

## Discussion

Since a lamb (ie, lambda), is a shoe, it is not useful for normalizing, just
for typechecking.  In particular, the existence of lambs does *not* let us send
gates or other cores over the network!

## Examples

```
~zod:dojo> =foo :lamb($foo $bar)

~zod:dojo> ($:foo %foo)
%bar
```
