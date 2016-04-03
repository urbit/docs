### `++cat`

Concatenate

Concatenates two atoms, `b` and `c`, according to bloq size `a`, producing an
atom.

Accepts
-------

`a` is a block size (see `++bloq`).

`b` is an atom.

`c` is an atom.

Produces
--------

An atom.

Source
------

    ++  cat                                                 ::  concatenate
      ~/  %cat
      |=  {a/bloq b/@ c/@}
      (add (lsh a (met a b) c) b)


Examples
--------

    ~zod/try=> `@ub`(cat 3 1 0)
    0b1
    ~zod/try=> `@ub`(cat 0 1 1)
    0b11
    ~zod/try=> `@ub`(cat 0 2 1)
    0b110
    ~zod/try=> `@ub`(cat 2 1 1)
    0b1.0001
    ~zod/try=> `@ub`256
    0b1.0000.0000
    ~zod/try=> `@ub`255
    0b1111.1111
    ~zod/try=> `@ub`(cat 3 256 255)
    0b1111.1111.0000.0001.0000.0000
    ~zod/try=> `@ub`(cat 2 256 255)
    0b1111.1111.0001.0000.0000
    ~zod/try=> (cat 3 256 255)
    16.711.936



***
