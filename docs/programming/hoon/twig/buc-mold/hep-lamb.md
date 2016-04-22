---
sort: 4
---

# `:lamb, $-, "buchep", {$lamb p/moss q/moss}`

Form a mold which normalizes to an example gate.

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

Since a lamb is a shoe, it is not useful for normalizing, just
for its signature.  In particular, the existence of lambs does
let us send gates or other cores over the network!

## Examples

```
~zod:dojo> =foo :lamb($foo $bar)

~zod:dojo> ($:foo %foo)
%bar
```
