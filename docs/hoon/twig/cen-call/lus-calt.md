---
navhome: /docs/
sort: 6
---

# `:calt  %+  "cenlus"` 

`{$calt p/seed q/seed r/seed}`: call with pair sample.

## Expands to

```
:call(p [q r])
```

```
%-(p [q r])
```

## Syntax

Regular: *3-fixed*.

## Examples

```
~zod:dojo> =add-triple :gate({a/@ b/@ c/@} :(add a b c))
~zod:dojo> :calt(add-triple 1 [2 3])
6
```

```
~zod:dojo> =add-triple |=({a/@ b/@ c/@} :(add a b c))
~zod:dojo> %+(add-triple 1 [2 3])
6
```
