section 2dD, casual containers
==============================

### `++mo`

Map from list

Produces a map of key-value pairs from the left-right cell pairs of list

Accepts
-------

`a` is a [`++list`]().

Produces
--------

A [`++map]()

Source
------

    ++  mo                                                  :: map from list
      |*  a=(list)
      =>  .(a `_(homo a)`a)
      =>  .(a `(list ,[p=_-<.a q=_->.a])`a)
      =+  b=*(map ,_?>(?=(^ a) p.i.a) ,_?>(?=(^ a) q.i.a))
      (~(gas by b) a)
    ::

Examples
--------

    ~zod/try=> (mo `(list ,[@t *])`[[`a` 1] [`b` 2] ~])
    {[p=`a` q=1] [p=`b` q=2]}

------------------------------------------------------------------------

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

------------------------------------------------------------------------

### `++qu`

Queue from list

Produces a queue from list `a`.

Accepts
-------

`a` is a [list]().

Produces
--------

A [`++que`]().

Source
------

    ++  qu                                                  ::  queue from list 
      |*  a=(list)
      =>  .(a `_(homo a)`a)
      =+  b=*(qeu ,_?>(?=(^ a) i.a))
      (~(gas to b) a)


Examples
--------

    ~zod/try=> (qu `(list ,@ud)`~[1 2 3 5])
    {5 3 2 1}
    ~zod/try=> (qu "sada")
    {'a' 'd' 'a' 's'}
    ~zod/try=> ~(top to (qu "sada"))
    [~ 's']

------------------------------------------------------------------------
