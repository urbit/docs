---
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
