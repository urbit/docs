### `++dis`

Binary AND

Computes the bit-wise logical AND of two [atom]()s `a` and `b`, producing an
atom.

Accepts
-------

`a` is an atom.

`b` is an atom.

Produces
--------

An atom.

Source
------

    ++  dis                                                 ::  binary and
      ~/  %dis
      |=  [a=@ b=@]
      =|  [c=@ d=@]
      |-  ^-  @
      ?:  ?|(=(0 a) =(0 b))  d
      %=  $
        a   (rsh 0 1 a)
        b   (rsh 0 1 b)
        c   +(c)
        d   %+  add  d 
              %^  lsh  0  c 
              ?|  =(0 (end 0 1 a)) 
                  =(0 (end 0 1 b))
              ==
      ==

Examples
--------

    ~zod/try=> `@ub`9
    0b1001
    ~zod/try=> `@ub`5
    0b101
    ~zod/try=> `@ub`(dis 9 5)
    0b1
    ~zod/try=> (dis 9 5)
    1
    ~zod/try=> `@ub`534
    0b10.0001.0110
    ~zod/try=> `@ub`987
    0b11.1101.1011
    ~zod/try=> `@ub`(dis 534 987)
    0b10.0001.0010
    ~zod/try=> (dis 534 987)
    530


