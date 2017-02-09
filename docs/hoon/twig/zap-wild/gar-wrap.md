---
navhome: /docs/
sort: 2
---

# `:wrap  !>  "zapgar"`

`{$wrap p/seed}`: wrap a noun in its span.

## Produces

A cell whose tail is `p`, and whose head is the static span of p.

## Syntax

Regular: *1-fixed*.

## Discussion

In Hoon, dynamic type is static type compiled at runtime.  This
span-noun cell is generally called a `vase`.

## Examples

```
~zod:dojo> :wrap(1)
[p=#t/@ud q=1]
```

```
~zod:dojo> !>(1)
[p=#t/@ud q=1]
```
