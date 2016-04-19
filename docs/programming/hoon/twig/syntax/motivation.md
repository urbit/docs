# Motivation

Three common syntactic problems in functional languages that Hoon
is trying to fix: *terminator piles*, *indentation creep*,
and *feature/label confusion*.

## Terminator piles

*Terminator piles* are like Lisp's stacks of right parens.  If a
syntax uses matching glyphs besides `)`, they get truly ugly.
Significant whitespace solves this problem but introduces others.

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

The worst-case result of FLC is "DSL cancer".  Every source file
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
