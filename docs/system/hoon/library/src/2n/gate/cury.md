### `++cury`

Curry a gate, binding the head of its sample

Accepts
-------

`a` is a gate.

`b` is a noun.

Produces
--------

A gate.

Source
------

    ++  cury                                                ::  curry left
      |*  {a/_|=(^ **) b/*}
      |*  c/_+<+.a
      (a b c)
    ::


Examples
--------

    ~zod/try=> =mol (cury add 2)
    ~zod/try=> (mol 4)
    6
    ~zod/try=> (mol 7)
    9



***
