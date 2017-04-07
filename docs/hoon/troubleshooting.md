---
navhome: /docs/
sort: 12
title: Troubleshooting
next: true
---

# Troubleshooting

Ideally your Hoon works perfectly the first time.  But...

## Syntax errors

When you get a syntax error, you'll see a message like

```
syntax error: 10 12
```

This is a line and column number; more exactly, the line and
column of the first byte the parser couldn't interpret as part of
a correct Hoon file.  These values are always correct.

Usually, the line and column tell you everything you need to
know.  But the worst-case scenario for a syntax error is that,
somewhere above, you've confused Hoon's tall form by using the
wrong fanout for a rune.  For example, `%+` (`:calt`, a function
call whose sample is a cell) has three subtwigs:

```
%+  foo
  bar
baz
```

But if you make a mistake and write

```
%+  foo
bar
```

the parser will eat the next twig below and try to treat it as a
part of the `%+`.  This can cause a cascading error somewhere
below, usually stopped by a `==` or `--`.

When this happens, don't panic!  Binary search actually works
quite well.  Any twig can be stubbed out as `!!`.  Find the
prefix of your file that compiles, then work forward until
the actual error appears.

## Semantic errors

Now your code parses but doesn't compile.

### Turn on debugging

Your first step should be to put a `!:` ("zapcol") rune at the
top of the file.  This is like calling the C compiler with `-g`;
it tells the Hoon compiler to generate tracing twigs.

Bear in mind that `!:` breaks tail-call optimization.  This is a
bug, but a relatively low-priority bug.  `!.` turns off `!:`.
Note that `!:` and `!.` are twig-level, not file-level; you can
wrap any twig in either.

### Error trace

If you have `!:` on, you'll see an error trace, like

```
/~zod/home/0/gen/hello:<[7 3].[11 21]>
/~zod/home/0/gen/hello:<[8 1].[11 21]>
/~zod/home/0/gen/hello:<[9 1].[11 21]>
/~zod/home/0/gen/hello:<[10 1].[11 21]>
/~zod/home/0/gen/hello:<[11 1].[11 21]>
/~zod/home/0/gen/hello:<[11 7].[11 21]>
nest-fail
```

The bottom of this trace is the line and column of the twig which
failed to compile, then the cause of the error (`nest-fail`).

Hoon does not believe in inundating you with possibly irrelevant
debugging information.  Your first resort is always to just look
at the code and try to figure out what's wrong.  This practice
strengthens your Hoon muscles.

(Consider the opposite extreme; imagine if you had a magic bot
that always fixed your compiler errors for you.  Pro: no time
wasted on compiler errors.  Con: you never learn Hoon.)

## Common errors

Moral fiber is all very well and good, but sometimes you're
stumped.  Couldn't the compiler help a little?  These messages do
mean something.  Here are the three most common:

### `nest-fail`

This is a type mismatch (`nest` is the Hoon typechecker).  It
means you tried to pound a square peg into a round hole.

What was the peg and what was the hole?  Hoon doesn't tell you by
default, because moral fiber, and also because in too many cases
trivial errors lead to large intimidating dumps.  However, you
can use the `~!` rune ("sigzap", `:peep`) to print the type of
any twig in your stack trace.

For instance, you wrote `(foo bar)` and got a `nest-fail`.  Change
your code to be:

```
~!  bar
~!  +6.foo
(foo bar)
```

You'll get the same `nest-fail`, but this will show the type of
`bar`, then the type of the sample of the `foo` gate.

### `find.foo`

A `find.foo` error means limb `foo` wasn't found in the subject.
In other words, "undeclared variable."

The most common subspecies of `find` error is `find.$`, meaning
the empty name `$` was not found.  This often happens when you
use a twig that does not produce a gate/mold, as a gate/mold.

For instance, `(foo bar)` will give `find.$` if `foo` is not
actually a function.  `?=([%foo %bar] baz)` will give `find.$`,
because `?=` ("wuttis", `:fits`) needs a mold rather than a seed
(you probably meant `?=({$foo $bar} baz)`).

### `mint-vain` and `mint-lost`

These are errors caused by type inference in pattern matching.
`mint-vain` means this twig is never executed.  `mint-lost` means
there's a case in a `?-` ("wuthep", `:case`) that isn't handled.

## Runtime crashes

If your code crashes at runtime or overflows the stack, you'll
see a stack trace that looks just like the trace above.  Don't
confuse runtime crashes with compilation errors, though.

If your code goes into an infinite loop, kill it with `ctrl-c` (you'll
need to be developing on the local console; otherwise, the
infinite loop will time out either too slowly or too fast).  The
stack trace will show what your code was doing when interrupted.

The counterpart of `~!` for runtime crashes is `~|` ("sigbar",
`:show`):

```
~|  foo
(foo bar)
```

If `(foo bar)` crashes, the value of `foo` is printed in the
stack trace.  Otherwise, the `~|` has no effect.

## Debugging printfs

The worst possibility, of course, is that your code runs but does
the wrong thing.  This is relatively unusual in a typed
functional language, but it still happens.

`~&` ("sigpam", `:dump`) is Hoon's debugging printf.  This
pretty-prints its argument:

```
~&  foo
(foo bar)
```

will always print `foo` every time it executes.  A variant is
`~?` ("sigwut", `:warn`), which prints only if a condition is
true:

```
~?  =(37 (lent foo))  foo
(foo bar)
```

For now, you need to be on the local console to see these debug
printfs (which are implemented by interpreter hints).  This is a
bug and, like all bugs, will be fixed at some point.
