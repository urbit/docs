### `++turf`

UTF8 to UTF32 cord

Convert utf8 (`++cord`) to utf32 codepoints.

Accepts
-------

`a` is a `@t`.

Produces
--------

A `@c`, UTF-32 codepoint.

Source
------

    ++  turf                                                ::  utf8 to utf32
      |=  a/@t
      ^-  @c
      %+  rap  5
      |-  ^-  (list @c)
      =+  b=(teff a)
      ?:  =(0 b)  ~
      =+  ^=  c
          %+  can  0
          %+  turn
            ^-  (list {p/@ q/@})
            ?+  b  !!
              $1  [[0 7] ~]
              $2  [[8 6] [0 5] ~]
              $3  [[16 6] [8 6] [0 4] ~]
              $4  [[24 6] [16 6] [8 6] [0 3] ~]
            ==
          |=({p/@ q/@} [q (cut 0 [p q] a)])
      ?.  =((tuft c) (end 3 b a))  ~|(%bad-utf8 !!)
      [c $(a (rsh 3 b a))]
    ::

Examples
--------

    /~zod/try=> (turf 'my ßam')
    ~-my.~df.am
    /~zod/try=> 'я тут'
    'я тут'
    /~zod/try=> (turf 'я тут')
    ~-~44f..~442.~443.~442.
    /~zod/try=> `@ux`'я тут'
    0x82.d183.d182.d120.8fd1
    /~zod/try=> `@ux`(turf 'я тут')
    0x442.0000.0443.0000.0442.0000.0020.0000.044f



***
