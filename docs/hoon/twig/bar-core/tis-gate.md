---
navhome: /docs/
sort: 2

---

# `:gate  |=  "bartis"` 

`{$gate p/moss q/seed}`: form a gate, a dry one-armed core with sample.

## Expands to

```
:new  p
:core
++  $
  q
--
```

```
=|  p
|%  ++  $  q
--
```

## Syntax

Regular: *2-fixed*.

## Discussion

A gate is a core with one arm named `$`, so, just as with `:loop` (`|-`),
we can recurse back into it with `:moar()` or `$()`.


> `:moar()` expands to `:make($)`, accepting a *jogging* body containing a list
> of changes to the subject.

> `$()` expands to `%=($)`, accepting a *jogging* body containing a
> list of changes to the subject.

## Examples

A trivial gate:

```
~zod:dojo> =foo :gate(a/@ +(a))
~zod:dojo> (foo 20)
21
```

```
~zod:dojo> =foo |=(a/@ +(a))
~zod:dojo> (foo 20)
21
```

A slightly less trivial gate:

```
~zod:dojo> =foo  :gate  {a/@ b/@}
                 (add a b)
~zod:dojo> :call(foo [20 400])
420
```

```
~zod:dojo> =foo  |=  {a/@ b/@}
                 (add a b)
~zod:dojo> (foo 20 400)
420
```
