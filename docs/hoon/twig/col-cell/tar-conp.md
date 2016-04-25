---
sort: 4
---

# `:conp  :*  "coltar"`

`{$conp p/(list twig)}`: construct an n-tuple.

## Expands to

```
|-(?~(p !! ?~(t.p i.p :cons(i.p $(p t.p)))))
```

## Syntax

Regular: *running*.

## Examples
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
