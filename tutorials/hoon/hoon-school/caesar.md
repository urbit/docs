+++
title = "1.7.1 Walkthrough: Caesar Cipher"
weight = 16
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/caesar/"]
insert_anchor_links = "none"
+++

A Caesar cipher is a very simple way to obfuscate a message. The technique
takes a string and swaps out each component letter with another letter that is
a specified number of positions up or down in the alphabet. For example, with a
"right-shift" of 1, `a` would become `b`, `j` would become `k`, and `z` would
wrap around back to `a`.

Consider the message below, and the cipher that results when we Caesar-shift the
message to the right by 1.

```
Plaintext message:    "do not give way to anger"
Right-shifted cipher: "ep opu hjwf xbz up bohfs"
```

Note that the Caesar cipher is completely unsuitable for actually securing
information. Implementing it in a program is just a fun exercise.

## A Caesar Cipher In Hoon

Below is a generator that performs a Caesar cipher on a tape. This example
isn't the most compact implementation of such a cipher in Hoon, but it
demonstrates important principles that more laconic code would not. Save it as
`caesar.hoon` in your `/gen` directory.

```hoon
!:
|=  [msg=tape steps=@ud]
=<
=.  msg  (cass msg)
:-  (shift msg steps)
(unshift msg steps)

|%
++  alpha  "abcdefghijklmnopqrstuvwxyz"
++  shift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (encoder shift-steps))
++  unshift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (decoder shift-steps))
++  encoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder alpha value-tape)
++  decoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder value-tape alpha)
++  operate
  |=  [message=tape shift-map=(map @t @t)]
  ^-  tape
  %+  turn  message
  |=  a=@t
  (~(got by shift-map) a)
++  space-adder
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  (~(put by (map-maker key-position value-result)) ' ' ' ')
++  map-maker
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  =|  chart=(map @t @t)
  ?.  =((lent key-position) (lent value-result))
  ~|  %uneven-lengths  !!
  |-
  ?:  |(?=(~ key-position) ?=(~ value-result))
  chart
  $(chart (~(put by chart) i.key-position i.value-result), key-position t.key-position, value-result t.value-result)
++  rotation
  |=  [my-alphabet=tape my-steps=@ud]
  =/  length=@ud  (lent my-alphabet)
  =+  (trim (mod my-steps length) my-alphabet)
  (weld q p)
--
```

This generator takes two arguments: a `tape`, which is your plaintext message,
and an unsigned integer, which is the shift-value of the cipher. It produces
a cell of two `tapes`: one that has been shifted right by the value, and another
that has been shifted left. It also converts any uppercase input into lowercase.

Try it out in the Dojo:

```
> +caesar ["abcdef" 1]
["bcdefg" "zabcde"]

> +caesar ["test" 2]
["vguv" "rcqr"]

> +caesar ["test" 26]
["test" "test"]

> +caesar ["test" 28]
["vguv" "rcqr"]

> +caesar ["test" 104]
["test" "test"]

> +caesar ["tESt" 2]
["vguv" "rcqr"]

> +caesar ["test!" 2]
nest-fail
```

### Examining Our Code

Let's examine our `caesar.hoon` code piece by piece. We won't necessarily go
in written order; instead, we'll cover code in the intuitive order of the
program. For each chunk that we cover, try to read and understand the code
itself before reading the explanation.

```hoon
!:
|=  [msg=tape steps=@ud]
=<
```

The `!:` in the first line of the above code enables a full stack trace in the
event of an error.

`|=  [msg=tape steps=@ud]` creates a [gate](/docs/glossary/gate/) that takes a cell. The head of this cell
is a `tape`, which is a string type that's a list of `cord`s. Tapes are represented
as text surrounded by double-quotes, such as this: `"a tape"`. We give this input
tape the face `msg`. The tail of our cell is a `@ud` -- an unsigned decimal [atom](/docs/glossary/atom/)
-- that we give the face `steps`.

`=<` is the rune that evaluates its first child expression with respect to its
second child expression as the subject. In this case, we evaluate the
expressions in the code chunk below against the [core](/docs/glossary/core/) declared later, which
allows us reference the core's contained [arms](/docs/glossary/arm/) before they are defined. Without
`=<`, we would need to put the code chunk below at the bottom of our program.  In Hoon, as previously
stated, we always want to keep the longer code towards the bottom of our programs - `=<` helps us do that.

```hoon
=.  msg  (cass msg)
:-  (shift msg steps)
(unshift msg steps)
```

`=.  msg  (cass msg)` changes the input string `msg` to lowercases. `=.` changes
the leg of the subject to something else. In our case, the leg to be changed is
`msg`, and the thing to replace it is `(cass msg)`. `cass` is a standard-library
gate that converts uppercase letters to lowercase.

`:-  (shift msg steps)` and `(unshift msg steps)` simply composes a
cell of a right-shifted cipher and a left-shifted cipher of our original message.
We will see how this is done using the core described below, but this is the final
output of our generator.

`|%` creates a `core`, the second child of `=<`. Everything after `|%` is part of that
second child `core`, and will be used as the subject of the first child of `=<`, described
above.  The various parts, or `arm`s, of the `core` are denoted by `++` beneath it, for
instance:

```hoon
    ++  rotation
      |=  [my-alphabet=tape my-steps=@ud]
      =/  length=@ud  (lent my-alphabet)
      =+  (trim (mod my-steps length) my-alphabet)
      (weld q p)
```

The `rotation` arm takes takes a specified number of characters off of a tape and
puts them on the end of the tape.  We're going to use this to create our shifted alphabet,
based on the number of `steps` given as an argument to our gate.

`|=  [my-alphabet=tape my-steps=@ud]` creates a gate that takes two arguments: `my-alphabet`, a `tape`,
and `my-steps`, a `@ud`.

`=/  length=@ud  (lent my-alphabet)` stores the length of `my-alphabet` to make the following
code a little clearer.

`trim` is a a gate from the standard library that splits a tape at into two
parts at a specified position. So `=+  (trim (mod my-steps length) my-alphabet)` splits the
tape `my-alphabet` into two parts, `p` and `q`, which are now directly available in the subject.
We call the modulus operation `mod` to make sure that the point at which we split our `tape` is 
a valid point inside of `my-alphabet` even if `my-steps` is greater than `length`, the length of
`my-alphabet`.  Try trim in the dojo:

```
> (trim 2 "abcdefg")
[p="ab" q="cdefg"]

> (trim 4 "yourbeard")
[p="your" q="beard"]
```

`(weld q p)` uses `weld`, which combines two strings into one. Remember that `trim` has given us
a split version of `my-alphabet` with `p` being the front half that was split off of `my-alphabet` 
and `q` being the back half. Here we are welding the two parts back together, but in reverse order:
the second part `q` is welded to the front, and the first part `p` is welded to the back.

```hoon
    ++  map-maker
      |=  [key-position=tape value-result=tape]
      ^-  (map @t @t)
      =|  chart=(map @t @t)
      ?.  =((lent key-position) (lent value-result))
      ~|  %uneven-lengths  !!
      |-
      ?:  |(?=(~ key-position) ?=(~ value-result))
        chart
      $(chart (~(put by chart) i.key-position i.value-result), key-position t.key-position, value-result t.value-result)
```

The `map-maker` arm, as the name implies, takes two tapes and creates a [`map`](/docs/reference/library/2o/#map) out of them.
A `map` is a type equivalent to a dictionary in other languages: it's a data structure that 
associates a key with a value. If, for example, we wanted to have an association 
between `a` and 1 and `b` and 2, we could use a `map`.

`|=  [a=tape b=tape]` builds a gate that takes two tapes, `a` and `b`, as its
sample.

`^-  (map @t @t)` casts the gate to a `map` with a `cord` (or `@t`) key and a `cord`
value. 

You might wonder, if our gate in this arm takes `tape`s, why then are we producing
a map of `cord` keys and values?

As we discussed earlier, a `tape` is a list of `cord`s.  In this case what we are going to do
is map a single element of a `tape` (either our alphabet or shifted-alphabet) to an element of
a different `tape` (either our shifted-alphabet or our alphabet).  This pair will therefore be
a pair of `cord`s.  When we go to use this `map` to convert our incoming `msg`, we will take 
each element (`cord`) of our `msg` `tape`, use it as a `key` when accessing our `map` and get
the corresponding `value` from that position in the `map`. This is how we're going to encode
or decode our `msg` `tape`.

`=|  chart=(map @t @t)` adds a [noun](/docs/glossary/noun/) to the subject with the default value of
the `(map @t @t)` type, and gives that noun the face `chart`.

`?.  =((lent key-position) (lent value-result))` checks if the two `tape`s are the same length. If not,
the program crashes with an error message of `%uneven-lengths`, using `|~  %uneven-lengths  !!`.

If the two `tape`s are of the same length, we continue on to create a trap.
`|-` creates a [trap](/docs/glossary/trap/), a gate that is called immediately.

`?:  |(?=(~ key-position) ?=(~ value-result))` checks if either `tape` is empty. If this is true, the
`map-maker` arm is finished and can return `chart`, the `map` that we have been
creating.

If the above test finds that the `tape`s are not empty, we trigger a recursion
that constructs our `map`: `$(chart (~(put by chart) i.a i.b), a t.a, b t.b)`.
This code recursively adds an entry in our `map` where the head of the `tape` `a`
maps to the value of the head of `tape` `b` with  `~(put by chart)`, our calling
of the `put` arm of the `by` map-engine core (note that `~(<wing> <door> <sample>`) is
a shorthand for `%~  <wing>  <door>  <sample>` (see the [Calls % ('cen')](/docs/reference/hoon-expressions/rune/cen/#censig)
documentation for more information). The recursion also "consumes"
those heads with every iteration by changing `a` and `b` to their tails using `a t.a, b t.b`.

We have three related arms to look at next, `decoder`, `encoder`, and
`space-adder`. `space-adder` is required for the other two, so we'll look at it
first.

```hoon
    ++  space-adder
      |=  [key-position=tape value-result=tape]
      ^-  (map @t @t)
      (~(put by (map-maker key-position value-result)) ' ' ' ')
```

`|=  [key-position=tape value-result=tape]` creates a gate that takes two `tapes`.

We use the `put` arm of the `by` core on the next line, giving it a `map` produced
by the `map-maker` arm that we created before as its sample. This adds an entry to the
map where the space character (called `ace`) simply maps to itself. This is done to
simplify the handling of spaces in `tapes` we want to encode, since we don't want to
shift them.

```hoon
    ++  encoder
      |=  [steps=@ud]
      ^-  (map @t @t)
      =/  value-tape=tape  (rotation alpha steps)
      (space-adder alpha value-tape)
    ++  decoder
      |=  [steps=@ud]
      ^-  (map @t @t)
      =/  key-tape=tape  (rotation alpha steps)
      (space-adder key-tape alpha)
```

`encoder` and `decoder` utilize the `rotation` and `space-adder` arms. These gates
are essentially identical, with the arguments passed to `space-adder` reversed. They
simplify the two common transactions you want to do in this program: producing `maps`
that we can use to encode and decode messages.

In both cases, we create a gate that accepts a `@ud` named `steps`.

In `encoder`:
`=/  value-tape=tape  (rotation alpha steps)` creates a `value-tape` noun by calling `rotation`
on `alpha`. `alpha` is our arm which contains a `tape` of the entire alphabet. The 
`value-tape` will be the list of `value`s in our `map`.

In `decoder`:
`=/  key-tape  (rotation alpha steps)` does the same work, but when passed to `space-adder`
it will be the list of `key`s in our `map`.

`(space-adder alpha value-tape)`, for `encoder`, and `(space-adder key-tape alpha)`, for
`decoder`, produce a `map` that has the first argument as the keys and the
second as the values.

If our two inputs to `space-adder` were `"abcdefghijklmnopqrstuvwxyz"` and
`"bcdefghijklmnopqrstuvwxyza"`, we would get a `map` where `'a'` maps to `'b'`,
`'b'` to `'c'` and so on. By doing this we can produce a `map` that gives us a
translation between the alphabet and our shifted alphabet, or vice versa.

Still with us? Good. We are finally about to use all the stuff that we've
walked through.

```hoon
    ++  shift
      |=  [message=tape shift-steps=@ud]
      ^-  tape
      (operate message (encoder shift-steps))
    ++  unshift
      |=  [message=tape shift-steps=@ud]
      ^-  tape
      (operate message (decoder shift-steps))
```

Both `shift` and `unshift` take two arguments: our `message`, the `tape` that we
want to manipulate; and our `shift-steps`, the number of positions of the alphabet
by which we want to shift our message.

`shift` is for encoding, and `unshift` is for decoding. Thus, `shift` calls the
`operate` arm with `(operate message (encoder shift-steps))`, and `unshift` makes
that call with `(operate message (decoder shift-steps))`. These both produce the
final output of the core, to be called in the form of `(shift msg steps)`
and `(unshift msg steps)` in the cell being created at the beginning of our code.

```hoon
    ++  operate
      |=  [message=tape shift-map=(map @t @t)]
      ^-  tape
      %+  turn  message
      |=  a=@t
      (~(got by shift-map) a)
```

`operate` produces a `tape`. The `%+` rune allows us to pull an arm
with a pair sample. The arm we are going to pull is `turn`. This arm
takes two arguments, a `list` and a `gate` to apply to each element of the
`list`.

In this case, the `gate` we are applying to our `message` uses the `got` arm 
of the `by` door with our `shift-map` as the sample (which is either the standard alphabet
for keys, and the shifted alphabet for values, or the other way, depending on
whether we are encoding or decoding) to look up each `cord` in our `message`, one by one
and replace it with the `value` from our `map` (either the encoded or decoded version).

If we then give our arm Caesar's famous statement, and get our left- and
right-ciphers.

```
> +caesar ["i came i saw i conquered" 4]
["m geqi m wea m gsruyivih" "e ywia e ows e ykjmqanaz"]
```

Now, to decode, we can put either of our ciphers in with the appropriate key and
look for the legible result.

```
> +caesar ["m geqi m wea m gsruyivih" 4]
["q kium q aie q kwvycmzml" "i came i saw i conquered"]

> +caesar ["e ywia e ows e ykjmqanaz" 4]
["i came i saw i conquered" "a usew a kso a ugfimwjwv"]
```

### Exercises

1. Take the example generator and modify it to add a second layer of shifts.

2. Extend the example generator to allow for use of characters other than a-z.
   Make it shift the new characters independently of the alpha characters, such
   that punctuation is only encoded as other punctuation marks.

3. Build a gate that can take a Caesar shifted `tape` and produce all
   possible unshifted `tapes`.

4. Modify the example generator into a `%say` generator.
