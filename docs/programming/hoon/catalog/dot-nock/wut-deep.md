# `:deep`, `.?`, "dotwut", `{$deep p/twig}`

Test if noun is cell or atom.

Generates: Nock operator 3. Tests whether a noun is a cell or an
atom, producing true if it is the former and false if the latter.

Regular form: *1-fixed*

Examples:

    ~zod:dojo> .?(~)
    %.n
    ~zod:dojo> .?(5)
    %.n
    ~zod:dojo> .?(~porlep)
    %.n

In all of these cases our sample is implicitly down-cast to an atom,
which produces `|`.

    ~zod:dojo> .?([1 2 3])
    %.y
    ~zod:dojo> .?("ha")
    %.y
    ~zod:dojo> ._a_b__
    [%a %b]
    ~zod:dojo> .?(._a_b__)
    %.y

`[1 2 3]` is clearly a cell, `"ha"` is equivalent to the null-terminated
tuple of its ASCII codes, and `._a_b__` is also clearly a cell. Each
produce `&`.
