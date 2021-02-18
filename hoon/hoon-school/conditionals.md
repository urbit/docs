+++
title = "1.3.1 Walkthrough: Conditionals"
weight = 5
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/conditionals/"]
+++

In this lesson, we will write a generator that takes an integer and checks if it is an even number between `1` and `100`. This will help demonstrate how boolean (`true` or `false`) conditional expressions work in Hoon.

```hoon
:-  %say
|=  [* [n=@ud ~] ~]
:-  %noun
^-  ?
?&  (gte n 1)
    (lte n 100)
    =(0 (mod n 2))
==
```

On the very first line, with `:-  %say` we are beginning to create a generator of the `%say` variety. The result of a `%say` generator is a cell with a head of `%say` and tail that is a [gate](/docs/glossary/gate/), itself producing a `cask`, a pair of a `mark` and some data. It's not important for understanding conditionals; this is just template code. For more information about `%say` generators, see the [Generators](@/docs/tutorials/hoon/hoon-school/generators.md) documentation.

```hoon
|=  [* [n=@ud ~] ~]
```

The code above builds a gate. The gate's first argument is a cell provided by Dojo that contains some system information we're not going to use, so we use `*` to indicate "any [noun](/docs/glossary/noun/)". The next cell is our arguments provided to the generator upon invocation at the Dojo. Here we only want one `@ud` with the face `n`.

```hoon
:-  %noun
```

This code is the third line of the `%say` "boilerplate", and it produces a `cask` with the head of `%noun`. We could use any `mark` here, but `%noun` is the most generic type, able to fit any data.

```hoon
^-  ?
```

This line casts the output as a `flag`, which is a type whose values are `%.y` and `%.n` representing "yes" and "no". These behave as boolean values (`true` or `false`).

Let's look at the conditional:

```hoon
?&  (gte n 1)
```

`?&` (pronounced "wut-pam") takes in a list of Hoon expressions, terminated by `==`, that evaluate to a `flag` and returns the logical "AND" of these flags. Most runes take a fixed number of children, but the handful that do not (such as `?&`) end their list of children with a terminating rune. In our context, that means that if the product of each of the children of `?&` is `%.y`, then the product of the entire `?&` expression is `%.y` as well. Otherwise, the product of the conditional `?&` is `%.n`.

The first child of `?&` is `(gte n 1)`. It is good practice to put the first boolean test of a conditional on the same line as the conditional, as we have done here. This utilizes the standard library function `gte` which stands for "greater than or equal to". `(gte a b)` returns `%.y` if `a` is greater than or equal to `b`, and `%.n` otherwise.

Next we have:

```hoon
    (lte n 100)
```

`lte` is the standard library function for "less than or equal to". `(lte a b)` returns `%.y` if `a` is less than `b`, and `%.n` otherwise.

The last boolean test we have is:

```hoon
    =(0 (mod n 2))
```

This checks to see if `0` is equal to `(mod n 2)` -- in other words, checking if `n` is even. It produces `%.y` if `n` is even and `%.n` if `n` is odd.

It is good practice in Hoon to put "lighter" lines at the top and "heavier" lines at the bottom, which is why we have put `=(0 (mod n 2))` last in the list of conditionals.

Finally we have a terminator:

```hoon
==
```

This marks the end of the list of children of `?&`.

### Other Runes

We only utilized one "wut" rune in our walkthrough, but there are many others. Here are a few more examples:

- `?:` (pronounced "wut-col") is the simplest "wut" rune. It takes three children, also called subexpressions. The first child is a boolean test, so it looks for a `%.y` or a `%.n`. The second child is a yes-branch, which is what we arrive at if the aforementioned boolean test evaluates to `%.y`. The third child is a no-branch, which we arrive at if the boolean test evaluates to `%.n`. These branches can contain any sort of Hoon expression, including further conditional expressions. Instead of the `?&` expression in our `%say` generator above, we could have written:

```hoon
?:  ?&  (gte n 1)
        (lte n 100)
        =(0 (mod n 2))
    ==
    %.y
%.n
```

Of course, doing so would be needlessly obfuscating -- we mention this only to illustrate that these two Hoon expressions have the same product.

- `?!` ("wut-zap") is the logical "NOT" operator, which inverts the truth value of its single child. Instead of `(lte n 100)` in our `%say` generator above, we could have written `?!  (gth n 100)`. Again, this would be bad practice, we only present this as an example.

- `?@` takes three children. It branches on whether its first child is an [atom](/docs/glossary/atom/).

- `?^` takes three children. It branches on whether its first child is a cell.

- `?~` takes three children. It branches on whether its first child is null.

- `?|` takes an indefinite number of children. It's the logical "or" operator. It checks if at least one of its children is true.

To see an exhaustive list of "wut" runes, check out the [reference documentation on conditionals](@/docs/reference/hoon-expressions/rune/wut.md).
