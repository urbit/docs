---
navhome: /docs/
sort: 3
---

# `:name  ^=  "kettis"`

`{$name p/toga q/seed}`: name a value.

## Produces

If `p` is a term, the product `q` with span `[%face p q]`.  `p`
may also be a tuple of terms, or a term-toga pair; the span of 
`q` must divide evenly into cells to match it.

## Syntax

Regular: *2-fixed*.

Irregular: `foo=bar` is `:name(foo bar)`.

## Examples

```
~zod:dojo> a=1
a=1
~zod:dojo> ^=  a
           1
a=1
~zod:dojo> :name(a 1)
a=1
~zod:dojo> [b c d]=[1 2 3 4]
[b=1 c=2 d=[3 4]]
~zod:dojo> [b c d=[x y]]=[1 2 3 4]
[b=1 c=2 d=[x=3 y4]]
```
