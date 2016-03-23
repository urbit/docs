---
sort: 2
---

# Philosophy

Hoon is a strict, typed functional language which compiles itself
to the Nock VM (whose spec fits on a T-shirt).

Hoon's design goal is to support higher-order typed functional
programming without category theory, formal logic, or other
interesting math.  The reasoning: (a) a programming language is a
user interface for programmers; (b) most programmers are not very
good at math.  Hoon is not quite as expressive as Haskell, though
fairly close.

Good Hoon style varies from good Haskell style.  Hoon encourages
coders to use higher-order programming as little as possible --
again, simply for UI reasons.  For example, multiple arguments
are curried by default in Haskell and tupled by default in Hoon.
The house style has been described as "procedural programming in
a functional language."  The power of Haskell, or close, is there
when we really need it.  But we try not to swat flies with it.

Hoon is objectively simple: its complexity is bounded by the size
of the compiler, about 3000 lines of Hoon.  This is split about
halfway half between frontend (parsing and macro expansion) and
backend (code generation and type inference).

This parser-heavy ratio reflects the belief that our brains are
better than everyone thinks at learning languages (symbols and/or
grammars), and worse at learning abstractions (proofs and/or
algorithms).  At first glance, Hoon may look gnarly (though its
squiggles are more structured than most ASCII-heavy languages).
But there's surprisingly little under the hood.

Keeping the Hoon-to-Nock mapping straightforward is a priority.
Very roughly, Hoon is to Haskell as C is to Pascal.  Pascal tries
to conceal its implementation beneath a layer of abstract
concepts; C, an "advanced macro assembler," tries to provide a
similar user experience with few abstract ideas as possible.
