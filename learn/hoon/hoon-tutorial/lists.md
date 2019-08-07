+++
title = "1.4 Lists"
weight = 7
template = "doc.html"
+++


# Lists

A **list** is a type of noun that you'll frequently encounter when reading and writing Hoon. A list can be thought of as an ordered arrangement of zero or more elements terminated by a `~` (null).

So a list can be either null or non-null. When the list contains only `~` and no items, it's the null list.  Most lists are, however, non-null lists, which have items preceding the `~`. Non-null lists, called _lests_, are cells in which the head is the first list item, and the tail is the rest of the list. The tail is itself a list, and if such a list is also non-null, the head of this sub-list is the second item in the greater list, and so on. To illustrate, let's look at a list `[1 2 3 4 ~]` with the cell-delineating brackets left in:

`[1 [2 [3 [4 ~]]]]`

It's easy to see where the heads are and where the nesting tails are. The head of the above list is the atom `1` and the tail is the list `[2 [3 [4 ~]]]`, (or `[2 3 4 ~]`). Recall that whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.

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

## Tapes

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

#### `flop` Exercise

Without using `flop`, write a gate that takes a `(list @)` and returns it in reverse order.  There is a solution at the bottom of this lesson.

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

The `weld` function takes two lists and concatenates them:

```
> (weld ~[1 2 3] ~[4 5 6])
~[1 2 3 4 5 6]

> (weld "Happy " "Birthday!")
"Happy Birthday!"
```

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

#### `snag` exercise

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

```
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

## Exercise Solutions

#### `flop`

```
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

#### `snag`

```
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

### [Next Up: Walkthrough -- Fibonacci Sequence](../fibonacci)
