+++
title = "Cells : ('col')"
weight = 9
template = "doc.html"
+++
The `:` ("col") expressions are used to produce cells, which are pairs of values.  E.g., `:-(p q)` produces the cell `[p q]`.  All `:` runes reduce to `:-`.

## Runes

### :_ "colcab"

`[%clcb p=hoon q=hoon]`; construct a cell, inverted.

##### Expands to

```hoon
:-(q p)
```

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> :_(1 2)
[2 1]
```

### :: "colcol"

Code comment

##### Syntax

::  any text you like!

##### Examples

```hoon
::
::  this is commented code
::
|=  a=@         ::  a gate
(add 2 a)       ::  that adds 2
                ::  to the input
```

### :- "colhep"

`[%clhp p=hoon q=hoon]`: construct a cell (2-tuple).

##### Produces

The cell of `p` and `q`.

##### Syntax

Regular: **2-fixed**.

Irregular: `[a b]` is `:-(a b)`.

Irregular: `[a b c]` is `[a [b c]]`.

Irregular: `a^b^c` is `[a b c]`.

Irregular: `a/b` is `[%a b]`.

Irregular: `` `a `` is `[~ a]`.

Irregular: `~[a b]` is `[a b ~]`.

Irregular: `[a b c]~` is `[[a b c] ~]`.

## Discussion

Hoon expressions actually use the same "autocons" pattern as Nock
formulas.  If you're assembling expressions (which usually only the
compiler does), `[a b]` is the same as `:-(a b)`.

##### Examples

```
~zod:dojo> :-(1 2)
[1 2

~zod:dojo> 1^2
[1 2]

~zod:dojo> 1/2
[%1 2]

~zod:dojo> `1
[~ 1]
```

### :^ "colket"

`[%clkt p=hoon q=hoon r=hoon s=hoon]`: construct a quadruple (4-tuple).

##### Expands to

```hoon
:-(p :-(q :-(r s)))
```

##### Syntax

Regular: **4-fixed**.

##### Examples

```
~zod:dojo> :^(1 2 3 4)
[1 2 3 4]

~zod:dojo> :^     5
                6
              7
            8
[5 6 7 8]
```

### :+ "collus"


`[%clls p=hoon q=hoon r=hoon]`: construct a triple (3-tuple).

##### Expands to:

```hoon
:-(p :-(q r))
```

##### Syntax

Regular: **3-fixed**.

##### Examples

```
/~zod:dojo> :+  1
              2
            3
[1 2 3]

~zod:dojo> :+(%a ~ 'b')
[%a ~ 'b']
```

### :~ "colsig"

`[%clsg p=(list hoon)]`: construct a null-terminated list.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `p`:

```hoon
:-(a :-(b :-(c :-(... :-(z ~)))))
```

##### Desugaring

```hoon
|-
?~  p
  ~
:-  i.p
$(p t.p)
```

##### Syntax

Regular: **running**.

##### Examples

```
~zod:dojo> :~(5 3 4 2 1)
[5 3 4 2 1 ~]

~zod:dojo> ~[5 3 4 2 1]
[5 3 4 2 1 ~]

~zod:dojo> :~  5
               3
               4
               2
               1
           ==
[5 3 4 2 1 ~]
```

### :* "coltar"

`[%cltr p=(list hoon)]`: construct an n-tuple.

##### Expands to

**Pseudocode**: `a`, `b`, `c`, ... as elements of `p`:

```hoon
:-(a :-(b :-(c :-(... z)))))
```

##### Desugaring

```hoon
|-
?~  p
  !!
?~  t.p
  i.p
:-  i.p
$(p t.p)
```

##### Syntax

Regular: **running**.

##### Examples

```
~zod:dojo> :*(5 3 4 1 4 9 0 ~ 'a')
[5 3 4 1 4 9 0 ~ 'a']

~zod:dojo> [5 3 4 1 4 9 0 ~ 'a']
[5 3 4 1 4 9 0 ~ 'a']

~zod:dojo> :*  5
                3
                4
                1
                4
                9
                0
                ~
                'a'
            ==
[5 3 4 1 4 9 0 ~ 'a']
```
