---
navhome: /docs/
sort: 10
next: true
title: Mission
---

# Mission

Hoon is a strict, typed functional language which compiles itself
to [Nock](../../nock), a combinator interpreter whose spec fits
on a T-shirt.

Hoon's design goal is to support higher-order typed functional
programming without category theory, formal logic, or other
interesting math.  The reasoning: (a) a programming language is a
user interface for programmers; (b) most programmers are not very
good at math.

Hoon is not quite as expressive as Haskell, though fairly close.
But good Hoon style isn't good Haskell style.  Hoon encourages
coders to use higher-order programming as little as possible --
again, simply for UI reasons.  For example, multiple arguments
are curried by default in Haskell and tupled by default in Hoon.
The Hoon style has been described as "procedural programming in
a functional language."

Hoon is objectively simple: its complexity is bounded by the size
of the compiler, about 3000 lines of Hoon.  This is split evenly
between frontend (parsing and macro expansion) and backend (code
generation and type inference).

Compared to most languages, Hoon has a heavier front end (more
complex syntax) and a lighter back end (less complex semantics).
This ratio reflects the belief that our brains are better than
everyone thinks at learning languages (symbols and/or grammars),
and worse at learning abstractions (proofs and/or algorithms).
At first glance, Hoon may look gnarly (though its squiggles are
more structured than most ASCII-heavy languages).  But under the
hood, there's much less complexity than you might expect.

Keeping the Hoon-to-Nock mapping simple and transparent is a
priority.  In a sense, Hoon is to Haskell as C is to Pascal.
There is no opaque high-level abstraction of Hoon's semantics;
the language is what the compiler does.  This design only works
when the compilation process is trivial or nearly so.
