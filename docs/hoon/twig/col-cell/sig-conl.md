---
sort: 5
---

# `:conl  :~  "colsig"`

`{$conl p/(list seed)}`: construct a null-terminated list.

## Expands to

```
|-(?~(p ~ :cons(i.p $(p t.p))))
```

## Syntax

Regular: *running*.

## Examples

```
~zod:dojo> :~(5 3 4 2 1)
[5 3 4 2 1 ~]
~zod:dojo> ~[5 3 4 2 1]
[5 3 4 2 1 ~]
~zod:dojo> :~  5
               3
               4
               2
               1
           ==
[5 3 4 2 1 ~]
```
