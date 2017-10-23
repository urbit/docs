---
navhome: /docs
sort: 7
title: |^  "barket"
---

# `|^  "barket"`

`{$brkt p/twig q/(map term foot)}`: form a core with battery and
anonymous arm `$` and kick it. 

## Expands to

```
=>  |%
    ++  $  p
    q
    --
$
```

## Syntax

Regular: *1-fixed*, then *battery*.

## Examples

A trivial cork:

```
~zod:dojo> |^
           (add n g)
           ++  n  42
           ++  g  58
           --
100
```

