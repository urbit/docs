---
navhome: /docs/
sort: 7
---

# `:rev  =;  "tissem"`

`{$rev p/taco q/seed r/seed}`: combine a named and/or typed noun with the
subject, inverted.

## Expands to

```
:var(p r q)
```

```
=/(p r q)
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

```
~zod:dojo> =foo  |=  a/@
                 =/   b  1
                 =;   c/@  :(add a b c)
                 2
~zod:dojo> (foo 5)
8
```
