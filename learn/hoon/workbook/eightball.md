+++
title = "Magic 8-Ball"
weight = 5
template = "doc.html"
+++
In this lesson we'll write a generator that mimics the functionality of a
Magic 8-Ball, producing a randomized response with each run.

Save the code below as `eightball.hoon` in your `/gen` directory.

```
!:
:-  %say
|=  [[* eny=@uv *] *]
:-  %noun
^-  tape
=/  answers=(list tape)
  :~  "It is certain."
      "It is decidedly so."
      "Without a doubt."
      "Yes - definitely."
      "You may rely on it."
      "As I see it, yes."
      "Most likely."
      "Outlook good."
      "Yes."
      "Signs point to yes."
      "Reply hazy, try again"
      "Ask again later."
      "Better not tell you now."
      "Cannot predict now."
      "Concentrate and ask again."
      "Don't count on it."
      "My reply is no."
      "My sources say no."
      "Outlook not so good."
      "Very doubtful."
  ==
=/  rng  ~(. og eny)
=/  val  (rad:rng (lent answers))
(snag val answers)
```

Let's go through our code in chunks so that we might more easily understand it.

```
!:
```

We start with the `!:` rune to enable a full stack trace for any errors. This
is good practice whenever developing something in Hoon.


```
:-  %say
|=  [[* eny=@uv *] *]
:-  %noun
```

To make our program produce a random result, we need entropy. To get entropy,
we need data from Arvo. To get data from Arvo, we use a generator of the
[`%say`](@/docs/learn/hoon/hoon-tutorial/generators.md) variety. The above code chunk is
the template that is followed for all `%say` generators.

`:-  %say` creates a cell with `%say` as that cell's head to define
the generator's format.

`|=  [[* eny=@uv *] *]` is the tail of the cell, a gate, and that gate's first
child, a sample. Because the only external data our program is interested in
using is entropy to seed our random-number generator, that's the only one we
will assign a face (`eny`). The `*` elements that you see represent any noun. We
use these as fillers: because we don't wish to use the data that's passed to
those parts of the sample, we don't assign them faces.

`:-  %noun` creates another cell, itself residing in the tail of our first cell
via our gate expression. In all `%say` generators, the head of this second cell
is a `mark` that's used to tell Arvo what kind of data the generator is
producing. In this case, we are using the `%noun` `mark` to tell the system how
to print the generator's outputted value. The tail of this cell is that value
itself, produced by the rest of our program.

```
^-  tape
```

Above is a cast statement that requires the non-`mark` component of our cell to
be of the `tape` type. If it's not, the program doesn't compile.

```
=/  answers=(list tape)
  :~  "It is certain."
      "It is decidedly so."
      "Without a doubt."
      "Yes - definitely."
      "You may rely on it."
      "As I see it, yes."
      "Most likely."
      "Outlook good."
      "Yes."
      "Signs point to yes."
      "Reply hazy, try again"
      "Ask again later."
      "Better not tell you now."
      "Cannot predict now."
      "Concentrate and ask again."
      "Don't count on it."
      "My reply is no."
      "My sources say no."
      "Outlook not so good."
      "Very doubtful."
  ==
```

The code in the chunk above constructs the list of possible responses.

`=/  answers=(list tape)` is used to put add data to the subject with a face,
so that we can easily use it later. The face is `answers`, and we designate that
its accompanying value will be a `list` of `tape`. The value itself is given
as a `list` in the lines that follow.

`:~` is a rune that constructs a null-terminated list. Here we have used the
tall form for readability, as an alternative to the wide form of `~[1 2 3]` that
you may be more familiar with.

Contained within the `:~` rune are the elements of the list. In our case, those
elements are the `tape`s that are selected as the 8-Ball's responses.

`==` terminates our list. `:~` expressions are always closed in this way.

```
=/  rng  ~(. og eny)
=/  val  (rad:rng (lent answers))
```

The code above is our random-number engine.

`og` is the core in the standard library that contains arms that perform
randomness-related operations. `=/  rng  ~(. og eny)` passes `eny` to the
subject of `og`, and then stores the resulting core in a face called `rng`.

`=/  val  (rad:rng (lent answers))` uses `rad` arm. `rad` produces a random
number from `0` to `n-1`, where `n` the entropy-seeded `rng` core and pulls.
Is the upper bound that we give it. In this case, the upper bound is the number
of elements in `answers`, obtained by using the `lent` standard-library arm. We
store the random result in `val`.

```
(snag val answers)
```

`snag` is a standard-library arm that that takes two arguments: an atom and
a `list`. It fetches the element in position `n` of the list, where `n` is the
value of the atom it was passed. By using the randomized `val` as that position
argument, we can pull a different response from `answers` every time the
generator is run.

TODO (rob): Exercises here.
