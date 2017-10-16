---
navhome: /docs/
sort: 10
---

# `:deny  ?<  "wutgal"`

`{$deny p/seed q/seed}`: negative assertion.

## Expands to

```
:if  p
  !!
q
```

```
?:(p !! q)
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :deny(=(3 4) %foo)
%foo
```

```
~zod:dojo> ?<(=(3 4) %foo)
%foo
```

