---
sort: 1
---

# `:fry ;; "semsem" {$fry p/moss q/seed}`

Normalize with a mold, asserting fixpoint.

## Expands to

```
:pin(:name(a (p q)) :sure(=(a (p a)) a))
```

## Syntax

Regular: *2-fixed*.

## Examples

Fails because of auras:

```
~zod:dojo> ^-(tape ~[97 98 99])
! nest-fail
! exit
```

Succeeds because molds don't care about auras:

```
~zod:dojo> ;;(tape ~[97 98 99])
"abc"
```

Succeeds because the mold normalizes:

```
~zod:dojo> (tape [50 51 52])
"23"
```

Fails because not a fixpoint:

```
~zod:dojo> ;;(tape [50 51 52])
! exit
```
