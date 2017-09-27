---
navhome: /docs/
sort: 6
---

# `:gill  |*  "bartar"` 

`{$gill p/moss q/seed}`: form a gill, a wet one-armed 
core with sample.

## Expands to

```
:new  p
:core
+-  $
  q
--
```

```
=|  p
|%
+-  $
  q
--
```

## Syntax

Regular: *2-fixed*.

## Discussion

In a normal (dry) gate, your argument is converted into the
sample type.  In a generic (wet) gate or gill, your argument type
passes through the function, rather as if it was a macro (there
is still only one copy of the code, however).

Genericity is a powerful and dangerous tool.  Use gills only if
you think you know what you're doing. 

Just as with a `:gate`, we can recurse back into a `:gill` with `:moar()` or `$()`.

> `:moar()` expands to `:make($)`, accepting a *jogging* body containing a list
> of changes to the subject.

> `$()` expands to `%=($)`, accepting a *jogging* body containing a
> list of changes to the subject.

## Examples

Wet and dry gates in a nutshell:

```
~zod:dojo> =foo :gate({a/* b/*} [b a])
~zod:dojo> =bar :gill({a/* b/*} [b a])
~zod:dojo> (foo %cat %dog)
[6.778.724 7.627.107]
~zod:dojo> (bar %cat %dog)
[%dog %cat]
```

```
~zod:dojo> =foo |=({a/* b/*} [b a])
~zod:dojo> =bar |*({a/* b/*} [b a])
~zod:dojo> (foo %cat %dog)
[6.778.724 7.627.107]
~zod:dojo> (bar %cat %dog)
[%dog %cat]
```

The dry gate does not preserve the span of `a` and `b`; the wet
gate does.
