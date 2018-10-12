:-  :~  navhome/'/docs/'
        next/'true'
        sort/'3'
        title/'+* "lustar"'
    ==
;>

# `+* "lustar"`

Produce a type constructor arm.

## Syntax

Regular: *2-fixed*.

```
+*  p=term  [q=term]  r=spec
```

`p` is the arm name, `q` is the name of the argument for the constructor function enclosed in square brackets, and `r` is a structure expression that defines the constructor function.

## Discussion

Arms produced by `+*` are essentially type constructors.  They are used to construct new types from ones you already have.  Consider `list`, which takes some type -- e.g., `@`, `tape`, etc. -- and returns a new type, e.g., `(list @)`, `(list tape)`, etc.

The Hoon subexpression, `r`, must be a structure expression.  That is, it must be either a basic structure expression (`*`, `~`, `^`, `?`, and `@`), or a complex expression made with the `$` family of runes (including irregular variants).

## Examples

```
> =c |%
       +*  triple  [a]  [a a a]
       +*  wrap-flag  [a]  [? a]
     --

> `(triple.c @)`[12 14 16]
[12 14 16]

> `(triple.c ?)`[12 14 16]
nest-fail

> `(triple.c ?)`[& | |]
[%.y %.n %.n]

> `(wrap-flag.c @)`[& 22]
[%.y 22]
```
