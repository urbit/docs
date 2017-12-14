---
navhome: /docs/
sort: 6
title: :~ "colsig"
---

# `:~ "colsig"`

`[%clsg p=(list hoon)]`: construct a null-terminated list.

## Expands to

*Pseudocode*: `a`, `b`, `c`, ... as elements of `p`:

```
:-(a :-(b :-(c :-(... :-(z ~)))))
```

### Compiler macro

```
|-
?~  p
  ~
:-  i.p
$(p t.p)
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
