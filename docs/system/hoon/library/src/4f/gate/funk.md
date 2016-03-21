### `++funk`

Add to tape

Parser modifier: prepend text to `++tape` before applying parser.

Accepts
-------

`pre` is a `++tape`

`sef` is a `++rule`

Produces
--------

A `++rule`.

Source
------

    ++  funk                                                ::  add to tape first
      |*  {pre/tape sef/rule}
      |=  tub/nail
      (sef p.tub (weld pre q.tub))

Examples
--------

    ~zod/try=> ((funk "abc prefix-" (jest 'abc')) [[1 1] "to be parsed"])
    [p=[p=1 q=4] q=[~ [p='abc' q=[p=[p=1 q=4] q=" prefix-to be parsed"]]]]
    ~zod/try=> ((funk "parse" (just 'a')) [[1 4] " me"])
    [p=[p=1 q=4] q=~]



***
