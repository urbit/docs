### `++con`

Binary OR

Computes the bit-wise logical OR of two [atom]()s, `a` and `b`, producing an
atom.

Accepts
-------

`a` is an atom

`b` is an atom

Produces
--------

An atom.

Source
------

    ++  con                                                 ::  binary or
      ~/  %con
      |=  [a=@ b=@]
      =+  [c=0 d=0]
      |-  ^-  @
      ?:  ?&(=(0 a) =(0 b))  d
      %=  $
        a   (rsh 0 1 a)
        b   (rsh 0 1 b)
        c   +(c)
        d   %+  add  d  
              %^  lsh  0  c 
              ?&  =(0 (end 0 1 a)) 
                  =(0 (end 0 1 b))
              ==
      ==

Examples
--------

    ~zod/try=> (con 0b0 0b1)
    1
    ~zod/try=> (con 0 1)
    1
    ~zod/try=> (con 0 0)
    0
    ~zod/try=> `@ub`(con 0b1111.0000 0b1.0011)
    0b1111.0011    
    ~zod/try=> (con 4 4)
    4
    ~zod/try=> (con 10.000 234)
    10.234


