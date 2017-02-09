---
navhome: /docs/
sort: 1
---

# `:dump  ~&  "sigpam"`

`{$dump p/seed q/seed}`: debugging printf.

## Expands to

`q`.

## Convention

Prettyprints `p` on the console before computing `q`. 

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :dump('halp' ~)
'halp'
~
```

```
~zod:dojo> ~&('halp' ~)
'halp'
~
```
