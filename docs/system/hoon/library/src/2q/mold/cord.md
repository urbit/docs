### `++cord`

UTF-8 text

One of Hoon's two string types (the other being [`++tape`]()). A cord is an
atom of UTF-8 text. [`++trip`]() and [`++crip`]() convert between cord and
`++tape`.

Source
------

    ++  cord  ,@t                                           ::  text atom (UTF-8)

Examples
--------

Odor [`@t`]() designates a Unicode atom, little-endian: the first character
in the text is the low byte.

    ~zod/try=> `@ux`'foobar'
    0x7261.626f.6f66

    ~zod/try=> `@`'urbit'
    499.984.265.845
    ~zod/try=> (cord 499.984.265.845)
    'urbit'



***
