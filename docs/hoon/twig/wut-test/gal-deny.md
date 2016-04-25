---
sort: 10
---

# `:deny  ?<  "wutgal"`

`{$deny p/seed q/seed}`: negative assertion.

## Expands to

```
:if  p
  :zpzp
q
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> ?<(=(3 4) %foo)
%foo
```

