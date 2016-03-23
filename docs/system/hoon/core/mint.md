---
sort: 6
---

# Compiler: `mint`

`mint` is the Hoon compiler.  It maps a cell `{subject/span
source/twig}` to a cell `{product/span formula/nock}`, where
`span` is a type, `twig` is a compiled expression, and `nock` is
a Nock formula.

Calculating the output type from the input type and the source
code is called "type inference." If you've used another typed
functional language, like Haskell, Hoon's type inference does the
same job but with less intelligence.

Haskell infers backward and forward; Hoon only infers forward.
Hoon can't figure out the type of a noun from how you use it,
only from how you make it.  Hoon can infer tail recursion, but
not head recursion.

Low-powered type inference means you need more type annotations,
which makes your program more readable anyway.  (Also, the dumber
the compiler, the easier it is for a dumb human to understand
what the compiler is thinking.) 
