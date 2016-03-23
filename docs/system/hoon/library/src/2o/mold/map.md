### `++map`

Map

mold generator. A `++map` is a treap of
key-value pairs.


Source
------

    ++  map  |*  {a/$-(* *) b/$-(* *)}                      ::  associative tree
             $@($~ {n/{p/a q/b} l/(map a b) r/(map a b)})   ::


Examples
--------

See also: `++by`

    ~zod/try=>? *(map @t @u)
              nlr({p/@t q/@u})
              {}   
    ~zod/try=> (molt `(list (pair * *))`[[a+1 b+2] ~])
              {[p=[97 1] q=[98 2]]}
   

***
