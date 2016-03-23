### `++curr`

Right curry

Right curry a gate, binding the tail of its sample

Accepts
-------

`a` is a gate.

`c` is a noun.

Produces
--------


Source
------

    ++  curr                                                ::  curry right
      |*  {a/_|=(^ **) c/*}     
      |*  b/_+<+.a
      (a b c)
    ::

Examples
--------

    ~zod/try=> =tep (curr scan sym)
    ~zod/try=> `@t`(tep "asd")
    'asd'
    ~zod/try=> `@t`(tep "lek-om")
    'lek-om'



***
