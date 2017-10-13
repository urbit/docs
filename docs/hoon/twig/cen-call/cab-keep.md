---
navhome: /docs/
sort: 2

---

# `:keep  %_  "cencab"`

`{$keep p/wing q/(list (pair wing seed))}`: take a wing with changes,
preserving type.

## Expands to

```
:like(p :make(p q))
```

```
^+(p %=(p q))
```

## Syntax

Regular: *1-fixed*, then *jogging*.

## Discussion

`:keep` is different from `:make` because `:make` can change the
span of a limb with mutations.

## Examples

```
~zod:dojo> =foo [p=42 q=6]
~zod:dojo> foo(p %bar)
[p=%bar q=6]
~zod:dojo> foo(p [55 99])
[p=[55 99] q=6]
~zod:dojo> :keep(foo p %bar)
[p=7.496.034 99]
~zod:dojo> :keep(foo p [55 99])
! nest-fail
```

```
~zod:dojo> =foo [p=42 q=6]
~zod:dojo> foo(p %bar)
[p=%bar q=6]
~zod:dojo> foo(p [55 99])
[p=[55 99] q=6]
~zod:dojo> %_(foo p %bar)
[p=7.496.034 99]
~zod:dojo> %_(foo p [55 99])
! nest-fail
```
