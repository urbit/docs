---
navhome: /docs/
sort: 1
---

# `:fail  !!  "zapzap"`

`{$fail $~}`: crash.

## Produces

Nothing.  Always crashes, with span `%void`.

## Syntax

`!!`

## Discussion

`%void` nests in every other span, so you can stub out anything with `!!`.

## Examples

```
~zod:dojo> :fail
! exit
```

```
~zod:dojo> !!
! exit
```
