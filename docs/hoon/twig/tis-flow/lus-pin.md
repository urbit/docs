---
navhome: /docs/
sort: 3
---

# `:pin  =+  "tislus"`

`{$pin p/seed q/seed}`: combine a new noun with the subject.

## Expands to

```
:per(:cons(p .) q)
```

```
=>([p .] q)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`:pin` is the simplest way of "declaring a variable."

## Examples
 
```
~zod:dojo> =foo  :gate  a/@
                 :pin  :name(b 1)
                 :pin  :name(c 2)
                 :(add a b c)
~zod:dojo> (foo 5)
8
```

```
~zod:dojo> =foo  |=  a/@
                 =+  b=1
                 =+  c=2
                 :(add a b c)
~zod:dojo> (foo 5)
8
```
