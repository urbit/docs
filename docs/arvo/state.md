---
navhome: '/docs/'
next: True
sort: 14
title: State
---

# State

In the last section we built a few small apps that sent moves. These apps were
entirely stateless, however. Most useful apps require some amount of state.
Let's build a trivial stateful app. It'll keep a running the sum of all the
atoms we poke it with. Here's `app/examples/sum.hoon`:

    /?    314
    !:
    |_  {bowl state/@}
    ++  poke-atom
      |=  arg/@
      ^-  {(list) _+>.$}
      ~&  [%so-far (add state arg)]
      [~ +>.$(state (add state arg))]
    --

We can start it with `|start %examples-sum`, and then run it:

    ~fintud-macrep:dojo> :examples-sum &atom 5
    [%so-far 5]
    >=
    ~fintud-macrep:dojo> :examples-sum &atom 2
    [%so-far 7]
    >=
    ~fintud-macrep:dojo> :examples-sum &atom 15
    [%so-far 22]
    >=

We can see that app state is being saved, but when, where, and how?

The state is stored as the second thing in the `|_` line. In our case, it's
simply an atom named `state`. We change it by producing our state not with
`+>.$` (as before), but with `+>.$(state (add state arg))`. We've seen all these
parts before, but you might not recognize them.

Recall in the first chapter that we recursed with the expression
`$(b (add 3 b))`. This meant "produce `$` with `b` changed to `(add 3 b)`.
Similarly, `+>.$(state (add state arg))` means "produce `+>.$` (i.e. our
context, which contains our state) with `state` changed to `(add state arg)`.

At a high level, then, when we handle state, we do it explicitly. It's passed in
and produced explicitly. In Unix systems, application state is just a block of
memory, which you need to serialize to disk if you want to keep it around for
very long.

In Urbit, app state is a single (usually complex) value. In our example, we have
very simple state, so we defined `state/@`, meaning that our state is an atom.
Of course, `state` is just a name, and you're free to name your state whatever
you like. But let's clarify a couple other things before we continue.

First, `bowl` is a set of general global states. This set is managed by the
system. It includes things like `now` (the current time), `our` (our urbit
identity), and `eny` (256 bits of guaranteed-fresh entropy). For the full list
of things in `++bowl`, search for `++  bowl` (note: two spaces) in
`/arvo/zuse.hoon`.

> This is, perhaps, the most common way to learn Hoon. The easiest way to learn
> about an identifier you see in code is to search in `/arvo/zuse.hoon` and
> `/arvo/hoon.hoon` for it.\\ These "standard libraries" are usually simple to
> read. Since Urbit's codebase is less than 15000 lines of code combined,
> including the hoon parser, the compiler, and the `/arvo` microkernel, you can
> usually use the code and its comments as a reference doc.
>
> You can also read
> [zuse.hoon](https://github.com/urbit/arvo/blob/master/arvo/zuse.hoon) and
> [hoon.hoon](https://github.com/urbit/arvo/blob/master/arvo/hoon.hoon) in your
> browser.

The second thing we should clear up is this: Urbit needs no "serialize to disk"
step. Everything you produce in the app state is persistent across calls to the
app, restarts of the urbit, and even power failure. If you want to write to the
Unix filesystem, you can, but it's not needed for persistence. Urbit has
transactional events, which makes it an [ACID operating
system](https://en.wikipedia.org/wiki/ACID). Thus, you don't have to worry about
persistence when programming in Urbit, or ever go through the hassle of having
to set up and write to a database.

**Exercises**:

-   Modify `:examples-sum` to reset the counter when you poke it with 0.

-   Write an app that prints out the previous value you poked it with. Sample
    output:

<!-- -->

    ~fintud-macrep:dojo> :examples-last 7
    [%last 0]
    >=
    ~fintud-macrep:dojo> :examples-last [1 2 3]
    [%last 7]
    >=
    ~fintud-macrep:dojo> :examples-last 'howdy'
    [%last [1 2 3]]
