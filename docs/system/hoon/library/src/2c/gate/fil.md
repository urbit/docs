### `++fil`

Fill bloqstream

Produces an [atom]() by repeating `c` for `b` blocks of size `a`.

Accepts
-------

`a` is a block size (see [`++bloq`]()).

`b` is an atom.

`c` is an [atom]().

Produces
--------

An atom.

Source
------

    ++  fil                                                 ::  fill bloqstream
      |=  [a=bloq b=@ c=@]
      =+  n=0
      =+  d=c
      |-  ^-  @
      ?:  =(n b)
        (rsh a 1 d)
      $(d (add c (lsh a 1 d)), n +(n))

Examples
--------

    ~zod/try=> `@t`(fil 3 5 %a)
    'aaaaa'
    ~zod/try=> `@t`(fil 5 10 %ceeb)
    'ceebceebceebceebceebceebceebceebceebceeb'
    ~zod/try=> `@t`(fil 4 10 %eced)
    'ʇʇʇʇʇʇʇʇʇʇed'
    ~zod/try=> `@tas`(fil 4 10 %bf)
    %bfbfbfbfbfbfbfbfbfbf



***
