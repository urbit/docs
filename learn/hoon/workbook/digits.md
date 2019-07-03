+++
title = "Digits"
weight = 4
template = "doc.html"
+++
Let's write a generator that takes a `@ud` (unsigned decimal) and returns a list
of its digits.

```
!:
:-  %say
|=  [* [n=@ud ~] ~]
:-  %noun
=|  lis=(list @ud)
|-  ^+  lis
?:  (lte n 0)
  lis
%=  $
  n    (div n 10)
  lis  (mod n 10)^lis
==
```

We're creating a [`%say` generator](@/docs/learn/hoon/hoon-tutorial/generators.md). That means we
need some "boilerplate" code in the format of `[%say [%noun "data"]]`:

```
:-  %say
|=  [* [n=@ud ~] ~]
:-  %noun
```

The head of this cell is the literal `%say`.

In the tail is the gate and its sample: `|=  [* [n=@ud ~] ~]`. This is
where we describe any arguments we are expecting to be passed in when the
generator is called. We are expecting data of type `@ud`. We give the data the
face `n` so that we can easily reference it later.

Also in the tail is another `cell`, its head indicating to the `dojo` how to
print the value we are creating. In this case, we use the generic `%noun`.

The tail of our second cell is the product of the rest of the program.

```
=|  lis=(list @ud)
```

We use the above code to construct a `list` of `@ud` by cutting up the `@ud` we
got passed and so we add a face onto that type. This list is empty until we
manipulate it further.

```
|-  ^+  lis
?:  (lte n 0)
  lis
```

`|-` creates a gate that functions as a recursion point.

We are actually able to reuse `lis` for the type of output that we are going
to produce. A sibling of the `^-` rune, `^+` is distinct because it is for
casting _by example_. It takes type information from an _instance_ of that type.
It's useful when using a complicated type.

```
?:  (lte n 0)
  lis
```

`?:` checks if the statement that follows is true or false. In our case, if it's
true that `n` is less than or equal to `0`, we simply return `lis`. Otherwise,
we branch to the following operations:

```
%=  $
  n    (div n 10)
  lis  (mod n 10)^lis
==
```

`%=` is the rune that takes a wing with any number changes, in the
form of a list. Our list has two elements that represent such changes, contained
in a `$` expression to perform recursion. This is the tall form of an equivalent
syntax that you may be more familiar with:
`$(n (div n 10), lis (mod n 10)^lis)`.

The first change divides `n` by `10`, rounding down without a remainder, and
assigning that product as the new value for `n`.

The second change prepends the remainder of `n` divided `10` to `lis` (`x^y` is
an alternative syntax for `[x y]`). `mod` performs the modulo operation.

Together, these operations will pull each digit out of `n` and put it into a
`list`. That's because dividing `n` by 10 will knock off one decimal place from
the value, and `mod` will store the actual discarded digit. To visualize this
complementarity, let's run some operations in the dojo:

```
> (div 146 10)
14

> (mod 146 10)
6
```

* TODO What if we do this with vases? Can we accept a vase, map it to whatever
the correct value would be to extract each digit of the number in whatever base
we are interpreting it in?

* TODO from Rob: we need a few exercises here. Maybe asking the reader to
make one that accepts a vase could be one?
