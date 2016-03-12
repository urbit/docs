### `++mix`

Binary XOR

Produces the bit-wise logical XOR of `a` and `b`, producing an [atom]().

Accepts
-------

`a` is an atom

`b` is an atom

Produces
--------

An atom.

Source
------

    ++  mix                                                 ::  binary xor
      ~/  %mix
      |=  [a=@ b=@]
      ^-  @
      =+  [c=0 d=0]
      |-
      ?:  ?&(=(0 a) =(0 b))  d
      %=  $
        a   (rsh 0 1 a)
        b   (rsh 0 1 b)
        c   +(c)
        d   (add d (lsh 0 c =((end 0 1 a) (end 0 1 b))))
      ==

Examples
--------

    ~zod/try=> `@ub`2
    0b10
    ~zod/try=> `@ub`3
    0b11
    ~zod/try=> `@ub`(mix 2 3)
    0b1
    ~zod/try=> (mix 2 3)
    1
    ~zod/try=> `@ub`(mix 2 2)
    0b0
    ~zod/try=> (mix 2 2)
    0



***
