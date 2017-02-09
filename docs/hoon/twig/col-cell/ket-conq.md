---
navhome: /docs/
sort: 3
---

# `:conq  :^  "colket"`

`{$conq p/seed q/seed r/seed s/seed}`: construct a quadruple (4-tuple).

## Expands to

```
:cons(p :cons(q :cons(r s)))
```

```
:-(p :-(q :-(r s)))
```

## Syntax

Regular: *4-fixed*.

## Examples

```
/~zod:dojo> :conq(1 2 3 4)
[1 2 3 4]
/~zod:dojo> :conq  5
                6
              7
            8
[5 6 7 8]
```

```
/~zod:dojo> :^(1 2 3 4)
[1 2 3 4]
/~zod:dojo> :^     5
                 6
               7
             8
[5 6 7 8]
```
