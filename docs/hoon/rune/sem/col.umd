---
navhome: /docs/
next: true
sort: 1
title: ;: "semcol"
---

# `;: "semcol"`

`[%smcl p=hoon q=(list hoon)]`: call a binary function as an n-ary function.

## Expands to

*Pseudocode*: `a`, `b`, `c`, ... as elements of `q`:

Regular form:

```
%-(p a %-(p b %-(p c ...)))
```

Irregular form:

```
(p a (p b (p c ...)))
```

### Compiler macro

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
~zod:dojo> ;:(add 3 4 5)
12
~zod:dojo> :(add 3 4 5)
12
```
