---
sort: 3
---

# `:pin, =+, "tislus", {$pin p/seed q/seed}`

Combine a new noun with the subject.

## Expands to

```
:per(:cons(p .) q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`:pin` is the simplest way of "declaring a variable."

## Examples
 
```
~zod:dojo> =foo  |=  a/@
                 =+  :name(b 1)
                 =+  c=2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```
