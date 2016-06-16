---
navhome: /docs
sort: 1
next: true
title: Hoon refresher / crash course
---

Basic Hoon
==========

This recapitulates material you've already learned in
[Hoon](/docs/hoon/). It will be a very abrupt tutorial if you don't know
Hoon already, but it may be enough in and of itself. If you don't find
it obvious at first glance, try working up from Hoon.

Our goal is to get you programming interesting and useful things as soon
as possible. To get there, we have to quickly cover some of the
fundamentals of hoon. To do this, we'll walk through two simple
programs: the first [Project Euler](https://projecteuler.net/) problem
and [fizzbuzz](https://en.wikipedia.org/wiki/Fizz_buzz).

To run this code, you'll need an urbit, and will have to copy the
[examples repo](https://github.com/urbit/examples) into it.

If you haven't installed urbit yet, check out the [installation
instructions](/docs/using/install). Once urbit is installed, take a look
at the [basic operation](/docs/using/admin) of your urbit.

If you haven't copied in the examples repo, running the following
commands from your urbit directory should do the trick:

`$ cp -r {wherever-you've-pulled-to}/examples/gall/*/ arvo/`
`$ cp -r {wherever-you've-pulled-to}/examples/dojo/*/ arvo/`

Run an example to ensure it worked:

    ~fintud-macrep:dojo> +examples-euler1
    233.168

Euler 1
-------

Let's check out the code for Euler 1. First, the problem:

    If we list all the natural numbers below 10 that are multiples of
    3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

    Find the sum of all the multiples of 3 or 5 below 1000.

Here is the hoon solution (which should be in your pier directory under
`/gen/examples/euler1`):

    ::    project euler 1
    ::    https://projecteuler.net/problem=1
    ::  run in dojo with +examples-euler1
    ::
    ::::  /hoon/euler1/examples/gen
      ::
    :-  %say  |=  *  
    :-  %noun
    =<  (sum 1.000)
    ::
    ::::  ~sivtyv-barnel
      ::
    |%
    ++  three 
      |=  a/@
      =|  b/@
      |-  ^-  @u
      ?:  (lth a b)
        0
      (add b $(b (add 3 b)))

    ++  five
      |=  a/@
      =|  b/@
      |-  ^-  @
      ?:  (lte a b)
        0
      ?:  =((mod b 3) 0)
        $(b (add b 5))
      (add b $(b (add b 5)))

    ++  sum
      |=  a/@u
      (add (five a) (three a))
    --

> Hoon is not generally whitespace sensitive, but we do have two
> different kinds of whitespace: a single space and a gap, which is two
> or more spaces or a linebreak. Tabs are taboo. Do not use them.
> Really. For a more detailed explanation of when to use spaces vs.
> gaps, see the syntax section before the first exercises.

### Lines 1-11:

Any line that begins with `::` is a comment.

    :-  %say  |=  *  
    :-  %noun
    =<  (sum 1.000)

All you need to know about the lines above is that they call the `++sum`
function with an argument of `1.000`. We'll cover them in more detail
later.

### How to form expressions

Hoon does not typically use reserved words to form expressions. Instead,
expressions are formed with *runes*: digraphs of two ASCII symbols. Each
rune takes a specific number of children, either expressions formed by
other runes or literals that produce their own value (some runes take
*N* children, and are usually closed with `==`).

For example, the rune `?:` from line 17 is the classic 'if-then-else'
statement, and thus takes three children:

      ?:  (lth a b)           ::  if first child evals to true
        0                     ::  then produce result of second
      (add b $(b (add 3 b)))  ::  else, produce result of third

Since runes are such a fundamental structure in Hoon, we found ourselves
speaking them out loud frequently. It quickly grew cumbersome to have to
say "question mark, colon" to describe `?:`. To alleviate this problem,
we came up with our own naming scheme: each ASCII glyph has a
single-syllable pronunciation phonetically designed to be both easily
remembered and easily pronounced in conjunction with the other glyphs
(when forming a rune).

See the entire naming scheme below.

        ace [1 space]   gal <               pel (
        bar |           gap [>1 space, \n]  per )
        bas \           gar >               sel [
        buc $           hax #               sem ;
        cab _           hep -               ser ]
        cen %           kel {               soq '
        col :           ker }               tar *
        com ,           ket ^               tec `
        doq "           lus +               tis =
        dot .           pam &               wut ?
        fas /           pat @               zap !

Using this scheme, we would pronounce `?:` as 'wutcol'.

For those who prefer to use reserved words to form expressions, you can
substitute any rune with that rune's keyword, which you can find in
`++twig` in `/arvo/hoon.hoon`. For example, here's the code for `?:` in
`++twig`:

`{$if p/twig q/twig r/twig}                          ::  ?:  if/then/else`

Instead of:

    ?:(=(1 2) 'this is true' 'this is false')
    'this is false'`

You can write:

    :if(=(1 2) 'this is true' 'this is false')
    'this is false'

### Lines 12-34

Now let's quickly walk through this code line-by-line. Lines 12-34 are
wrapped in a `|%` ('[barcen](/hoon/twig/bar-core/cen-core/)'), which produces a core. Cores are a
fundamental datatype in Hoon, similar to a struct, class, or object. A
core is just a map of names to any kind of code, whether it be functions
or data. Each element in this map begins with a `++` followed by the
name and the corresponding code. Since `|%` takes an arbitrary number of
children, it needs to be closed with a `--`.

> `++` ('luslus') is not technically a rune, since it is only used in
> core syntax, as shown above.

Let's step into each of the three arms within our core.

### `++  sum`

    ++  sum
      |=  a/@
      (add (five a) (three a))
    --

`|=` ('[bartis](/hoon/twig/bar-core/tis-gate/)') produces a function, much like a lambda in lisp. It
takes two children:

1.  A set of argument(s). In this case our argument set only contains
    one: `a`, which is required to be an atom or natural number, denoted
    by `@`.

2.  The body of the function itself, which is executed when the function
    is called (in this case, with `(sum 1.000)`). This particular
    function adds the results of evaluating the gates `++   five` and
    `++three` with each of their respective input parameters set to `a`.

### ++ three

    ++  three 
      |=  a/@
      =|  b/@
      |-  ^-  @u
      ?:  (lth a b)
        0
      (add b $(b (add 3 b)))

As above, `++three` takes an integer argument, `a`, and then executes
the remainder of the code with `a` set to the actual arguments.

Similarly, `=|` ('[tisbar](/hoon/twig/tis-flow/bar-new/)') pushes its first child, `b` into our context
(in other words, it declares a variable `b`) and executes the remainder
of the code. However, `b` is not an argument; `=|` sets `b` to the
default value of whatever type it is declared as. Since the default
value of an atom is `0`, b is set to `0`.

> To produce the default value of any given type, use `$*` ('buctar')
> followed by the type. Alternatively, use the irregular form `*`.
>
>         > *@ :: produce the default value of atom @
>         0
>      
>         > *@p :: produce the phonemic base of atom @
>         ~zod

So now we have two variables: `a` is set to our input, and `b` is
initialized to `0`.

One way to think about `|-` ('[barhep](/hoon/twig/bar-core/hep-loop/)') is that it lays down a recursion
point. More on this later.

`^-` ('[kethep](/hoon/core/ket-cast/hep-cast/)') is just a cast that sets the result of the remainder of
the code to an unsigned integer, `@u`.

In pseudocode, the last three lines read like this: if `a` is less than
`b`, produce zero. Else, add `b` to the result of rerunning the segment
of the function following the `|-` with the value of `b` changed to `b`
plus three.

The only thing that should look completely unfamiliar to you here is the
`$(b (add 3 b))`, which causes us to recurse back to our last recursion
point with the value of `b` set to `(add 3 b)`. Note that we only
specify what changes (`b` in this case). If you recurse by an actual
function call, then you have to specify every argument.

> If you're familiar with Clojure, `|-` is `loop` and `$()` is `recur`.

**Exercises**:

Tweak your code to complete the following excercises.

There are a few runes and some syntax that we have yet to cover that you
will need to complete the excercises below. For these, please refer to
our cheatsheat at the bottom.

1.  Read and understand `++five` line by line.

2.  Change `++sum` to accept two variables, `a` and `b`. Pass `a` to
    `three` and `b` to `five`. Then run the code with `a` set to `1.000`
    and `q` set to `2.000`.

3.  Check if this new result is under one thousand. If it is, return the
    string `'result < 1.000'`. If not, return `'result >= 1.000'`.

### Review

    |%  ('barcen') start core (collection of named ++ arms; an "object")
    |=  ('bartis') define function
    =|  ('tisbar') define variable from type with default value
    |-  ('barhep') drop a recursion point
    ^-  ('kethep') cast
    ?:  ('wutcol') if-then-else
    =(a b)  test equality
    (function args ...)  call function with args

Lookup each of these expressions (and all others!) in the [Twig Expressions](/hoon/twig/) definition.

### New material

1.  There are two syntaxes for writing Hoon: tallform and wideform.

In tallform, expressions are formed with either two spaces or a line
break separating both a rune from its children and each of its children
from one another. We use tallform when writing multiline expressions.

For more concise expressions, we use wideform, which is always a single
line. Wideform can be used inside tallform expressions, but not vice
versa.

Wideform expressions are formed with a rune followed by `()` containing
its children, all of which are separated by a single space. For example,
to make a cell of two elements:

      :-(a b)

We've already seen wideform in action, for example with
`=((mod b 3) 0)`. In this case, `=` is actually an irregular form of
`.=`, which tests its two children for equality.

Surrounding a function with `()` is an irregular wide form syntax for
calling a function with *N* arguments. More on this later.

1.  `:-` makes a cell of values. The irregular wide form of this is
    `[a b]`, with two expressions separated by a single space. While the
    regular form of this rune takes a fixed number of children (two),
    its irregular wide form can accept *N* expressions: `[a1..an]`

2.  Cords are one datatype for text in Hoon. They're just a big atom
    formed from adjacent unicode bytes -- a "c string". To produce a
    cord, enclose text within single quotes. To set the type of an
    argument to a cord, use `@t`.


