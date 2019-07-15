+++
title = "1.2 Nouns"
weight = 4
template = "doc.html"
+++

In Urbit, every piece of data is a noun.  In order to understand Hoon, one must first understand nouns.

## Noun Definition

A **noun** is either an atom or a cell.  An **atom** is a natural number ("unsigned integer" in computer lingo) of any size, including zero.  A **cell** is an [ordered pair](https://en.wikipedia.org/wiki/Ordered_pair) of nouns, usually indicated with square brackets around the nouns in question; i.e., `[a b]`, where `a` and `b` are nouns.

Here are some atoms:

- `0`
- `87`
- `325`

Here are some cells:

- `[12 13]`
- `[12 [487 325]]`
- `[[12 13] [87 65]]`
- `[[83 [1 17]] [[23 [32 64]] 90]]`

All of the above are nouns.

### Nouns as Binary Trees

A [binary tree](https://en.wikipedia.org/wiki/Binary_tree) has a single base node, and each node of the tree may have up to two child nodes (but it need not have any).  A node without children is a 'leaf'.  You can think of a noun as a binary tree whose leaves are atoms, i.e., unsigned integers.  All non-leaf nodes are cells.  To visualize this, consider the following representation of the noun: `[12 [17 45]]`:

```
[12 [17 45]]
    .
   / \
 12   .
     / \
   17   45
```

Each number is an atom; each dot is a cell.  Let's look at another example, this time of `[[7 13] [87 65]]`, with the cell nodes shown explicitly:

```
  [[7 13] [87 65]]
         .
        / \
  [7 13]   [87 65]
    .         .
   / \       / \
  7   13   87   65
```

An atom is a trivial tree of just one node; e.g., `17`.

## Atoms

Atoms are unsigned integers.  These are often represented by the dojo as unsigned integers in decimal notation, e.g., `17`.

To be sure we understand Hoon's atom notation, let's enter some atoms into the dojo:

```
> 3
3
```

Seems straightforward.

```
> 32
32
```

Why not try it again to make sure?

```
> 320
320
```

Can we add another zero?

```
> 320
```

It didn't work!  When you tried to type that next zero and turn `320` into `3200`, the dojo actually _deleted the `0` and beeped at you_.

Isn't an atom an unsigned integer of any size?  It is.  But the way to represent the four-digit number `3200` is actually `3.200`:

```
> 3.200
3.200

> (mul 32 100)
3.200
```

Just think of it as "3,200", written the German way with a dot.

Why?  Long numbers are difficult to read.  We know this, so we group digits in threes.  For some reason most programming languages don't use this marvelous innovation.  Hoon does.

English notation for decimals is more common than German notation.  Unfortunately, dots are URL-safe and commas aren't.  For reasons to be discussed in a later lesson, it's nice to have a regular syntax for atoms that's URL-safe.

As for why the dojo deleted your zero: it parses the command line as you type, and rejects any characters after the parser stops.  This prevents you from entering commands or expressions that aren't well-formed.

### Atom Auras

Atoms are nothing more than unsigned integers -- natural numbers -- but it's often useful to represent an atom in a different way.  This is done with an **aura**.  The aura of an atom is type meta-data used by Hoon to determine how to interpret that atom.  It answers the question: What type of information is this atom?

We use auras because data isn't always represented as a positive decimal number. Sometimes we want to represent data as binary, as text, or as a negative number. Auras allow us to to use such types of data _without changing the underlying atom_.

We won't fully explain auras and their various uses yet.  Auras will be covered more comprehensively in a later lesson.  For now let's just look at the various kinds of [literal syntax](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29) associated with a few atom auras.

In computer science, a 'literal' is an expression that represents and evaluates to a fixed value.  The default syntax of an atom literal is the German-style decimal notation, as seen above.  Let's look at some other atom literal syntaxes: unsigned binary, unsigned hexadecimal, signed decimal, signed binary and hexadecimal.

```
> 0b1001
0b1001

> 0b1001.1101
0b1001.1101

> 0x9d
0x9d

> 0xdead.beef
0xdead.beef

> --9
--9

> -79
-79

> --0b1001
--0b1001

> -0x9d
-0x9d
```

All of the above are atoms.  The underlying noun of each is just an unsigned integer, but each is written in a special syntax indicating to Hoon that the atom is to be represented in a different way.  To see their values in the default atom notation, you can tell Hoon to throw away the aura information.  Do this by preceding each expression above with `\`@\``.

```
> `@`0b1001
9

> `@`0b1001.1101
157

> `@`0x9d
157

> `@`0xdead.beef
3.735.928.559

> `@`--9
18

> `@`-79
157

> `@`--0b1001
18

> `@`-0x9d
313
```

The `` `@` `` syntax is used to 'cast' a value to a raw atom, i.e., an atom without an aura.  Don't worry about exactly what `` `@` `` means just yet.  Casts will be explained in more detail in a later lesson.  For now all you need to know is that a cast doesn't change the underlying value of the noun; it's used here only to change how the value is printed in the dojo output.

#### Identities, Cords, and Terms

Urbit identities such as `~zod` and `~sorreg-namtyv` are also atoms, but of the aura `@p`:

```
> ~zod
~zod

> ~sorreg-namtyv
~sorreg-namtyv

> `@`~zod
0

> `@p`0
~zod

> `@`~sorreg-namtyv
5.702.400

> `@p`5.702.400
~sorreg-namtyv
```

Hoon permits the use of atoms as strings.  Strings that are encoded as atoms are called **cords**. Cords are of the aura `@t`.  The literal syntax of a cord is text inside a pair of single-quotes, e.g., `'Hello world!'`.

```
> 'Howdy!'
'Howdy!'

> `@`'Howdy!'
36.805.260.308.296

> 'Hello world!'
'Hello world!'

> `@`'Hello world!'
10.334.410.032.606.748.633.331.426.632
```

Hoon also has **terms**, of the aura `@tas`. Terms are constant values that are used to tag data using the type system. These are strings preceded with a `%` and made up of lower-case letters, numbers, and hyphens, i.e., 'kebab case'.  The first character after the `%` must be a letter.  For example, `%a`, `%hello`, `%this-is-kebab-case123`.

```
> %howdy
%howdy

> %this-is-kebab-case123
%this-is-kebab-case123

> `@`%howdy
521.376.591.720

> `@`'howdy'
521.376.591.720

> `@`%this-is-kebab-case123
74.823.134.616.534.770.182.309.416.397.866.674.543.716.995.786.868
```

#### List of Auras

Here's a non-exhaustive list of auras, along with examples of corresponding literal syntax:

```
Aura         Meaning                        Example of Literal Syntax
-------------------------------------------------------------------------
@d           date
  @da        absolute date                  ~2018.5.14..22.31.46..1435
  @dr        relative date (ie, timespan)   ~h5.m30.s12
@n           nil                            ~
@p           phonemic base (urbit name)     ~sorreg-namtyv
@r           IEEE floating-point
  @rd        double precision  (64 bits)    .~6.02214085774e23
  @rh        half precision (16 bits)       .~~3.14
  @rq        quad precision (128 bits)      .~~~6.02214085774e23
  @rs        single precision (32 bits)     .6.022141e23
@s           signed integer, sign bit low
  @sb        signed binary                  --0b11.1000
  @sd        signed decimal                 --1.000.056
  @sv        signed base32                  -0v1df64.49beg
  @sw        signed base64                  --0wbnC.8haTg
  @sx        signed hexadecimal             -0x5f5.e138
@t           UTF-8 text (cord)              'howdy'
  @ta        ASCII text (knot)              ~.howdy
    @tas     ASCII text symbol (term)       %howdy
@u              unsigned integer
  @ub           unsigned binary             0b11.1000
  @ud           unsigned decimal            1.000.056
  @uv           unsigned base32             0v1df64.49beg
  @uw           unsigned base64             0wbnC.8haTg
  @ux           unsigned hexadecimal        0x5f5.e138
```

#### Casting to Other Auras

You can force Hoon to interpret an atom differently by using the aura symbols in the chart above; e.g., `\`@ux\`` for unsigned hexadecimal, `\`@ub\`` for unsigned binary, etc.:

```
> `@ux`157
0x9d

> `@ub`157
0b1001.1101

> `@ub`0x9d
0b1001.1101

> `@ux`0b1001.1101
0x9d
```

The atoms in the examples above are all exactly the same value.  Only they're interpreted and printed differently, depending on the aura.

You'll learn more about atoms and auras in [lesson 2.4](../atoms-auras-and-simple-cell-types.md).

## Cells

There's not much mystery about cells.  The left of a cell is called the **head**, and the right is called the **tail**.  Cells are typically represented in Hoon with square brackets around a pair of nouns.

```
> [32 320]
[32 320]
```

In this cell `32` is the head and `320` is the tail.  Cells can contain cells, and atoms of other auras as well:

```
> [%hello 'world!']
[%hello 'world!']

> [[%in 0xa] 'cell']
[[%in 0xa] 'cell']
```

I said there isn't _much_ mystery about cells, but there is a little.  So far whenever we've entered a cell into the dojo, it not only returned the same cell; the cell was printed in the same way it was entered.  This doesn't always happen.  The dojo is obligated to evaluate the input and return the correct answer, but it doesn't have to show the result in exactly the same way:

```
> [6 [62 620]]
[6 62 620]

> [6 62 620]
[6 62 620]

> [[6 62] 620]
[[6 62] 620]
```

In the first example, the inner pair of square brackets is dropped.  Why did this happen?  Why is `[6 62 620]` accepted as a cell despite apparently having more than two atoms in it?

In fact, `[6 [62 620]]` and `[6 62 620]` are considered equivalent in Hoon.  A cell _must_ be a pair, which means there are always exactly two nouns in it.  Whenever cell brackets are omitted so that visually there appears to be more than two child nouns, it is implicitly understood that the right-most nouns constitute a cell.  That is, the tail of the whole cell is assumed to be a cell of the right-most nouns.

This is why `[6 [62 620]]` and `[6 62 620]` are equivalent.  `[6 [62 620]]` and `[[6 62] 620]`, on the other hand, are not equivalent.  If you look at them as binary trees you can see the difference:

```
 [6 [62 620]]       [[6 62] 620]
     .                  .
    / \                / \
   6   .              .   620
      / \            / \
    62   620        6   62
```

When the dojo pretty-prints a cell it always removes superfluous cell brackets:

```
> [[12 13] [[14 15] [16 17]]]
[[12 13] [14 15] 16 17]
```

However, you should always remember that though cells can be presented as lists of more than two nouns, they're always just pairs.

### Exercise 1.2a

Without using the dojo, assess whether each of the following pairs of nouns is equivalent.  (Answers are at the bottom of the page.)

```
1.  [[1 3] [6 2]]                 [1 3 [6 2]]
2.  [[[17 18] 20] 19 21]          [[[17 18] 20] [19 21]]
3.  [[[[[12 13] 14] 15] 16] 17]   [12 13 14 15 16 17]
4.  [12 [13 [14 [15 [16 17]]]]]   [12 13 14 15 16 17]
5.  [37 [99 17] 83]               [37 [[99 17] 83]]
```

## Noun Addresses

Nouns have a regular structure that can be exploited to give a unique **address** to each of its 'sub-nouns'.  A sub-noun is a part of a noun that is itself a noun; e.g., `[6 2]` is a sub-noun of `[[1 3] [6 2]]`.  We can also call these 'noun fragments'.

What if you want to refer to a noun fragment, and not the whole thing? For example, what if you want to refer to the `[6 2]` part of `[[1 3] [6 2]]`?  One way is to use the unique address of that noun fragment.

To define noun addresses we'll use recursion.  The base case is trivial: address `1` of a noun is the entire noun.  The generating case: if the noun at address `n` is a cell, then its head is at address `2n` and its tail is at address `2n + 1`.  For example, if address `5` of some noun is a cell, then its head is at address `10` and its tail address `11`.

Address 1 of the noun `[[1 3] [6 2]]` is the whole noun: `[[1 3] [6 2]]`.  The head of the noun at address `1`, `[1 3]`, is at address `2 x 1`, i.e., `2`.  The tail of the noun at address `1`, `[6 2]`, is at address `(2 x 1) + 1`, i.e., `3`.

If the way this works isn't immediately clear, remember that each noun can be understood as a binary tree.  The following diagram shows the address of several nodes of the tree:

```
           1
         /   \
        2     3
       / \   / \
      4   5 6   7
               / \
              14 15
```

Let's do some examples in the dojo.  We're going to use the `slot` operator, `+`, to return fragments of a noun.  For any unsigned integer `n`, `+n` evaluates to the fragment at address `n`.

```
> +1:[22 [33 44]]
[22 33 44]

> +2:[22 [33 44]]
22

> +3:[22 [33 44]]
[33 44]

> +6:[22 [33 44]]
33

> +7:[22 [33 44]]
44
```

You'll notice that we use the `:` symbol between the slot syntax and the noun.  Don't worry about what this means yet; we'll explain it in another lesson.  For now you can read it as the word "of": `+7:[22 [33 44]]` is "slot `7` of `[22 [33 44]]`".

What happens if you ask for a fragment that doesn't exist?

```
> +4:[22 [33 44]]
ford: %ride failed to execute:
```

Let's do a few more examples:

```
> +2:[['apple' %pie] [0b1101 0xdad]]
['apple' %pie]

> +5:[['apple' %pie] [0b1101 0xdad]]
%pie

> +2:[[%one %two] [%three %four] [%five %six]]
[%one %two]

> +3:[[%one %two] [%three %four] [%five %six]]
[[%three %four] %five %six]

> +15:[[%one %two] [%three %four] [%five %six]]
%six
```

For those who prefer to think in terms of binary numbers and binary trees, there is another (equivalent) way to understand noun addressing.  When the noun address is expressed as a binary number, you can think of the the number as indicating a tree path from the top node.

As before, the root of the binary tree (i.e., the whole noun) is at address `1`. For the node of a tree at any address `b`, where `b` is a binary number, you get the address of its head by concatenating a `0` to the end of `b`; and to get its tail, concatenate a `1` to the end. For example, the head of the node at binary address `111` is at `1110`, and the tail is at `1111`.

Address `1110` indicates "the head of the tail of the tail of the noun".

### Exercise 1.2b

Without using the dojo, evaluate the following expressions.  (Answers are at the bottom of the page.)

```
1. +6:[[34 54] [86 48]]
2. +3:[13 [[[65 35] 54] 77]]
3. +12:[13 [[[65 35] 54] 77]]
4. +7:[13 [[[65 35] 54] 77]]
5. +10:[[[2 4 5] [3 6]] 11]
```

### Exercise 1.2c

Without using the dojo, for each fragment below provide the address relative to the noun `[51 52 53 54 55]`.  (Answers are at the bottom of the page.)

```
1. 51
2. 52
3. 53
4. [54 55]
5. 55
```

That's it for our basic introduction to nouns.  Hit `ctrl-d` to exit your ship, or else move on to the next lesson.

## Exercise Answers

### 1.2a

+ No
+ Yes
+ No
+ Yes
+ Yes

### 1.2b

+ 86
+ [[[65 35] 54] 77]
+ [65 35]
+ 77
+ 3

### 1.2c

+ +2
+ +6
+ +14
+ +15
+ +31

### [Next Up: Reading -- Hoon Syntax](../hoon-syntax)
