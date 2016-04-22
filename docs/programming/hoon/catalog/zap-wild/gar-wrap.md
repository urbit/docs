---
sort: 2
---

# `:wrap !> "zapgar" {$wrap p/twig}`

Wrap a noun in its span.

## Produces

A cell whose tail is `p`, and whose head is the static span of p.

## Syntax

Regular: *1-fixed*.

## Discussion

In Hoon, dynamic type is static type compiled at runtime.  This
span-noun cell is generally called a `vase`.

## Examples

```
~zod:dojo> !>(1)
[#t/@ud q=1]
```
