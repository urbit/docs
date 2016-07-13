---
navhome: /docs
sort: 7
---

# `:not  ?!  "wutzap"`

`{$not p/seed}`: logical not.

## Expands to 

```
:same(%.n p)
```

```
.=(| p)
```

Produces the logical "not" of `p`.

## Syntax

Regular: *1-fixed*.

Irregular: `!foo` is `?!(foo)`.

## Examples

```
~zod:dojo> ?!(.=(1 2))
%.y
~zod:dojo> !&
%.n
~zod:dojo> !|
%.y
~zod:dojo> !(gth 5 6)
%.y
```
