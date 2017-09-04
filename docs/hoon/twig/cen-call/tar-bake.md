---
navhome: /docs
sort: 8
---

# `:bake  %*  "centar"`

`{$bake p/wing q/twig r/(list (pair wing seed))}`: make
with arbitrary twig.

## Expands to

```
:pin  q
:make p
r
```

```
=+  q
=%  p
r
```

## Syntax

Regular: *2-fixed*, then *jogging*.

## Examples

```
~zod:dojo> %*($ add a 2, b 3)
5
~zod:dojo> =foo [a=1 b=2 c=3 d=4]
~zod:dojo> %*(+ foo c %hello, d %world)
[b=2 c=%hello d=%world]
```
