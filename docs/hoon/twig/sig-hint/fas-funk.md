---
navhome: /docs/
sort: 11
---

# `:funk  ~/  "sigfas"`

`{$funk p/term q/seed}`: jet registration for gate with
registered context.

## Expands to

```
:fast(p +7 ~ q)
```

```
~%(p +7 ~ q)
```

## Syntax

Regular: *2-fixed*.

## Examples

From the kernel: 
```
++  add
  ~/  %add
  |=  {a/@ b/@}
  ^-  @
  ?:  =(0 a)  b
  $(a (dec a), b +(b))
```
