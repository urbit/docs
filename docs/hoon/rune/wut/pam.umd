---
navhome: /docs/
next: true
sort: 5
title: ?& "wutpam"
---

# `?& "wutpam"`

`[%wtpm p=(list hoon)]`: logical and.

## Expands to

*Pseudocode*: `a`, `b`, `c`, ... as elements of `p`:

```
?.(a | ?.(b | ?.(c | ?.(... ?.(z | &)))))
```

### Compiler macro

```
|-
?~  p
  &
?.  i.p
  |
$(p t.p)
```

## Syntax

Regular: *running*.

Irregular: `&(foo bar baz)` is `?&(foo bar baz)`.

## Examples

```
~zod:dojo> &(=(6 6) =(42 42))
%.y

~zod:dojo> &(=(6 7) =(42 43))
%.n
```
