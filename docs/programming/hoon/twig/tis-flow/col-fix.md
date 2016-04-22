---
sort: 9
---

# `:fix, =:, "tiscol", {$fix p/(list (pair wing twig)) q/twig}`

Mutate multiple legs in the subject.

## Expands to

```
:per(:keep(. p q) r)
```

## Syntax

Regular: *jogging*, then *1-fixed*.

## Examples

```
~zod:dojo> =+  a=[b=1 c=2]
           =:  c.a  4
               b.a  3
             ==
           a
[b=3 c=4]
```
