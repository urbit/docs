---
navhome: /docs/
sort: 4
---

# `:nip  =-  "tishep"`

`{$nip p/seed q/seed}`: combine a new noun with the subject, inverted.

## Expands to

```
:per(:cons(q .) p)
```

```
=>([q .] p)
```

## Syntax

Regular: *2-fixed*.

## Discussion

`:nip` looks better than `:pin` when the twig you're pinning 
is much smaller than the twig that uses it.

## Examples
 
```
~zod:dojo> =foo  :gate  a/@
                 :pin  :name(b 1)
                 :nip  :(add a b c)
                 c=2 
~zod:dojo> (foo 5)
8
```

```
~zod:dojo> =foo  |=  a/@
                 =+  b=1)
                 =-  (add a b c)
                 c=2 
~zod:dojo> (foo 5)
8
```
