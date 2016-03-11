### `++sa`

Set from list

Produces a set of the elements in list `a`.

Accepts
-------

`a` is a [list]().

Produces
--------

A [`++set`]().

Source
------

    ++  sa                                                  :: set from list
      |*  a=(list)
      =>  .(a `_(homo a)`a)
      =+  b=*(set ,_?>(?=(^ a) i.a))
      (~(gas in b) a)
    ::


Examples
--------

    ~zod/try=> (sa `(list ,@)`[1 2 3 4 5 ~])
    {5 4 1 3 2}
    ~zod/try=> (sa `(list ,[@t *])`[[`a` 1] [`b` 2] ~])
    {[`a` 1] [`b` 2]}


