---
navhome: /docs/
sort: 7
---

# `:calq  %^  "cenket"` 

`{$calq p/seed q/seed r/seed s/seed}`: call with triple sample.

## Expands to

```
:call(p [q r s])
```

```
%-(p [q r s])
```

## Syntax

Regular: *4-fixed*.

## Examples

```
~zod:dojo> =add-triple :gate({a/@ b/@ c/@} :(add a b c))
~zod:dojo> :calq(add-triple 1 2 3)
6
```

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %^(add-triple 1 2 3)
6
```
