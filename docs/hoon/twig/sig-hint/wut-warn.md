---
navhome: /docs/
sort: 4
---

# `:warn  ~?  "sigwut"`

`{$warn p/seed q/seed r/seed}`: conditional debug printf.

## Expands to

`r`.

## Convention 

If `p` is true, prettyprints `q` on the console before computing `r`.

## Syntax

Regular: *4-fixed*.

## Examples

```
~zod:dojo> :warn((gth 1 2) 'oops' ~)
~
~zod:dojo> :warn((gth 1 0) 'oops' ~)
'oops'
~
```

```
~zod:dojo> ~?((gth 1 2) 'oops' ~)
~
~zod:dojo> ~?((gth 1 0) 'oops' ~)
'oops'
~
```
