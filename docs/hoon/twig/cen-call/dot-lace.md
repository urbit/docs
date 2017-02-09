---
navhome: /docs/
sort: 5
---

# `:lace  %.  "cendot"` 

`{$lace p/seed q/seed}`: call a gate (function), reversed.

## Expands to

```
:call(q p)
```

```
%-(q p)
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> =add-triple :gate({a/@ b/@ c/@} :(add a b c))
~zod:dojo> :lace([1 2 3] add-triple)
6
```

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %.([1 2 3] add-triple)
6
```

