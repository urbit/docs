### `++yell`

Produce a parsed daily time format from an atomic date.

`now` is a `@d`.

Source
------

    ++  yell                                                ::  tarp from @d
      |=  now/@d
      ^-  tarp
      =+  sec=(rsh 6 1 now)
      =+  ^=  fan
          =+  [muc=4 raw=(end 6 1 now)]
          |-  ^-  (list @ux)
          ?:  |(=(0 raw) =(0 muc))
            ~
          =>  .(muc (dec muc))
          [(cut 4 [muc 1] raw) $(raw (end 4 muc raw))]
      =+  day=(div sec day:yo)
      =>  .(sec (mod sec day:yo))
      =+  hor=(div sec hor:yo)
      =>  .(sec (mod sec hor:yo))
      =+  mit=(div sec mit:yo)
      =>  .(sec (mod sec mit:yo))
      [day hor mit sec fan]
    ::


Examples
--------

    ~zod/try=> (yell ~2014.3.20..05.42.53..7456)
    [d=106.751.991.820.094 h=5 m=42 s=53 f=~[0x7456]]
    ~zod/try=> (yell ~2014.6.9..19.09.40..8b66)
    [d=106.751.991.820.175 h=19 m=9 s=40 f=~[0x8b66]]
    ~zod/try=> (yell ~1776.7.4)
    [d=106.751.991.733.273 h=0 m=0 s=0 f=~]


***
