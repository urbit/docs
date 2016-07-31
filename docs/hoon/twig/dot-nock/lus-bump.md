---
navhome: /docs
sort: 3
---

# `:bump  .+  "dotlus"`

`{$bump p/atom}`: increment an atom with Nock `4`.

## Produces

`p` plus `1` if `p` is an atom; otherwise, crashes.  The product
atom has no aura.

## Syntax

Regular: *1-fixed*.

Irregular: `+(6)` is `.+(6)`.

## Examples

```
~zod:dojo> :bump(6)
7
~zod:dojo> +(6)
7
~zod:dojo> +(%foo)
7.303.015
~zod:dojo> +([1 2])
! nest-fail
```
