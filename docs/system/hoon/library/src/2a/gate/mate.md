### `++mate`

Choose

Accepts two units `a` and `b` whose values are expected to be
equivalent. If either is empty, then the value of the other is produced.
If neither are empty, it asserts that both values are the same and
produces that value. If the assertion fails, `++mate` crashes with
`'mate'` in the stack trace.

Accepts
-------

`a` is a unit.

`b` is a unit.

Produces
--------

A unit or crash.

Source
------

    ++  mate                                                ::  choose
      |*  {a/(unit) b/(unit)}
      ?~  b  a
      ?~  a  b
      ?.(=(u.a u.b) ~|('mate' !!) a)


Examples
--------

    ~zod/try=> =a ((unit @) [~ 97])
    ~zod/try=> =b ((unit @) [~ 97])
    ~zod/try=> (mate a b)
    [~ 97]
    ~zod/try=> =a ((unit @) [~ 97])
    ~zod/try=> =b ((unit @) [~])
    ~zod/try=> (mate a b)
    [~ 97]
    ~zod/try=> =a ((unit @) [~ 97])
    ~zod/try=> =b ((unit @) [~ 98])
    ~zod/try=> (mate a b)
    ! 'mate'
    ! exit



***
