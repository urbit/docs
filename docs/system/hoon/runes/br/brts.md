---
sort: 2
---

# `:gate`, `|=`, "bartis", `{$gate p/twig q/twig}`

Function with argument(s).

Produces: a dry `%gold` gate with sample `$*(p)`, arm `q`. A gate is a core with one arm, `$`, the
empty name.

Examples

    ~zod/try=> =inc |=(a/@ +(a))
    ~zod/try=> (inc 20)
    21

Here we create a very simple gate that increments its sample, `a`. You
can think of `|=` as similar to a straightforward function that takes
arguments.

    ++  add                                                 ::  add
          ~/  %add
          |=  [a/@ b=@]
          ^-  @
          ?:  =(0 a)
            b
          $(a (dec a), b +(b))

In ++add, from `hoon.hoon`, `|=` creates a gate whose sample takes
two atoms labeled `a` and `b`, and whose arm evaluates an expression
that produces the sum of the atoms by decrementing `a` until it is `0`
and incrementing `b` at each step. Here, `$` is used for recursion,
calling the gate produced by `|=` with `a` replaced by `(dec a)` and `b`
replaced by `+(b)`.
