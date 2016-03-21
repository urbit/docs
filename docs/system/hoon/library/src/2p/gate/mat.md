### `++mat`

Length-encode

Produces a cell whose tail `q` is atom `a` with a bit representation of
its length prepended to it (as the least significant bits). The head `p`
is the length of `q` in bits.

Accepts
-------

`a` is an atom.

Produces
--------

A cell of two atoms, `p` and `q`. 

Source
------

    ++  mat                                                 ::  length-encode
      ~/  %mat
      |=  a/@
      ^-  {p/@ q/@}
      ?:  =(0 a)
        [1 1]
      =+  b=(met 0 a)
      =+  c=(met 0 b)
      :-  (add (add c c) b)
      (cat 0 (bex c) (mix (end 0 (dec c) b) (lsh 0 (dec c) a)))
    ::


Examples
--------

    ~zod/try=> (mat 0xaaa)
    [p=20 q=699.024]
    ~zod/try=> (met 0 q:(mat 0xaaa))
    20
    ~zod/try=> `@ub`q:(mat 0xaaa)
    0b1010.1010.1010.1001.0000
    ~zod/try=> =a =-(~&(- -) `@ub`0xaaa)
    0b1010.1010.1010
    ~zod/try=> =b =-(~&(- -) `@ub`(xeb a))
    0b1100
    ~zod/try=> =b =-(~&(- -) `@ub`(met 0 a))
    0b1100
    ~zod/try=> =c =-(~&(- -) (xeb b))
    4
    ~zod/try=>  [`@ub`a `@ub`(end 0 (dec c) b) `@ub`(bex c)]
    [0b1010.1010.1010 0b100 0b1.0000]



***
