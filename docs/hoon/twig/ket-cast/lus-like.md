---
sort: 1
---

# `:like  ^+  "ketlus" 

`{$like p/seed q/seed}`: typecast by example (seed).

## Produces

The value of `p` with the span of `q`, if the span of `p` nests
within the span of `q`.  Otherwise, `nest-fail`.

## Syntax

Regular: *2-fixed*.

Irregular: `\`_foo\`bar` is `:like(foo bar)`.

## Examples

```
~zod:dojo> :like('text' 97)
'a'
```
