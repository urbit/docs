---
navhome: /docs/
sort: 12
next: true
title: The subject
---

The subject
===========

Now we're going to cover the boiler plate that we skimmed over earlier.

    :-  %say  |=  *  
    :-  %noun
    =<  (sum [1.000 2.000])

The first rune, `:-` (colhep, aka
[:cons](../../hoon/twig/col-cell/hep-cons/)), constructs the 2-element cell
that will be our program. The first element, `%say`, tells the
interpreter what to produce--in this case a value.

The second element is `|=`, which we know produces a function. `|=`'s
first child is its argument(s), which in this case is any noun (`*`).
Its second child is the remainder of the program.

Similarly, the rest of the program (which we construct with another
`:-`) is a cell of the literal `%noun`, which tells the shell that we're
producing a value of type `noun`, and the code that we run to actually
produce our value of the type `noun`.

`=<` ([tisgal](../../hoon/twig/tis-flow/gal-rap/)) is a rune that takes two
children. The second child is the context against which we run the first
child. So in this case, we are running the expression
`(sum [1.000 2.000])` against everything contained within the `|%`. In
Hoon, we call the code executed the "formula" and its context the
"subject".

    ::::::::::::::::::::::::::::::
    =<  (sum [1.000 2.000])     :: formula
    ::::::::::::::::::::::::::::::
    |%                          ::
    ++  three                   ::
      |=  a/@                   ::
      =|  b/@                   ::
      |-  ^-  @u                ::
      ?:  (lth a b)             ::
        0                       ::
      (add b $(b (add 3 b)))    ::
    ::                          ::
    ++  five                    ::
      |=  a/@                   ::  subject
      =|  b/@                   ::
      |-  ^-  @                 ::
      ?:  (lte a b)             ::
        0                       ::
      ?:  =((mod b 3) 0)        ::
        $(b (add b 5))          ::
      (add b $(b (add b 5)))    ::
    ::                          ::
    ++  sum                     ::
      |=  {a/@u b/@u}           ::
      (add (five a) (three b))  ::
    --                          ::
    ::::::::::::::::::::::::::::::

In nearly every language there is a similar concept of a "context" in
which expressions are executed. For example, in C this includes things
like the call stack, stack variables, and so on.

Hoon is unique in that this context is a first-class value. Scheme
allows a sort of reification of the context through continuations, and
some may see a parallel to Forth's stack, but Hoon takes the
concept one step further.

Our starting subject is the [standard library](../../hoon/library), which is
defined in `/arvo/hoon.hoon` and `/arvo/zuse.hoon`. This is where
functions like `add` are defined. When we define a core with `|%`, we
don't throw away the subject (i.e. the standard library); rather, we
stack the new core on top of the old subject so that both are
accessible.

**Exercises**:

-   Pass `++sum` its arguments (`2.000` and `3.000`) from the
    command line.

-   Comment out all of the arms of the `|%`. Now add another arm and
    call it `++add`, have it accept two arguments and produce 42
    (regardless of input). Change the `=<` line to
    `[(add 5 7)   (^add 5 7)]`. Can you recognize what's happening?

Cheatsheet:

-   To pass arguments from the command line to a program, you replace
    the `*` in the first line of the boiler plate to
    `{^ {{arg/TYPE $~} $~}}` where `TYPE` is replaced with the type of
    argument you're expecting. Then `+euler1 a` from the dojo sets `arg`
    to `a`.
-   The empty list is `~`
-   Lisp-style cons (construct a cell/prepend an element) is
    `[new-element list]`
-   For example, the first three positive integers are `[1 2 3   ~]`
-   `(gte a b)` tests whether `a` is greater than or equal to `b`.
-   `(mod a b)` runs the modulo operation on two atoms.
-   See the basic math section in `/arvo/hoon.hoon` for more info.
