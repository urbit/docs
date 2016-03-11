### `++yule`

Daily time to time atom

Accept a [`++tarp`](/doc/hoon/library/1#++tarp), a parsed daily time, and produces a time atom,
`@d`.

Accepts
-------

`rip` is a [`++tarp`](/doc/hoon/library/1#++tarp).

Produces
--------

A [`@d`]().

Source
------

    ++  yule                                                ::  time atom
      |=  rip=tarp
      ^-  @d
      =+  ^=  sec  ;:  add
                     (mul d.rip day:yo)
                     (mul h.rip hor:yo)
                     (mul m.rip mit:yo)
                     s.rip
                   ==
      =+  ^=  fac  =+  muc=4
                   |-  ^-  @
                   ?~  f.rip
                     0
                   =>  .(muc (dec muc))
                   (add (lsh 4 muc i.f.rip) $(f.rip t.f.rip))
      (con (lsh 6 1 sec) fac)

Examples
--------

    ~zod/try=> =murica (yell ~1776.7.4)
    ~zod/try=> murica
    [d=106.751.991.733.273 h=0 m=0 s=0 f=~]
    ~zod/try=> (yule murica)
    0x8000000b62aaf5800000000000000000
    ~zod/try=> `@da`(yule murica)
    ~1776.7.4
    ~zod/try=> `@da`(yule (yell ~2014.3.20..05.42.53..7456))
    ~2014.3.20..05.42.53..7456
    ~zod/try=> `tarp`[31 12 30 0 ~]
    [d=31 h=12 m=30 s=0 f=~]
    ~zod/try=> `@dr`(yule `tarp`[31 12 30 0 ~])
    ~d31.h12.m30


