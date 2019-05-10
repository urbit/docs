+++
title = "Type Polymorphism"
weight = 31
template = "doc.html"
+++
There are many cases in which one may want to write a function that accepts as input various different types of data.  Such a function is said to be [polymorphic](https://en.wikipedia.org/wiki/Polymorphism_%28computer_science%29).  ("Polymorphism" = "many forms"; so polymorphic functions accept many forms of data as input.)

One relatively trivial form of polymorphism involves sub-typing.  A gate whose sample is a raw `noun` can accept any Hoon data structure as input -- it's just that the sample will only be treated as a raw noun.  For example, consider the `copy` gate below:

```
> =copy |=(a=* [a a])

> (copy 15)
[15 15]

> (copy [15 16])
[[15 16] [15 16]]

> (copy "Hello!")
[[72 101 108 108 111 33 0] [72 101 108 108 111 33 0]]
```

`copy` takes the input, `a`, and returns a cell of `[a a]`.  Because every piece of Hoon data is a noun, anything can be taken as input.  Every other type in Hoon is a sub-type of `noun`.  But the output of `copy` is always going to be just a cell of nouns; the type information of the original input value is not preserved by the gate.  Consider the `tape` in the last example: `"Hello!"` was pretty-printed in the dojo as a raw noun, not as a string.  So `copy` is a relatively uninteresting polymorphic function.

In this lesson we'll go over Hoon's support for more interesting polymorphic functions.

## Polymorphic Properties of Cores

Hoon supports type polymorphism at the core level.  That is, each core has certain polymorphic properties that are tracked and maintained as metadata by Hoon's type system.  (See `+$  type` of `hoon.hoon`.)  These properties determine the extent to which a core can be used as an interface for values of various types.

This is rather vaguely put so far.  We can clarify by talking more specifically about the kinds of polymorphism supported in Hoon.  There are two kinds of type polymorphism for cores: [genericity](https://en.wikipedia.org/wiki/Generic_programming), to include certain kinds of [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism); and [variance polymorphism](https://en.wikipedia.org/wiki/Covariance_and_contravariance_%28computer_science%29), which involves making use of special sub-typing rules for cores.

If you don't understand these very well, that's okay.  We'll explain them.  Let's begin with the former.

## Dry vs. Wet Cores

To review briefly, a **core** is a pair of `[battery payload]`.  The **battery** contains the various arms of the core (code), and the **payload** contains all the data needed to evaluate those arms correctly (data).  Every arm is evaluated with its parent core as the subject.  A **gate** (i.e., a Hoon function) is a core with exactly one arm named `$` and with a payload of the form: `[sample context]`.  The **sample** is reserved for the function's argument value, and the **context** is any other data needed to evaluate `$` correctly.

There are two kinds of cores: **dry** and **wet**.  Dry cores, which are more typical, _don't_ make use of **genericity**.  Wet cores do.  In order to understand generic functions in Hoon, you have to understand the difference between dry and wet cores.

The cores produced with the `|=`, `|-`, `|%`, and `|_` runes, among others, are all dry.  The cores produced with the `|*` and `|@` runes are wet.  (`|*` and `|@` are the wet versions of `|=` and `|%`, respectively.)

Briefly, the difference between dry and wet cores has to do with how they're treated at compile time, for type inference and type checking.  During the type check, the product type of each arm is inferred.  For computing a dry arm type, it's assumed that the arm's subject type is of the original parent core.  For computing a wet arm type, the parent core type is used, except that the payload value may vary from the original type.

Because of this, wet gates can be used as functions that take different input types at different call sites.  We'll go over the dry/wet distinction in more detail below and explain why it matters.

### Dry Cores

A core's payload can change from its original value.  In fact, this happens in the typical function call -- the default sample is replaced with an input value.  How can we ensure that the core's arms are able to run correctly, that the payload type is still appropriate despite whatever changes it has undergone?

There is a type check for each arm of a dry core, intended to verify that the arm's parent core has a payload of the correct type.  In this section we'll describe that type check, starting with typical gate usage.

When the `$` arm of a dry gate is evaluated it takes its parent core -- the dry gate itself -- as the subject, often with a modified sample _value_.  But any change in sample _type_ should be conservative; the modified sample value must be of the same type as the default sample value (or possibly a subtype).  When the `$` arm is evaluated it should have a subject of a type it knows how to use.

For illustration, consider the gate created by `add`, a function in the Hoon standard library.  The structure of the `add` gate is as follows:

```
       add
      /   \
     $     .
          / \
    sample   context
```

The `add` code depends on the fact that there are two atoms in the sample: the numbers to be added together.  Hence, it is appropriate that only a cell of atoms is permitted for the sample.  We can look at the default sample of `add` at address `+6`:

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

This function call attempts to create a modified copy of the `add` gate, replacing the original sample `[0 0]` with `[12 "hello"]`, then evaluate the `$` arm of this modified core.  (We ignore the `a` and `b` faces for now.)  But this piece of code failed to compile; the type system knew to reject it.

How does it know?  The type system keeps track of two copies of the payload type for each core:

+ The original payload type, i.e., the type of the payload when the core was first created.  In the case of `add`, the original sample type is a cell of atoms, `[@ @]`. This original type information is always preserved, regardless of the argument values used to call `add`.
+ The current payload type, i.e., the type of the payload after any substitutions or other changes have been made.  In the last `add` call, `(add 12 "hello")`, the sample would be a cell whose head is an `@ud`, and whose tail is a `tape`.

The type check at compile time compares these two types, and if the current payload type doesn't nest under the original payload, the compile fails with a `nest-fail` crash.  (E.g., a cell of type `[@ud tape]` doesn't nest under `[@ @]`.)  Otherwise, the original payload _type_ is used for evaluation, even though the original sample _value_ has been replaced.  So the arm of a dry core is guaranteed to run with exactly the same subject type each time it is evaluated.

The type check for each arm in a dry core can be understood as implementing a version of the ["Liskov substitution principle"](https://en.wikipedia.org/wiki/Liskov_substitution_principle).  The arm works for some (originally defined) payload type `P`.  Payload type `Q` nests under `P`.  Therefore the arm works for `Q` as well, though for type inference purposes the payload is treated as a `P`.  The inferred type of the arm is based on the assumption that it's evaluated with a subject type exactly like that of its original parent core -- i.e., whose payload is of type `P`.

### Wet Cores (Genericity)

The type checking and inference rules for arms are a bit different for wet cores.  Whereas the dry arm is understood as having _exactly_ its parent core type for its subject, wet arms can be evaluated with payloads of various types.

Let's start again with a typical function call.

When a function call occurs on a wet arm, the [call site](https://en.wikipedia.org/wiki/Call_site) argument value type is used as the sample type -- not the original parent core sample type.  Correspondingly, the inferred type of a wet arm depends, among other things, on the type of the argument value -- i.e., the modified sample value type of the core, not the original sample.  Thus, the inferred product type typically varies from one call site to another.

The arms of wet cores must be able to handle subjects of various types -- they are interestingly polymorphic in a way that dry cores cannot be.  The Hoon code that defines each wet arm must be [generic](https://en.wikipedia.org/wiki/Generic_programming) with respect to the sample type.

An example will clarify how wet gates work.  Recall the `copy` gate from earlier in the lesson:

```
> =copy |=(a=* [a a])

> (copy 15)
[15 15]

> (copy [15 16])
[[15 16] [15 16]]

> (copy "Hello!")
[[72 101 108 108 111 33 0] [72 101 108 108 111 33 0]]
```

This gate is dry (as are all cores produced with `|=`), and so the inferred type of the product is determined based on the original core sample type.  In this case, that's a raw noun, `*`.  The dojo pretty-printer therefore has no way of knowing that the product of the last `copy` call should be printed as a pair of `tape`s -- it just sees a pair of nouns.  If we want the original type information preserved, we must use a wet gate, which can be produced with `|*`:

```
> =wet-copy |*(a=* [a a])

> (wet-copy 15)
[15 15]

> (wet-copy [15 16])
[[15 16] 15 16]

> (wet-copy "Hello!")
["Hello!" "Hello!"]
```

We see that the type information about the `tape` literal `"Hello!"` is preserved in the last function call, as desired.  The original sample value of `wet-copy` is replaced with `"Hello!"`, and the original sample type is ignored in favor of the new sample type, `tape`.  So the inferred arm type is a cell of `tape`s, which the dojo pretty-printer handles appropriately.

In fact, `wet-copy` can take a Hoon value of any type you like.

For another example, consider the following gate that switches the order of the head and tail of a cell:

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

Even though both `switch` and `dry-switch` are polymorphic in the sense that each can operate on any pair of nouns, the former does so in a way that makes use of the argument value types.

But `switch` can't take just any input:

```
> (switch 11)
-find.b
```

It must take a cell, not an atom.  So it's certainly possible to write a wet gate that doesn't take all possible input types.

It is good practice to include a cast in all gates, even wet gates.  But in many cases the desired output type depends on the input type.  How can we cast appropriately?  Often we can cast by example, using the input values themselves.  For example, we can rewrite `switch` as:

```
> =switch |*([a=* b=*] ^+([b a] [b a]))

> (switch "Hello" 0xbeef)
[0xbeef "Hello"]
```

As is the case with dry arms, there is a type-check associated with each wet arm.  Or, rather, there are potentially many checks for each wet arm, one for each wing in the code that resolves to a wet arm.  The product type of that arm is inferred at each call site, using the argument value type given at that site.  If the type inference doesn't go through -- e.g., if there is a cast that doesn't succeed relative to the call site argument value -- then the compile will crash with a `nest-fail`.  Otherwise the type check goes through with the inferred type of the wet arm at that call site.  So the product type of a wet gate can differ from one call site to another, as we saw with `switch` above.

### Parametric Polymorphism and `+*` Arms

In Chapter 2 we saw how to use the `+*` rune to define an arm that produced a more complex type from one or more simpler types.  This rune provides a way of making use of **parametric polymorphism** in Hoon.

For example, we have `list`s, `tree`s, and `set`s in Hoon, which are each defined in `hoon.hoon` with `+*` arms.  (Take a moment to see for yourself.)  Each `+*` arm is followed by an argument definition, inside brackets `[ ]`.  After that subexpression comes another that defines a type, relative to the input value.  For example, here is the definition of `list` from `hoon.hoon`:

```
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

Let's say you want to write a function that takes a gate as one (or more) of its arguments.  It's not hard to imagine useful cases of this.  Consider `turn` from the Hoon standard library, which applies an arbitrary function to each item in a list and returns a modified list:

```
> =b `(list @)`~[2 3 4 5]

> (turn b |=(a=@ +(a)))
~[3 4 5 6]

> (turn b |=(a=@ (mul 2 a)))
~[4 6 8 10]

=b
```

It's quite useful to be able to pass cores as arguments.  But let's think about how to write a function that accepts a core as input.  How do we define a sample so that it accepts a core?

We _could_ define the sample by example -- i.e., with `$_`, or `_` for short -- using a core.  Consider the following, in which `mycore` is the example core and `apply` is  function that accepts gates:

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

This works, but in fact `apply` is a very brittle function.  It can only take as input a core whose payload is exactly like, or a subtype of, the payload of `mycore`:

```
> (apply 15 |=(a=@ (mul 2 a)))
nest-fail
```

A core created in one place of your code isn't likely to have the same payload as a core produced elsewhere, unless you intentionally define it so that it does.  This generally isn't practical, so we need another way to indicate that we want a core as input.

Why did the last example crash?  To understand this, you need to understand the the different variance properties a core can have.  These properties determine the nesting and type inference rules associated with each core.

The basic question to be answered is: when does one core type nest under another?

The battery nesting rules for dry cores are relatively straightforward, and they're the same for all cores, regardless of variance properties.  Let `A` and `B` be two cores.  The type of `B` nests under the type of `A` only if two conditions are met: (i) the batteries of `A` and `B` have exactly the same tree shape, and (ii) the product type of each `B` arm nests under the product type of the corresponding `A` arm.

The payload types of `A` and `B` must also be checked.  Certain payload nesting rules apply to all cores, if `B` is to nest under `A`: (i) if `A` is wet then `B` must also be wet; (ii) the original payload type of `A` must mutually nest with the current payload type of `A` (i.e., these types nest under each other); and (iii) the current payload type of `B` must nest under the original payload type of `B`.

### The Four Kinds of Cores: Gold, Iron, Zinc, and Lead

But there are different sets of nesting rules for finishing the payload type check, depending on the variance properties of the core.

There are four kinds of cores: **gold** (invariant payload), **iron** (contravariant sample), **zinc** (covariant sample), and **lead** (bivariant sample).  Information about the kind of core is tracked by the Hoon type system.

Their nesting rules in brief:

+ If `A` is a gold core, then core `B` nests under it only if `B` is gold and the payload of `B` doesn't vary in type from the payload of `A`.  The payload `B` is **invariant** (i.e., neither co- nor contravariant) relative to the payload of an `A` it nests under.  Gold cores have a read-write payload.
+ If `A` is an iron core, then core `B` nests under it only if `B` is gold or iron and the sample of `A` nests under the sample of `B`.  Notice that the nesting direction of the samples is the opposite of the nesting direction of the cores.  I.e., the sample types are **contravariant** with respect to the iron core types.  Iron cores have a write-only sample and an opaque context. ("Opaque" means neither read nor write.)
+ If `A` is a zinc core, then core `B` nests under it only if `B` is gold or zinc and the sample of `B` nests under the sample of `A`.  Notice that the nesting direction of the samples is the same as the nesting direction of the cores.  I.e., the sample types are **covariant** with respect to the zinc core types.  Zinc cores have a read-only sample and an opaque context.
+ If `A` is a lead core, then core `B` nests under it without any additional payload check beyond those described in the previous section.  It trivially follows that the payload type both co- and contravaries with respect to the lead core types (hence lead cores are **bivariant**).  Lead cores have an opaque payload.

Let's go through each kind more carefully.

#### Gold Cores (Invariant)

By default, most cores are gold.  This includes the cores produced with the `|%`, `|=`, `|_`, and `|-` runes, among others.

Assume that `A` is a gold core and that `B` is some other core.  The type of `B` nests under the type of `A` only if the original payload types of each mutually nest -- i.e., the original payload type of `A` nests under the original payload type of `B`, and _vice versa_.  Furthermore, only gold cores nest under other gold cores; so `B` must be gold to nest under `A`.

These payload nesting rules are the strictest ones for cores.  The payload type is neither covariant nor contravariant; when type-checking against a gold core, the target payload cannot vary at all in type.  Consequently, it is type-safe to modify every part of the payload: gold cores have a read-write payload.

Usually it makes sense to cast for a gold core type when you're treating a core as a state machine.  The check ensures that the payload, which includes the relevant state, doesn't vary in type.  To see state machines that involve casts for gold cores, see Chapter 2 of the Hoon tutorial.

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

The first cast goes through because the right-hand gold core has the same sample type as the left-hand gold core.  The sample types mutually nest.  The second cast fails because the right-hand sample type is more specific than the left-hand sample type.  (Not all cells, `^`, are pairs of atoms, `[@ @]`.)  And the third cast fails because the right-hand sample type is broader than the left-hand sample type. (Not all nouns, `*`, are cells, `^`.)

Two more examples:

```
> ^+(=>([1 2] |=(@ 15)) =>([123 456] |=(@ 16)))
<1.xqz {@ @ud @ud}>

> ^+(=>([1 2] |=(@ 15)) =>([123 456 789] |=(@ 16)))
nest-fail
```

In these examples, the `=>` rune is used to give each core a simple context.  The context of the left-hand core in each case is a pair of atoms, `[@ @]`.  The first cast goes through because the right-hand core also has a pair of atoms as its context.  The second cast fails because the right-hand core has the wrong type of context -- three atoms, `[@ @ @]`.

#### Iron Cores (Contravariant)

Assume that `A` is an iron core and `B` is some other core.  The type of `B` nests under the type of `A` only if the original sample type of `A` nests under the original sample type of `B`.  That is, `B`'s sample type must be equivalent or more general than the sample type of `A`.  Furthermore, `B` must be either iron or gold to nest under `A`.

The context type of `B` isn't checked at all; and because of the nesting rules it isn't type-safe to do type-inference on the sample of an iron gate.  Thus, there are certain restrictions on iron cores that preserve type safety: (i) the context of an iron core is opaque, meaning that it cannot be written-to or read-from; and (ii) the iron core payload is write-only.

Iron gates are particularly useful when you want to pass gates (having various payload types) to other gates.  We can illustrate this use with a very simple example.  Save the following as `gatepass.hoon` in the `gen` directory of your urbit's pier:

```
|=  a=_^|(|=(@ 15))
^-  @
=/  b=@  (a 10)
(add b 20)
```

This generator is mostly very simple.  Everything about it should be clear except possibly the first line.

The first line defines the sample as an iron gate and gives it the face `a`.  The function as a whole is for taking some gate as input, calling it by passing it the value `10`, adding `20` to it, and returning the result.  Let's try it out in the dojo:

```
> +gatepass |=(a=@ +(a))
31

> +gatepass |=(a=@ (add 3 a))
33

> +gatepass |=(a=@ (mul 3 a))
50
```

But we still haven't fully explained the first line of the code.  What does `_^|(|=(@ 15))` mean?  The inside portion is clear enough -- `|=(@ 15)` produces a normal (i.e., gold) gate that takes an atom and returns `15`.  The `^|` rune is used to turn gold gates to iron.  (Reverse alchemy!)  And the `_` character turns that iron gate value into a structure, i.e. a type.  So the whole subexpression means, roughly: "the same type as an iron gate whose sample is an atom, `@`, and whose product is another atom, `@`".  The context isn't checked at all.  This is good, because that allows us to accept gates defined and produced in drastically different environments.  Let's try passing a gate with a different context:

```
> +gatepass =>([22 33] |=(a=@ +(a)))
31
```

Yup, it still works.  You can't do that with a gold core sample!

There's a simpler way to define an iron sample.  Revise the first line of `gatepass.hoon` to the following:

```
|=  a=$-(@ @)
^-  @
=/  b=@  (a 10)
(add b 20)
```

If you test it you'll find that the generator behaves the same as it did before the edits.  The `$-` rune is used to create an iron gate structure, i.e., an iron gate type.  The first expression defines the desired sample type, and the second subexpression defines the gate's desired output type.

The sample type of an iron gate is contravariant.  This means that, when doing a cast with some iron gate, the desired gate must have either the same sample type or a superset.

Why is this a useful nesting rule for passing gates?

Let's say you're writing a function `F` that takes as input some gate `G`. Let's also say you want `G` to be able to take as input any **mammal**.  The code of `F` is going to pass arbitrary **mammals** to `G`, so that `G` needs to know how to handle all **mammals** correctly. You can't pass `F` a gate that only takes **dogs** as input, because `F` might call it with a **cat**. But `F` can accept a gate that takes all **animals** as input, because a gate that can handle any **animal** can handle **any mammal**.

Iron cores are designed precisely with this purpose in mind.  The reason that the sample is write-only is that we want to be able to assume, within function `F`, that the sample of `G` is a **mammal**.  But that might not be true when `G` is first passed into `F` -- the default value of `G` could be another **animal**, say, a **lizard**.  So we restrict looking into the sample of `G` by making the sample write-only.  The illusion is maintained and type safety secured.

Let's illustrate iron core nesting properties:

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

(As before, we use the `^|` rune to turn gold gates iron.)

The first cast goes through because the two gates have the same sample type.  The second cast fails because the right-hand gate has a more specific sample type than the left-hand gate does.  If you're casting for a gate that accepts any cell, `^`, it's because we want to be able to pass any cell to it.  A gate that is only designed for pairs of atoms, `[@ @]`, can't handle all such cases, naturally.  The third cast goes through because the right-hand gate sample type is broader than the left-hand gate sample type.  A gate that can take any noun as its sample, `*`, works just fine if we choose only to pass it cells, `^`.

We mentioned previously that an iron core has a write-only sample and an opaque core.  Let's prove it.

Let's define a trivial gate with a context of `[g=22 h=44 .]`, convert it to iron with `^|`, and bind it to `iron-gate` in the dojo:

```
> =iron-gate ^|  =>([g=22 h=44 .] |=(a=@ (add a g)))

> (iron-gate 10)
32

> (iron-gate 11)
33
```

Not a complicated function, but it serves our purposes.  Normally (i.e., with gold cores) we can look at a context value `p` of some gate `q` with a wing expression: `p.q`.  Not so with the iron gate:

```
> g.iron-gate
-find.g.iron-gate
```

And usually we can look at the sample value using the face given in the gate definition.  Not in this case:

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

Zinc cores are mirror versions of iron cores.

Assume that `A` is a zinc core and `B` is some other core.  The type of `B` nests under the type of `A` only if the original sample type of `B` nests under the original sample type of `A`.  That is, the target core sample type must be equivalent or a subset of the cast core sample type.  Furthermore, `B` must be either zinc or gold to nest under `A`.

As with iron cores, the context of zinc cores is opaque -- they cannot be written-to or read-from.  The sample of a zinc core is read-only.  That means, among other things, that zinc cores cannot be used for function calls.  Function calls in Hoon involve a change to the sample (the default sample is replaced with the argument value), which is disallowed as type-unsafe for zinc cores.

We can illustrate the casting properties of zinc cores with a few examples.  The `^&` rune is used to convert gold cores to zinc:

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

The first two casts succeed because the right-hand core sample type is either the same or a subset of the left-hand core sample type.  The last one fails because the right-hand sample type is a superset.

Even though you can't function call a zinc core, the arms of a zinc core can be computed and the sample can be read.  Let's test this with a zinc gate of our own:

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

Lead cores have more permissive nesting rules than either iron or zinc cores.  There is no restriction on which payload types nest.  That means, among other things, that the payload type of a lead core is both covariant and contravariant ('bivariant').

In order to preserve type safety when working with lead cores, a severe restriction is needed.  The whole payload of a lead core is opaque -- the payload can neither be written-to or read-from.  For this reason, as was the case with zinc cores, lead cores cannot be called as functions.

The arms of a lead core can still be evaluated, however.  We can use the `^?` rune to convert a gold, iron, or zinc core to lead:

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
