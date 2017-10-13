---
navhome: /docs/
sort: 5
---

# `:new  =|  "tisbar"`

`{$new p/moss q/seed}`: combine a defaulted mold with the subject.

## Expands to

```
:pin(:bunt(p) q)
```

```
=+(*p q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`:new` "declares a variable" which is "uninitialized," presumably 
because you'll set it in a loop or similar.

A common mistake is to forget that since `p` is moldy,
`:new(foo=@ bar)` is wrong; you mean `:new(foo/@ bar)`, since
`foo=@` is `:name(foo @)` (putting a face on a seed) and `foo/@`
is `:coat(foo @)` (wrapping a face around a mold).

## Examples

```
~zod:dojo> =foo  :gate  a/@
                 :new  b/@
                 :nip  :(add a b c)
                 c=2 
~zod:dojo> (foo 5)
7
```

```
~zod:dojo> =foo  |=  a/@
                 =|  b/@
                 =-  :(add a b c)
                 c=2 
~zod:dojo> (foo 5)
7
```
