---
sort: 10
---

# `:gill`, `|*`, "bartar", `{$gill p/twig q/twig}`

Function with arguments; type checking at call time

Produces: a gate with argument `p` and body `q`. Type checking happens at
call time. 

Regular form: *1-fixed*, followed by Battery

Examples:

    ~zod/try=> %.('c' |*(a/@ a))
    'c'
    ~zod/try=> %.('c' |=(a/@ a))
    99

This is a concise way of understanding the difference between `|*` and
`|=`. We use `%.` in both cases to slam each gate with the sample `'c'`.
`|=` uses its mold `a=@` to cast `'c'` to an atom (`99` is the ASCII
code for `'c'`). `|*` simply ensures that the product type matches the
input sample type.

    ++  flop                                                ::  reverse
          ~/  %flop
          |*  a/(list)
          =>  .(a (homo a))
          ^+  a
          =+  b=`_a`~
          |-
          ?@  a
            b
          $(a t.a, b [i.a b])

In `++flop`, `|*` is used so the type information within the passed
in list is maintained. Without a `|*`, any cords would be cast to nouns
as in our previous example.
