---
navhome: /docs/
sort: 4
---

# `:conp  :*  "coltar"`

`{$conp p/(list twig)}`: construct an n-tuple.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `p`

```
:cons(a :cons(b :cons(c :cons(... z)))))
```

### Compiler macro

```
:loop
:ifno  p
  !!
:ifno  t.p
  i.p
:cons  i.p
:moar(p t.p)
```

```
|-
?~  p
  !!
?~  t.p
  i.p
:-  i.p
$(p t.p)
```

## Syntax

Regular: *running*.

## Examples
```
/~zod:dojo> :conp(5 3 4 1 4 9 0 ~ 'a')
[5 3 4 1 4 9 0 ~ 'a']
/~zod:dojo> [5 3 4 1 4 9 0 ~ 'a']
[5 3 4 1 4 9 0 ~ 'a']
/~zod:dojo> :conp  5
                   3
                   4 
                   1
                   4
                   9
                   0
                   ~
                   'a'
            ==
[5 3 4 1 4 9 0 ~ 'a']
```
```
/~zod:dojo> :*(5 3 4 1 4 9 0 ~ 'a')
[5 3 4 1 4 9 0 ~ 'a']
/~zod:dojo> [5 3 4 1 4 9 0 ~ 'a']
[5 3 4 1 4 9 0 ~ 'a']
/~zod:dojo> :*  5
                3
                4 
                1
                4
                9
                0
                ~
                'a'
            ==
[5 3 4 1 4 9 0 ~ 'a']
```
