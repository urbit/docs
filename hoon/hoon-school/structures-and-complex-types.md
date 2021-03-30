+++
title = "2.3 Structures and Complex Types"
weight = 27
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/structures-and-complex-types/"]
+++

In this lesson we'll talk a little about how type expressions become structures, and how these structures manifest in different ways in different parts of your Hoon code. We'll also talk about how to create your own custom-defined complex types from simpler ones.

## Structures

Attentive readers may remember that Hoon programs are made of expressions. By definition, an expression produces a value. We've talked about expressions for types such as `@`, `^`, `[? *]`, etc. What values do these subexpressions produce? The answer is that they produce a **structure**. But what are structures, and what role do they play in Hoon?

You don't actually need to know much about what a structure is in order to write Hoon programs that use the type system effectively. Accordingly, we'll save the particular details for a later lesson. Here we'll give only a sketch of the most important features.

### Cast Expressions

Structures play different roles in different code contexts. First, let's look at type expressions in casts:

```hoon
> ^-(@ 15)
15

> ^-(^ [15 17])
[15 17]

> ^-([? *] [%.y [15 17]])
[%.y [15 17]]
```

The `@`, `^`, and `[? *]` subexpressions have no effect on the overall value produced.

It's important to understand that these casts don't affect the [runtime](https://en.wikipedia.org/wiki/Run_time_%28program_lifecycle_phase%29) semantics of a program at all. They affect only the compiler behavior at compile-time. The compiler does these type-checks when compiling, but the resulting code has no value corresponding to the types above.

Accordingly, the structures produced by the type subexpressions above aren't part of the program's runtime semantics. They are compile-time values only.

### Type Example Values ('Bunt' Values)

In other cases, structures _can_ have an effect on runtime semantics. For example, consider the expression `|=(a=@ 15)`. This produces a [gate](/docs/glossary/gate/) that takes any [atom](/docs/glossary/atom/) as its sample and returns `15`.

The `@` subexpression of `|=(a=@ 15)` produces a structure at compile time. In the compiled program this structure is converted to a default value for the appropriate type, sometimes called an **example** value (or a **bunt** value).

```hoon
> |=(a=@ 15)
< 1.xqz
  { a/@
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> a:|=(a=@ 15)
0
```

As you can see, the example value for `@` is `0`. Example values are used as placeholder data for the gate's sample. You can prepend `*` to a type expression to see the default value of that type:

```hoon
> *^
[0 0]

> *?
%.y

> *@
0

> *@ux
0x0
```

### Molds

Structures can also become gates at runtime. To produce such a gate, use a type expression as a stand-alone expression in the dojo:

```hoon
> @
< 1.goa
  { *
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> ?
< 1.zgf
  { *
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> ^
< 1.ylu
  { *
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

In all three cases, the result of evaluation is a gate. For each, the head is a single [arm](/docs/glossary/arm/), signified by `1.xxx`. The sample -- i.e., the head of the tail -- in each case is of the type `*`. These gates are sometimes called **molds**.

Molds are gates with two special properties: (1) they are guaranteed to produce a value of the type indicated by the type expression, and (2) they are [idempotent](https://en.wikipedia.org/wiki/Idempotence). (A gate `i` is idempotent if and only if the result of applying `i` multiple times to a value produces the same result as applying it once. In other words, `(i val)` must produce the same result as `(i (i val))`.)

```hoon
> (@ 123)
123

> (@ (@ 123))
123

> (@ 'hello')
478.560.413.032

> (@t 'hello')
'hello'

> (^ [12 14])
[12 14]

> (^ (^ [12 14]))
[12 14]

> (? %.y)
%.y
```

But what if we call a mold with the 'wrong' type of sample? It will crash:

```hoon
> (@ [12 14])
ford: %ride failed to execute:
```

Molds are designed for data validation. We won't discuss that particular use case here.

## Constructing Complex Types

Up to this point we've only talked about relatively simple data types. You've seen (1) the basic types and (2) one way of combining basic types to make complex types. In the rest of this lesson you'll learn other ways to create custom data types in Hoon.

Let's review (1) and (2) briefly.

### Basic Types

The basic types of Hoon are: `*` for [nouns](/docs/glossary/noun/), `@` for atoms (possibly with aura information, e.g., `@ud` and `@sx`), `^` for cells, `?` for flags, and `~` for null. You can also make constant, one-value types by using `%` followed by a series of lowercase letters, the hyphen symbol `-`, and numbers. E.g., `%red`, `%2`, `%kebab-case123`. The lone values of these one-value types are sometimes called 'tags'.

Let's illustrate with the irregular `` ` ` `` cast syntax:

```hoon
> `%blah`%blah
%blah

> `%blah`%not-blah
nest-fail
```

### Complex Types

In certain parts of Hoon code (not all) you can define a complex cell type from simpler types using square brackets, `[ ]`. For some examples: `[@ ^]`, `[@ud @ub]`, `[@t [? ^]]`, `[%employee @t ? @]` etc.

```hoon
> `[@ud @ub]`[12 0b11]
[12 0b11]

> `[@ud @ub]`[12 14]
nest-fail

> `[%employee @t ? @]`[%employee 'Bob Smith' %.y 123]
[%employee 'Bob Smith' %.y 123]

> `[%employee @t ? @]`[%employer 'John Williams' %.n 321]
nest-fail
```

## Building Structures: The `$` Rune Family

The purpose of the `$` family of runes is to construct user-defined complex structures from simpler ones. Let's take a look at some of these runes and use them to make custom types.

### `$:` Build a Cell Structure

The `$:` takes two subexpressions, each of which must be a structure. The result is a cell structure whose head and tail are the two structures indicated. For example, the type defined by `$:(@ ?)` is the set of cells whose head is an atom, `@` and whose tail is a flag, `?`. Most of the time you can achieve the same result using square brackets: `[@ ?]`. (Most of the time, but not always!)

```hoon
> `$:(@ ?)`[123 %.y]
[123 %.y]

> `$:(@ ?)`[%.y 123]
nest-fail

> `$:(%yes ?)`[%yes %.n]
[%yes %.n]

> `$:(%yes ?)`[%no %.n]
nest-fail
```

#### Two Interpretations for `[@ ?]` (and Other Such Expressions)

Why are `$:(@ ?)` and `[@ ?]` the same only 'most of the time'? Why not always? The answer has to do with the way Hoon handles certain rune subexpressions. Some subexpressions are reserved exclusively for types. For example, the `^-` rune is always followed by two subexpressions, the first of which must indicate a type. Subexpressions reserved exclusively for types are interpreted as types. These subexpressions must **always** produce a single structure, at least as an intermediate piece of data at compile-time. When `[@ ?]` is interpreted by Hoon as indicating a type, the result is a structure equivalent to that of `$:(@ ?)`.

The first subexpression after the `|=` rune is also interpreted in the same way, i.e., as giving a type definition (in this case for the gate sample).

But expressions of Hoon that aren't exclusively for types interpret expressions such as `[@ ?]` differently, i.e., as a cell of structures. Interpreted in this way, `[@ ?]` isn't equivalent to `$:(@ ?)`.

`$:` expressions _always_ evaluate to a single structure, regardless of where they're located in the code. Expressions like `[@ ?]` are only understood as a single structure if it's a subexpression that must indicate a type; otherwise it's taken to be a pair of structures.

Here we can see the difference by noting how many molds each produces:

```hoon
> $:(@ ?)
< 1.igg
  { *
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> [@ ?]
[ < 1.goa
    { *
      {our/@p now/@da eny/@uvJ}
      <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
    }
  >
  < 1.zgf
    { *
      {our/@p now/@da eny/@uvJ}
      <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
    }
  >
]
```

You can force `[@ ?]` to be interpreted as a single mold by prepending it with `,`: `,[@ ?]`. However, there usually is no need for this.

```hoon
> ,[@ ?]
< 1.igg
  { *
    {our/@p now/@da eny/@uvJ}
    <19.arv 24.fmf 7.mpi 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

### `$-` Define a Gate Type

You can use `$-` to define a gate type. The `$-` rune takes two subexpressions, which correspond to the gate input type and output type, respectively. For example, if you want to cast for a gate that takes `@` and returns `@` when called, use `$-(@ @)`:

```hoon
> (`$-(@ @)`|=(@ `@`15) 12)
15

> (`$-(@ @)`|=(@ `*`15) 12)
nest-fail

> `$-(@ @)`add
nest-fail

> `$-([@ @] @)`add
<1|efh {{@ @} {@ @} @}>

> `$-([@ @] ?)`gte
<1|efh {{@ @} {@ @} ?($.n $.y)}>
```

### `$?` Define a Union

In set theory, the [union](https://en.wikipedia.org/wiki/Union_%28set_theory%29) of sets A and B is a set containing all members of both A and B. For example, the union of the set of even integers and the set of odd integers is the set of all integers.

It's useful to be able to define a type that is the union of other types. The `$?` rune lets us do this. The `$?` takes a series of subexpressions, each of which must be a structure. The resulting type is the union of all types indicated in the expression. For example, `$?(%green %yellow %red)` is the union of the types indicated by `%green`, `%yellow`, and `%red`.

```hoon
> `$?(%green %yellow %red)`%green
%green

> `$?(%green %yellow %red)`%yellow
%yellow

> `$?(%green %yellow %red)`%red
%red

> `$?(%green %yellow %red)`%blue
nest-fail
```

The irregular form of `$?` is just `?( )`:

```hoon
> `?(%green %yellow %red)`%green
%green

> `?(%green %yellow %red)`%yellow
%yellow
```

`$?` should only be used on types that are disjoint, i.e., which have no values in common. For example, it shouldn't be used on atom types differing only in aura.

```hoon
> `?(@ud @ux)`10
10

> `?(@ud @ux)`0x12
18
```

Notice that in the latter cast, the type of the literal `0x12` is ignored and the value is printed as `@ud`. To avoid this when using `$?`, make sure you use types with no values in common.

### `$%` Define a Tagged Union

A [tagged union](https://en.wikipedia.org/wiki/Tagged_union) is a structure corresponding to a union of tagged cell types. A tagged cell is a cell whose head is a tag, e.g., `[%employee name='John Smith' full-time=%.y]`. The type of this cell is `[%employee name=@t full-time=?]`, and you may want a union of this type and another tagged cell type, `[%customer name=@t]`. To construct such a type, use `$%`.

The `$%` rune takes a series of subexpressions, each of which must define a tagged cell type. The result is a tagged union. For example, we can make a tagged union of the tagged cell types above using `$%`. We'll store this structure using the dojo `=` operation (not a feature of Hoon):

```hoon
> =user $%([%employee name=@t full-time=?] [%customer name=@t])

> `user`[%employee 'John Smith' &]
[%employee name='John Smith' full-time=%.y]

> `user`[%employee 'Ryan Jones' |]
[%employee name='Ryan Jones' full-time=%.n]

> `user`[%customer 'Sally Williams']
[%customer name='Sally Williams']

> `user`[%burglar 'Hamburglar']
nest-fail
```

`$%` is especially useful when you need a composite type of various categories, each of which has a different structure. There is to be a unique tag for each category, which your Hoon program will use to determine how to handle the data appropriately.

### `$@` Define a Union of Atom and Cell Types

The `$@` rune takes two subexpressions. The first must be an atomic type, and the second must be a cell type. The result is a union.

Often `$@` is used to define a type with a null or trivial case for the `@` case. For example, we can expand the `user` structure using `$@` to give it a null case:

```hoon
> =user $@(~ $%([%employee name=@t full-time=?] [%customer name=@t]))

> `user`[%employee 'Ryan Jones' |]
[%employee name='Ryan Jones' full-time=%.n]

> `user`[%customer 'Sally Williams']
[%customer name='Sally Williams']

> `user`~
~
```

Now the `~` value is included as a possible value for `user`.

We will see types arise again, in the context of polymorphism in [Lesson 2.5](@/docs/hoon/hoon-school/type-polymorphism.md).
