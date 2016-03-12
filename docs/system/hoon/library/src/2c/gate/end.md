### `++end`

Tail

Produces an [atom]() by taking the last `b` blocks of size `a` from `c`.

Accepts
-------

`a` is a block size (see [`++bloq`]()).

`b` is an atom.

`c` is an [atom]().

Produces
--------

An atom.


Source
------

    ++  end                                                 ::  tail
      ~/  %end
      |=  [a=bloq b=@ c=@]
      (mod c (bex (mul (bex a) b)))

Examples
--------

    ~zod/try=> `@ub`12
    0b1100
    ~zod/try=> `@ub`(end 0 3 12)
    0b100
    ~zod/try=> (end 0 3 12)
    4
    ~zod/try=> `@ub`(end 1 3 12)
    0b1100
    ~zod/try=> (end 1 3 12)
    12
    ~zod/try=> `@ux`'abc'
    0x63.6261
    ~zod/try=> `@ux`(end 3 2 'abc')
    0x6261
    ~zod/try=> `@t`(end 3 2 'abc')
    'ab'



***
