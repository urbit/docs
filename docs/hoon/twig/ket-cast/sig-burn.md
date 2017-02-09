---
navhome: /docs/
sort: 6
---

# `:burn  ^~  "ketsig"`

`{$burn p/seed}`: fold constant at compile time.

## Produces

`p`, folded as a constant if possible.

## Syntax

Regular: *1-fixed*.

## Examples

```
~zod:dojo> (make '|-(42)')
[%8 p=[%1 p=[1 42]] q=[%9 p=2 q=[%0 p=1]]]
~zod:dojo> (make '^~(|-(42))')
[%1 p=42]
```

```
~zod:dojo> (make ':loop(42)')
[%8 p=[%1 p=[1 42]] q=[%9 p=2 q=[%0 p=1]]]
~zod:dojo> (make ':burn(:loop(42))')
[%1 p=42]
```
