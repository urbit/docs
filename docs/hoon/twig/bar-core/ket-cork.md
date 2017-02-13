---
navhome: /docs
sort: 7

---

# `:cork  |^  "barket"`

`{$cork p/twig q/(map term foot)}`: form a core with battery and
anonymous arm `$` and kick it. 

## Expands to

```
:per  :core
      ++  $  p
      q
      --
$
```

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
~zod:dojo> :cork
           (add n g)
           ++  n  42
           ++  g  58
           --
```

```
~zod:dojo> |^
           (add n g)
           ++  n  42
           ++  g  58
           --
100
```

