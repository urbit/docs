+++
title = "Gates (Hoon Functions)"
weight = 15
template = "doc.html"
+++
In this lesson you're going to learn about Hoon functions.

## What is a Function?

The word 'function' is used in various ways, but let's start by talking about them in the [mathematical sense](https://en.wikipedia.org/wiki/Function_%28mathematics%29).  Roughly put, a function takes one or more arguments (i.e., input values) and returns a value.  What the return value is depends solely on the argument(s), and nothing else.  For example, we can understand multiplication as a function: it takes two numbers and returns another number.  It doesn't matter where you ask, when you ask, or what kind of hat you're wearing when you ask.  If you pass the same two numbers (e.g., `3` and `4`), you get the same answer returned every time (`12`).

That output value depends solely upon input value(s) is an important property of functions.  This property is called [referential transparency](https://en.wikipedia.org/wiki/Referential_transparency), and we make use of it throughout the Urbit software stack.

Functions are implemented in Hoon with a special kind of core called a **gate**.  In this lesson you'll learn what a gate is and how a gate represents a function.  Along the way you'll build some example gates of your own.

You've already used two functions from the Hoon standard library: `add` and `mul`.  These are implemented with gates, and you call them from the dojo in the following way:

```
> (add 2 3)
5

> (mul 2 3)
6
```

## What is a Gate?

A core is a cell: `[battery payload]`.

A gate is a core with two distinctive properties: (1) the battery of a gate contains exactly one arm, which has the special name `$`.  The `$` arm contains the instructions for the function in question.  And (2), the payload of a gate consists of a cell of `[sample context]`.  The sample is the part of the payload that stores the 'argument' (i.e., input value) of the function call.  The context contains all other data that is needed for computing the `$` arm of the gate correctly.

```
Gate:  [$ [Sample Context]]
```

As a tree, a gate looks like the following:

```
       Gate
      /    \
     $      .
           / \
     Sample   Context
```

Like all arms, `$` is computed with its parent core as the subject.  When `$` is computed, the resulting value is called the 'product' of the gate.  No other data is used to calculate the product other than the data in the gate itself.

## Creating Your First Gate

Let's make a gate that takes any unsigned integer (i.e., an atom) as its sample and returns that value plus one as the product.  To do this we'll use the `|=` rune.  We'll bind this gate to the face `inc` for 'increment':

```
> =inc |=(a=@ (add 1 a))

> (inc 1)
2

> (inc 12)
13

> (inc 123)
124
```

The gate works as promised -- it takes any number `n` and returns `n + 1`.  Let's take a closer look at what the `|=` is doing.

### The `|=` Rune

We typically use the `|=` rune to create a gate.  In the expression above the `|=` is immediately followed by a set of parentheses containing two subexpressions: `a=@` and `(add 1 a)`.  The first defines the gate's sample (input value type), and the second defines the gate's product (value).

When we used the `|%` rune in the last lesson we didn't use parentheses because we were writing in "tall form" syntax, whereas here we are writing in "flat form" syntax.  (The latter uses parentheses and is more suitable for shorter snippets of code.)  We'll explain these concepts more thoroughly in lesson 2.2.

In the example gate above, `inc`, the sample is defined by `a=@`.  This means that the sample is defined as an atom, `@`, meaning that the gate will take as input anything of that type.  The sample is given the face `a`.  With the face it's easier to refer to the sample in later code, if desired.

In `inc`, the product is defined by `(add 1 a)`.  There's not much to it -- it returns the value of `a + 1`!

The second subexpression after the `|=` rune is used to build the gate's `$` arm.  That's where all the computations go.

## Anatomy of a Gate

A gate is a one-armed core with a sample: `[$ [Sample Context]]`.  Let's go over these parts a little more carefully, using `inc` as our example.

```
> inc
< 1.jgn
  { a/@
    {our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

### The `$` Arm

The arm of a gate encodes the instructions for the Hoon function in question.

The pretty printer represents the `$` arm of `inc` as `1.jgn`.  To see the actual noun of the `$` arm, enter `+2:inc` into the dojo:

```
> +2:inc
[8 [9 8 0 4.095] 9 2 [0 4] [[7 [0 3] 1 1] 0 14] 0 11]
```

This is un-computed Nock.  You don't need to understand any of this.

It's worth pointing out that the arm name, `$`, can be used like any other name.  We can compute `$` directly with `$:add` in the dojo:

```
> $:inc
1
```

This result may seem a bit strange.  We didn't call `inc` or in any other way pass it a number.  Yet using `$` to evaluate `inc`'s arm seems to work -- sort of, anyway.  Why is it giving us `1` as the return value?  We can answer this question after we understand gate samples a little better.

### The Sample

The sample of a gate is the address reserved for storing the argument(s) to the Hoon function.  The sample is always at the head of the gate's tail, i.e., `+6`.

Let's look at the gate for `inc` again, paying particular attention to its sample:

```
> inc
< 1.jgn
  { a/@
    {our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

We see `a/@`.  This may not be totally clear, but it should make _some_ sense.  This is the pretty-printer's way of indicating an atom with the face `a`.  Let's take a closer look:

```
> +6:inc
a=0
```

We see now that the sample of `inc` is the value `0`, and has `a` as a face.  This is a placeholder value for the function argument.  If you evaluate the `$` arm of `inc` without passing it an argument the placeholder value is used for the computation, and the return value will thus be `0 + 1`:

```
> $:inc
1
```

The placeholder value is sometimes called a **bunt** value.  The bunt value is determined by the input type; for atoms, `@`, the bunt value is `0`.

The face value of `a` comes from the way we defined the gate above: `|=(a=@ (add 1 a))`.  It was so we could use `a` to refer to the sample to generate the product with `(add 1 a)`.

### The Context

The context of a gate contains other data that may be necessary for the `$` arm to evaluate correctly.  The context always located at the tail of the tail of the gate, i.e., `+7` of the gate.  There is no requirement that the context have any particular arrangement, though often it does.

Let's look at the context of `inc`:

```
> +7:inc
[ [ our=~zod
    now=~2018.12.12..18.55.06..df2b
      eny
    \/0v2g0.cmm6d.1igpo.llg7o.4921d.nov38.vjsgp.mdfln.8pt9f.n23hj.qc6q9.8p7bd\/
      .2eo59.qko43.1jgd2.rtc44.egooe.esvft.orohc.i9ufn.4rnur
    \/                                                                       \/
  ]
  <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
]
```

This is exactly the default dojo subject, from before we put `inc` into the subject.  The `|=` expression defines the context as whatever the subject is.  This guarantees that the context has all the information it needs to have for the `$` arm to work correctly.

### Exercise 1.5.1

Write a gate that takes an atom, `a=@`, and which returns double the value of `a`.  Bind this gate to `double` and test it in the dojo.  A solution is given at the end of this lesson.

## Gates Define Functions of the Sample

The value of a function's output depends solely upon the input value.  This is one of the features that make functions desirable in many programming contexts.  It's worth going over how Hoon function calls implement this feature.

In Hoon one can use `(gate arg)` syntax to make a function call.  For example,

```
> (inc 234)
235
```

The name of the gate is `inc`.  How is the `$` arm of `inc` evaluated?  When a function call occurs, a copy of the `inc` gate is created, but with one modification; the sample is replaced with the function argument.  Then the `$` arm is computed against this modified version of the `inc` gate.

Remember that the default or 'bunt' value of the sample of `inc` is `0`.  In the function call above, a copy of the `inc` gate is made but with a sample value of `234`.  When `$` is computed against this modified core, the product is `235`.

Notice that neither the arm nor the context is modified before the arm is evaluated.  That means that the only part of the gate that changes before the arm evaluation is the sample.  Hence, we may understand each gate as defining a function whose argument is the sample.  If you call a gate with the same sample, you'll get the same value returned to you every time.

Let's unbind `inc` to keep the subject tidy:

```
> =inc

> inc
-find.inc
```

### Modifying the Context of a Gate

It _is_ possible to modify the context of a gate when you make a function call; or, to be more precise, it's possible to call a mutant copy of the gate in which the context is modified.  To illustrate this let's use another example gate.  Let's write a gate which uses a value from the context to generate the product.  Bind `b` to the value `10`:

```
> =b 10

> b
10
```

Now let's write a gate called `ten` that adds `b` to the input value:

```
> =ten |=(a=@ (add a b))

> (ten 10)
20

> (ten 20)
30

> (ten 25)
35
```

We can unbind `b` from the dojo subject, and `ten` works just as well because it's using a copy of `b` stored its context:

```
> =b

> (ten 15)
25

> (ten 35)
45

> b.+7.ten
10
```

We can use `ten(b 25)` to produce a variant of `ten`.  Calling this mutant version of `ten` causes a different value to be returned than we'd get with a normal `ten` call:

```
> (ten(b 25) 10)
35

> (ten(b 1) 25)
26

> (ten(b 75) 100)
175
```

Before finishing the lesson let's unbind `ten`:

```
> =ten
```

## Exercise 1.5.1 Solution

Write a gate that takes an atom, `a=@`, and which returns double the value of `a`.  Bind this gate to `double` and test it in the dojo.

```
> =double |=(a=@ (mul 2 a))

> (double 10)
20

> (double 25)
50
```

### [Next Lesson: Multi-gate Cores and Doors](./docs/learn/hoon/hoon-tutorial/multi-gate-cores-and-doors.md)
