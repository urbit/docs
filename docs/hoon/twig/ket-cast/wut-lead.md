---
navhome: /docs
sort: 4
---

# `:lead  ^?  "ketwut"`

`{$lead p/seed}`: convert any core to a lead core (bivariant).

## Produces

`p` as a lead core; crash if not a core.

## Syntax

Regular: *1-fixed*.

## Discussion

A lead core is an opaque generator; the payload can't be read or 
written.

Theorem: if span `x` nests within span `a`, a lead core producing
`x` nests within a lead core producing `a`.

Informally, a more specific generator can be used as a less
specific generator.

## Examples

The prettyprinter shows the core metal (`.` gold, `?` lead):

```
~zod:dojo> :gate(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
~zod:dojo> :lead(:gate(@ 1))
<1?gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```

```
~zod:dojo> |=(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
~zod:dojo> ^?(|=(@ 1))
<1?gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```

