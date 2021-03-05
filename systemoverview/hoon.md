+++
title = "Hoon"
weight = 20
template = "doc.html"
aliases = ["/understanding-urbit/technical-overview"]
+++

Hoon is a strictly typed functional programming language that compiles itself
to Nock and is designed to support higher-order functional programming without
requiring knowledge of category theory or other advanced mathematics.  Haskell
is fun but it isn't for everybody.

Hoon aspires to a concrete, imperative feel.  To discourage the creation of
write-only code, Hoon forbids user-level macros and uses ASCII digraphs instead
of keywords.  The type system infers only forward and does not use unification,
but is not much weaker than Haskell's.  The compiler and inference engine is
about 3000 lines of Hoon.

