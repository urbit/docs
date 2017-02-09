---
navhome: /docs/
sort: 9
---

# `:peep  ~!  "sigzap"` 

`{$peep p/seed q/seed}`: print type on compilation fail.

## Expands to

`q`.

## Convention

If compilation of `q` fails, prints the span of `p` in the trace.

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> a
! -find.a
~zod:dojo> :peep('foo' a)
! @t
! find.a
```

```
~zod:dojo> a
! -find.a
~zod:dojo> ~!('foo' a)
! @t
! find.a
```
