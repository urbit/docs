---
navhome: /docs/
sort: 4
---

# `:need  !?  "zapwut"`

`{$need p/@ q/seed}`: restrict Hoon version.

## Produces

`q`, if `p` is greater than or equal to the Hoon kelvin version.
(Versions count down; the current version is 150.)

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> :need(264 (add 2 2))
4
~zod:dojo> :need(164 (add 2 2))
4
~zod:dojo> :need(64 (add 2 2))
! exit
```

```
~zod:dojo> !?(264 (add 2 2))
4
~zod:dojo> !?(164 (add 2 2))
4
~zod:dojo> !?(64 (add 2 2))
! exit
```
