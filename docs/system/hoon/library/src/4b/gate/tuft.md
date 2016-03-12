### `++tuft`

UTF32 to UTF8 text

Convert utf32 glyph to
[LSB](http://en.wikipedia.org/wiki/Least_significant_bit) utf8 [`++cord`]().

Accepts
-------

`a` is a codepoint ([`@c`]()).

Produces
--------

A `++cord`.

Source
------

    ++  tuft                                                ::  utf32 to utf8 text
      |=  a=@c
      ^-  @t
      %+  rap  3
      |-  ^-  (list ,@)
      ?:  =(0 a)
        ~
      =+  b=(end 5 1 a)
      =+  c=$(a (rsh 5 1 a))
      ?:  (lth b 0x7f)
        [b c]
      ?:  (lth b 0x7ff)
        :*  (mix 0b1100.0000 (cut 0 [6 5] b))
            (mix 0b1000.0000 (end 0 6 b))
            c
        ==
      ?:  (lth b 0xffff)
        :*  (mix 0b1110.0000 (cut 0 [12 4] b))
            (mix 0b1000.0000 (cut 0 [6 6] b))
            (mix 0b1000.0000 (end 0 6 b))
            c
        ==
      :*  (mix 0b1111.0000 (cut 0 [18 3] b))
          (mix 0b1000.0000 (cut 0 [12 6] b))
          (mix 0b1000.0000 (cut 0 [6 6] b))
          (mix 0b1000.0000 (end 0 6 b))
          c
      ==
    ::

Examples
--------

    /~zod/try=> (tuft `@c`%a)
    'a'
    /~zod/try=> (tuft `@c`0xb6)
    '¶'


