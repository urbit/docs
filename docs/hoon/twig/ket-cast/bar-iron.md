---
navhome: /docs/
sort: 5
---

# `:iron  ^|  "ketbar"`

`{$iron p/seed}`: convert a gold core to an iron core (contravariant).

## Produces

`p` as an iron core; crash if not a gold core.

## Syntax

Regular: *1-fixed*.

## Discussion

An iron core is an opaque function (gate or door).

Theorem: if span `x` nests within span `a`, and span `y` nests
within span `b`, a core accepting `b` and producing `x` nests
within a iron core accepting `y` and producing `a`.

Informally, a function fits an interface if the function has a
more specific result and/or a less specific argument than the
interface.

## Examples

The prettyprinter shows the core metal (`.` gold, `|` iron):

```
~zod:dojo> :gate(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
~zod:dojo> :iron(:gate(@ 1))
<1|gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```

```
~zod:dojo> |=(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
~zod:dojo> ^|(|=(@ 1))
<1|gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```

