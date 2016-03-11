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


