### `++fnv`

Hashes an atom with the 32-bit FNV non-cryptographic hash algorithm.
Multiplies `a` by the prime number 16,777,619 and then takes the block
of size 5 off the product's end, producing an atom.

Accepts
-------

`a` is an atom.

Produces
--------

An atom.


Source
------

    ++  fnv  |=(a/@ (end 5 1 (mul 16.777.619 a)))           ::  FNV scrambler

Examples
--------

    ~zod/try=> (fnv 10.000)
    272.465.456
    ~zod/try=> (fnv 10.001)
    289.243.075
    ~zod/try=> (fnv 1)
    16.777.619



***
