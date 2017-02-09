---
navhome: /docs/
sort: 3
---

# `:ifno  ?~  "wutsig"` 

`{$ifno p/wing q/seed r/seed}`: branch on whether a wing 
of the subject is null.
 
## Expands to

```
:if  :fits($~ p)
  q
r
```

```
?:(?=($~ p) q r)
```

## Syntax

Regular: *3-fixed*.

## Discussion

It's bad style to use `:ifno` to test for any zero atom.  Use it
only for a true null, `~`.

## Examples

```
~zod:dojo> =foo ""
~zod:dojo> :ifno(foo 1 2)
1
```

```
~zod:dojo> =foo ""
~zod:dojo> ?~(foo 1 2)
1
```
