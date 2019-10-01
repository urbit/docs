+++
title = "1.7.1 Walkthrough: Caesar Cipher"
weight = 16
template = "doc.html"
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
|=  [msg=tape key=@ud]
=<
=.  msg  (cass msg)
:-  (shift msg key)
(unshift msg key)
|%
++  alpha  "abcdefghijklmnopqrstuvwxyz"
++  shift
  |=  [message=tape key=@ud]
  (operate message key (encoder key))
++  unshift
  |=  [message=tape key=@ud]
  (operate message key (decoder key))
++  operate
  |=  [message=tape key=@ud encoder=(map @t @t)]
  ^-  tape
  %+  turn  message
  |=  a=@t
  (~(got by encoder) a)
++  encoder
  |=  [key=@ud]
  =/  keytape=tape  (rott alpha key)
  (coder alpha keytape)
++  decoder
  |=  [key=@ud]
  =/  keytape=tape  (rott alpha key)
  (coder keytape alpha)
++  coder
  |=  [a=tape b=tape]
  (~(put by (zipper a b)) ' ' ' ')
++  zipper
  |=  [a=tape b=tape]
  ^-  (map @t @t)
  =|  chart=(map @t @t)
  ?.  =((lent a) (lent b))
  ~|  %uneven-lengths  !!
  |-
  ?:  |(?=(~ a) ?=(~ b))
  chart
  $(chart (~(put by chart) i.a i.b), a t.a, b t.b)
++  rott
  |=  [m=tape n=@ud]
  =/  length=@ud  (lent m)
  =+  s=(trim (mod n length) m)
  (weld q.s p.s)
--
```

This generator takes two arguments: a `tape`, which is your plaintext message,
and an unsigned integer, which is the shift-value of the cipher. It produces
a cell of two `tapes`: one that has been shifted right by the value, and another
that has been shifted left. It also converts any uppercase input into lowercase.

Try it out in the Dojo:

```
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
|=  [msg=tape key=@ud]
=+  ^=  caesar
    |%
```

The `!:` in the first line of the above code enables a full stack trace in the
event of an error.

`|=  [msg=tape key=@ud]` creates a gate that takes a cell. The head of this cell
is a `tape`, which is a string type that's a list of `cord`s. Tapes are represented
as text surrounded by double-quotes, such as this: `"a tape"`. We give this input
tape the face `msg`. The tail of our cell is a `@ud` -- an unsigned decimal atom
-- that we give the face `key`.

`=<` is the rune that evaluates its first child expression with respect to its
second child expression as the subject. In this case, we evaluate the
expressions in the code chunk below against the core declared later, which
allows us reference the core's contained arms before they are defined. Without
`=<`, we would need to put the code chunk below at the bottom of our program.

```hoon
=.  msg  (cass msg)
:-  (shift msg key)
(unshift msg key)
```

`=.  msg  (cass msg)` changes the input string `msg` to lowercases. `=.` changes
the leg of the subject to something else. In our case, the leg to be changed is
`msg`, and the thing to replace it is `(cass msg)`. `cass` is a standard-library
gate that converts uppercase letters to lowercase.

`:-  (shift msg key)` and `(unshift msg key)` simply composes a
cell of a right-shifted cipher and a left-shifted cell. This is the final output
of our generator.

```hoon
    ++  rott
      |=  [m=tape n=@ud]
      =/  length=@ud  (lent m)
      =+  s=(trim (mod n length) m)
      (weld q.s p.s)
```

The `rott` arm takes takes a specified number of characters off of a tape and
puts them on the end of the tape.

`|=  [m=tape n=@ud]` creates a gate that takes two arguments: `m`, a `tape`,
and `n`, a `@ud`.

`=/  length=@ud  (lent m)` stores the length of `m` to make the following
code a little clearer.

`trim` is a a gate from the standard library that splits a tape at into two
parts at a specified position. So `=+  s=(trim (mod n length) m)` splits the
tape `m` into two parts, `p` and `q`, and stores it in `s`. We call the modulus
operation `mod` to make sure that we split our `tape` at the correct place, even
if `n` is larger than `length`.

`(weld q.s p.s)` uses `weld`, which combines two strings into one. In this
instance, we are switching the two parts: the second part `q.s` is welded to the
front, and the first part `p.s` is welded to the back.

```hoon
    ++  zipper
      |=  [a=tape b=tape]
      ^-  (map @t @t)
      =|  chart=(map @t @t)
      ?.  =((lent a) (lent b))
        ~|  %uneven-lengths  !!
      |-
      ?:  |(?=(~ a) ?=(~ b))
          chart
      $(chart (~(put by chart) i.a i.b), a t.a, b t.b)
```

The `zipper` arm takes two tapes and creates a `map` out of them -- an
an association between their elements.

So then if `tapes` are easier to manipulate, why then are we producing `cords`?
In this case what we are going to to be doing is mapping a single element of a `
tape` to another element of a `tape`, which as we have established as being a
`cord`. This will simplify our use of this method and we don't need to
manipulate the keys or values, simply look them up.

`|=  [a=tape b=tape]` builds a gate that takes two tapes, `a` and `b`, as its
sample.

`^-  (map @t @t)` casts the gate to a `map` with a `cord` key and a `cord`
value. A `map` is a type equivalent to a dictionary in other languages: it's a
data structure that associates a key with a value. If, for example, we wanted
to have an association between `a` and 1 and `b` and 2, we could use a `map`.

`=|  chart=(map @t @t)` adds a noun to the subject with the default value of
the `(map @t @t)` type, and gives that noun the face `chart`.

`?.  =((lent a) (lent b))` checks if the two tapes are the same length. If not,
the program crashes.

`|-` creates a trap, a gate that is called immediately.

`?:  |(?=(~ a) ?=(~ b))` checks if either tape is empty. If this is true, we
the program is finished and can return `chart`, the the `map` that we have been
creating.

If the above test finds that its condition to be false, we trigger a recursion
that constructs our `map`: `$(chart (~(put by chart) i.a i.b), a t.a, b t.b)`.
This code recursively adds an entry in our `map` where the head of the tape `a`
maps to the value of the head of tape `b` with  `~(put by chart)`, our calling
of the `put` arm of the `by` map-engine core. The recursion also "consumes"
those heads with every iteration by changing `a` and `b` to their tails.

Perhaps now you can understand why this arm is named `zipper`. It's putting two
tapes together by matching pieces from each side, something akin to a jacket zipper.

We have three related arms to look at next, `coder`, `encoder`, and
`decoder`. `coder` is the foundation of the other two, so we'll look at it
first.

```hoon
    ++  coder
      |=  [a=tape b=tape]
      (~(put by (zipper a b)) ' ' ' ')
```

`|=  [a=tape b=tape]` creates a gate that takes two `tapes`.

We use `put by` on the next line, giving it a `map` produced by the `zipper`
arm that we created before. This adds an entry to the map where the space
character (called `ace`) simply maps to itself. This is done to simplify
the handling of spaces in `tapes` we want to encode, since we don't want to
shift them.

```hoon
    ++  encoder
      |=  [key=@ud]
      =/  keytape=tape  (rott alpha key)
      (coder alpha keytape)
    ++  decoder
      |=  [key=@ud]
      =/  keytape=tape  (rott alpha key)
      (coder keytape alpha)
```

`encoder` and `decoder` are implemented in terms of the `coder` arm. These gates
are essentially identical, with the arguments reversed. They simplify the two
common transactions you want to do in this program: producing `maps` that we can
use to encode and decode messages.

In both cases, we create a gate that accepts a `@ud` named `key`.

`=/  keytape=tape  (rott alpha key)` creates a `keytape` noun by calling `rott`
on `alpha` our `key` input. `alpha` is our arm which contains a `tape` of the
entire alphabet.

`(coder alpha keytape)`, for `encoder`, and `(coder keytape alpha)`, for
`decoder`, produce a `map` that has the first argument as the keys and the
second as the values.

If our two inputs to `coder` were `"abcdefghijklmnopqrstuvwxyz"` and
`"bcdefghijklmnopqrstuvwxyza"` We would get a `map` where `'a'` maps to `'b'`,
`'b'` to `'c'` and so on. By doing this we can produce a `map` that gives us a
translation between the alphabet and our shifted alphabet, or vice versa.

Still with us? Good. We are finally about to use all the stuff that we've
walked through.

```hoon
    ++  shift
      |=  [message=tape key=@ud]
      (operate message key (encoder key))
    ++  unshift
      |=  [message=tape key=@ud]
      (operate message key (decoder key))
```

Both `shift` and `unshift` take two arguments: our `message`, the `tape` that we
want to manipulate; and our `key`, the value that we want to shift our message
by.

`shift` is for encoding, and `unshift` is for decoding. Thus, `shift` calls the
`operate` arm with `(operate message key (encoder key))`, and `unshift` makes
that call with `(operate message key (decoder key))`. These both produce the
final output of the core, to be called in the form of `(shift msg key)`
and `(unshift msg key)` at the bottom of the program.

```hoon
++  operate
  |=  [message=tape key=@ud encoder=(map @t @t)]
  ^-  tape
  %+  turn  message
  |=  a=@t
  (~(got by encoder) a)
```

`operate` produces a `tape`. The `%+` rune allows us to pull an arm
with a pair sample. The arm we are going to pull is `turn`. This arm
takes two arguments, a `list` and a `gate` to apply to each element of the
`list`.

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

3. Build a gate that can take a Caesar shifted `tape` and produce
possible unshifted `tapes`.

4. Modify the example generator into a `%say` generator.

### [Next Up: Reading -- Doors](../doors)
