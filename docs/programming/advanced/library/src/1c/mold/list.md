### `++list`

List

mold generator. `++list` generates a mold of a null-termanated list of a
homogenous type.


Source
------

    ++  list  |*  a/$-(* *)                                 ::  null-term list
              $@($~ {i/a t/(list a)})                       ::


Examples
--------

See also: `++turn`, `++snag`

    > *(list)
    ~
    > `(list @)`"abc"
    ~[97 98 99]
    > (snag 0 "abc")
    'a'



***
