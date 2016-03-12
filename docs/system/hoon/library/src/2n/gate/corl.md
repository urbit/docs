### `++corl`

Gate compose

XX Revisit

`a` is a gate.

`b` is a noun.

Source
------

    ++  corl                                                ::  compose backwards
      |*  [a=gate b=_,*]
      |=  c=_+<.b
      (a (b c))

Examples
--------

    ~zod/try=> ((corl (lift bex) (slat %ud)) '2')
    [~ 4]



***
