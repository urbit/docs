+++
title = "1.5 Lists"
weight = 8
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/lists/"]
+++

# Lists

A **list** is a type of [noun](/docs/glossary/noun/) that you'll frequently encounter when reading and writing Hoon. A list can be thought of as an ordered arrangement of zero or more elements terminated by a `~` (null).

So a list can be either null or non-null. When the list contains only `~` and no items, it's the null list.  Most lists are, however, non-null lists, which have items preceding the `~`. Non-null lists, called _lests_, are cells in which the head is the first list item, and the tail is the rest of the list. The tail is itself a list, and if such a list is also non-null, the head of this sub-list is the second item in the greater list, and so on. To illustrate, let's look at a list `[1 2 3 4 ~]` with the cell-delineating brackets left in:

`[1 [2 [3 [4 ~]]]]`

It's easy to see where the heads are and where the nesting tails are. The head of the above list is the [atom](/docs/glossary/atom/) `1` and the tail is the list `[2 [3 [4 ~]]]`, (or `[2 3 4 ~]`). Recall that whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.

To make a list, let's cast nouns to the `(list @)` ("list of atoms") type.

```
> `(list @)`~
~

> `(list @)`[1 2 3 4 5 ~]
~[1 2 3 4 5]

> `(list @)`[1 [2 [3 [4 [5 ~]]]]]
~[1 2 3 4 5]

> `(list @)`~[1 2 3 4 5]
~[1 2 3 4 5]
```

Notice how the last Dojo command has a different construction, with the `~` in front of the bracketed items. This is just another way of writing the same thing; `~[1 2]` is semantically identical to `[1 2 ~]`.

## An aside about Casting

The use of casts in this example is helpful to explain to the Hoon compiler exactly what it is we mean with these data structures. In this case, we are telling it they are all lists of atoms. Get in the habit of casting your data structures, as it will not only help anyone reading your code, but it will help you in hunting down bugs in your code.

Let's make a list whose items are of the `@t` string type:

```
> `(list @t)`['Urbit' 'will' 'rescue' 'the' 'internet' ~]
<|Urbit will rescue the internet|>
```

The head of a list has the face `i` and the tail has the face `t`.  (For the sake of neatness, these faces aren't shown by the Hoon pretty printer.) To use the `i` and `t` faces of a list, you must first prove that the list is non-null by using the conditional family of runes, `?`:

```
> =>(b=`(list @)`[1 2 3 4 5 ~] i.b)
-find.i.b
find-fork-d

> =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ i.b))
1

> =>(b=`(list @)`[1 2 3 4 5 ~] ?~(b ~ t.b))
~[2 3 4 5]
```

It's important to note that performing tests like `?~ mylist` will actually transform `mylist` into a `lest`, a non-null list. Because `lest` is a different type than `list`, performing such tests can come back to bite you later in non-obvious ways when you try to use some standard library functions meant for `list`s.

You can construct lists of any type.  `(list @)` indicates a list of atoms, `(list ^)` indicates a list of cells, `(list [@ ?])` indicates a list of cells whose head is an atom and whose tail is a flag, etc.

## Tapes and Cords

While a list can be of any type, there are some special types of lists that are built into Hoon. The tape is the most common example.

Hoon has two kinds of strings: cords and tapes.  Cords are atoms with aura `@t`, and they're pretty-printed between `''` marks.

```
> 'this is a cord'
'this is a cord'

> `@`'this is a cord'
2.037.307.443.564.446.887.986.503.990.470.772
```

A tape is a list of `@tD` atoms (i.e., ASCII characters).

```
> "this is a tape"
"this is a tape"

> `(list @)`"this is a tape"
~[116 104 105 115 32 105 115 32 97 32 116 97 112 101]
```

You can also use the words `cord` and `tape` for casting:

```
> `tape`"this is a tape"
"this is a tape"

> `cord`'this is a cord'
'this is a cord'
```

## List Functions in the Hoon Standard Library

Lists are a commonly used data structure.  Accordingly, there are several functions in the [Hoon standard library](/docs/reference/library/) intended to make lists easier to use.

For a complete list of these functions, check out the standard library reference for lists [here](/docs/reference/library/2b/).  Here we'll look at a few of these functions.

### `flop`

The `flop` function takes a list and returns it in reverse order:

```
> (flop ~[11 22 33])
~[33 22 11]

> (flop "Hello!")
"!olleH"

> (flop (flop "Hello!"))
"Hello!"
```

#### `flop` Exercise 1.5a

Without using `flop`, write a [gate](/docs/glossary/gate/) that takes a `(list @)` and returns it in reverse order.  There is a solution at the bottom of this lesson.

### `sort`

The `sort` function uses the 'quicksort' algorithm to sort a list.  It takes a list to sort and a gate that serves as a comparator.  For example, if you want to sort the list `~[37 62 49 921 123]` from least to greatest, you would pass that list along with the `lth` gate (for 'less than'):

```
> (sort ~[37 62 49 921 123] lth)
~[37 49 62 123 921]
```

To sort the list from greatest to least, use the `gth` gate ('greater than') as the basis of comparison instead:

```
> (sort ~[37 62 49 921 123] gth)
~[921 123 62 49 37]
```

You can sort letters this way as well:

```
> (sort ~['a' 'f' 'e' 'k' 'j'] lth)
<|a e f j k|>
```

The function passed to `sort` must produce a `flag`, i.e., `?`.

### `weld`

The `weld` function takes two lists of the same type and concatenates them:

```
> (weld ~[1 2 3] ~[4 5 6])
~[1 2 3 4 5 6]

> (weld "Happy " "Birthday!")
"Happy Birthday!"
```

#### `weld` Exercise 1.5b

Without using `weld`, write a gate that takes a `[(list @) (list @)]` who product is the concatenation of these two lists. There is a solution at the bottom of this lesson.

### `snag`

The `snag` function takes an atom `n` and a list, and returns the `n`th item of the list, where `0` is the first item:

```
> (snag 0 `(list @)`~[11 22 33 44])
11

> (snag 1 `(list @)`~[11 22 33 44])
22

> (snag 3 `(list @)`~[11 22 33 44])
44

> (snag 3 "Hello!")
'l'

> (snag 1 "Hello!")
'e'

> (snag 5 "Hello!")
'!'
```

Note: there is currently a type system issue that causes some of these functions to fail when passed a list `b` after some type inference has been performed on `b`.  For an illustration of the bug, let's set `b` to be a `(list @)` of `~[11 22 33 44]` in the dojo:

```
> =b `(list @)`~[11 22 33 44]

> b
~[11 22 33 44]
```

Now let's use `?~` to prove that `b` isn't null, and then try to `snag` it:

```
> ?~(b ~ (snag 0 b))
nest-fail
```

The problem is that `snag` is expecting a raw list, not a list that is known to be non-null.

You can cast `b` to `(list)` to work around this:

```
> ?~(b ~ (snag 0 `(list)`b))
11
```

#### `snag` Exercise 1.5c

Without using `snag`, write a gate that returns the `n`th item of a list.  There is a solution at the bottom of this lesson.

### `oust`

The `oust` function takes a pair of atoms `[a=@ b=@]` and a list, and returns the list with `b` items removed, starting at item `a`:

```
> (oust [0 1] `(list @)`~[11 22 33 44])
~[22 33 44]

> (oust [0 2] `(list @)`~[11 22 33 44])
~[33 44]

> (oust [1 2] `(list @)`~[11 22 33 44])
~[11 44]

> (oust [2 2] "Hello!")
"Heo!"
```

### `lent`

The `lent` function takes a list and returns the number of items in it:

```
> (lent ~[11 22 33 44])
4

> (lent "Hello!")
6
```

#### `lent` Exercise 1.5d

Without using `lent`, write a gate that takes a list and returns the number of item in it. There is a solution at the bottom of this lesson.

### `roll`

The `roll` function takes a list and a gate, and accumulates a value of the list items using that gate.  For example, if you want to add or multiply all the items in a list of atoms, you would use `roll`:

```
> (roll `(list @)`~[11 22 33 44 55] add)
165

> (roll `(list @)`~[11 22 33 44 55] mul)
19.326.120
```

### `turn`

The `turn` function takes a list and a gate, and returns a list of the products of applying each item of the input list to the gate.  For example, to add `1` to each item in a list of atoms:

```
> (turn `(list @)`~[11 22 33 44] |=(a=@ +(a)))
~[12 23 34 45]
```

Or to double each item in a list of atoms:

```
> (turn `(list @)`~[11 22 33 44] |=(a=@ (mul 2 a)))
~[22 44 66 88]
```

`turn` is Hoon's version of Haskell's `map`.

We can rewrite the Caesar cipher program using `turn`:

```hoon
|=  [a=@ b=tape]
^-  tape
?:  (gth a 25)
  $(a (sub a 26))
%+  turn  b
|=  c=@tD
?:  &((gte c 'A') (lte c 'Z'))
  =.  c  (add c a)
  ?.  (gth c 'Z')  c
  (sub c 26)
?:  &((gte c 'a') (lte c 'z'))
  =.  c  (add c a)
  ?.  (gth c 'z')  c
  (sub c 26)
c
```

## Using `hoon.hoon` to Learn Hoon

The Hoon standard library and compiler are written in Hoon.  At this point, you know enough Hoon to be able to explore the standard library portions of `hoon.hoon` and find more functions relevant to lists.  [Look around in section `2b` (and elsewhere)](/docs/reference/library/2b/)

## Additional Exercises

#### Exercise 1.5e
Without entering these expressions into the dojo, what are the products of the following expressions?
```
> (lent ~[1 2 3 4 5])
```
```
> (lent ~[~[1 2] ~[1 2 3] ~[2 3 4]])
```
```
> (lent ~[1 2 (weld ~[1 2 3] ~[4 5 6])])
```

#### Exercise 1.5f
First, bind these faces.
```
> =b ~['moon' 'planet' 'star' 'galaxy']
> =c ~[1 2 3]
```
Then determine whether the following dojo expressions are valid, and if so, what they evaluate to.
```
> (weld b b)
```
```
> (weld b c)
```
```
> (lent (weld b c))
```
```
> (add (lent b) (lent c))
```

#### Exercise 1.5g
Write a gate that takes in a list `a` and returns `%.y` if `a` is a palindrome and `%.n` otherwise. You may make use of the `flop` function.


## Exercise Solutions

#### `flop` 1.5a

```hoon
::  flop.hoon
::
|=  a=(list @)
=|  b=(list @)
|-  ^-  (list @)
?~  a  b
$(b [i.a b], a t.a)
```

Run in dojo:

```
> +flop ~[11 22 33 44]
~[44 33 22 11]
```

#### `weld` 1.5b
```hoon
::  weld.hoon
::
|=  [a=(list @) b=(list @)]
|-  ^-  (list @)
?~  a  b
[i.a $(a t.a)]
```

Run in dojo:

```
> +weld [~[1 2 3] ~[3 4 5 6]]
~[1 2 3 3 4 5 6]
```

#### `snag` 1.5c

```hoon
::  snag.hoon
::
|=  [a=@ b=(list @)]
?~  b  !!
?:  =(0 a)  i.b
$(a (dec a), b t.b)
```

Run in dojo:

```
> +snag [0 ~[11 22 33 44]]
11

> +snag [2 ~[11 22 33 44]]
33
```

#### `lent` 1.5d

```hoon
::  lent.hoon
::
|=  a=(list)
^-  @
=/  b=@  0
|-
?~  a  b
$(a t.a, b +(b))
```

Run in dojo:

```
> +lent ~[1 2 3 4 5]
5
> +lent "asdf"
4
```

#### 1.5e

Run in dojo:

```
> (lent ~[1 2 3 4 5])
5
> (lent ~[~[1 2] ~[1 2 3] ~[2 3 4]])
3
> (lent ~[1 2 (weld ~[1 2 3] ~[4 5 6])])
3
```

#### 1.5f

Run in dojo:

```
> (weld b b)
<|moon planet star galaxy moon planet star galaxy|>
```
```
> (weld b c)
```
This will not run because `weld` expects the elements of both lists to be of the same type.
```
> (lent (weld b c))
```
This also fails for the same reason, but it is important to note that in some languages that are more lazily evaluated, such an expression would still work since it would only look at the length of `b` and `c` and not worry about what the elements were. In that case, it would return `7`.
```
> (add (lent b) (lent c))
7
```
We see here the correct way to find the sum of the length of two lists of unknown type.

#### 1.5g
```hoon
::  palindrome.hoon
::
|=  a=(list)
=(a (flop a))
```

Run in dojo:

```
> +palindrome "urbit"
%.n
> +palindrome "racecar"
%.y
```
