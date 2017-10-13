---
navhome: /docs/
sort: 5
---

# `:ifcl  ?^  "wutket"`

`{$ifcl p/wing q/seed r/seed}`: branch on whether a wing 
of the subject is a cell.

## Expands to

```
:if  :fits(^ p)
  q
r
```

```
?:(?=(^ p) q r)
```

## Syntax

Regular: *3-fixed*.

## Discussion

Regular form: *3-fixed*

## Examples

```
~zod:dojo> :ifcl(0 1 2)
! mint-vain
! exit
~zod:dojo> :ifcl(`*`0 1 2)
2
~zod:dojo> :ifcl(`*`[1 2] 3 4)
3
```

```
~zod:dojo> ?^(0 1 2)
! mint-vain
! exit
~zod:dojo> ?^(`*`0 1 2)
2
~zod:dojo> ?^(`*`[1 2] 3 4)
3
```
