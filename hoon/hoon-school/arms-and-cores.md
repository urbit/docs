+++
title = "1.7 Arms and Cores"
weight = 15
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/arms-and-cores/"]
+++

The Hoon subject is a [noun](/docs/glossary/noun/). Each fragment of this [noun](/docs/glossary/noun/) is either an [arm](/docs/glossary/arm/) or a leg. In the previous lesson you learned what a leg is, and how to return legs of the subject by various means. In this lesson you'll learn what an [arm](/docs/glossary/arm/) is. Arms are a bit more complex than legs -- a full understanding of them requires a bit more background knowledge. Accordingly, in this lesson we must also introduce an important Hoon data structure: a '[core](/docs/glossary/core/)'.

After arms are defined and explained we review wing expressions, this time focusing on wing resolution to arms.

## A Preliminary Explanation

Arms and legs are limbs of the subject, i.e., noun fragments of the subject. In the last lesson we said that legs are for data and arms are for computations. But what _specifically_ is an arm, and how is it used for computation? Let's begin with a preliminary explanation that will be refined later in the lesson.

An **arm** is some expression of Hoon encoded as a noun. (By 'encoded as a noun' we literally mean: 'compiled to a Nock formula'. But you don't need to know anything about Nock to understand Hoon.) You virtually never need to treat an arm as raw data, even though technically you can -- it's just a noun like any other. You virtually always want to think of an arm simply as a way of running some Hoon code.

Every expression of Hoon is evaluated relative to a subject. What subject is the arm to be evaluated against? Answer: the parent [core](/docs/glossary/core/) of that arm.

So in order to understand fully what an arm is, you must understand what a core is. Briefly, a **core** is a cell of `[battery payload]`. The **battery** is a collection of one or more arms, and the **payload** is the data needed by the arms to evaluate correctly. (The battery is code and the [payload](/docs/glossary/payload/) is data for that code.) A given core is the **parent core** of all of the arms in its battery.

## Your First Core

To clarify the basic idea, let's look at an example core.

We'll make a core using a multi-line Hoon expression that is more complex than the other examples you've seen up to this point. The dojo can be used to input multi-line Hoon expressions; just type each line, hitting 'enter' or 'return' at the end. The expression will be evaluated at the appropriate line break, i.e., when the dojo recognizes it as a complete expression of Hoon.

Use the following to bind `c` to a core. It begins with a **rune**, `|%`, which is used for creating a core. (A rune is just a pair of ASCII characters, and it usually indicates the beginning of a complex Hoon expression.) Take note of the expression spacing -- Hoon uses significant whitespace. Feel free to cut and paste the following expression into the dojo, starting with `=c`:

```hoon
> =c |%
  ++  twenty  20
  ++  double-twenty  (mul 2 twenty)
  --
```

This core has two arms, `twenty` and `double-twenty`. Each arm definition begins with `++` followed by the name of that arm. After that is the Hoon expression associated with that arm. The first expression is the trivial `20` (guess what that does?), and the second is the slightly more interesting `(mul 2 twenty)`.

You can run these arms using `twenty.c` and `double-twenty.c`:

```hoon
> twenty.c
20

> double-twenty.c
40
```

Notice that the second arm, `double-twenty`, makes use of the first arm, `twenty`. It's able to do so because each arm is evaluated with its parent core as the subject. Hence, each arm is able to use any other arm inside the parent core's battery.

### `|%` Expressions

Before moving on let's talk about what each part of the `|%` expression is for.

The `|%` indicates the beginning of an expression that produces a core. The `++` rune is used to define each of the arms of the core's battery, and is followed by both an arm name and a Hoon expression. The `--` rune is used to indicate that there are no more arms to be defined, and indicates the end of the expression.

The battery of the core to be produced is explicitly defined by the `|%` expression. The payload of the core to be produced is implicitly defined as the subject of the `|%` expression. Let's unbind `c` to keep the subject clean:

```hoon
> =c
```

## Cores

Let's go over what a core is a little more carefully and comprehensively. As stated before, a **core** is a cell of a **battery** and a **payload**.

```
A core:  [battery payload]
```

### Battery

A battery is a collection of arms. An arm is an encoded Hoon expression, to be used for running computations. Each arm has a name. Arm naming rules are the same kebab-case rules that faces have. When an arm is evaluated, it uses its parent core as the subject.

That's all you really need to know about the battery. You can become a master Hoon programmer if you know what is stated above but otherwise think of the battery as a black box.

If you'd really like to know, technically a battery is a tree of Nock formulas, one formula per each arm. Again, however, you don't need to understand the first thing about Nock to understand Hoon.

### Payload

The payload contains all the data needed for running the arms in the battery correctly. In principle, the payload of a core can have data arranged in any arbitrary configuration. In practice, the payload often has a predictable structure of its own.

The payload may include other cores. Consequently, a core's payload can include other 'code' -- cores in the payload have their own battery arms.

### Subject Organization for Arm Computation

Why must an arm have its parent core as the subject, when it's computed? As stated previously, the payload of a core contains all the data needed for computing the arms of that core. Arms can only access data in the subject. By requiring that the parent core be the subject we guarantee that each arm has the appropriate data available to it. The tail of its subject contains the payload and thus all the values therein. The head of the subject is the battery, which allows for making reference to sibling arms of that same core.

Let's look at an example in which the payload information is needed for correct arm evaluation.

## Another Example Core

First let's use the dojo to bind the face `a` to the value `12`, and the face `b` to the value `[22 24]`. These values will be used in the arms of the core we're going to make.

```hoon
> =a 12

> =b [22 24]
```

Now use the following multi-line expression to bind `c` to a core. As before, feel free to cut and paste the following expression into the dojo (starting at `=c`):

```hoon
> =c |%
  ++  two  2
  ++  inc  (add 1 a)
  ++  double  (mul 2 a)
  ++  sum  (add -.b +.b)
  --
```

Note: binding `c` to the core created by the `|%` expression will fail unless you have already bound `a` and `b` to the relevant values, as we did above. Our having already bound them is what lets us use them in the `|%` expression.

The `|%` expression above creates a core with four arms. The first, named `two`, evaluates to the constant `2`. The second arm, `inc`, adds `1` to `a`. `double` returns double the value of `a`, and `sum` returns the sum of the two [atoms](/docs/glossary/atom/) in `b`. The computations defined by these arms are pretty simple (and in the case of `two`, trivial), but a good starting point for learning about cores.

Let's run the arm names in the dojo:

```hoon
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

To reiterate a point made earlier: a wing resolution to a leg returns the value of that leg. A wing resolution to an arm returns the value produced by the arm computation.

### Dissecting a Core

Enter `c` in the dojo to look at this core as printed data:

```hoon
> c
< 4.cvq
  { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>
```

`c`, like all cores, is a cell of `[battery payload]`, and it's pretty-printed inside a set of angled brackets: `< >`. The battery of four arms is represented by the pretty-printer as `4.cvq`. The `4` represents the number of arms in the battery, and the `cvq` is a [hash](https://en.wikipedia.org/wiki/Hash_function) of the battery.

The tail, i.e., the payload, might look suspiciously familiar. It looks an awful lot like the default dojo subject, which has `our`, `now`, and `eny` in the head, but it also has `a` and `b`, which we also bound in the dojo subject. That's exactly what the payload is. The tail is a copy of what the subject was for the `|%` expression. (It's pretty-printed in a slightly compressed way).

(You'll notice that there are several other cores in the payload. For example, `19.anu` is a battery of `19` arms, `24.tmo` is a battery of `24` arms, etc.)

This means, among other things, that we should be able to unbind `a` and `b` in the subject, but the arms of `c` should still work correctly:

```hoon
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

This works because `a` and `b` were copied into the core payload when the core was initially created. Unbinding them in the dojo subject doesn't matter to the arms in `c`, which only look in `c`'s payload anyway.

The payload stores all the data needed to compute the arms correctly. That also includes `add` and `mul`, which themselves are arms in a core of the Hoon standard library. This library core is available as part of the default dojo subject.

## Wings that Resolve to Arms

To reinforce your newfound understanding of arms and cores, let's go over the various ways that wings resolve to arms in cores. Remember that face resolution to a leg of the subject produces the leg value unchanged, but resolution to an arm produces the _computed_ value of that arm.

### Address-Based Wings

In the [previous lesson](@/docs/hoon/hoon-school/the-subject-and-its-legs.md), you saw how the following expressions return legs based on an address in the subject: `+n`, `.`, `-`, `+`, `+>`, `+<`, `->`, `-<`, `&`, `|` etc. When these resolve to the part of the subject containing an arm, they **don't** evaluate the arm. They simply return the indicated noun fragment of the subject, as if it were a leg.

Let's use `-.c` to look at the head of `c`, i.e., the battery of the core:

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

The result is a tree of uncomputed Nock formulas. But you virtually never need to see or use this raw data. Generally speaking, don't use address-based expressions to look at arms for any reason other than to satisfy your curiosity (and even then only if you've learned or plan to learn Nock). Use name-based expressions instead.

### Name-based Wings

To get the arm of a core to compute you must use its name. The arm names of `c` are in the expression used to create `c`:

```hoon
> =c |%
  ++  two  2
  ++  inc  (add 1 a)
  ++  double  (mul 2 a)
  ++  sum  (add -.b +.b)
  --
```

We evaluated the arms of `c` previously:

```hoon
> two.c
2

> inc.c
13

> double.c
24

> sum.c
46
```

You can also evaluate the arms of `c` using `:` instead:

```hoon
> two:c
2

> inc:c
13

> double:c
24

> sum:c
46
```

The difference between `two.c` and `two:c` is as follows. `two.c` is an instruction for finding `two` in `c` in the subject. `two:c` is an instruction for setting `c` as the subject, and then for finding `two`. In the examples above both versions amount to the same thing, and so return the same product. (There are other cases in which `two.c` and `two:c` _don't_ amount to the same thing. We'll address the difference in more detail later.)

### Name Searches and Collisions

It's possible to have 'name collisions' with faces and arm names. Nothing prevents one from using the name of some arm as a face too. For example:

```hoon
> double:c
24

> double:[double=123 c]
123
```

When `[double=123 c]` is the subject, the result is a cell of: (1) `double=123` and (2) the core `c`:

```hoon
> [double=123 c]
[ double=123
  < 4.cvq
    { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
      <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
    }
  >
]
```

Hoon doesn't know whether `double` is a face or an arm name until it conducts a search looking for name matches. If it finds a face first, the value of the face is returned. If it finds an arm first, the arm will be evaluated and the product returned. You may use `^` to indicate that you want to skip the first match, and multiple `^`s to indicate multiple skips:

```hoon
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

We can produce a modified version of the core `c` in which `a` and `b` have different values. A core is just a noun in the subject, so we can modify it in the way we learned to modify legs in the last lesson. To change `a` to `99`, use `c(a 99)`:

```hoon
> c(a 99)
< 4.cvq
  { {{a/@ud b/{@ud @ud}} our/@p now/@da eny/@uvJ}
    <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
  }
>

> a.c
12
```

The expression `c(a 99)` produces a core exactly like `c` except that the value of `a` in the payload is `99` instead of `12`. But when we evaluate `a.c` we still get the original value, `12`. Why? The value of `c` in the dojo is bound to the original core value, and will stay that way until we unbind `c` or bind it to something else. We can ask for a modified copy of `c` but that value doesn't automatically persist. It must be put into the subject if we're to find it there. So how do we know that `c(a 99)` successfully modified the value of `a`? We can check by setting the new version of the core as the subject and checking `a`:

```hoon
> a:c(a 99)
99

> double:c(a 99)
198
```

To make the modified core persist as `c`, we can rebind `c` to the new value:

```hoon
> =c c(a 99)

> a:c
99

> double:c
198
```

We can make multiple changes to `c` at once:

```hoon
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

A wing is a search path into the subject. We've looked at some examples of wings that resolve to arms; e.g., `double.c`, which resolves to `double` in `c` in the subject. In the latter example the arm `double` is the final limb in the resolution path. What if an arm name in a wing isn't the final limb? What if it's elsewhere in the wing path?

Normally we might read a wing expression like `two.double.c` as '`two` in `double` in `c`'. Does that make sense when `double` is itself an arm? Try it:

```hoon
> two.double.c
2
```

It produces the value of `two` in `c`. This is a fact in need of explanation.

When arm names are included in the body of a wing, the resolution behavior is a little different from that of legs. Instead of indicating that the wing resolution should continue in the arm itself, an arm name indicates that the resolution should continue in the parent core of the arm.

So the meaning of `two.double.c` is, roughly, '`two` in the parent core of `double` in `c`'. Of course, Hoon doesn't know that `double` is an arm until the search for it ends; but once the `double` arm is found, Hoon continues the resolution from _the parent core of_ `double`, not `double` itself. It turns out in this case that this is a redundant step. `c` is the parent core and was already in the wing path. We can illustrate redundancy more dramatically:

```hoon
> double.two.sum.two.double.inc.c
246

> two.double.two.sum.two.double.inc.c
2

> sum.two.double.two.sum.two.double.inc.c
99
```

In each of the following examples, the only wings that matter are `c` and whichever arm name is left-most in the expression. The other arm names in the path simply resolve to their parent core, which is just `c`.

### The `..arm` Syntax

Let's say you have a wing that resolves to a leg of the subject. In this wing is an arm name, e.g., `a.b.arm`. As you learned in lesson 1.4, this should be read as '`a` in `b` in the parent core of `arm`'. Speaking more directly: the wing resolution path goes through the parent core of the arm, not the arm itself.

Recall that using `.` by itself returns the whole subject. With that in mind, take a moment to answer the following question on your own. In general, what should the expression `..arm` produce?

Do you have an answer? If not, consider going back and trying to figure it out before moving on.

You may read `..arm` as '`.` of the parent core of `arm`'. This amounts to just the parent core of `arm`. Let's try this out with the arms of `c`:

```hoon
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

Yes, they match. `..inc` of `c` is just the parent core of `inc`, `c` itself. But why would we ever use `..inc` to refer to `c`? It's much simpler to use `c`.

Sometimes the `..arm` syntax is quite useful. Often there is a core in the subject without a face bound to it; i.e., the core might be nameless. In that case you can use an arm name in that core to refer to the whole core.

For an example of this, consider the `add` arm of the Hoon standard library. This arm is in a nameless core. To see the parent core of `add`, try `..add`:

```hoon
> ..add
<74.dbd 1.qct $141>
```

Here you see a core with a battery of 74 arms (!), and whose payload is another core with one arm.

### Evaluating an Arm Against a Modified Core

Assume `this.is.a.wing` is a wing that resolves to an arm. You can use the `this.is.a.wing(face new-value)` syntax to compute the arm against a modified version of the parent core of `this.is.a.wing`.

```hoon
> double.c(a 55)
110

> inc.c(a 55)
56
```

This almost looks like a function call of sorts.

### Cores, Gates, and Traps

Let's take a quick look at the battery of one core in the dojo to show that this is true by inputting one into the dojo.

```hoon
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

This core has one arm `dec` which implements decrement. If we look at the head of the core we'll see the Nock.

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

### Cores and Contexts

Let's take a quick look at how cores can be combined with `=>` to build up
larger structures. `=> p=hoon q=hoon` yields the product of `q` with the product of `p` taken as the subject.

We can use this to set the context of cores. Recall that the payload of a gate
is a cell of `[sample context]`. For example:

```hoon
~zod:dojo> =foo =>([1 2] |=(@ 15))
> +3:foo
[0 1 2]
```

Here we have created a gate with `[1 2]` as its context that takes in an `@` and
returns `15`. `+3:foo` shows the payload of the core to be `[0 [1 2]]`. Here `0`
is the default value of `@` and is the sample, while `[1 2]` is the context that
was given to `foo`.

`=>` (and its reversed version `=<`) are used extensively to put cores into the
context of other cores.

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

At the level of arms, `+foo` is in the subject of `+bar`, and so `+bar` is able to call `+foo`. On the other hand, `+bar` is not in the subject of `+foo`, so `+foo` cannot call `+bar` - you will get a `-find.bar` error.

At the level of cores, the `=>` sets the context of the core containing `+bar` to be the core
containing `+foo`. Recall that arms are evaluated with the parent core as the
subject. Thus `+bar` is evaluated with the core containing it as the subject,
which has the core containing `+foo` in its context. So this is why `+foo` is in
the scope of `+bar` but not vice versa.

Let's look inside `hoon.hoon`, where the standard library is located, to see how this is being used.

The first core listed here has just one arm.

```hoon
|%
++  hoon-version  141
--
```

This is reflected in the subject of `hoon-version`.

```hoon
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

This core contains the arms in parts [1a-1c of the standard library documentation](@/docs/hoon/reference/stdlib/1a.md). If you count them, there are 41 arms in the core from `++ add` down to `++ unit`. We again can see this fact reflected in the dojo by looking at the subject of `add`.

```hoon
> ..add
<41.mac 1.ane $141>
```

Here we see that core containing `hoon-version` is in the subject of the
section one core.

Next, [section two](@/docs/hoon/reference/stdlib/2a.md) starts:

```hoon
=>
::                                                      ::
::::  2: layer two                                      ::
```

...

```hoon
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

If you counted the arms in this core by hand, you'll come up with 126 arms. This is also reflected in the dojo:

```hoon
> ..biff
<126.xjf 41.mac 1.ane $141>
```

and we also see the section 1 core and the core containing `hoon-version` in the subject.

We can also confirm that `add` is in the subject of `biff`

```hoon
> add:biff
<1.vwd {{a/@ b/@} <41.mac 1.ane $141>}>
```

and that `biff` is not in the subject of `add`.

```hoon
> biff:add
-find.biff
```

Lastly, let's check the subject of the last arm in `hoon.hoon` (as of November 2019)

```hoon
> ..pi-tell
<92.nnn 247.tye 51.mvt 126.xjf 41.mac 1.ane $141>
```

This confirms for us, then, that `hoon.hoon` consists of six nested cores, with one
inside the payload of the next, with
the `hoon-version` core most deeply nested.

#### Exercise 1.7a

Pick a couple of arms in `hoon.hoon` and check to make sure that they are only
referenced in its parent core or core(s) that have the parent core put in its
context via the `=>` or `=<` runes.

## Casts

Once again we remind you it's a good idea when writing your code to cast your data structures often. The Hoon type inferencer is quite naive and while it will often correctly understand what you mean, manually casting can be beneficial both for someone reading the code and for helping you debug problems.

## Summary

At this point you should have a pretty good understanding of what an arm is, and how wing resolution to an arm works. But so far the arms you've created have been fairly simple. In the next lesson you'll learn about Hoon functions, and how to create your own.

You can now unbind `c` in the dojo -- this will help to keep your dojo subject tidy:

```hoon
> =c

> c
-find.c
```
