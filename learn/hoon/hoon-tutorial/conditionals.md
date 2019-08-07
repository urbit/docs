+++
title = "1.3.1 Walkthrough: Conditionals"
weight = 6
template = "doc.html"
+++

In this lesson, we will write a generator that takes an integer and checks if it is an even number between 1 and 100. This will help demonstrate how boolean (true or false) conditional expressions work in Hoon.

```
:-  %say
|=  [* [n=@ud ~] ~]
:-  %noun
?:  ?&  =(0 (mod n 2))
        ?&  (gte n 1)
            ?!  (gth n 100)
        ==
    ==
    %.y
%.n
```

On the very first line, with `:-  %say` we are beginning to create a generator of the `%say` variety. The result of a `%say` generator is a cell with a head of `%say` and tail that is a gate, itself producing a `cask`, a pair of a `mark` and some data. It's not important for understanding conditionals; this is just template code. For more information about `%say` generators, see the [Generators](../generators) documentation.

```
|=  [* [n=@ud ~] ~]
```

The code above builds a gate. The gate's first argument is a cell provided by Dojo that contains some system information we're not going to use, so we use `*` to indicate "any noun." The next cell is our arguments provided to the generator upon invocation at the `dojo`. Here we only want one `@ud` with the face `n`.

```
:-  %noun
```

This code is the third line of the `%say` "boilerplate," and it produces a `cask` with the head of `%noun`. We could use any `mark` here, but `%noun` is the most generic type, able to fit any data.

But now let's get into the conditionals themselves. Below we'll examine the series of `?` runes used.

```
?:  ?&  =(0 (mod n 2))
```

`?:` (pronounced "wut-col") is the simplest "wut" rune. It takes three children, also called sub-expressions. The first child is a boolean test, which means that it looks for a `%.y` ("yes") or a `%.n` ("no."). The second child is a yes-branch, which is what we arrive at if the aforementioned boolean test evaluates to `%.y`. The third child is a no-branch, so we arrive at it if instead the boolean test evaluates to `%.n`. These branches can contain any sort of Hoon expression, including further conditional expressions, as we will see.

In our case, the first child of `?:` is `?&  =(0 (mod n 2))`. It itself has another conditional rune, `?&` ("wut-pam"), which performs the logical "and" operation on its two children, making sure that both of them are true. The first child of our `?&` rune is `=(0 (mod n 2))`, which simply asks if `n` is even or not.

The second child is:

```
        ?&  (gte n 1)
            ?!  (gth n 100)
        ==
```

Its first child is another `?&` rune. This second "and" rune checks for the truth of the following two expressions: `(gte n 1)`, meaning "n is greater than or equal to one"; and `?!  (gth n 100),` which means "n is not greater than 100".

`?!` ("wut-zup") is the logical "not" operator, which inverts the truth value of its single child. We would normally use simpler code here to do the same thing: `(lte n 100)`, without the `?!` rune. We're just using this rune artificially to demonstrate its use to the reader. The `==` runes close the `?&` runes, since `?&` runes can take an unlimited number of children.

So the two `?&` runes that we used in this code together check the that all three of these different expressions evaluate to true: `=(0 (mod n 2))`, `(gte n 1)`, and `?!  (gth n 100)`. If all of these expressions evaluate to true, our original `?:` expression branches to the `%.y` we wrote on the second-to-last line; if one or more evaluates to false, it branches to the `%.n` on the final line. Try to visualize how this works by looking through the program and examining the indentation.

### Other Runes

We only went into three "wut" runes in our walkthrough, but there are many others. Here are a few more examples:

- `?@` takes three children. It branches on whether its first child is an atom.

- `?^` takes three children. It branches on whether its first child is a cell.

- `?~` takes three children. It branches on whether its first child is null.

- `?|` takes an indefinite number of children. It's the logical "or" operator. It checks if at least one of its children is true.

To see an exhaustive list of "wut" runes, check out the [reference documentation on conditionals](/docs/reference/hoon-expressions/rune/wut/).

### [Next Up: Reading -- Lists](../lists)
