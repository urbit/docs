---
navhome: /docs/
sort: 3

---

# `:trap |.  "bardot"`

`{$trap p/seed}`: form a trap, a core with one arm `$`.

## Expands to

```
:core
++  $  p
--
```

```
|%  ++  $  p
--
```

## Syntax

Regular: *1-fixed*.

## Discussion

A trap is a deferred computation.

## Examples

A trivial trap:

```
~zod:dojo> =foo :trap(42)
~zod:dojo> :rap($ foo)
42
~zod:dojo> (foo)
42
```

```
~zod:dojo> =foo |.(42)
~zod:dojo> $:foo
42
~zod:dojo> (foo)
42
```

A more interesting trap:

```
~zod:dojo> =foo  :var  reps  10
                 :var  step  0
                 :var  outp  0
                 :trap
                 :if  =(step reps)
                   outp
                 :moar(outp (add outp 2), step +(step))
~zod:dojo> (foo)
20
```

```
~zod:dojo> =foo  =/  reps  10
                 =/  step  0
                 =/  outp  0
                 |.
                 ?:  =(step reps)
                   outp
                 $(outp (add outp 2), step +(step))
~zod:dojo> (foo)
20
```

Note that we can use `:moar()` or `$()` to recurse back into the
trap, since it's a core with an `$` arm.

> `:moar()` expands to `:make($)`, accepting a *jogging* body containing a list
> of changes to the subject.

> `$()` expands to `%=($)`, accepting a *jogging* body containing a
> list of changes to the subject.
