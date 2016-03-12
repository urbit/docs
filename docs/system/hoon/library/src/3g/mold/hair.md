### `++hair`

Parsing line and column

A pair of two [`@ud`]() used in parsing indicating line and column number.

Source
------

        ++  hair  ,[p=@ud q=@ud]                                ::  parsing trace

Examples
--------

    ~zod/try=> *hair
    [p=0 q=0]

    ~zod/try=> `hair`[1 1] :: parsing starts at [1 1] as a convention.
    [p=1 q=1]
    ~zod/try=> ((plus ace) [1 1] "   --")
    [p=[p=1 q=4] q=[~ u=[p=[~~. "  "] q=[p=[p=1 q=4] q="--"]]]]
    ~zod/try=> `hair`p:((plus ace) [1 1] "   --")
    [p=1 q=4]


