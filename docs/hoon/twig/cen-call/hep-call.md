---
navhome: /docs/
sort: 4
---

# `:call  %-  "cenhep"`

`{$call p/seed q/seed}`: call a gate (function).

## Expands to

```
:open($ p q)
```

```
%~($ p q)
```

## Syntax

Regular: *2-fixed*.

Irregular: `(a)` is `$:a`; `(a b c d)` is `:call(a [b c d])`.

## Discussion

`$call` is a function call; `p` is the function (`gate`), `q` the
argument.  `$call` is a special case of `$open`, and a gate is a
special case of a door.

In a gate, the modified core has only one anonymous arm; in a
door it gets a full battery.  Intuitively, a gate defines one
algorithm it can compute upon its sample, `+6`. A door defines
many such algorithms.

In classical languages, doors correspond to groups of functions 
with the same argument list, or at least sharing a prefix.  In
Hoon, this shared sample is likely to be pulled into a door.

## Examples

```
~zod:dojo> =add-triple :gate({a/@ b/@ c/@} :(add a b c))
~zod:dojo> (add-triple 1 2 3)
6
~zod:dojo> :call(add-triple [1 2 3])
6
```

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> (add-triple 1 2 3)
6
~zod:dojo> %-(add-triple [1 2 3])
6
```

