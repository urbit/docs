+++
title = "Arms + ('lus')"
weight = 8
template = "doc.html"
+++
A core is a cell of `[battery payload]`.  The battery is made of one or more arms, each of which is a computation on its parent core.

Arm runes are used to define arms in a core, and thus can only be used from within an expression that produces a multi-arm core.  That means arm runes cannot be used to mark the beginning of a first-class expression -- there is no such thing in Hoon as an arm without a core.

There are various arm runes you can use to produce different kinds of arms.  Normal arms use `++`; arms defining a structure (or 'mold') use `+$`; and constructor arms use `+*`.

## Runes

### +| "lusbar"

Chapter label.

##### Syntax

Regular: **1-fixed**.

```hoon
+|  %label
```

##### Discussion

The `+|` doesn't produce an arm.  It instead provides a label for the arms that follow it.  The arms of a core can be divided into **chapters** for 'organization'.  Chapter labels aren't part of the underlying noun of the core; they're stored as type system metadata only.

See `tome` in the Hoon standard library.

##### Examples

Let's look at what the Hoon compiler's parser, `ream`, does with the `+|` rune:

```
> (ream '|%  +|  %numbers  ++  two  2  ++  three  3  --')
[ %brcn
  p=~
    q
  { [ p=%numbers
      q=[p=~ q={[p=%three q=[%sand p=%ud q=3]] [p=%two q=[%sand p=%ud q=2]]}]
    ]
  }
]
```

Notice that `p.q` has the label `%numbers`.  Contrast with:

```
> (ream '|%  ++  two  2  ++  three  3  --')
[ %brcn
  p=~
    q
  { [ p=%$
      q=[p=~ q={[p=%three q=[%sand p=%ud q=3]] [p=%two q=[%sand p=%ud q=2]]}]
    ]
  }
]
```

### +$ "lusbuc"

Produce a structure arm (type definition).

##### Syntax

Regular: **2-fixed**.

```hoon
+$  p=term  q=spec
```

`p` is an arm name, and `q` is any structure expression.

##### Discussion

Arms produced by `+$` are essentially type definitions.  They should be used when one wants to define custom types using core arms.

The Hoon subexpression, `q`, must be a structure expression.  That is, it must be either a basic structure expression (`*`, `~`, `^`, `?`, and `@`), or a complex expression made with the `$` family of runes (including irregular variants).  Names of structures are also permitted (e.g., `tape`).

##### Examples

```
> =c |%
       +$  atom-pair  $:(@ @)
       +$  flag-atom  $:(? @)
     --

> `atom-pair.c`[12 14]
[12 14]

> `atom-pair.c`[12 [22 33]]
nest-fail

> `flag-atom.c`[& 22]
[%.y 22]
```

### ++ "luslus"

Produce a normal arm.

##### Syntax

Regular: **2-fixed**.

```hoon
++  p=term  q=hoon
```

`p` is the arm name, and `q` is any Hoon expression.

##### Discussion

All arms must have a name (e.g., `add`).  An arm is computed by name resolution.  (This resolution is implicit in the case of `$` arms.  See `|=`, `|-`, and `|^`.)  The `++` rune is used for explicitly giving a name to an arm.

Any Hoon expression, `q`, may be used to define the arm computation.

##### Examples

```
> =c |%
       ++  two  2
       ++  increment  |=(a=@ +(a))
     --

> two.c
2

> (increment.c 11)
12
```

### +* "lustar"


Produce a type constructor arm.

##### Syntax

Regular: **2-fixed**.

```hoon
+*  p=term  [q=term]  r=spec
```

`p` is the arm name, `q` is the name of the argument for the constructor function enclosed in square brackets, and `r` is a structure expression that defines the constructor function.

##### Discussion

Arms produced by `+*` are essentially type constructors.  They are used to construct new types from ones you already have.  Consider `list`, which takes some type -- e.g., `@`, `tape`, etc. -- and returns a new type, e.g., `(list @)`, `(list tape)`, etc.

The Hoon subexpression, `r`, must be a structure expression.  That is, it must be either a basic structure expression (`*`, `~`, `^`, `?`, and `@`), or a complex expression made with the `$` family of runes (including irregular variants).

##### Examples

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
