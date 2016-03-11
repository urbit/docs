### `++gate`

Function

A core with one arm, `$`--the empty name--which transforms a sample noun into a product
noun. If used [dryly]() as a type, the [subject]() must have a sample type of [`*`]().


Source
------

        ++  gate  $+(* *)                                       ::  general gate

Examples
--------

See also: [`++lift`](), [`++cork`]()

    ~zod/try=> *gate
    <1|mws [* <101.jzo 1.ypj %164>]>
    ~zod/try=> `gate`|=(* 0)
    <1|mws [* <101.jzo 1.ypj %164>]>

    ~zod/try=> (|=(a=* [a 'b']) 'c')
    [99 'b']
    ~zod/try=> (`gate`|=(a=* [a 'b']) 'c')
    [99 98]


