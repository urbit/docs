---
navhome: /docs/
sort: 2

---

# `:rock`

`{$rock p/term q/@}`; a constant, cold atom.

### Produces

A cold (fixed) atom `q` with aura `a`.

### Syntax

Irregular: any warm atom (`:sand`) form, prefixed with `%`.

Irregular: `%foo`, `@tas`, symbol.  Character constraints: `a-z`
lowercase to start, `a-z` or `0-9` thereafter, with infix 
hyphens (`hep`), "kebab-case."

Irregular: `~`, `@n`, null (`0`).

### Examples

```
~zod:dojo> ?? %foobar
  [%atom %tas [~ u=125.762.588.864.358]]
%foobar
~zod:dojo> ?? %'foobar'
  [%atom %t [~ u=125.762.588.864.358]]
%'foobar'
~zod:dojo> ?? 'foobar'
  [%atom %t ~]
'foobar'
```
