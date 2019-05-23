+++
title = "Casts"
weight = 11
template = "doc.html"
+++
[`^-` ("kethep")](#kethep), [`^+` ("ketlus")](#ketlus), and
[`^=` ("kettis")](#kettis) let us adjust types without violating type
constraints.

The `nest` algorithm which tests subtyping is conservative;
it never allows invalid nests, it sometimes rejects valid nests.

## Runes

### ^| "ketbar"

`[%ktbr p=hoon]`: convert a gold core to an iron core (contravariant).

##### Produces

`p` as an iron core; crash if not a gold core.

##### Syntax

Regular: **1-fixed**.

##### Discussion

An iron core is an opaque function (gate or door).

Theorem: if type `x` nests within type `a`, and type `y` nests
within type `b`, a core accepting `b` and producing `x` nests
within a iron core accepting `y` and producing `a`.

Informally, a function fits an interface if the function has a
more specific result and/or a less specific argument than the
interface.

##### Examples

The prettyprinter shows the core metal (`.` gold, `|` iron):

```
~zod:dojo> |=(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>

~zod:dojo> ^|(|=(@ 1))
<1|gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```

### "ketcol"

`[%ktcl p=spec]`: 'factory' gate for type `p`.

##### Produces

A gate that returns the sample value if it's of the correct type, but crashes otherwise.

##### Syntax

Regular: **1-fixed**.

##### Discussion

In older versions of Hoon, a 'mold' was an idempotent gate that was guaranteed to produce a noun of that type.  If an input value wasn't of the correct type, the bunt value of that type was returned.  (See `^*`.)

`^:` is used to produce a gate that is much like a mold, except that instead of producing a bunt value when the input value is of the wrong type, it crashes.

##### Examples

```
> ^:  @
< 1.goa
  { *
    {our/@p now/@da eny/@uvJ}
    <19.hqf 23.byz 5.mzd 36.apb 119.zmz 238.ipu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> (^:(@) 22)
22

> (^:(@) [22 33])
ford: %ride failed to execute:
```

### ^. "ketdot"

`[%ktdt p=hoon q=hoon]`: typecast on value produced by passing `q` to `p`.

##### Expands to

```
^+(%:(p q) q)
```

##### Syntax

Regular: **2-fixed**.

```
^.  p=hoon  q=hoon
```

##### Discussion

`p` produces a gate and q is any Hoon expression.

`^.` is particularly useful when `p` is a gate that 'cleans up' the type information about some piece of data.  For example, `limo` is used to turn a raw noun of the appropriate shape into a genuine list.  Hence we can use `^.` to cast with `limo` and similar gates, ensuring that the product has the desired type.

##### Examples

```
> =mylist [11 22 33 ~]

> ?~(mylist ~ i.mylist)
mint-vain

> =mylist ^.(limo mylist)

> ?~(mylist ~ i.mylist)
11

> ?~(mylist ~ t.mylist)
~[22 33]
```

### ^- "kethep"

`[%kthp p=spec q=hoon]`: typecast by explicit type label.

##### Expands to

```
^+(^*(p) q)
```

##### Syntax

Regular: **2-fixed**.

Irregular: `` `foo`baz`` is `^-(foo baz)`.

##### Discussion

It's a good practice to put a `^-` ("kethep") at the top of every arm
(including gates, loops, etc).  This cast is strictly necessary
only in the presence of head recursion (otherwise you'll get a
`rest-loop` error, or if you really screw up spectacularly an
infinite loop in the compiler).

##### Examples

```
~zod:dojo> (add 90 7)
97

~zod:dojo> `@t`(add 90 7)
'a'

~zod:dojo> ^-(@t (add 90 7))
'a'

/~zod:dojo> =foo  |=  a=@tas
                  ^-  (unit @ta)
                  `a

/~zod:dojo> (foo 97)
[~ ~.a]
```

### ^+ "ketlus"

`[%ktls p=hoon q=hoon]`: typecast by inferred type.

##### Produces

The value of `q` with the type of `p`, if the type of `q` nests within the type of `p`.  Otherwise, `nest-fail`.

##### Syntax

Regular: **2-fixed**.

##### Examples

```
~zod:dojo> ^+('text' %a)
'a'
```

### ^& "ketpad"

`[%ktpd p=hoon]`: convert a core to a zinc core (covariant).

##### Produces

`p` as a zinc core; crash if `p` isn't a gold or zinc core.

##### Syntax

Regular: **1-fixed**.

##### Discussion

A zinc core has a read-only sample and an opaque context.  See [Advanced types](./docs/reference/hoon-expressions/advanced.md).

##### Examples

The prettyprinter shows the core metal in the arm labels `1.xoz` and `1&xoz` below (`.` is gold, `&` is zinc):

```
> |=(@ 1)
< 1.xoz
  { @
    {our/@p now/@da eny/@uvJ}
    <19.hqf 23.byz 5.mzd 36.apb 119.zmz 238.ipu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> ^&(|=(@ 1))
< 1&xoz
  { @
    {our/@p now/@da eny/@uvJ}
    <19.hqf 23.byz 5.mzd 36.apb 119.zmz 238.ipu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>
```

You can read from the sample of a zinc core, but not change it:

```
> =mycore ^&(|=(a=@ 1))

> a.mycore
0

> mycore(a 22)
-tack.a
-find.a
ford: %slim failed:
ford: %ride failed to compute type:
```

### ^~ "ketsig"

`[%ktsg p=hoon]`: fold constant at compile time.

##### Produces

`p`, folded as a constant if possible.

##### Syntax

Regular: **1-fixed**.

##### Examples

```
~zod:dojo> (make '|-(42)')
[%8 p=[%1 p=[1 42]] q=[%9 p=2 q=[%0 p=1]]]

~zod:dojo> (make '^~(|-(42))')
[%1 p=42]
```

### ^* "kettar"

`[%kttr p=spec]`: Produce example type value.

##### Produces

A default value (i.e., 'bunt value') of the type `p`.

##### Syntax

Regular: **1-fixed**.

```
^*  p=spec
```

Irregular: `*p`.

`p` is any structure expression.

##### Examples

Regular:

```
> ^*  @
0

> ^*  %baz
%baz

> ^*  ^
[0 0]

> ^*  ?
%.y
```

Irregular:

```
> *@
0

> *^
[0 0]

> *tape
""
```

### ^= "kettis"

`[%ktts p=skin q=hoon]`: Bind name to a value.

##### Produces

If `p` is a term, the product `q` with type `[%face p q]`.  `p`
may also be a tuple of terms, or a term-skin pair; the type of
`q` must divide evenly into cells to match it.

##### Syntax

Regular: **2-fixed**.

Irregular: `foo=baz` is `^=(foo baz)`.

##### Examples

```
~zod:dojo> a=1
a=1

~zod:dojo> ^=  a
           1
a=1

~zod:dojo> ^=(a 1)
a=1

~zod:dojo> [b c d]=[1 2 3 4]
[b=1 c=2 d=[3 4]]

~zod:dojo> [b c d=[x y]]=[1 2 3 4]
[b=1 c=2 d=[x=3 y4]]
```

### ^? "ketwut"

`[%ktwt p=hoon]`: convert any core to a lead core (bivariant).

##### Produces

`p` as a lead core; crash if not a core.

##### Syntax

Regular: **1-fixed**.

##### Discussion

A lead core is an opaque generator; the payload can't be read or
written.

Theorem: if type `x` nests within type `a`, a lead core producing
`x` nests within a lead core producing `a`.

Informally, a more specific generator can be used as a less
specific generator.

##### Examples

The prettyprinter shows the core metal (`.` gold, `?` lead):

```
~zod:dojo> |=(@ 1)
<1.gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>

~zod:dojo> ^?(|=(@ 1))
<1?gcq [@  @n <250.yur 41.wda 374.hzt 100.kzl 1.ypj %151>]>
```
