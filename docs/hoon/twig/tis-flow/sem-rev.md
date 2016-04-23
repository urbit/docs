---
sort: 7
---

# `:rev, =;, "tissem", {$rev p/taco q/seed r/seed}`

Combine a named and/or typed noun with the subject, inverted.

## Expands to

```
?@(p :pin(:name(p r) q) :pin(:cast(:(coat p) r) q)
```

## Syntax

Regular: *3-fixed*.

## Examples

```
~zod:dojo> =foo  :gate  a/@
                 :var   b  1
                 :rev   c/@  :(add a b c)
                 2
~zod:dojo> (foo 5)
8
```
