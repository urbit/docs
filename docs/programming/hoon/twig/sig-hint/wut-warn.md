---
sort: 4
---

# `:warn ~? "sigwut" `{$warn p/twig q/twig r/twig}`

Conditional debugging printf.

## Expands to

`r`.

## Convention 

If `p` is true, prettyprints `q` on the console before computing `r`.

## Syntax

Regular: *4-fixed*.

## Examples

```
~zod:dojo> ~?((gth 1 2) 'oops' ~)
~
~zod:dojo> ~?((gth 1 0) 'oops' ~)
'oops'
~
```
