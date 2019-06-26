+++
title = "Iron Polymorphism and Wet Polymorphism: ++fold Walkthrough"
weight = 0
template = "doc.html"
+++

Polymorphism, the ability to have some piece of code use different types a different times, is a common technique used in many languages to create reusable code. Hoon also has polymorphism, though it is different from what you have probably experienced. Let us example a gate from the Hoon standard library as an example of a few types. This is an excerpt from `hoon.hoon` and as such, will not run as is by itself. 


```
++  fold
   |*  [state=mold elem=mold]
   |=  [[st=state xs=(list elem)] f=$-([state elem] state)]
   ^-  state
   |-
   ?~  xs  st
   $(xs t.xs, st (f st i.xs))
```

`fold` is a wet gate that takes two arguments and produces a dry gate. What are wet and dry gates? A dry gate is the kind you have seen and written previously to this, a one armed core with a sample. A wet gate is also a one armed core with a sample but there is a difference. With a dry gate, when you pass in an argument and the code gets compiled the type system will try to cast to the type specified by the gate. If you pass something that does not fit in the specified type, for example a `cord` instead of a `cell` you will get a nest failure. On the other hand, when you pass arguments to a wet gate, their types are preserved and type analysis is done at the definition site of the gate rather than the call site. This can lead to some confusing errors so be aware of that when using wet gates.

`state` and `elem` are both `mold` that is to say they are type definitions. We actually use this to define the types used in the dry gate. 

```
|=  [[st=state xs=(list elem)] f=$-([state elem] state)]
```

The first thing this gate takes is a cell `[st=state xs=(list elem)]`. `state` is the type we passed in first to our wet gate, and will be the type that is produced by the dry gate. `st` is a value of type `state` that will be used as an accumulator of some sort and will be the final value returned when the dry gate is called.

The second argument is `f=$-([state elem] state)`. `$-` is a rune that takes two type operands `[state elem]` and `state` and produces a `mold` of gate that maps from the first type operand to the second. This will match a gate we provide `fold` for how to map from both the `state`. 

The rest of the gate is very straightforward.

```
   ^-  state
   |-
   ?~  xs  st
   $(xs t.xs, st (f st i.xs))
```

We ensure the output is of type `state`, check if `xs`, the list is empty, if it is we return st, otherwise we call `f` on `i.xs`, the head of the list, and set `xs` to be the tail of the list and repeat.

Lets look at two examples of using `fold`.

```
%+  (fold (list @) @)
 :-  ~
 ~[1 2 3 4]
|=  [s=(list @) e=@]
:_  s
(add 2 e)
```

Here we have a call to `fold` that we can see will produce a `(list @)` from a list of `@`. The first argument is a cell of `~` and `~[1 2 3 4]`.

The gate will simply add two to each element `e` and append that to the front of `s`. If we run this in the `dojo`

```
> %+  (fold (list @) @)
   :-  ~
   ~[1 2 3 4]
  |=  [s=(list @) e=@]
  :_  s
  (add 2 e)
~[6 5 4 3]
~zod:dojo> 
```

The list is in reverse order simply because it's easier to add to the front of a list than the end. If you needed it in the same order you could simply `flop` it.

But `fold` does not have to produce a `list`. Let's look at another example.

```
%+  (fold @ @)
  [0 ~[1 2 3 4]]
|=  [s=@ e=@]
(add e s)
```

Here `fold` will produce a gate that takes an `atom` and applies a gate to a `list` of `atoms`. The difference here is that this call will produce a sum of the elements of the list. 

The key thing to take away from both of these examples is that the gates provided are iron polymorphic with the definition of the type in `fold`. Their samples next under one another, `s` and `e` nest under the types `state` and `elem` in this case because when we provided those to `fold` was stated they were `@` and `@`. In the first case, we stated that `state` was `(list @)` and `elem` was `@`. In both cases the sample of each gate nest inside the types defined when we called the wet gate `fold`.