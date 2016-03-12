### `++lth`

Less-than

Tests whether `a` is less than `b`.

Accepts
-------

`a` is an [atom]().

`b` is an atom.

Produces
--------

A boolean.

Source
------

    ++  lth                                                 ::  less-than
      ~/  %lth
      |=  [a=@ b=@]
      ^-  ?
      ?&  !=(a b) 
          |-  
          ?|  =(0 a)  
              ?&  !=(0 b) 
                  $(a (dec a), b (dec b))
      ==  ==  ==
    ::

Examples
--------

    ~zod/try=> (lth 4 5)
    %.y
    ~zod/try=> (lth 5 4)
    %.n
    ~zod/try=> (lth 5 5)
    %.n
    ~zod/try=> (lth 5 0)
    %.n


***
