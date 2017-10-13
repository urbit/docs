---
navhome: /docs/
sort: 5

---

# `:claw  $@  "bucpat"`

`{$claw p/moss q/moss}`: mold which normalizes a union tagged by depth.
  
## Normalizes to

Default, if the sample is an atom; `p`, if the head of the sample
is an atom; `q` otherwise.

## Defaults to

The default of `p`.

## Syntax

Regular: *2-fixed*.

Product: a mold which applies `p` if its sample is an atom, 
`q` if its sample is a cell.

Regular form: *2-fixed*.

Example:
```
~zod:dojo> =a :claw($foo :bank(p/$bar q/@ud))

~zod:dojo> (a %foo)
%foo

~zod:dojo> `a`[%bar 99]
[p=%bar q=99]

~zod:dojo> $:a
[%foo p=0 q=0]
```

```
~zod:dojo> =a $@($foo $:(p/$bar q/@ud))

~zod:dojo> (a %foo)
%foo

~zod:dojo> `a`[%bar 99]
[p=%bar q=99]

~zod:dojo> $:a
[%foo p=0 q=0]
```
