+++
title = "2.5 Type Polymorphism"
weight = 31
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/type-polymorphism/"]
+++

There are many cases in which one may want to write a function that accepts as input various different types of data.  Such a function is said to be [polymorphic](https://en.wikipedia.org/wiki/Polymorphism_%28computer_science%29).  ("Polymorphism" = "many forms"; so polymorphic functions accept many forms of data as input.)

One relatively trivial form of polymorphism involves sub-typing.  A [gate](/docs/glossary/gate/) whose sample is a raw `noun` can accept any Hoon data structure as input -- it's just that the sample will only be treated as a raw [noun](/docs/glossary/noun/).  For example, consider the `copy` [gate](/docs/glossary/gate/) below:

```
> =copy |=(a=* [a a])

> (copy 15)
[15 15]

> (copy [15 16])
[[15 16] [15 16]]

> (copy "Hello!")
[[72 101 108 108 111 33 0] [72 101 108 108 111 33 0]]
```

`copy` takes the input, `a`, and returns a cell of `[a a]`.  Because every piece of Hoon data is a [noun](/docs/glossary/noun/), anything can be taken as input.  Every other type in Hoon is a sub-type of `noun`.  But the output of `copy` is always going to be just a cell of [noun](/docs/glossary/noun/); the type information of the original input value is not preserved by the [gates](/docs/glossary/gate/).  Consider the `tape` in the last example: `"Hello!"` was pretty-printed in the dojo as a raw [noun](/docs/glossary/noun/), not as a string.  So `copy` is a relatively uninteresting polymorphic function.

In this lesson we'll go over Hoon's support for more interesting polymorphic functions.

## Polymorphic Properties of Cores

Hoon supports type polymorphism at the [core](/docs/glossary/core/) level.  That is, each [core](/docs/glossary/core/) has certain polymorphic properties that are tracked and maintained as metadata by Hoon's type system.  (See `+$  type` of `hoon.hoon`.)  These properties determine the extent to which a [core](/docs/glossary/core/) can be used as an interface for values of various types.

This is rather vaguely put so far.  We can clarify by talking more specifically about the kinds of polymorphism supported in Hoon.  There are two kinds of type polymorphism for [cores](/docs/glossary/core/): [genericity](https://en.wikipedia.org/wiki/Generic_programming), to include certain kinds of [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism); and [variance polymorphism](https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29), which involves making use of special sub-typing rules for [cores](/docs/glossary/core/).

If you don't understand these very well, that's okay.  We'll explain them.  Let's begin with the former.

## Dry vs. Wet Cores

To review briefly, a **core** is a pair of `[battery [payload](/docs/glossary/payload/)]`.  The **battery** contains the various [arms](/docs/glossary/arm/) of the [core](/docs/glossary/core/) (code), and the **payload** contains all the data needed to evaluate those [arms](/docs/glossary/arm/) correctly (data).  Every [arm](/docs/glossary/arm/) is evaluated with its parent [core](/docs/glossary/core/) as the subject.  A **gate** (i.e., a Hoon function) is a [core](/docs/glossary/core/) with exactly one [arm](/docs/glossary/arm/) named `$` and with a [payload](/docs/glossary/payload/) of the form: `[sample context]`.  The **sample** is reserved for the function's argument value, and the **context** is any other data needed to evaluate `$` correctly.

There are two kinds of [cores](/docs/glossary/core/): **dry** and **wet**.  Dry [cores](/docs/glossary/core/), which are more typical, _don't_ make use of **genericity**.  Wet [cores](/docs/glossary/core/) do.  In order to understand generic functions in Hoon, you have to understand the difference between dry and wet [cores](/docs/glossary/core/).

The [cores](/docs/glossary/core/) produced with the `|=`, `|-`, `|%`, and `|_` runes, among others, are all dry.  The [cores](/docs/glossary/core/) produced with the `|*` and `|@` runes are wet.  (`|*` and `|@` are the wet versions of `|=` and `|%`, respectively.)

Briefly, the difference between dry and wet [cores](/docs/glossary/core/) has to do with how they're treated at compile time, for type inference and type checking.  During the type check, the product type of each [arm](/docs/glossary/arm/) is inferred.  For computing a dry [arm](/docs/glossary/arm/) type, it's assumed that the [arm's](/docs/glossary/arm/) subject type is of the original parent [core](/docs/glossary/core/).  For computing a wet [arm](/docs/glossary/arm/) type, the parent [core](/docs/glossary/core/) type is used, except that the [payload](/docs/glossary/payload/) value may vary from the original type.

Because of this, wet gates can be used as functions that take different input types at different call sites.  We'll go over the dry/wet distinction in more detail below and explain why it matters.

### Dry Cores

A [core's](/docs/glossary/core/) [payload](/docs/glossary/payload/) can change from its original value.  In fact, this happens in the typical function call -- the default sample is replaced with an input value.  How can we ensure that the [core's](/docs/glossary/core/) [arms](/docs/glossary/arm/) are able to run correctly, that the [payload](/docs/glossary/payload/) type is still appropriate despite whatever changes it has undergone?

There is a type check for each [arm](/docs/glossary/arm/) of a dry [core](/docs/glossary/core/), intended to verify that the [arm's](/docs/glossary/arm/) parent [core](/docs/glossary/core/) has a [payload](/docs/glossary/payload/) of the correct type.  In this section we'll describe that type check, starting with typical [gate](/docs/glossary/gate/) usage.

When the `$` [arm](/docs/glossary/arm/) of a dry [gate](/docs/glossary/gate/) is evaluated it takes its parent [core](/docs/glossary/core/) -- the dry [gate](/docs/glossary/gate/) itself -- as the subject, often with a modified sample _value_.  But any change in sample _type_ should be conservative; the modified sample value must be of the same type as the default sample value (or possibly a subtype).  When the `$` [arm](/docs/glossary/arm/) is evaluated it should have a subject of a type it knows how to use.

For illustration, consider the [gate](/docs/glossary/gate/) created by `add`, a function in the Hoon standard library.  The structure of the `add` [gate](/docs/glossary/gate/) is as follows:

```
       add
      /   \
     $     .
          / \
    sample   context
```

The `add` code depends on the fact that there are two [atoms](/docs/glossary/atom/) in the sample: the numbers to be added together.  Hence, it is appropriate that only a cell of [atoms](/docs/glossary/atom/) is permitted for the sample.  We can look at the default sample of `add` at address `+6`:

```
> +6:add
[a=0 b=0]
```

If we call `add` with no arguments, we get the sum of these two values:

```
> (add)
0
```

Any other type of value in the sample results in a `nest-fail` crash:

```
> (add 12 "hello")
nest-fail
```

This function call attempts to create a modified copy of the `add` [gate](/docs/glossary/gate/), replacing the original sample `[0 0]` with `[12 "hello"]`, then evaluate the `$` [arm](/docs/glossary/arm/) of this modified [core](/docs/glossary/core/).  (We ignore the `a` and `b` faces for now.)  But this piece of code failed to compile; the type system knew to reject it.

How does it know?  The type system keeps track of two copies of the [payload](/docs/glossary/payload/) type for each [core](/docs/glossary/core/):

+ The original [payload](/docs/glossary/payload/) type, i.e., the type of the [payload](/docs/glossary/payload/) when the [core](/docs/glossary/core/) was first created.  In the case of `add`, the original sample type is a cell of [atoms](/docs/glossary/atom/), `[@ @]`. This original type information is always preserved, regardless of the argument values used to call `add`.
+ The current [payload](/docs/glossary/payload/) type, i.e., the type of the [payload](/docs/glossary/payload/) after any substitutions or other changes have been made.  In the last `add` call, `(add 12 "hello")`, the sample would be a cell whose head is an `@ud`, and whose tail is a `tape`.

The type check at compile time compares these two types, and if the current [payload](/docs/glossary/payload/) type doesn't nest under the original [payload](/docs/glossary/payload/), the compile fails with a `nest-fail` crash.  (E.g., a cell of type `[@ud tape]` doesn't nest under `[@ @]`.)  Otherwise, the original [payload](/docs/glossary/payload/) _type_ is used for evaluation, even though the original sample _value_ has been replaced.  So the [arm](/docs/glossary/arm/) of a dry [core](/docs/glossary/core/) is guaranteed to run with exactly the same subject type each time it is evaluated.

The type check for each [arm](/docs/glossary/arm/) in a dry [core](/docs/glossary/core/) can be understood as implementing a version of the ["Liskov substitution principle"](https://en.wikipedia.org/wiki/Liskov_substitution_principle).  The [arm](/docs/glossary/arm/) works for some (originally defined) [payload](/docs/glossary/payload/) type `P`.  Payload type `Q` nests under `P`.  Therefore the [arm](/docs/glossary/arm/) works for `Q` as well, though for type inference purposes the [payload](/docs/glossary/payload/) is treated as a `P`.  The inferred type of the [arm](/docs/glossary/arm/) is based on the assumption that it's evaluated with a subject type exactly like that of its original parent [core](/docs/glossary/core/) -- i.e., whose [payload](/docs/glossary/payload/) is of type `P`.

### Wet Cores (Genericity)

The type checking and inference rules for [arms](/docs/glossary/arm/) are a bit different for wet [cores](/docs/glossary/core/).  Whereas the dry [arm](/docs/glossary/arm/) is understood as having _exactly_ its parent [core](/docs/glossary/core/) type for its subject, wet [arms](/docs/glossary/arm/) can be evaluated with [payloads](/docs/glossary/payload/) of various types.

Let's start again with a typical function call.

When a function call occurs on a wet [arm](/docs/glossary/arm/), the [call site](https://en.wikipedia.org/wiki/Call_site) argument value type is used as the sample type -- not the original parent [core](/docs/glossary/core/) sample type.  Correspondingly, the inferred type of a wet [arm](/docs/glossary/arm/) depends, among other things, on the type of the argument value -- i.e., the modified sample value type of the [core](/docs/glossary/core/), not the original sample.  Thus, the inferred product type typically varies from one call site to another.

The [arms](/docs/glossary/arm/) of wet [cores](/docs/glossary/core/) must be able to handle subjects of various types -- they are interestingly polymorphic in a way that dry [cores](/docs/glossary/core/) cannot be.  The Hoon code that defines each wet [arm](/docs/glossary/arm/) must be [generic](https://en.wikipedia.org/wiki/Generic_programming) with respect to the sample type.

An example will clarify how wet gates work.  Recall the `copy` [gate](/docs/glossary/gate/) from earlier in the lesson:

```
> =copy |=(a=* [a a])

> (copy 15)
[15 15]

> (copy [15 16])
[[15 16] [15 16]]

> (copy "Hello!")
[[72 101 108 108 111 33 0] [72 101 108 108 111 33 0]]
```

This [gate](/docs/glossary/gate/) is dry (as are all [cores](/docs/glossary/core/) produced with `|=`), and so the inferred type of the product is determined based on the original [core](/docs/glossary/core/) sample type.  In this case, that's a raw [noun](/docs/glossary/noun/), `*`.  The dojo pretty-printer therefore has no way of knowing that the product of the last `copy` call should be printed as a pair of `tape`s -- it just sees a pair of [nouns](/docs/glossary/noun/).  If we want the original type information preserved, we must use a wet gate, which can be produced with `|*`:

```
> =wet-copy |*(a=* [a a])

> (wet-copy 15)
[15 15]

> (wet-copy [15 16])
[[15 16] 15 16]

> (wet-copy "Hello!")
["Hello!" "Hello!"]
```

We see that the type information about the `tape` literal `"Hello!"` is preserved in the last function call, as desired.  The original sample value of `wet-copy` is replaced with `"Hello!"`, and the original sample type is ignored in favor of the new sample type, `tape`.  So the inferred [arm](/docs/glossary/arm/) type is a cell of `tape`s, which the dojo pretty-printer handles appropriately.

In fact, `wet-copy` can take a Hoon value of any type you like.

For another example, consider the following [gate](/docs/glossary/gate/) that switches the order of the head and tail of a cell:

```
> =switch |*([a=* b=*] [b a])

> (switch 2 3)
[3 2]

> (switch "Hello" [11 22 33])
[[11 22 33] "Hello"]

> (switch 0xbeef 0b1101)
[0b1101 0xbeef]
```

Not only does `switch` reverse the order of the values, it also reverses their respective types, as desired.  The dry version of switch is not as useful:

```
> =dry-switch |=([a=* b=*] [b a])

> (dry-switch "Hello" [11 22 33])
[[11 22 33] [72 101 108 108 111 0]]

> (dry-switch 0xbeef 0b1101)
[13 48.879]
```

Even though both `switch` and `dry-switch` are polymorphic in the sense that each can operate on any pair of [nouns](/docs/glossary/noun/), the former does so in a way that makes use of the argument value types.

But `switch` can't take just any input:

```
> (switch 11)
-find.b
```

It must take a cell, not an [atom](/docs/glossary/atom/).  So it's certainly possible to write a wet gate that doesn't take all possible input types.

It is good practice to include a cast in all [gates](/docs/glossary/gate/), even wet gates.  But in many cases the desired output type depends on the input type.  How can we cast appropriately?  Often we can cast by example, using the input values themselves.  For example, we can rewrite `switch` as:

```
> =switch |*([a=* b=*] ^+([b a] [b a]))

> (switch "Hello" 0xbeef)
[0xbeef "Hello"]
```

As is the case with dry [arms](/docs/glossary/arm/), there is a type-check associated with each wet [arm](/docs/glossary/arm/).  Or, rather, there are potentially many checks for each wet [arm](/docs/glossary/arm/), one for each wing in the code that resolves to a wet [arm](/docs/glossary/arm/).  The product type of that [arm](/docs/glossary/arm/) is inferred at each call site, using the argument value type given at that site.  If the type inference doesn't go through -- e.g., if there is a cast that doesn't succeed relative to the call site argument value -- then the compile will crash with a `nest-fail`.  Otherwise the type check goes through with the inferred type of the wet [arm](/docs/glossary/arm/) at that call site.  So the product type of a wet gate can differ from one call site to another, as we saw with `switch` above.

### Parametric Polymorphism and `+*` Arms

We may use the `+*` rune to define an [arm](/docs/glossary/arm/) that produced a more complex type from one or more simpler types.  This rune provides a way of making use of **parametric polymorphism** in Hoon.

For example, we have `list`s, `tree`s, and `set`s in Hoon, which are each defined in `hoon.hoon` with `+*` [arms](/docs/glossary/arm/).  (Take a moment to see for yourself.)  Each `+*` [arm](/docs/glossary/arm/) is followed by an argument definition, inside brackets `[ ]`.  After that subexpression comes another that defines a type, relative to the input value.  For example, here is the definition of `list` from `hoon.hoon`:

```hoon
+*  list  [item]
  ::    null-terminated list
  ::
  ::  mold generator: produces a mold of a null-terminated list of the
  ::  homogeneous type {a}.
  ::
  $@(~ [i=item t=(list item)])
```

The `+*` rune is especially useful for defining [containers](https://en.wikipedia.org/wiki/Container_%28abstract_data_type%29) of various kinds.  Indeed, `list`s, `tree`s, and `set`s are all examples of containers.  You can have a `(list @)`, a `(list ^)`, a `(list *)`, and so on.  Or a `(tree @)`, a `(tree ^)`, a `(tree *)`, etc.  And the same for `set`.

One nice thing about containers defined by `+*` is that they nest in the expected way.  Intuitively a `(list @)` should nest under `(list *)`, because `@` nests under `*`.  And so it does:

```
> =a `(list @)`~[11 22 33]

> ^-((list *) a)
~[11 22 33]
```

Conversely, a `(list *)` should not nest under `(list @)`, because `*` does not nest under `@`:

```
> =b `(list *)`~[11 22 33]

> ^-((list @) b)
nest-fail
```

Let's clear the dojo subject by unbinding the faces we've used up to now in the lesson:

```
=a

=b

=copy

=wet-copy

=switch

=dry-switch
```

## Core Variance

Let's say you want to write a function that takes a [gate](/docs/glossary/gate/) as one (or more) of its arguments.  It's not hard to imagine useful cases of this.  Consider `turn` from the Hoon standard library, which applies an arbitrary function to each item in a list and returns a modified list:

```
> =b `(list @)`~[2 3 4 5]

> (turn b |=(a=@ +(a)))
~[3 4 5 6]

> (turn b |=(a=@ (mul 2 a)))
~[4 6 8 10]

=b
```

It's quite useful to be able to pass [cores](/docs/glossary/core/) as arguments.  But let's think about how to write a function that accepts a [core](/docs/glossary/core/) as input.  How do we define a sample so that it accepts a [core](/docs/glossary/core/)?

We _could_ define the sample by example -- i.e., with `$_`, or `_` for short -- using a [core](/docs/glossary/core/).  Consider the following, in which `mycore` is the example [core](/docs/glossary/core/) and `apply` is  function that accepts [gates](/docs/glossary/gate/):

```
> =mycore =>([12 13] |=(a=@ +(a)))

> =apply |=([a=@ b=_mycore] (b a))

> (apply 15 mycore)
16

> (apply 15 =>([12 13] |=(a=@ +(+(a)))))
17

> (apply 15 =>([12 13] |=(a=@ 123)))
123
```

This works, but in fact `apply` is a very brittle function.  It can only take as input a [core](/docs/glossary/core/) whose [payload](/docs/glossary/payload/) is exactly like, or a subtype of, the [payload](/docs/glossary/payload/) of `mycore`:

```
> (apply 15 |=(a=@ (mul 2 a)))
nest-fail
```

A [core](/docs/glossary/core/) created in one place of your code isn't likely to have the same [payload](/docs/glossary/payload/) as a [core](/docs/glossary/core/) produced elsewhere, unless you intentionally define it so that it does.  This generally isn't practical, so we need another way to indicate that we want a [core](/docs/glossary/core/) as input.

Why did the last example crash?  To understand this, you need to understand the the different variance properties a [core](/docs/glossary/core/) can have.  These properties determine the nesting and type inference rules associated with each [core](/docs/glossary/core/).

The basic question to be answered is: when does one [core](/docs/glossary/core/) type nest under another?

The [battery](/docs/glossary/battery/) nesting rules for dry [cores](/docs/glossary/core/) are relatively straightforward, and they're the same for all [cores](/docs/glossary/core/), regardless of variance properties.  Let `A` and `B` be two [cores](/docs/glossary/core/).  The type of `B` nests under the type of `A` only if two conditions are met: (i) the batteries of `A` and `B` have exactly the same tree shape, and (ii) the product type of each `B` [arm](/docs/glossary/arm/) nests under the product type of the corresponding `A` [arm](/docs/glossary/arm/).

The [payload](/docs/glossary/payload/) types of `A` and `B` must also be checked.  Certain [payload](/docs/glossary/payload/) nesting rules apply to all [cores](/docs/glossary/core/), if `B` is to nest under `A`: (i) if `A` is wet then `B` must also be wet; (ii) the original [payload](/docs/glossary/payload/) type of `A` must mutually nest with the current [payload](/docs/glossary/payload/) type of `A` (i.e., these types nest under each other); and (iii) the current [payload](/docs/glossary/payload/) type of `B` must nest under the original [payload](/docs/glossary/payload/) type of `B`.

### The Four Kinds of Cores: Gold, Iron, Zinc, and Lead

But there are different sets of nesting rules for finishing the [payload](/docs/glossary/payload/) type check, depending on the variance properties of the [core](/docs/glossary/core/).

There are four kinds of cores: **gold** (invariant payload), **iron** (contravariant sample), **zinc** (covariant sample), and **lead** (bivariant sample).  Information about the kind of [core](/docs/glossary/core/) is tracked by the Hoon type system.

Their nesting rules in brief:

+ If `A` is a gold [core](/docs/glossary/core/), then [core](/docs/glossary/core/) `B` nests under it only if `B` is gold and the [payload](/docs/glossary/payload/) of `B` doesn't vary in type from the [payload](/docs/glossary/payload/) of `A`.  The [payload](/docs/glossary/payload/) `B` is **invariant** (i.e., neither co- nor contravariant) relative to the [payload](/docs/glossary/payload/) of an `A` it nests under.  Gold [cores](/docs/glossary/core) have a read-write [payload](/docs/glossary/payload/).
+ If `A` is an iron [core](/docs/glossary/core/), then [core](/docs/glossary/core/) `B` nests under it only if `B` is gold or iron and the sample of `A` nests under the sample of `B`.  Notice that the nesting direction of the samples is the opposite of the nesting direction of the [cores](/docs/glossary/core/).  I.e., the sample types are **contravariant** with respect to the iron [core](/docs/glossary/core/) types.  Iron [cores](/docs/glossary/core/) have a write-only sample and an opaque context. ("Opaque" means neither read nor write.)
+ If `A` is a zinc [core](/docs/glossary/core/), then [core](/docs/glossary/core/) `B` nests under it only if `B` is gold or zinc and the sample of `B` nests under the sample of `A`.  Notice that the nesting direction of the samples is the same as the nesting direction of the [cores](/docs/glossary/core/).  I.e., the sample types are **covariant** with respect to the zinc [core](/docs/glossary/core/) types.  Zinc [cores](/docs/glossary/core/) have a read-only sample and an opaque context.
+ If `A` is a lead [core](/docs/glossary/core/), then [core](/docs/glossary/core/) `B` nests under it without any additional [payload](/docs/glossary/payload/) check beyond those described in the previous section.  It trivially follows that the [payload](/docs/glossary/payload/) type both co- and contravaries with respect to the lead [core](/docs/glossary/core/) types (hence lead [cores](/docs/glossary/core/) are **bivariant**).  Lead [cores](/docs/glossary/core/) have an opaque [payload](/docs/glossary/payload/).

Let's go through each kind more carefully.

#### Gold Cores (Invariant)

By default, most [cores](/docs/glossary/core/) are gold.  This includes the [cores](/docs/glossary/core/) produced with the `|%`, `|=`, `|_`, and `|-` runes, among others.

Assume that `A` is a gold [core](/docs/glossary/core/) and that `B` is some other [core](/docs/glossary/core/).  The type of `B` nests under the type of `A` only if the original [payload](/docs/glossary/payload/) types of each mutually nest -- i.e., the original [payload](/docs/glossary/payload/) type of `A` nests under the original [payload](/docs/glossary/payload/) type of `B`, and _vice versa_.  Furthermore, only gold [cores](/docs/glossary/core/) nest under other gold [cores](/docs/glossary/core/); so `B` must be gold to nest under `A`.

These [payload](/docs/glossary/payload/) nesting rules are the strictest ones for [cores](/docs/glossary/core/).  The [payload](/docs/glossary/payload/) type is neither covariant nor contravariant; when type-checking against a gold [core](/docs/glossary/core/), the target [payload](/docs/glossary/payload/) cannot vary at all in type.  Consequently, it is type-safe to modify every part of the [payload](/docs/glossary/payload/): gold [cores](/docs/glossary/core/) have a read-write [payload](/docs/glossary/payload/).

Usually it makes sense to cast for a gold [core](/docs/glossary/core/) type when you're treating a [core](/docs/glossary/core/) as a state machine.  The check ensures that the [payload](/docs/glossary/payload/), which includes the relevant state, doesn't vary in type.  To see state machines that involve casts for gold [cores](/docs/glossary/core/), see Chapter 2 of the Hoon tutorial.

Let's look at simpler examples here, using the `^+` rune:

```
> ^+(|=(^ 15) |=(^ 16))
< 1.xqz
  { {* *}
    {our/@p now/@da eny/@uvJ}
    <19.rga 23.byz 5.rja 36.apb 119.ikf 238.utu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> ^+(|=(^ 15) |=([@ @] 16))
nest-fail

> ^+(|=(^ 15) |=(* 16))
nest-fail
```

The first cast goes through because the right-hand gold [core](/docs/glossary/core/) has the same sample type as the left-hand gold [core](/docs/glossary/core/).  The sample types mutually nest.  The second cast fails because the right-hand sample type is more specific than the left-hand sample type.  (Not all cells, `^`, are pairs of [atoms](/docs/glossary/atom/), `[@ @]`.)  And the third cast fails because the right-hand sample type is broader than the left-hand sample type. (Not all [nouns](/docs/glossary/noun/), `*`, are cells, `^`.)

Two more examples:

```
> ^+(=>([1 2] |=(@ 15)) =>([123 456] |=(@ 16)))
<1.xqz {@ @ud @ud}>

> ^+(=>([1 2] |=(@ 15)) =>([123 456 789] |=(@ 16)))
nest-fail
```

In these examples, the `=>` rune is used to give each [core](/docs/glossary/core/) a simple context.  The context of the left-hand [core](/docs/glossary/core/) in each case is a pair of [atoms](/docs/glossary/atom/), `[@ @]`.  The first cast goes through because the right-hand [core](/docs/glossary/core/) also has a pair of [atoms](/docs/glossary/atom/) as its context.  The second cast fails because the right-hand [core](/docs/glossary/core/) has the wrong type of context -- three [atoms](/docs/glossary/atom/), `[@ @ @]`.

#### Iron Cores (Contravariant)

Assume that `A` is an iron [core](/docs/glossary/core/) and `B` is some other [core](/docs/glossary/core/).  The type of `B` nests under the type of `A` only if the original sample type of `A` nests under the original sample type of `B`.  That is, `B`'s sample type must be equivalent or more general than the sample type of `A`.  Furthermore, `B` must be either iron or gold to nest under `A`.

The context type of `B` isn't checked at all; and because of the nesting rules it isn't type-safe to do type-inference on the sample of an iron [gate](/docs/glossary/gate/).  Thus, there are certain restrictions on iron [cores](/docs/glossary/core/) that preserve type safety: (i) the context of an iron [core](/docs/glossary/core/) is opaque, meaning that it cannot be written-to or read-from; and (ii) the iron [core](/docs/glossary/core/) [payload](/docs/glossary/payload/) is write-only.

Iron [gates](/docs/glossary/gate/) are particularly useful when you want to pass [gates](/docs/glossary/gate/) (having various [payload](/docs/glossary/payload/) types) to other [gates](/docs/glossary/gate/).  We can illustrate this use with a very simple example.  Save the following as `gatepass.hoon` in the `gen` directory of your urbit's pier:

```hoon
|=  a=_^|(|=(@ 15))
^-  @
=/  b=@  (a 10)
(add b 20)
```

This generator is mostly very simple.  Everything about it should be clear except possibly the first line.

The first line defines the sample as an iron [gate](/docs/glossary/gate/) and gives it the face `a`.  The function as a whole is for taking some [gate](/docs/glossary/gate/) as input, calling it by passing it the value `10`, adding `20` to it, and returning the result.  Let's try it out in the dojo:

```
> +gatepass |=(a=@ +(a))
31

> +gatepass |=(a=@ (add 3 a))
33

> +gatepass |=(a=@ (mul 3 a))
50
```

But we still haven't fully explained the first line of the code.  What does `_^|(|=(@ 15))` mean?  The inside portion is clear enough -- `|=(@ 15)` produces a normal (i.e., gold) [gate](/docs/glossary/gate/) that takes an [atom](/docs/glossary/atom/) and returns `15`.  The `^|` rune is used to turn gold [gates](/docs/glossary/gate/) to iron.  (Reverse alchemy!)  And the `_` character turns that iron [gate](/docs/glossary/gate/) value into a structure, i.e. a type.  So the whole subexpression means, roughly: "the same type as an iron [gate](/docs/glossary/gate/) whose sample is an [atom](/docs/glossary/atom/), `@`, and whose product is another [atom](/docs/glossary/atom/), `@`".  The context isn't checked at all.  This is good, because that allows us to accept [gates](/docs/glossary/gate/) defined and produced in drastically different environments.  Let's try passing a [gate](/docs/glossary/gate/) with a different context:

```
> +gatepass =>([22 33] |=(a=@ +(a)))
31
```

Yup, it still works.  You can't do that with a gold [core](/docs/glossary/core/) sample!

There's a simpler way to define an iron sample.  Revise the first line of `gatepass.hoon` to the following:

```hoon
|=  a=$-(@ @)
^-  @
=/  b=@  (a 10)
(add b 20)
```

If you test it you'll find that the generator behaves the same as it did before the edits.  The `$-` rune is used to create an iron [gate](/docs/glossary/gate/) structure, i.e., an iron [gate](/docs/glossary/gate/) type.  The first expression defines the desired sample type, and the second subexpression defines the [gate](/docs/glossary/gate/)'s desired output type.

The sample type of an iron [gate](/docs/glossary/gate/) is contravariant.  This means that, when doing a cast with some iron [gate](/docs/glossary/gate/), the desired [gate](/docs/glossary/gate/) must have either the same sample type or a superset.

Why is this a useful nesting rule for passing [gates](/docs/glossary/gate/)?

Let's say you're writing a function `F` that takes as input some [gate](/docs/glossary/gate/) `G`. Let's also say you want `G` to be able to take as input any **mammal**.  The code of `F` is going to pass arbitrary **mammals** to `G`, so that `G` needs to know how to handle all **mammals** correctly. You can't pass `F` a [gate](/docs/glossary/gate/) that only takes **dogs** as input, because `F` might call it with a **cat**. But `F` can accept a [gate](/docs/glossary/gate/) that takes all **animals** as input, because a [gate](/docs/glossary/gate/) that can handle any **animal** can handle **any mammal**.

Iron [cores](/docs/glossary/core/) are designed precisely with this purpose in mind.  The reason that the sample is write-only is that we want to be able to assume, within function `F`, that the sample of `G` is a **mammal**.  But that might not be true when `G` is first passed into `F` -- the default value of `G` could be another **animal**, say, a **lizard**.  So we restrict looking into the sample of `G` by making the sample write-only.  The illusion is maintained and type safety secured.

Let's illustrate iron [core](/docs/glossary/core/) nesting properties:

```
> ^+(^|(|=(^ 15)) |=(^ 16))
< 1|xqz
  { {* *}
    {our/@p now/@da eny/@uvJ}
    <19.rga 23.byz 5.rja 36.apb 119.ikf 238.utu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> ^+(^|(|=(^ 15)) |=([@ @] 16))
nest-fail

 ^+(^|(|=(^ 15)) |=(* 16))
< 1|xqz
  { {* *}
    {our/@p now/@da eny/@uvJ}
    <19.rga 23.byz 5.rja 36.apb 119.ikf 238.utu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>
```

(As before, we use the `^|` rune to turn gold [gates](/docs/glossary/gate/) iron.)

The first cast goes through because the two [gates](/docs/glossary/gate/) have the same sample type.  The second cast fails because the right-hand [gate](/docs/glossary/gate/) has a more specific sample type than the left-hand [gate](/docs/glossary/gate/) does.  If you're casting for a [gate](/docs/glossary/gate/) that accepts any cell, `^`, it's because we want to be able to pass any cell to it.  A [gate](/docs/glossary/gate/) that is only designed for pairs of [atoms](/docs/glossary/atom/), `[@ @]`, can't handle all such cases, naturally.  The third cast goes through because the right-hand [gate](/docs/glossary/gate/) sample type is broader than the left-hand [gate](/docs/glossary/gate/) sample type.  A [gate](/docs/glossary/gate/) that can take any [noun](/docs/glossary/noun/) as its sample, `*`, works just fine if we choose only to pass it cells, `^`.

We mentioned previously that an iron [core](/docs/glossary/core/) has a write-only sample and an opaque [core](/docs/glossary/core/).  Let's prove it.

Let's define a trivial [gate](/docs/glossary/gate/) with a context of `[g=22 h=44 .]`, convert it to iron with `^|`, and bind it to `iron-gate` in the dojo:

```
> =iron-gate ^|  =>([g=22 h=44 .] |=(a=@ (add a g)))

> (iron-gate 10)
32

> (iron-gate 11)
33
```

Not a complicated function, but it serves our purposes.  Normally (i.e., with gold [cores](/docs/glossary/core/)) we can look at a context value `p` of some [gate](/docs/glossary/gate/) `q` with a wing expression: `p.q`.  Not so with the iron [gate](/docs/glossary/gate/):

```
> g.iron-gate
-find.g.iron-gate
```

And usually we can look at the sample value using the face given in the [gate](/docs/glossary/gate/) definition.  Not in this case:

```
> a.iron-gate
-find.a.iron-gate
```

If you really want to look at the sample you can check `+6` of `iron-gate`:

```
> +6.iron-gate
0
```

...and if you really want to look at the head of the context (i.e., where `g` is located, `+14`) you can:

```
> +14.iron-gate
22
```

...but in both cases all the relevant type information has been thrown away:

```
> -:!>(+6.iron-gate)
#t/*

> -:!>(+14.iron-gate)
#t/*
```

Let's clear up the dojo subject by unbinding `iron-gate`:

```
=iron-gate
```

#### Zinc Cores (Covariant)

Zinc [cores](/docs/glossary/core/) are mirror versions of iron [cores](/docs/glossary/core/).

Assume that `A` is a zinc [core](/docs/glossary/core/) and `B` is some other [core](/docs/glossary/core/).  The type of `B` nests under the type of `A` only if the original sample type of `B` nests under the original sample type of `A`.  That is, the target [core](/docs/glossary/core/) sample type must be equivalent or a subset of the cast [core](/docs/glossary/core/) sample type.  Furthermore, `B` must be either zinc or gold to nest under `A`.

As with iron [cores](/docs/glossary/core/), the context of zinc [cores](/docs/glossary/core/) is opaque -- they cannot be written-to or read-from.  The sample of a zinc [core](/docs/glossary/core/) is read-only.  That means, among other things, that zinc [cores](/docs/glossary/core/) cannot be used for function calls.  Function calls in Hoon involve a change to the sample (the default sample is replaced with the argument value), which is disallowed as type-unsafe for zinc [cores](/docs/glossary/core/).

We can illustrate the casting properties of zinc [cores](/docs/glossary/core/) with a few examples.  The `^&` rune is used to convert gold [cores](/docs/glossary/core/) to zinc:

```
> ^+(^&(|=(^ 15)) |=(^ 16))
< 1&xqz
  { {* *}
    {our/@p now/@da eny/@uvJ}
    <19.rga 23.byz 5.rja 36.apb 119.ikf 238.utu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> ^+(^&(|=(^ 15)) |=([@ @] 16))
< 1&xqz
  { {* *}
    {our/@p now/@da eny/@uvJ}
    <19.rga 23.byz 5.rja 36.apb 119.ikf 238.utu 51.mcd 93.glm 74.dbd 1.qct $141>
  }
>

> ^+(^&(|=(^ 15)) |=(* 16))
nest-fail
```

The first two casts succeed because the right-hand [core](/docs/glossary/core/) sample type is either the same or a subset of the left-hand [core](/docs/glossary/core/) sample type.  The last one fails because the right-hand sample type is a superset.

Even though you can't function call a zinc [core](/docs/glossary/core/), the [arms](/docs/glossary/arm/) of a zinc [core](/docs/glossary/core/) can be computed and the sample can be read.  Let's test this with a zinc [gate](/docs/glossary/gate/) of our own:

```
> =zinc-gate ^&  |=(a=_22 (add 10 a))

> (zinc-gate 12)
payload-block

> a.zinc-gate
22

> $.zinc-gate
32
```

Let's clear up the dojo subject again:

```
> =zinc-gate
```

#### Lead Cores (Bivariant)

Lead [cores](/docs/glossary/core/) have more permissive nesting rules than either iron or zinc [cores](/docs/glossary/core/).  There is no restriction on which [payload](/docs/glossary/payload/) types nest.  That means, among other things, that the [payload](/docs/glossary/payload/) type of a lead [core](/docs/glossary/core/) is both covariant and contravariant ('bivariant').

In order to preserve type safety when working with lead [cores](/docs/glossary/core/), a severe restriction is needed.  The whole [payload](/docs/glossary/payload/) of a lead [core](/docs/glossary/core/) is opaque -- the [payload](/docs/glossary/payload/) can neither be written-to or read-from.  For this reason, as was the case with zinc [cores](/docs/glossary/core/), lead [cores](/docs/glossary/core/) cannot be called as functions.

The [arms](/docs/glossary/arm/) of a lead [core](/docs/glossary/core/) can still be evaluated, however.  We can use the `^?` rune to convert a gold, iron, or zinc [core](/docs/glossary/core/) to lead:

```
> =lead-gate ^?  |=(a=_22 (add 10 a))

> $.lead-gate
32
```

But don't try to read the sample:

```
> a.lead-gate
-find.a.lead-gate
```

Once more let's clear up the dojo subject:

```
=lead-gate
```
