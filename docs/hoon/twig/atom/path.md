---
navhome: /docs/
sort: 4
---

# `:path`

`{$path p/(list (each @ta seed))}`: path with interpolation.

### Produces

A null-terminated list if  of the items in `p`, which are either constant
`@ta` atoms (`knot`), or twigs producing a `knot`.

### Syntax

Irregular: `/foo/bar/baz`.

Irregular: `"foo{(weld "moo" "baz")}bar"`.

### Examples

```
~zod/dojo> /foo/bar/baz
/foo/bar/baz
~zod/dojo> /foo/[`@ta`(cat 3 %moo %bar)]/baz
/foo/moobar/baz/
~zod:dojo> /
~
```
