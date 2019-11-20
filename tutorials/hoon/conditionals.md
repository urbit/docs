+++
title = "1.3.1 Walkthrough: Conditionals"
weight = 5
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/conditionals/"]
+++

In this lesson, we will write a generator that takes an integer and checks if it is an even number between 1 and 100. This will help demonstrate how boolean (true or false) conditional expressions work in Hoon.

```hoon
:-  %say
|=  [* [n=@ud ~] ~]
:-  %noun
^-  ?
?&
    =(0 (mod n 2))
    (gte n 1)
    (lte n 100)
==
```

On the very first line, with `:-  %say` we are beginning to create a generator of the `%say` variety. The result of a `%say` generator is a cell with a head of `%say` and tail that is a gate, itself producing a `cask`, a pair of a `mark` and some data. It's not important for understanding conditionals; this is just template code. For more information about `%say` generators, see the [Generators](@/docs/tutorials/hoon/generators.md) documentation.

```hoon
|=  [* [n=@ud ~] ~]
```

The code above builds a gate. The gate's first argument is a cell provided by Dojo that contains some system information we're not going to use, so we use `*` to indicate "any noun." The next cell is our arguments provided to the generator upon invocation at the `dojo`. Here we only want one `@ud` with the face `n`.

```hoon
:-  %noun
```

This code is the third line of the `%say` "boilerplate," and it produces a `cask` with the head of `%noun`. We could use any `mark` here, but `%noun` is the most generic type, able to fit any data.

```hoon
^-  ?
```
This line casts the output as a `flag`, which is a type whose values are `%.y` and `%.n` representing "yes" and "no". These behave as boolean values.

Let's look at the conditional.

```hoon
?&
```

`?&` (pronounced "wut-pam") takes in a list of Hoon expressions terminated by `==` that evaluate to a `flag` and returns the logical "AND" of these `flag`s. Most runes take a fixed number of children, but the handful that do not (such as `?&`) end their list of children with a terminating rune. In our context, that means that if the product of each of the children of `?&` is `%.y`, then the product of the entire `?&` expression is `%.y` as well. Otherwise, the product of the conditional `?&` is `%.n`.

The first child of `?&` is the following.

```hoon
=(0 (mod n 2))
```

This checks to see if `0` is equal to `(mod n 2)` and returns a `flag`. In other words, it produces `%.y` if `n` is even and `%.n` if `n` is odd.

Next we have:
```hoon
(gte n 1)
```
This utilizes the standard library function `gte` which stands for "greater than or equal to". `(gte a b)` returns `%.y` if `a` is greater than or equal to `b`, and `%.n` otherwise.

```hoon
(lte n 100)
```
`lte` is the standard library function for "less than or equal to". `(lte a b)` returns `%.y` if `a` is less than `b`, and `%.n` otherwise.

```hoon
==
```
This terminates the list of children of `?&`.


`?:` (pronounced "wut-pam") is the simplest "wut" rune. It takes three children, also called sub-expressions. The first child is a boolean test, which means that it looks for a `%.y` ("yes") or a `%.n` ("no."). The second child is a yes-branch, which is what we arrive at if the aforementioned boolean test evaluates to `%.y`. The third child is a no-branch, so we arrive at it if instead the boolean test evaluates to `%.n`. These branches can contain any sort of Hoon expression, including further conditional expressions, as we will see.

In our case, the first child of `?:` is `?&  =(0 (mod n 2))`. It itself has another conditional rune, `?&` ("wut-pam"), which performs the logical "and" operation on its two children, making sure that both of them are true. The first child of our `?&` rune is `=(0 (mod n 2))`, which simply asks if `n` is even or not.

The second child is:

```hoon
        ?&  (gte n 1)
            ?!  (gth n 100)
        ==
```

Its first child is another `?&` rune. This second "and" rune checks for the truth of the following two expressions: `(gte n 1)`, meaning "n is greater than or equal to one"; and `?!  (gth n 100),` which means "n is not greater than 100".

`?!` ("wut-zup") is the logical "not" operator, which inverts the truth value of its single child. We would normally use simpler code here to do the same thing: `(lte n 100)`, without the `?!` rune. We're just using this rune artificially to demonstrate its use to the reader. The `==` runes close the `?&` runes, since `?&` runes can take an unlimited number of children.

So the two `?&` runes that we used in this code together check the that all three of these different expressions evaluate to true: `=(0 (mod n 2))`, `(gte n 1)`, and `?!  (gth n 100)`. If all of these expressions evaluate to true, our original `?:` expression branches to the `%.y` we wrote on the second-to-last line; if one or more evaluates to false, it branches to the `%.n` on the final line. Try to visualize how this works by looking through the program and examining the indentation.

### Other Runes

We only utilized one "wut" rune in our walkthrough, but there are many others. Here are a few more examples:

- `?:` (pronounced "wut-pam") is the simplest "wut" rune. It takes three children, also called sub-expressions. The first child is a boolean test, so it looks for a `%.y` or a `%.n`. The second child is a yes-branch, which is what we arrive at if the aforementioned boolean test evaluates to `%.y`. The third child is a no-branch, which we arrive at if the boolean test evaluates to `%.n`. These branches can contain any sort of Hoon expression, including further conditional expressions. Instead of the `?&` expression in our `%say` generator above, we could have written

```hoon
?:  ?& 
        =(0 (mod n 2))
        (gte n 1)
        (lte n 100)
    ==
    %.y
%.n
```
Of course, doing so would be needlessly obfuscating - we mention this only to illustrate that these two Hoon expressions have the same product.

- `?!` ("wut-zup") is the logical "NOT" operator, which inverts the truth value of its single child. Instead of `(lte n 100)` in our `%say` generator above, we could have written `?!  (gth n 100)`. Again, this would be bad practice, we only present this as an example.

- `?@` takes three children. It branches on whether its first child is an atom.

- `?^` takes three children. It branches on whether its first child is a cell.

- `?~` takes three children. It branches on whether its first child is null.

- `?|` takes an indefinite number of children. It's the logical "or" operator. It checks if at least one of its children is true.

To see an exhaustive list of "wut" runes, check out the [reference documentation on conditionals](@/docs/reference/hoon-expressions/rune/wut.md).
