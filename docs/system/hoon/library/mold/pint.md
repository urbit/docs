### `++pint`

Parsing range

Mostly used for stacktraces. A `++pint` is a pair of
[`++hair`](), indicating from `p` to `q`.

Source
------

        ++  pint  ,[p=[p=@ q=@] q=[p=@ q=@]]                    ::  line/column range

Examples
--------

    ~zod/try=> !:(!!)
    ! /~zod/try/~2014.9.20..01.22.04..52e3/:<[1 4].[1 6]>
    ~zod/try=> :: !! always produces a crash
    ~zod/try=> `pint`[[1 4] [1 6]]
    [p=[p=1 q=4] q=[p=1 q=6]]


