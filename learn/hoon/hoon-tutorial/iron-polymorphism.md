+++
title = "2.5.1 Walkthrough: Iron Polymorphism and Wet Polymorphism"
weight = 32
template = "doc.html"
+++

Polymorphism is a programming concept that allows a a piece of code to use different types at different times. It's a common technique in most languages to make code that can be reused for many different situations, and Hoon is no exception. Let's take a look at a gate from the Hoon standard library as an example; we'll be passing a few different types in. The code below is an excerpt from `hoon.hoon` and, as such, will not run as-is by itself.

`fold` is a _wet_ gate that takes two arguments and produces a _dry_ gate. But what are wet and dry gates?

A dry gate (also simply a _gate_) is the kind that you're already familiar with by now: a one-armed core with a sample. A wet gate is also a one-armed core with a sample, but there is a difference. With a dry gate, when you pass in an argument and the code gets compiled, the type system will try to cast to the type specified by the gate; if you pass something that does not fit in the specified type, for example a `cord` instead of a `cell` you will get a nest failure. On the other hand, when you pass arguments to a wet gate, their types are preserved and type analysis is done at the definition site of the gate -- in our case, `fold` in `hoon.hoon` -- rather than the call site.

```hoon
++  fold  
   |*  [state=mold elem=mold]
   |=  [[st=state xs=(list elem)] f=$-([state elem] state)]
   ^-  state
   |-
   ?~  xs  st
   $(xs t.xs, st (f st i.xs))
```

On the first line of the arm, we use `|*` to create a wet gate, with two arguments: `state` and `elem`. These arguments are both `mold`s; that is to say, they are type definitions. We use this to define the types used in the dry gate.

```hoon
|=  [[st=state xs=(list elem)] f=$-([state elem] state)]
```

Here we begin to define our dry gate. The first thing the dry gate takes is a cell, `[st=state xs=(list elem)]`. `state` is the type we passed in first to our wet gate, and will be the type that is produced by the dry gate. `st` is a value of type `state` that will be used as an accumulator, and will be the final value returned when the dry gate is called.

The second argument is `f=$-([state elem] state)`. `$-` is a rune that takes two type arguments, `[state elem]` and `state` in this case, and produces a `mold` of a gate that maps from the first type operand to the second. This will match a gate we provide `fold` for how to map from both the `state`.

The rest of the dry gate is straightforward:

```hoon
   ^-  state
   |-
   ?~  xs  st
   $(xs t.xs, st (f st i.xs))
```

We ensure the output is of type `state`. Then we check if `xs`, the list, is empty. If it is, we return `st`. Otherwise, we call `f` on `i.xs`, the head of the list, and set `xs` to be the tail of the list and repeat.

Lets look at two examples of using `fold`.

```hoon
%+  (fold (list @) @)
 :-  ~
 ~[1 2 3 4]
|=  [s=(list @) e=@]
:_  s
(add 2 e)
```

Here we have a call to `fold` that we can see will produce a `(list @)` from a list of `@`. The first argument is a cell of `~` and `~[1 2 3 4]`.


The gate will simply add two to each element `e` and append that to the front of `s`. Let's run this in the `dojo`:

```hoon
> %+  (fold (list @) @)
   :-  ~
   ~[1 2 3 4]
  |=  [s=(list @) e=@]
  :_  s
  (add 2 e)
~[6 5 4 3]

~zod:dojo>
```

The list is in reverse order simply because it's easier to add to the front of a list than the end. If you needed it in the same order, you could just `flop` it.

But `fold` does not have to produce a `list`. Let's look at another example:


```hoon
%+  (fold @ @)
  [0 ~[1 2 3 4]]
|=  [s=@ e=@]
(add e s)
```


Here `fold` will produce a gate that takes an `atom` and applies a gate to a `list` of `atoms`. The difference here is that this call will produce a sum of the elements of the list, rather than the list itself.

The key takeaway from both of these examples is that the gates provided are _iron polymorphic_ with respect to the definition of the type in `fold`. They are iron polymorphic because samples `s` and `e` nest under the types `state` and `elem`. In second case case, that's because when we provided those to `fold`, it was was stated they were `@` and `@`. In the first case, we stated that `state` was `(list @)` and `elem` was `@`. In both cases, the sample of each gate nest inside the types defined when we called the wet gate `fold`.


[Next Up: Walkthrough -- Lead Polymorphism](../lead-polymorphism)
