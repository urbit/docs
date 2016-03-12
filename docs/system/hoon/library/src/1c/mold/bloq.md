### `++bloq`

Blocksize

Atom representing a blocksize, by convention expressed as a power of 2.


Source
------

    ++  bloq  ,@                                            ::  blockclass

Examples
--------

    ~zod/try=> :: ++met measures how many bloqs long an atom is
    ~zod/try=> (met 3 256)
    2
    ~zod/try=> :: 256 is 2 bloqs of 2^3

