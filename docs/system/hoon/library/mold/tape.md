
### `++tape`

List of chars

One of Hoon's two string types, the other being [`++cord`](). A tape is a
list of chars.

Source
------

        ++  tape  (list char)                                   ::  like a string

Examples
--------

    ~zod/try=> `(list ,char)`"foobar"
    "foobar"
    ~zod/try=> `(list ,@)`"foobar"
    ~[102 111 111 98 97 114]

