+++
title = "1.7 Arms and Cores"
weight = 15
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/arms-and-cores/"]
+++
The Hoon subject is a [noun](/docs/glossary/noun/).  Each fragment of this [noun](/docs/glossary/noun/) is either an [arm](/docs/glossary/arm/) or a leg.  In the previous lesson you learned what a leg is, and how to return legs of the subject by various means.  In this lesson you'll learn what an [arm](/docs/glossary/arm/) is.  Arms are a bit more complex than legs -- a full understanding of them requires a bit more background knowledge.  Accordingly, in this lesson we must also introduce an important Hoon data structure: a 'core'.

After [arms](/docs/glossary/arm/) are defined and explained we review wing expressions, this time focusing on wing resolution to [arms](/docs/glossary/arm/).

## A Preliminary Explanation

Arms and legs are limbs of the subject, i.e., [noun](/docs/glossary/noun/) fragments of the subject.  In the last lesson we said that legs are for data and [arms](/docs/glossary/arm/) are for computations.  But what _specifically_ is an [arm](/docs/glossary/arm/), and how is it used for computation?  Let's begin with a preliminary explanation that will be refined later in the lesson.

An **arm** is some expression of Hoon encoded as a [noun](/docs/glossary/noun/).  (By 'encoded as a [noun](/docs/glossary/noun/)' we literally mean: 'compiled to a Nock formula'.  But you don't need to know anything about Nock to understand Hoon.)  You virtually never need to treat an [arm](/docs/glossary/arm/) as raw data, even though technically you can -- it's just a [noun](/docs/glossary/noun/) like any other.  You virtually always want to think of an [arm](/docs/glossary/arm/) simply as a way of running some Hoon code.

Every expression of Hoon is evaluated relative to a subject.  What subject is the [arm](/docs/glossary/arm/) to be evaluated against?  Answer: the parent [core](/docs/glossary/core/) of that [arm](/docs/glossary/arm/).

So in order to understand fully what an [arm](/docs/glossary/arm/) is, you must understand what a [core](/docs/glossary/core/) is.  Briefly, a **core** is a cell of `[battery payload]`.  The **battery** is a collection of one or more [arms](/docs/glossary/arm/), and the **payload** is the data needed by the [arms](/docs/glossary/arm/) to evaluate correctly.  (The [battery](/docs/glossary/battery/) is code and the [payload](/docs/glossary/payload/) is data for that code.)  A given [core](/docs/glossary/core/) is the **parent [core](/docs/glossary/core/)** of all of the [arms](/docs/glossary/arm/) in its [battery](/docs/glossary/battery/).

## Your First Core

To clarify the basic idea, let's look at an example [core](/docs/glossary/core/).

We'll make a [core](/docs/glossary/core/) using a multi-line Hoon expression that is more complex than the other examples you've seen up to this point.  The dojo can be used to input multi-line Hoon expressions; just type each line, hitting 'enter' or 'return' at the end.  The expression will be evaluated at the appropriate line break, i.e., when the dojo recognizes it as a complete expression of Hoon.

Use the following to bind `c` to a [core](/docs/glossary/core/).  It begins with a **rune**, `|%`, which is used for creating a [core](/docs/glossary/core/).  (A rune is just a pair of ASCII characters, and it usually indicates the beginning of a complex Hoon expression.)  Take note of the expression spacing -- Hoon uses significant whitespace.  Feel free to cut and paste the following expression into the dojo, starting with `=c`:

```hoon
> =c |%
  ++  twenty  20
  ++  double-twenty  (mul 2 twenty)
  --
```

This [core](/docs/glossary/core/) has two [arms](/docs/glossary/arm/), `twenty` and `double-twenty`.  Each [arm](/docs/glossary/arm/) definition begins with `++` followed by the name of that [arm](/docs/glossary/arm/).  After that is the Hoon expression associated with that [arm](/docs/glossary/arm/).  The first expression is the trivial `20` (guess what that does?), and the second is the slightly more interesting `(mul 2 twenty)`.

You can run these [arms](/docs/glossary/arm/) using `twenty.c` and `double-twenty.c`:

```
> twenty.c
20

> double-twenty.c
40
```

Notice that the second [arm](/docs/glossary/arm/), `double-twenty`, makes use of the first [arm](/docs/glossary/arm/), `twenty`.  It's able to do so because each [arm](/docs/glossary/arm/) is evaluated with its parent [core](/docs/glossary/core/) as the subject.  Hence, each [arm](/docs/glossary/arm/) is able to use any other [arm](/docs/glossary/arm/) inside the parent [core's](/docs/glossary/core/) [battery](/docs/glossary/battery/).

### `|%` Expressions

Before moving on let's talk about what each part of the `|%` expression is for.

The `|%` indicates the beginning of an expression that produces a [core](/docs/glossary/core/).  The `++` rune is used to define each of the [arms](/docs/glossary/arm/) of the [core's](/docs/glossary/core/) [battery](/docs/glossary/battery/), and is followed by both an [arm](/docs/glossary/arm/) name and a Hoon expression.  The `--` rune is used to indicate that there are no more [arms](/docs/glossary/arm/) to be defined, and indicates the end of the expression.

The [battery](/docs/glossary/battery/) of the [core](/docs/glossary/core/) to be produced is explicitly defined by the `|%` expression.  The [payload](/docs/glossary/payload/) of the [core](/docs/glossary/core/) to be produced is implicitly defined as the subject of the `|%` expression.  Let's unbind `c` to keep the subject clean:

```
> =c
```

## Cores

Let's go over what a [core](/docs/glossary/core/) is a little more carefully and comprehensively.  As stated before, a **core** is a cell of a **battery** and a **payload**.

```
A [core](/docs/glossary/core/):  [battery [payload](/docs/glossary/payload/)]
```

### Battery

A [battery](/docs/glossary/battery/) is a collection of [arms](/docs/glossary/arm/).  An [arm](/docs/glossary/arm/) is an encoded Hoon expression, to be used for running computations.  Each [arm](/docs/glossary/arm/) has a name.  Arm naming rules are the same kebab-case rules that faces have.  When an [arm](/docs/glossary/arm/) is evaluated, it uses its parent [core](/docs/glossary/core/) as the subject.

That's all you really need to know about the [battery](/docs/glossary/battery/).  You can become a master Hoon programmer if you know what is stated above but otherwise think of the [battery](/docs/glossary/battery/) as a black box.

If you'd really like to know, technically a [battery](/docs/glossary/battery/) is a tree of Nock formulas, one formula per each [arm](/docs/glossary/arm/).  Again, however, you don't need to understand the first thing about Nock to understand Hoon.

### Payload

The [payload](/docs/glossary/payload/) contains all the data needed for running the [arms](/docs/glossary/arm/) in the [battery](/docs/glossary/battery/) correctly.  In principle, the [payload](/docs/glossary/payload/) of a [core](/docs/glossary/core/) can have data arranged in any arbitrary configuration.  In practice, the [payload](/docs/glossary/payload/) often has a predictable structure of its own.

The [payload](/docs/glossary/payload/) may include other [cores](/docs/glossary/core/).  Consequently, a [core](/docs/glossary/core/)'s [payload](/docs/glossary/payload/) can include other 'code' -- [cores](/docs/glossary/core/) in the [payload](/docs/glossary/payload/) have their own [battery](/docs/glossary/battery/) [arms](/docs/glossary/arm/).

### Subject Organization for Arm Computation

Why must an [arm](/docs/glossary/arm/) have its parent [core](/docs/glossary/core/) as the subject, when it's computed?  As stated previously, the [payload](/docs/glossary/payload/) of a [core](/docs/glossary/core/) contains all the data needed for computing the [arms](/docs/glossary/arm/) of that [core](/docs/glossary/core/).  Arms can only access data in the subject.  By requiring that the parent [core](/docs/glossary/core/) be the subject we guarantee that each [arm](/docs/glossary/arm/) has the appropriate data available to it.  The tail of its subject contains the [payload](/docs/glossary/payload/) and thus all the values therein.  The head of the subject is the [battery](/docs/glossary/battery/), which allows for making reference to sibling [arms](/docs/glossary/arm/) of that same [core](/docs/glossary/core/).

Let's look at an example in which the [payload](/docs/glossary/payload/) information is needed for correct [arm](/docs/glossary/arm/) evaluation.

## Another Example Core

First let's use the dojo to bind the face `a` to the value `12`, and the face `b` to the value `[22 24]`.  These values will be used in the [arms](/docs/glossary/arm/) of the [core](/docs/glossary/core/) we're going to make.

```
> =a 12

> =b [22 24]
```

Now use the following multi-line expression to bind `c` to a [core](/docs/glossary/core/).  As before, feel free to cut and paste the following expression into the dojo (starting at `=c`):

```hoon
> =c |%
  ++  two  2
  ++  inc  (add 1 a)
  ++  double  (mul 2 a)
  ++  sum  (add -.b +.b)
  --
```

Note: binding `c` to the [core](/docs/glossary/core/) created by the `|%` expression will fail unless you have already bound `a` and `b` to the relevant values, as we did above.  Our having already bound them is what lets us use them in the `|%` expression.

The `|%` expression above creates a [core](/docs/glossary/core/) with four [arms](/docs/glossary/arm/).  The first, named `two`, evaluates to the constant `2`.  The second [arm](/docs/glossary/arm/), `inc`, adds `1` to `a`.  `double` returns double the value of `a`, and `sum` returns the sum of the two [atoms](/docs/glossary/atom/) in `b`.  The computations defined by these [arms](/docs/glossary/arm/) are pretty simple (and in the case of `two`, trivial), but a good starting point for learning about [cores](/docs/glossary/core/).

Let's run the [arm](/docs/glossary/arm/) names in the dojo:

```
> two.c
2

> inc.c
13

> double.c
24

> sum.c
46
```

Ideally these wing expressions behave the way you expected!

To reiterate a point made earlier: a wing resolution to a leg returns the value of that leg.  A wing resolution to an [arm](/docs/glossary/arm/) returns the value produced by the [arm](/docs/glossary/arm/) computation.

### Dissecting a Core

Enter `c` in the dojo to look at this [core](/docs/glossary/core/) as printed data:

```
> c
< 4.cvq
  { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

`c`, like all cores, is a cell of `[battery payload]`, and it's pretty-printed inside a set of angled brackets: `< >`.  The battery of four arms is represented by the pretty-printer as `4.cvq`.  The `4` represents the number of arms in the battery, and the `cvq` is a [hash](https://en.wikipedia.org/wiki/Hash_function) of the battery.

The tail, i.e., the payload, might look suspiciously familiar.  It looks an awful lot like the default dojo subject, which has `our`, `now`, and `eny` in the head, but it also has `a` and `b`, which we also bound in the dojo subject.  That's exactly what the payload is.  The tail is a copy of what the subject was for the `|%` expression.  (It's pretty-printed in a slightly compressed way).

(You'll notice that there are several other cores in the payload.  For example, `19.anu` is a battery of `19` arms, `24.tmo` is a battery of `24` arms, etc.)

This means, among other things, that we should be able to unbind `a` and `b` in the subject, but the arms of `c` should still work correctly:

```
> =a

> =b

> a
-find.a

> b
-find.b

> double.c
24

> sum.c
46
```

This works because `a` and `b` were copied into the [core](/docs/glossary/core/) [payload](/docs/glossary/payload/) when the [core](/docs/glossary/core/) was initially created.  Unbinding them in the dojo subject doesn't matter to the [arms](/docs/glossary/arm/) in `c`, which only look in `c`'s [payload](/docs/glossary/payload/) anyway.

The [payload](/docs/glossary/payload/) stores all the data needed to compute the [arms](/docs/glossary/arm/) correctly.  That also includes `add` and `mul`, which themselves are [arms](/docs/glossary/arm/) in a [core](/docs/glossary/core/) of the Hoon standard library.  This library [core](/docs/glossary/core/) is available as part of the default dojo subject.

## Wings that Resolve to Arms

To reinforce your newfound understanding of [arms](/docs/glossary/arm/) and [cores](/docs/glossary/core/), let's go over the various ways that wings resolve to [arms](/docs/glossary/arm/) in [cores](/docs/glossary/core/).  Remember that face resolution to a leg of the subject produces the leg value unchanged, but resolution to an [arm](/docs/glossary/arm/) produces the _computed_ value of that [arm](/docs/glossary/arm/).

### Address-Based Wings

In the [previous lesson](@../the-subject-and-its-legs.md), you saw how the following expressions return legs based on an address in the subject: `+n`, `.`, `-`, `+`, `+>`, `+<`, `->`, `-<`, `&`, `|` etc.  When these resolve to the part of the subject containing an [arm](/docs/glossary/arm/), they **don't** evaluate the [arm](/docs/glossary/arm/).  They simply return the indicated [noun](/docs/glossary/noun/) fragment of the subject, as if it were a leg.

Let's use `-.c` to look at the head of `c`, i.e., the [battery](/docs/glossary/battery/) of the [core](/docs/glossary/core/):

```
> -.c
[ [1 2]
  [ [8 [9 702 0 2.047] 9 2 10 [6 [7 [0 3] 1 2] 0 56] 0 2]
    8
    [9 20 0 2.047]
    9
    2
    10
    [6 [7 [0 3] 1 1] 0 56]
    0
    2
  ]
  8
  [9 20 0 2.047]
  9
  2
  10
  [6 [0 114] 0 115]
  0
  2
]
```

The result is a tree of uncomputed Nock formulas.  But you virtually never need to see or use this raw data.  Generally speaking, don't use address-based expressions to look at [arms](/docs/glossary/arm/) for any reason other than to satisfy your curiosity (and even then only if you've learned or plan to learn Nock).  Use name-based expressions instead.

### Name-based Wings

To get the [arm](/docs/glossary/arm/) of a [core](/docs/glossary/core/) to compute you must use its name.  The [arm](/docs/glossary/arm/) names of `c` are in the expression used to create `c`:

```hoon
> =c |%
  ++  two  2
  ++  inc  (add 1 a)
  ++  double  (mul 2 a)
  ++  sum  (add -.b +.b)
  --
```

We evaluated the [arms](/docs/glossary/arm/) of `c` previously:

```
> two.c
2

> inc.c
13

> double.c
24

> sum.c
46
```

You can also evaluate the [arms](/docs/glossary/arm/) of `c` using `:` instead:

```
> two:c
2

> inc:c
13

> double:c
24

> sum:c
46
```

The difference between `two.c` and `two:c` is as follows.  `two.c` is an instruction for finding `two` in `c` in the subject.  `two:c` is an instruction for setting `c` as the subject, and then for finding `two`.  In the examples above both versions amount to the same thing, and so return the same product.  (There are other cases in which `two.c` and `two:c` _don't_ amount to the same thing.  We'll address the difference in more detail later.)

### Name Searches and Collisions

It's possible to have 'name collisions' with faces and [arm](/docs/glossary/arm/) names.  Nothing prevents one from using the name of some [arm](/docs/glossary/arm/) as a face too.  For example:

```
> double:c
24

> double:[double=123 c]
123
```

When `[double=123 c]` is the subject, the result is a cell of: (1) `double=123` and (2) the [core](/docs/glossary/core/) `c`:

```
> [double=123 c]
[ double=123
  < 4.cvq
    { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
      <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
    }
  >
]
```

Hoon doesn't know whether `double` is a face or an [arm](/docs/glossary/arm/) name until it conducts a search looking for name matches.  If it finds a face first, the value of the face is returned.  If it finds an [arm](/docs/glossary/arm/) first, the [arm](/docs/glossary/arm/) will be evaluated and the product returned.  You may use `^` to indicate that you want to skip the first match, and multiple `^`s to indicate multiple skips:

```
> double:[double=123 c]
123

> ^double:[double=123 c]
24

> ^double:[double=123 double=456 c]
456

> ^^double:[double=123 double=456 c]
24
```

### Modifying a Core's Payload

We can produce a modified version of the [core](/docs/glossary/core/) `c` in which `a` and `b` have different values.  A [core](/docs/glossary/core/) is just a [noun](/docs/glossary/noun/) in the subject, so we can modify it in the way we learned to modify legs in the last lesson.  To change `a` to `99`, use `c(a 99)`:

```
> c(a 99)
< 4.cvq
  { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> a.c
12
```

The expression `c(a 99)` produces a [core](/docs/glossary/core/) exactly like `c` except that the value of `a` in the [payload](/docs/glossary/payload/) is `99` instead of `12`.  But when we evaluate `a.c` we still get the original value, `12`.  Why?  The value of `c` in the dojo is bound to the original [core](/docs/glossary/core/) value, and will stay that way until we unbind `c` or bind it to something else.  We can ask for a modified copy of `c` but that value doesn't automatically persist.  It must be put into the subject if we're to find it there.  So how do we know that `c(a 99)` successfully modified the value of `a`?  We can check by setting the new version of the [core](/docs/glossary/core/) as the subject and checking `a`:

```
> a:c(a 99)
99

> double:c(a 99)
198
```

To make the modified [core](/docs/glossary/core/) persist as `c`, we can rebind `c` to the new value:

```
> =c c(a 99)

> a:c
99

> double:c
198
```

We can make multiple changes to `c` at once:

```
> =c c(a 123, b [44 55])

> a:c
123

> b:c
[44 55]

> two:c
2

> inc:c
124

> double:c
246

> sum:c
99
```

### Arms on the Search Path

A wing is a search path into the subject.  We've looked at some examples of wings that resolve to [arms](/docs/glossary/arm/); e.g., `double.c`, which resolves to `double` in `c` in the subject.  In the latter example the [arm](/docs/glossary/arm/) `double` is the final limb in the resolution path.  What if an [arm](/docs/glossary/arm/) name in a wing isn't the final limb?  What if it's elsewhere in the wing path?

Normally we might read a wing expression like `two.double.c` as '`two` in `double` in `c`'.  Does that make sense when `double` is itself an [arm](/docs/glossary/arm/)?  Try it:

```
> two.double.c
2
```

It produces the value of `two` in `c`.  This is a fact in need of explanation.

When [arm](/docs/glossary/arm/) names are included in the body of a wing, the resolution behavior is a little different from that of legs.  Instead of indicating that the wing resolution should continue in the [arm](/docs/glossary/arm/) itself, an [arm](/docs/glossary/arm/) name indicates that the resolution should continue in the parent [core](/docs/glossary/core/) of the [arm](/docs/glossary/arm/).

So the meaning of `two.double.c` is, roughly, '`two` in the parent [core](/docs/glossary/core/) of `double` in `c`'.  Of course, Hoon doesn't know that `double` is an [arm](/docs/glossary/arm/) until the search for it ends; but once the `double` [arm](/docs/glossary/arm/) is found, Hoon continues the resolution from _the parent [core](/docs/glossary/core/) of_ `double`, not `double` itself.  It turns out in this case that this is a redundant step.  `c` is the parent [core](/docs/glossary/core/) and was already in the wing path.  We can illustrate redundancy more dramatically:

```
> double.two.sum.two.double.inc.c
246

> two.double.two.sum.two.double.inc.c
2

> sum.two.double.two.sum.two.double.inc.c
99
```

In each of the following examples, the only wings that matter are `c` and whichever [arm](/docs/glossary/arm/) name is left-most in the expression.  The other [arm](/docs/glossary/arm/) names in the path simply resolve to their parent [core](/docs/glossary/core/), which is just `c`.

### The `..arm` Syntax

Let's say you have a wing that resolves to a leg of the subject.  In this wing is an [arm](/docs/glossary/arm/) name, e.g., `a.b.arm`.  As you learned in lesson 1.4, this should be read as '`a` in `b` in the parent [core](/docs/glossary/core/) of `arm`'.  Speaking more directly: the wing resolution path goes through the parent [core](/docs/glossary/core/) of the [arm](/docs/glossary/arm/), not the [arm](/docs/glossary/arm/) itself.

Recall that using `.` by itself returns the whole subject.  With that in mind, take a moment to answer the following question on your own.  In general, what should the expression `..arm` produce?

Do you have an answer?  If not, consider going back and trying to figure it out before moving on.

You may read `..arm` as '`.` of the parent [core](/docs/glossary/core/) of `arm`'.  This amounts to just the parent [core](/docs/glossary/core/) of `arm`.  Let's try this out with the [arms](/docs/glossary/arm/) of `c`:

```
> ..inc:c
< 4.han
  { {our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> c
< 4.han
  { {our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

Yes, they match.  `..inc` of `c` is just the parent [core](/docs/glossary/core/) of `inc`, `c` itself.  But why would we ever use `..inc` to refer to `c`?  It's much simpler to use `c`.

Sometimes the `..arm` syntax is quite useful.  Often there is a [core](/docs/glossary/core/) in the subject without a face bound to it; i.e., the [core](/docs/glossary/core/) might be nameless.  In that case you can use an [arm](/docs/glossary/arm/) name in that [core](/docs/glossary/core/) to refer to the whole [core](/docs/glossary/core/).

For an example of this, consider the `add` [arm](/docs/glossary/arm/) of the Hoon standard library.  This [arm](/docs/glossary/arm/) is in a nameless [core](/docs/glossary/core/).  To see the parent [core](/docs/glossary/core/) of `add`, try `..add`:

```
> ..add
<74.dbd 1.qct $141>
```

Here you see a [core](/docs/glossary/core/) with a [battery](/docs/glossary/battery/) of 74 [arms](/docs/glossary/arm/) (!), and whose [payload](/docs/glossary/payload/) is another [core](/docs/glossary/core/) with one [arm](/docs/glossary/arm/).


### Evaluating an Arm Against a Modified Core

Assume `this.is.a.wing` is a wing that resolves to an [arm](/docs/glossary/arm/).  You can use the `this.is.a.wing(face new-value)` syntax to compute the [arm](/docs/glossary/arm/) against a modified version of the parent [core](/docs/glossary/core/) of `this.is.a.wing`.

```
> double.c(a 55)
110

> inc.c(a 55)
56
```

This almost looks like a function call of sorts.


### Cores, Gates, and Traps

Let's take a quick look at the [battery](/docs/glossary/battery/) of one [core](/docs/glossary/core/) in the dojo to show that this is true by inputting one into the dojo.

```
> =dec |%
  ++  dec
    |=  a=@
    ?<  =(0 a)
    =+  b=0
    |-  ^-  @
    ?:  =(a +(b))  b
    $(b +(b))
  --
```

This [core](/docs/glossary/core/) has one [arm](/docs/glossary/arm/) `dec` which implements decrement. If we look at the head of the [core](/docs/glossary/core/) we'll see the Nock.

```
> -:dec
[ 8
  [1 0]
  [ 1
    6
    [5 [1 0] 0 6]
    [0 0]
    8
    [1 0]
    8
    [1 6 [5 [0 30] 4 0 6] [0 6] 9 2 10 [6 4 0 6] 0 1]
    9
    2
    0
    1
  ]
  0
  1
]
```
 
Again, being able to read Nock is not essential to understanding Hoon.

### Core Nesting

Let's take a quick look at how [cores](/docs/glossary/core/) can be combined with `=>` to build up larger structures.  `=>  p=hoon  q=hoon` allows you to take the product of `q` with the product of `p` taken as the subject.

```hoon
=>
|%
++  foo
  |=  a=@
  (mul a 2)
-- 
|%
++  bar
  |=  a=@
  (mul (foo a) 2)
--
```
In this [core](/docs/glossary/core/), `foo` is in the subject of `bar`, and so `bar` is able to call `foo`. On the other hand, `bar` is not in the subject of `foo`, so `foo` cannot call `bar` - you will get a `-find.bar` error.

Let's take a look inside of `hoon.hoon`, where the standard library is located, to see how this is being used.

The first [core](/docs/glossary/core/) listed here has just one [arm](/docs/glossary/arm/).
```hoon
|%
++  hoon-version  141
--
```
This is reflected in the subject of `hoon-version`.
```
> ..hoon-version
<1.ane $141>
```

After several lines that we'll ignore for pedagogical purposes, we see
```hoon
|%
::  #  %math
::    unsigned arithmetic
+|  %math
++  add
  ~/  %add
  ::  unsigned addition
  ::
  ::  a: augend
  ::  b: addend
  |=  [a=@ b=@]
  ::  sum
  ^-  @
  ?:  =(0 a)  b
  $(a (dec a), b +(b))
::
++  dec
```
and so on, down to
```hoon
++  unit
  |$  [item]
  ::    maybe
  ::
  ::  mold generator: either `~` or `[~ u=a]` where `a` is the
  ::  type that was passed in.
  ::
  $@(~ [~ u=item])
--
```
This [core](/docs/glossary/core/) contains the [arms](/docs/glossary/arm/) in parts [1a-1c of the standard library documentation](@/docs/reference/library/1a.md). If you count them, there are 41 [arms](/docs/glossary/arm/) in the [core](/docs/glossary/core/) from `++  add` down to `++  unit`. We again can see this fact reflected in the Dojo by looking at the subject of `add`.
```
> ..add
<41.mac 1.ane $141>
```
Now though, we see that the section 1 [core](/docs/glossary/core/) is contained within the [core](/docs/glossary/core/) containing `hoon-version`.

Next, [section two](@/docs/reference/library/2a.md) starts:
```
=>
::                                                      ::
::::  2: layer two                                      ::
```
...
```
|%
::                                                      ::
::::  2a: unit logic                                    ::
  ::                                                    ::
  ::    biff, bind, bond, both, clap, drop,             ::
  ::    fall, flit, lift, mate, need, some              ::
  ::
++  biff                                                ::  apply
  |*  {a/(unit) b/$-(* (unit))}
  ?~  a  ~
  (b u.a)
```
If you counted the [arms](/docs/glossary/arm/) in this [core](/docs/glossary/core/) by hand, you'll come up with 126 [arms](/docs/glossary/arm/). This is also reflected in the dojo:
```
> ..biff
<126.xjf 41.mac 1.ane $141>
```
and we also see the section 1 [core](/docs/glossary/core/) and the [core](/docs/glossary/core/) containing `hoon-version` in the subject.

We can also confirm that `add` is in the subject of `biff`
```
> add:biff
<1.vwd {{a/@ b/@} <41.mac 1.ane $141>}>
```
and that `biff` is not in the subject of `add`.
```
> biff:add
-find.biff
```

Lastly, let's check the subject of the last [arm](/docs/glossary/arm/) in `hoon.hoon` (as of November 2019)
```
> ..pi-tell
<92.nnn 247.tye 51.mvt 126.xjf 41.mac 1.ane $141>
```
This confirms for us, then, that `hoon.hoon` consists of six nested [cores](/docs/glossary/core/), with the `hoon-version` [core](/docs/glossary/core/) at the top.

#### Exercise 1.7a
Pick a couple of [arms](/docs/glossary/arm/) in `hoon.hoon` and check to make sure that they are only referenced in the layer they exist in or a deeper layer. This is easily accomplished with `Ctrl-F`.

## Casts

Once again we remind you it's a good idea when writing your code to cast your data structures often. The Hoon type inferencer is quite naive and while it will often correctly understand what you mean, manually casting can be beneficial both for someone reading the code and for helping you debug problems.

## Summary

At this point you should have a pretty good understanding of what an [arm](/docs/glossary/arm/) is, and how wing resolution to an [arm](/docs/glossary/arm/) works.  But so far the [arms](/docs/glossary/arm/) you've created have been fairly simple.  In the next lesson you'll learn about Hoon functions, and how to create your own.

You can now unbind `c` in the dojo -- this will help to keep your dojo subject tidy:

```
> =c

> c
-find.c
```
