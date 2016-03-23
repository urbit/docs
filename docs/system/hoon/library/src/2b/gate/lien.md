### `++lien`

Logical "or" on list

Computes the Boolean logical "or" on the results of applying [gate]() `b` to every element of [`++list`]() `a`.

Accepts
-------

`a` is a list.

`b` is a gate.

Source
------

    ++  lien                                                ::  some of
      ~/  %lien
      |*  {a/(list) b/$-(* ?)}
      |-  ^-  ?
      ?~  a  |
      ?:  (b i.a)  &
      $(a t.a)
        
Examples
--------

    ~zod/try=> =a |=(a=@ (gte a 1))
    ~zod/try=> (lien (limo [0 1 2 1 ~]) a)
    %.y
    ~zod/try=> =a |=(a=@ (gte a 3))
    ~zod/try=> (lien (limo [0 1 2 1 ~]) a)
    %.n



***
