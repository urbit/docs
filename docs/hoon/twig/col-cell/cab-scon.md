---
navhome: /docs/
sort: 6
---

# `:scon  :_  "colcab"`

`{$scon p/seed q/seed}`; construct a cell, inverted.

### Expands to

```
:cons(q p)
```

```
:-(q p)
```

### Syntax

Regular: *2-fixed*.

### Examples

```
~zod:dojo> :scon(1 2)
[2 1]
```

```
~zod:dojo> :_(1 2)
[2 1]
```
