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


