---
navhome: /docs/
sort: 11
---

# `:aka  =* "tistar"`

`{$aka p/term q/seed r/seed}`: define an alias.

## Produces

`r`, compiled with a subject in which `p` is aliased to `q`.

## Syntax

Regular: *3-fixed*.

## Discussion

The difference between aliasing and pinning is that the subject
noun stays the same; the alias is just recorded in its span.
`q` is calculated every time you use the `p` alias, of course.

## Examples

```
~zod:dojo>
    :pin  a=1
    :aka  b  a
    [a b]
[1 1]
~zod:dojo>
    :pin  a=1
    :aka  b  a
    :set  a  2
    [a b]
[2 2]
```

```
~zod:dojo>
    =+  a=1
    =*  b  a
    [a b]
[1 1]
~zod:dojo>
    =+  a=1
    =*  b  a
    =.  a  2
    [a b]
[2 2]
```
