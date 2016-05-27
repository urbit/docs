---
navhome: /docs
sort: 2
---

# `:cast  ^-  "kethep"`

`{$cast p/moss q/seed}`: typecast by mold.

## Expands to

```
:like(:bunt(p) q)
```

## Syntax

Regular: *2-fixed*

## Discussion

It's a good practice to put a `:cast` at the top of every arm
(including gates, loops, etc).  This cast is strictly necessary
only in the presence of head recursion (otherwise you'll get a
`rest-loop` error, or if you really screw up spectacularly an 
infinite loop in the compiler).

## Examples

``
~zod:dojo> (add 90 7)
97
~zod:dojo> `@t`(add 90 7)
'a'
~zod:dojo> ^-(@t (add 90 7))
'a'
/~zod:dojo> =foo  |=  a/@tas
                  ^-  (unit @ta)
                  `a
/~zod:dojo> (foo 97)
[~ ~.a]
```
