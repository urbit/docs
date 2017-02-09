---
navhome: /docs/
sort: 2
---

# `:cont  :+  "collus"`

`{$cont p/seed q/seed r/seed}`: construct a triple (3-tuple).

## Expands to:

```
:cons(p :cons(q r))
```

```
:-(p :-(q r))
```

## Syntax

Regular: *3-fixed*.

## Examples

```
/~zod:dojo> :cont  1
              2
            3
[1 2 3]
/~zod:dojo> :cont(%a ~ 'b')
[%a ~ 'b']
```

```
/~zod:dojo> :+  1
              2
            3
[1 2 3]
/~zod:dojo> :+(%a ~ 'b')
[%a ~ 'b']
```
