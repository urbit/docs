---
navhome: /docs/
sort: 5
---

# `:conl  :~  "colsig"`

`{$conl p/(list seed)}`: construct a null-terminated list.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `p`

```
:cons(a :cons(b :cons(c :cons(... :cons(z ~)))))
```

### Compiler macro

```
:loop
:ifno  p
  ~
:cons  i.p
:moar(p t.p)
```

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
~zod:dojo> :conl(6 5 3 4 2 1)
[6 5 3 4 2 1 ~]
~zod:dojo> ~[6 5 3 4 2 1]
[6 5 3 4 2 1 ~]
~zod:dojo> :conl  5
                  3
                  4
                  2
                  1
           ==
[5 3 4 2 1 ~]
```

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
