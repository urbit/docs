### `++ja`

Jar engine

      |_  a/(jar)

A container arm for `++jar` operation arms. A `++jar` is a `++map` of
`++list`s. The contained arms inherit the sample jar.

`a` is a jar.

    ~zod/try=> ~(. ja (mo (limo a/"ho" b/"he" ~)))
    <2.dgz [nlr([p={%a %b} q=""]) <414.fvk 101.jzo 1.ypj %164>]>

------------------------------------------------------------------------

### `+-get:ja`

Grab value by key

      +-  get                                               ::  gets list by key
        |*  b/*
        =+  c=(~(get by a) b)
        ?~(c ~ u.c)
      ::

Produces a list retrieved from jar `a` using the key `b`.

`a` is a `++jar`.

`b` is a key of the same type as the keys in `a`.

    ~zod/try=> =l (mo `(list ,[@t (list ,@)])`[['a' `(list ,@)`[1 2 3 ~]] ['b' `(list ,@)`[4 5 6 ~]] ~])
    ~zod/try=> l
    {[p='a' q=~[1 2 3]] [p='b' q=~[4 5 6]]}
    ~zod/try=> (~(get ja l) 'a')
    ~[1 2 3]
    ~zod/try=> (~(get ja l) 'b')
    ~[4 5 6]
    ~zod/try=> (~(get ja l) 'c')
    ~

------------------------------------------------------------------------

### `+-add:ja`

Prepend to list

      +-  add                                               ::  adds key-list pair
        |*  {b/* c/*}
        =+  d=(get b)
        (~(put by a) b [c d])

Produces jar `a` with value `c` prepended to the list located at key
`b`.

`a` is a jar.

`b` is a key of the same type as the keys in `a`.

`c` is a value of the same type as the values in `a`.

    ~zod/try=> =l (mo `(list ,[@t (list ,@)])`[['a' `(list ,@)`[1 2 3 ~]] ['b' `(list ,@)`[4 5 6 ~]] ~])
    ~zod/try=> l
    {[p='a' q=~[1 2 3]] [p='b' q=~[4 5 6]]}
    ~zod/try=> (~(add ja l) 'b' 7)
    {[p='a' q=~[1 2 3]] [p='b' q=~[7 4 5 6]]}
    ~zod/try=> (~(add ja l) 'a' 100)
    {[p='a' q=~[100 1 2 3]] [p='b' q=~[4 5 6]]}
    ~zod/try=> (~(add ja l) 'c' 7)
    {[p='a' q=~[1 2 3]] [p='c' q=~[7]] [p='b' q=~[4 5 6]]}
    ~zod/try=> (~(add ja l) 'c' `(list ,@)`[7 8 9 ~])
    ! type-fail
    ! exit

**
