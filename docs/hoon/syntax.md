---
navhome: /docs/
sort: 14
next: true
title: Syntax
---

# Hoon syntax

Hoon's semantics are simple, but unusual.  Hoon's syntax is
complex, and unusual.  Sorry.

# Motivation

An excuse: the normal human brain doesn't have hardware support
for math, but it does have hardware support for syntax.  Learning
math is harder than it looks.  Learning syntax is easier.

An explanation: the Hoon syntax is trying to solve three serious
problems in functional syntax design.  These are *terminator
piles*, *indentation creep*, and *feature/label confusion*.

## Terminator piles

*Terminator piles* are like Lisp's stacks of right parentheses.
Significant whitespace solves this problem and creates others.

Hoon has no terminator piles.  Except for a 1-space / more-space
distinction, it has no significant whitespace.

## Indentation creep

*Indentation creep* is a problem caused by indentation conventions
where the indentation point is a function of expression tree
depth.  It's true that short functions are better than long ones,
but long ones sometimes need to be written.

A procedural block has a backbone of statements which flows
straight down.  Most expressions are flat and of limited depth.
With some bulging, a long function flows *down* the page.

A functional language lacks the expression/statement distinction.
So a long function means a deep tree.  Given normal indentation
conventions, a long function wants to flow *down and across*.
This *diagonal* shape fits poorly into most editor windows.

Thanks to backstep indentation (see below), Hoon programs are
shaped more or less like procedural programs.

## Feature/label confusion

*Feature/label confusion* is any syntax which makes it hard for
the eye to tell whether a token on the screen is a feature of the
language, or a label in the program.  For example, in Lisp a
special form has the same syntax as a function call.

The worst-case result of FLC is "DSL cancer."  Every source file
is effectively written in its own domain-specific language.  To
read a new file is to learn a new language -- "write-only code."

A fixed reserved-word set, especially with syntax highlighting,
and especially with orthogonal grammar (in C, you don't write
`for(a b c)`), may not be too bad.  User-level macros, operator
overloading, even excessive use of higher-order programming,
can all lead quickly to the tragedy of write-only code.

Hoon has very weak FLC in keyword style, none in rune style.
It has no user-level macros or overloading.  It does support
higher-order programming; write-only Hoon can certainly be
(and has been) written.  But good Hoon style is to avoid it.

# Design

Because each twig stem has its own bulb, each has its own parser
rule.  We'll describe these grammars as we go through the stems.

But Hoon has a general syntax design with common principles and
regularities.  We'll cover those here.

## Glyphs and characters

Hoon is a heavy punctuation user.  To make ASCII great again,
we've mapped each punctuation glyph to a syllable:

```
ace [1 space]   gal <               pal (
bar |           gap [>1 space, nl]  par )
bas \           gar >               sel [
buc $           hax #               sem ;
cab _           hep -               ser ]
cen %           kel {               sig ~
col :           ker }               soq '
com ,           ket ^               tar *
doq "           lus +               tec `
dot .           pam &               tis =
fas /           pat @               wut ?
zap !
```

You don't need to memorize these glyph names, but it helps.  Code
is often vocalized or subvocalized.   "pal" is easier to say,
aloud or silently, then "left paren."

Note that the list includes two separate whitespace forms: `ace`
for a single space, `gap` for 2+, comment or newline.  In Hoon,
the only significance in whitespace is the difference between
`ace` and `gap`.

Comments start with `::` and run to the end of the line.  Hard
tab characters are illegal, and an 80-column right margin is
strongly encouraged.  Really well-groomed Hoon uses a 55-column
code margin and puts a standard line comment at column 57.

Hoon does not accept non-ASCII text in source files, except UTF-8
in quoted strings.

## Tall and flat forms

There are two kinds of Hoon expression syntax: *tall* and *flat*.
Most stems have both tall and flat forms.  Tall twigs can contain
flat twigs, but not vice versa.

Visually, a tall twig looks like a "statement" and a flat twig
like an "expression," preserving the attractive visual shape of
procedural code without the nasty side effects.

## Regular and irregular forms

Most stems have *regular forms*, which share a common design.
There is a regular flat form and a regular tall form; most stems
implement both.  All tall forms are regular.

Some twigs also have *irregular forms*, which follow no
principles at all.  All irregular forms are flat.

Some twigs (simple leafy ones) have *only* irregular forms.

## Keywords versus runes

A regular form starts with a *sigil*, which is either a
*keyword* or a *rune* -- at the programmer's choice.

A *keyword* is `:` and then the stem label - e.g., `:cons`.

A *rune* is a pair of ASCII punctuation marks (a digraph) - e.g.,
`:-`.  The first glyph in the rune indicates the category - e.g.,
`:` runes make cells.  Runes can be pronounced by their glyphs or
by their stem -- for `:-`, you can say either "colhep" or "cons".

Keywords may be less challenging for early learners.  Rune style
is less cluttered and distracting for experienced programmers;
the system codebase is all in rune style.   Beginners can start
with keywords and move to runes; start with runes and stick
with runes; or start with keywords and stick with keywords.

Here's the FizzBuzz demo code, in idiomatic rune syntax.  Compare
with the [original](../demo).

```
  |=  end/atom
  =/  count  1
  |-  ^-  (list tape)
  ?:  =(end count)  ~
  :_  $(count (add 1 count))
  ?:  =(0 (mod count 15))
    "FizzBuzz"
  ?:  =(0 (mod count 5))
    "Fizz"
  ?:  =(0 (mod count 3))
    "Buzz"
  (pave !>(count))
```

## Tall regular form

Tall regular form starts with the sigil, followed by a `gap`
(any whitespace except `ace`), followed by a bulb whose twigs are
separated by `gap`.

There are four body subtypes: *fixed*, *running*, *jogging*, and
*battery*.  Stems with a *fixed* number of subexpressions
self-terminate.  For instance, `:if` has three subexpressions and
is self-terminating.  Otherwise the twig is terminated by a
`gap`, then either `==` (*running* or *jogging*, most twigs) or
`--` (*battery*).

The *running* body is a list of twigs.  The *jogging* body is a
list of twig pairs, separated by a `gap`.  The *battery* body is
a list of symbol-twig pairs, separated by a gap, prefixed by `++`
and then a gap.

This definition is enough to parse.  But the proper shape of the
whitespace gaps demands an informal convention.

Whitespace design in Hoon is an art, not a science.  It involves
both tall/flat mode switches and well-shaped gaps.  (Hoon layout
could probably be done automatically with reasonable quality.
But it would at least take machine learning, not a rule engine.)

There are only two real *rules* in Hoon whitespace design: don't
go past 80 characters, and don't use (completely) blank lines.
Otherwise, if it looks good and is easy to read, it's good.  But
the best way to learn the art is to do everything by convention
until you know what you're doing.  Here are the conventions:

### Conventions: *fixed*

Bulbs with *fixed* fanout use "backstep" indentation, which slopes
backward and to the right by two spaces per line.  The first
child is two spaces after the end of the sigil.

Some *1-fixed*, *2-fixed*, *3-fixed* and *4-fixed* examples:

```
|.
p

=|  p
q

?:  p
  q
r

%^    p
    q
  r
s
```

The hope of backstep indentation is that the heaviest twigs are
at the bottom, keeping code flow vertical rather than diagonal.


### Conventions: *running*

A *running* bulb (a simple child list) puts the first child two
spaces after the end of the sigil, and the following children
straight down:

A *running* example:

```
:*  p
    q
    r
    s
    t
==
```

### Conventions: *jogging*

A *jogging* bulb (a list of child pairs) is like a running bulb,
but backsteps the head of the pair above the tail.  Most jogging
twigs start with a *fixed* sequence; the first jogging pair is
below and two steps backward from the last fixed child.

There are two jogging conventions: *flat* (pair on one line) and
*tall* (pair split across lines).

A *flat jogging* example (preceded by *1-fixed* `p`)

```
?-  p
  q  r
  s  t
  u  v
==
```

A *tall jogging* example (preceded by *1-fixed* `p`):

```
?-    p
    q  
  r
    s  
  t
    u  
  v
==
```

### Conventions: *battery*

A *battery* bulb is a list of symbol-twig pairs, for the battery
of a core.  A conventional example:

```
|%
++  dry-arm-foo
  %p
++  dry-arm-bar
  %q
+-  wet-arm-baz
  %r
--
```

## Flat regular form

Flat regular form starts with the sigil, followed by `pal`
(`(`, left parenthesis), followed by a bulb whose subexpressions
are separated by `ace` (one space), followed by `par` (`)`, right
parenthesis).

A twig in flat form, `:if`, `?:`, `{$if p/twig q/twig r/twig}`:

```
:if(p q r)

?:(p q r)
```

The only exception is *jogging* bodies, in which subexpression
pairs are separated by commas:

```
:make(foo bar 42, baz 55, moo 17)
```

There is no flat regular form for *battery* bodies.  Be tall.

## Naming conventions

Hoon does not enforce any rule on symbols, except that capitals
are not allowed (use kebab-case).  However, a lot of system code
is written in using "lapidary" conventions that need explanation.

Naming things is one of the hard problems in CS.  Dodging this
problem is one of the reasons mathematicians use Greek letters,
not variable names.  Meaningful names also interpose a verbal
interpretation, distracting at best and confusing at worst, on
the formula or algorithm.  Greek letters are not *meaningful*,
but they are *memorable*.  And their interpretation is defined by
the formula and nothing else.

### Lapidary and ultralapidary

In the *lapidary* naming style, labels are pronounceable
three-letter strings, usually CVC (consonant-vowel-consonant).
Sometimes they encode a mnemonic, but usually they are just
memorable.  Labels are reused wherever the analogy seems
appropriate.

In the *ultralapidary* naming style, labels are single letters,
starting in order of construction from `a`, or within a tuple
mold `p`.  Hoon uses single-letter names for the same reason
Algol style languages pass arguments by order, rather than
keyword.  Naming items by order makes sense when there are no
more than three or four; five is stretching it; six is outright
ridiculous.

For example, when defining `add`, we want to name the operands
`a` and `b`.  It's silly to call them `foo` and `bar`, let alone
`left-operand` and `right-operand`.  The smaller the scale of an
algorithm, the simpler its names should be.

### When in doubt, don't be lapidary

This works in the other direction: namelessness doesn't scale.
Most normal code shouldn't use lapidary naming at all.  (Everyone
agrees: there is *way* too much lapidary Hoon in Urbit.)

Lapidary naming is only for *inherently simple code*: code that
both aspires to high elegance and clarity, and *is solving a
simple and elegant problem*.

Given an ugly or complex problem, lapidary naming is a liability,
no matter the excellence of the programmer.  When in doubt, use
long names and/or kebab-case.

## Freedom

If you came all this way to learn how to write apps, you're all
set. This is about all you need to know to start getting your
hands dirty. Refer back here or to the [standard library](../../hoon/library) when
needed, but for now, move on to [Arvo](../../arvo) to continue learning.

If, however, good enough is *not* enough, feel free to dive deeper:
