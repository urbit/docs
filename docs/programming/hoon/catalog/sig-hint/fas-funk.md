---
sort: 1

# `:funk ~/ "sigfas" {$funk p/term q/twig}` 

Jet hint for a gate whose context is a registered core.

## Expands to

```
:fast(p +7 ~ q)
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
