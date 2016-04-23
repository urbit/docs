---
sort: 2
---

# `:rap, =<, "tisgal", {$rap p/seed q/seed}`

Compose two twigs, inverted.

## Expands to

```
:per(q p)
```

## Syntax

Regular: *2-fixed*.

Irregular: `foo:bar` is `:rap(foo bar)`.

## Examples

```
~zod:dojo> b:[a=1 b=2 c=3]
2
~zod:dojo> [. .]:(add 2 4)
[6 6]
```
