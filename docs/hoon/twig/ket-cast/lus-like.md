---
navhome: /docs
sort: 1
---

# `:like  ^+  "ketlus"`

`{$like p/seed q/seed}`: typecast by example (seed).

## Produces

The value of `p` with the span of `q`, if the span of `p` nests
within the span of `q`.  Otherwise, `nest-fail`.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :like('text' %a)
'a'
~zod:dojo> :like('text' 97)
nest-fail
```


