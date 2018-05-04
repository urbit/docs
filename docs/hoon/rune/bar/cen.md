---
navhome: /docs/
next: true
sort: 1
title: |% "barcen"
---

# `|% "barcen"`

[%brcb p=(map term foot)]: Form a core `[battery payload]` with subject as the payload.

## Produces

A core with battery `p`.  Payload is the subject.

## Syntax

Regular: *battery*.

## Discussion

A core is like an "object" in a conventional language, but its
attributes (_arms_) are functions on the core, not the core and
an argument.  A "method" on a core is an arm producing a gate.

## Examples

A trivial core:

```
~zod:dojo> =foo  =+  x=58
                 |%
                 ++  n  (add 42 x)
                 ++  g  |=  b=@
                        (add b n)
                 --
~zod:dojo> n.foo
100
~zod:dojo> (g.foo 1)
101
```

