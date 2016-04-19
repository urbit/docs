---
sort: 2 
---

# `:deep, .?, "dotwut", {$deep p/twig}`

Test for cell or atom with Nock `3`.

## Produces

`&`, `%.y`, `0` if `p` is a cell; otherwise `|`, `%.n`, `1`.

## Syntax

Regular: *1-fixed*.

## Examples

```
~zod:dojo> .?(~)
%.n
~zod:dojo> .?([2 3])
%.y
```
