---
navhome: /docs/
sort: 12
next: true
title: Syntax
---

# Hoon syntax

Hoon's syntax is unusual, and to beginners it can look a lot more 
complex than it really is. However, we believe that anyone who 
learns Hoon syntax will find that it has a number of advantages.

# Motivation

Hoon syntax is trying to solve three serious
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
depth. This problem is especially irritating when working with 
long functions.  It's true that short functions are better, but 
long ones sometimes need to be written.

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

*Feature/label confusion* (FLC) is the result of any syntax that
makes it hard for the eye to tell whether a token on the screen is 
a feature of the language, or a label in the program.  For example, 
in Lisp a special form has the same syntax as a function call.

The worst-case result of FLC is "DSL cancer."  Every source file
is effectively written in its own domain-specific language.  To
read a new file is to learn a new language&mdash;"write-only code."

User-level macros, operator overloading, even excessive use of 
higher-order programming, can all lead quickly to the tragedy of 
write-only code.

Hoon has no FLC, user-level macros, or overloading. It does 
support higher-order programming; write-only Hoon can certainly be
(and has been) written.  But good Hoon style is to avoid it.

# Design

Hoon has a general syntax design with common principles and
regularities.  We'll cover those here.

## Glyphs and characters

Hoon source uses ASCII text. Hoon does not accept non-ASCII 
text in source files, except UTF-8 in quoted strings. Hard
tab characters are illegal.

Hoon is a heavy punctuation user.  Reading off code aloud 
using the proper names of ASCII symbols is tedious, so we've 
mapped each punctuation glyph to a syllable:

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

You don't need to memorize these glyph names, but it might help. 
Code is often vocalized or subvocalized. "pal" is easier to say,
aloud or silently, than "left paren".

Note that the list includes two separate whitespace forms: `ace`
for a single space; `gap` is either 2+ spaces or a newline.  In Hoon,
the only significance in whitespace is the difference between
`ace` and `gap`. Comments also count as `gap` whitespace&mdash;they 
start with `::` and run to the end of the line.

An 80-column right margin is strongly encouraged.  Really 
well-groomed Hoon uses a 55-column code margin and puts a standard 
line comment at column 57.

## Expressions and Runes

Each regular Hoon expression begins with a 
[rune](https://urbit.org/docs/about/glossary#rune). A rune is a pair 
of ASCII punctuation marks (a digraph)&mdash;e.g., `:-`.  The first 
glyph in the rune indicates the category&mdash;e.g., `:` runes make 
[cells](https://urbit.org/docs/about/glossary#cell) (i.e., ordered 
pairs). We pronounce runes using their glyph names&mdash;for `:-`, 
we say "colhep".

Each rune is followed by one or more subexpressions. The number and 
kind of subexpressions depend on the rune used.

```
:-  25
3
```

This twig uses `:-` to produce a cell: `[25 3]`. There are always two 
subexpressions following the `:-` in syntactically correct Hoon code, 
the first of which, when evaluated, becomes the *head* (i.e., the left) 
and the second of which becomes the *tail* (i.e., the right).

Hoon expressions are sometimes called 
[twigs](https://urbit.org/docs/about/glossary#twig). You'll find that 
Hoon code has a tree-like structure, so you can think of the various 
expressions as twigs of the tree.  The subexpressions following the 
rune are sometimes called the *children* of that twig.

## Tall and flat forms

There are two kinds of Hoon expression syntax: *tall* and *flat*.
Most runes can be used in both tall and flat twigs. Tall twigs can 
contain flat twigs, but not vice versa.

The `:-` expression in the last subsection was in tall form.  Here's 
the flat equivalent:

`:-(25 3)`

Visually, a tall twig looks like a "statement" and a flat twig
like an "expression," preserving the attractive visual shape of
procedural code without the nasty side effects.

## Regular and irregular forms

Most runes have *regular forms*, which share a common design.
There is a regular flat form and a regular tall form; most runes
have both kinds of implementation.  All tall forms are regular.

Some runes also have *irregular forms*, which follow no
principles at all.  All irregular forms are flat.

```
.=  22
23
```

The `.=` rune tests for equality the two subexpressions that 
follow, and returns a boolean. Above is the tall, regular form of 
`.=`.  Below is the irregular form:

`=(22 23)`

Some twigs have *only* irregular forms.

## Tall regular form

Tall regular forms start with a rune followed by a `gap`.
(Remember, a `gap` is any whitespace other than `ace`.) After 
that are the number and types of subexpressions appropriate for 
that rune.  Each subexpression is separated from its neighboring 
subexpressions by a `gap`.

Let's call everything in the twig after the initial rune the twig 
*body*. There are four body subtypes: *fixed*, *running*, *jogging*, 
and *[battery](https://urbit.org/docs/about/glossary#battery)*. 

Runes with a *fixed* number of subexpressions self-terminate. For 
instance, the `:-` and `.=` runes each have two subexpressions 
and are self-terminating.  Otherwise the twig is terminated by both
a `gap`, then either `==` (*running* or *jogging*, most twigs) or
`--` (*battery*).

The *running* body has a list of *children* (i.e., subexpressions). 
The *jogging* body has a list of child pairs, where the members of 
each pair are separated by a `gap`.  The *battery* body is
a list of symbol-child pairs, separated by a gap, prefixed by `++`
and then a gap.

This definition is enough to write Hoon that will parse.  But 
writing code with optimal whitespace management requires some 
additional informal conventions.

Whitespace design in Hoon is an art, not a science.  It involves
both tall/flat mode switches and well-shaped gaps.  (Hoon layout
could probably be done automatically with reasonable quality.
But it would at least take machine learning, not a rule engine.)

There are only two real *rules* in Hoon whitespace design: don't
go past 80 characters, and don't use (completely) blank lines.
Otherwise, if it looks good and is easy to read, it's good.  The 
best way to learn the art is to do everything by convention
until you know what you're doing.  Here are the conventions:

### Conventions: *fixed*

Twig bodies with *fixed* fanout use "backstep" indentation, which 
slopes backward and to the right by two spaces per line.  The first
twig child is two spaces after the end of the rune.

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

In optimal usage of backstep indentation, the most complicated twigs 
are at the bottom, keeping code flow vertical rather than diagonal.

### Conventions: *running*

A *running* twig body (a simple child list) puts the first child two
spaces after the end of the rune, and the following children straight 
down:

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

A *jogging* twig body (a list of child pairs) is like a running 
body, but with a pair of children on each line, separated by 
two spaces. Most jogging bodies start with a *fixed* sequence; 
the first jogging pair is below and two steps backward from the 
last fixed child.

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

A *battery* body has a list of symbol-child pairs, for the
[battery](https://urbit.org/docs/about/glossary#battery)
of a 
[core](https://urbit.org/docs/about/glossary#core).  A 
conventional example:

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

Flat regular form starts with the rune, followed by `pal`, `(` 
(left parenthesis), followed by a body whose subexpressions
are separated by `ace` (one space), followed by `par`, `)` (right
parenthesis).

A twig in flat form, `:if`, `?:`, `{$if p/twig q/twig r/twig}`:

`?:(p q r)`

The only exception is *jogging* bodies, in which subexpression
pairs are separated by commas:

```
foo(bar 42, baz 55, moo 17)
```

There is no flat regular form for *battery* bodies.  Be tall.

## Naming conventions

Hoon does not enforce any rule on symbols, except that capitals
are not allowed (use kebab-case).  However, a lot of system code
is written using "lapidary" conventions that need explanation.

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
[mold](https://urbit.org/docs/about/glossary#mold) `p`.  Hoon 
uses single-letter names for the same reason Algol style 
languages pass arguments by order, rather than keyword.  Naming 
items by order makes sense when there are no more than three or 
four; five is stretching it; six is outright ridiculous.

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
