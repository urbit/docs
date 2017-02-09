---
navhome: /docs/
sort: 4
---

# `:ifat  ?@  "wutpat"`

`{$ifat p/wing q/seed r/seed}`: branch on whether a wing 
of the subject is an atom.

## Expands to

```
:if  :fits(@ p)
  q
r
```

```
?:(?=(@ p) q r)
```

## Syntax

Regular: *3-fixed*.

## Examples

```
~zod:dojo> :ifat(0 1 2)
! mint-vain
! exit
~zod:dojo> :ifat(`*`0 1 2)
1
~zod:dojo> :ifat(`*`[1 2] 3 4)
4
```

```
~zod:dojo> ?@(0 1 2)
! mint-vain
! exit
~zod:dojo> ?@(`*`0 1 2)
1
~zod:dojo> ?@(`*`[1 2] 3 4)
4
```
