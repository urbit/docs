---
navhome: /docs
sort: 4

---

# `:loop  |-  "barhep"`

`{$loop p/seed}`: form a trap and kick it.

## Expands to

```
:rap  $
:core
++  $  p
--
``` 

## Syntax

Regular: *1-fixed*.

## Discussion

The `:loop` keyword (and `|-` rune) can be thought of as a "recursion point" -
since `:loop` makes a `:trap` (a core with one arm named `$`), we can recurse
back into it with `:moar()` or `$()`.

> `:moar()` expands to `:make($)` (`%=($)`), accepting a *jogging* body
> containing a list of changes to the subject.

## Examples

A trivial loop doesn't even recurse:

```
~zod:dojo> |-(42)
42
```

The classic loop is a decrement:

```
~zod:dojo> =foo  :var  a  42
                 :var  b  0
                 :loop
                 :if  =(a +(b))
                   b
                 :moar(b +(b))
~zod:dojo> foo
41
```
