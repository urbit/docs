# `:same`, `.=`, "dottis", `{$same p/twig q/twig}`

Test equality.

Generates: Nock operator 5. Tests two nouns `p` and `q` for equality, producing a boolean.

Regular form: *2-fixed*

Examples:

    ~zod:dojo> =(0 0)
    %.y
    ~zod:dojo> =(1 2)
    %.n

Comparing two atoms is the most straightforward case of `.=`.

    ~zod:dojo> =("a" [97 ~])
    %.y
    ~zod:dojo> =(~nec 1)
    %.y
    ~zod:dojo> =([%a 2] a/(dec 3))
    %.y
    ~zod:dojo> =([%b 2] a/(dec 3))
    %.n

It's important to keep in mind that `.=` compares the atomic equivalent
of each `p` and `q`. In the first case of this example the tape `"a"` is
actually the list `[97 0]` since the ASCII code for `'a'` is 97. The
following cases serve to show similar implicit down-casts.

    /~zod:dojo> =isa  |=  a/@t
                      ?:  =(a 'a')
                        'yes a'
                      'not a'
    new var %isa
    /~zod:dojo> (isa 'b')
    'not a'
    /~zod:dojo> (isa 'a')
    'yes a'

In common practice `.=` is often used inside of `?` runes, where
switching on equality is needed. Here we construct a simple function to test
if our argument is equal to `'a'` and produce either `'yes a'` or
`'not a'` accordingly.
