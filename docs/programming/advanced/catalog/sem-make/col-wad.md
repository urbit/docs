# ``, `;:`, "semcol" `{$wad p/twig q/(list twig)}`

Fold over tuple.

Apply a binary function `p` to a tuple `q` with n elements. Similar to folding over the tuple `q`.

Regular form: *running*

Irregular form:

`:(p i.q i.t.q i.t.t.q)   ;:(p i.q i.t.q i.t.t.q)`

Examples:

    ~zod:dojo> (add 3 (add 4 5))
    12
    ~zod:dojo> ;:(add 3 4 5)
    12
    ~zod:dojo> :(add 3 4 5)
    12

Here we see how `;:` is equivalent to nesting our calls to the binary
gate `++add`.

    ~zod:dojo> :(weld "foo" "bar" "baz")
    ~[~~f ~~o ~~o ~~b ~~a ~~r ~~b ~~a ~~z]
    ~zod:dojo> `tape`:(weld "foo" "bar" "baz")
    "foobarbaz"
    ~zod:dojo> `tape`(weld "foo" (weld "bar" "baz"))
    "foobarbaz"

Following on from our previous example, using `;:` with `++weld` is
convenient for concatenating multiple strings.
