+++
title = "Even"
weight = 8
template = "doc.html"
+++

Write a generator that takes an integer and checks if it even and between 1 and 100.

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

On the very first line, with `:-  %say` we are beginning to create a generator of the `%say` kind. The result of a `%say` generator is a cell with a head of `%say` and tail that is a gate, itself producing a `cask`, a pair of a `mark` and some data. For more information about `%say` generators, see the [Generators](/using/generators) documentation.

```
|=  [* [n=@ud ~] ~]
```

The code above builds a gate. The gate's first argument is a cell provided by Dojo that contains some system information we're not going to use, so we use `*` to indicate "any noun." The next cell is our arguments provided to the generator upon invocation at the `dojo`. Here we only want one `@ud` with the face `n`.

```
:-  %noun
```

This code is the third line of the `%say` "boilerplate," and it produces a `cask` with the head of `%noun`. We could use any `mark` here, but `%noun` is the most generic type, able to fit any data.

Below we'll examine the the series of `?` runes used.

```
?:  ?&  =(0 (mod n 2))
```

`?:` is the simplest "wut" rune. It takes three expressions: a boolean test, a yes-branch, and a no-branch. The yes-branch is executed when the test evaluates to `%.y` and the no-branch is executed when the test evaluates to `%.n`. Here the yes-branch is `%.y` and the no-branch is `%.n`. The boolean test is the more complicated portion. First we're going to use `?&` to combine to expressions with a logical and operation.

The first expression is:

```
=(0 (mod n 2))
```

which simply asks if `n` is even or not.

The second expression is:

```
        ?&  (gte n 1)
            ?!  (gth n 100)
        ==
```

Again we use the "and" operator on two expressions with `?&` the first is just checking if n is greater than or equal to 1. The second we have artificially use the `?!` rune to demonstrate its use. `?!` is a logical NOT operation. We use that on the result of asking if n is greater than 100 to effectively ask if it is less than or equal to 100.
