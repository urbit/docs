---
navhome: /docs/
sort: 13
---

# `:deft  ?+  "wutlus"`

`{$case p/wing q/seed r/(list (pair moss seed))}`: switch against 
a union, with a default.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `r`

```
:if  :fits(p.a)  q.a
:if  :fits(p.b)  q.b
:if  :fits(p.c)  q.c
...
q
```

### Compiler macro

```
:loop
:ifno  r
  q
:if  :fits(p.i.r p)
  q.i.r
:moar(r t.r)
```

```
|-
?.  r
  q
?:  ?=(p.i.r p)
  q.i.r
$(r t.r)
```

## Syntax

Regular: *2-fixed*, then *jogging*.

## Discussion

An extra case will throw `mint-vain`.  A lost case defaults.

## Examples

```
~zod:dojo> =cor  :gate  vat/?($a $b)
                 :deft  vat  240
                      $a  20
                      $b  42
                 ==
~zod:dojo> (cor %a)
20
~zod:dojo> (cor %b)
42
~zod:dojo> (cor %c)
240
```

```
~zod:dojo> =cor  |=  vat/?($a $b)
                 ?+  vat  240
                   $a  20
                   $b  42
                 ==
~zod:dojo> (cor %a)
20
~zod:dojo> (cor %b)
42
~zod:dojo> (cor %c)
240
```
