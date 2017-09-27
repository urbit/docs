---
navhome: /docs/
sort: 2
---

# `:show  ~|  "sigbar"`

`{$show p/seed q/seed}`: tracing printf.

## Expands to

`q`.

## Convention

Prettyprints `p` in stack trace if `q` crashes.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :show('sample error message' !!)
'sample error message'
ford: build failed
```

```
~zod:dojo> ~|('sample error message' !!)
'sample error message'
ford: build failed
```
