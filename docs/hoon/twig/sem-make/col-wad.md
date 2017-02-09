---
navhome: /docs/
sort: 3
---

# `:wad  ;:  "semcol"`

`{$wad p/seed q/(list seed)}`: call a binary function as an n-ary function.

## Expands to

*Pseudocode*, `a`, `b`, `c`, ... as elements of `q`

```
:call(p a :call(p b :call(p c ...)))
```

### Compiler macro

```
:loop
:ifno  q  !!
:ifno  t.q  !!
:ifno  t.t.q
  :call(p i.q i.t.q)
:call(p i.q :moar(q t.q))
```

```
|-
?~  q  !!
?~  t.q  !!
?~  t.t.q
  (p i.q i.t.q)
(p i.q $(q t.q))
```

## Syntax

Regular: *1-fixed*, then *running*.

Irregular: `:(add a b c)` is `;:(add a b c)`.

## Examples

```
~zod:dojo> (add 3 (add 4 5))
12
~zod:dojo> :wad(add 3 4 5)
12
```

```
~zod:dojo> (add 3 (add 4 5))
12
~zod:dojo> ;:(add 3 4 5)
12
~zod:dojo> :(add 3 4 5)
12
```
