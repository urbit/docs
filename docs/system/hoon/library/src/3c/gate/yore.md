### `++yore`

Produces a `++date` from a `@d`

Accepts
-------

`now` is a `@d`.

Produces
--------

A [`++date`]().

Source
------

    ++  yore                                                ::  @d to date
      |=  now=@d
      ^-  date
      =+  rip=(yell now)
      =+  ger=(yall d.rip)
      :-  ?:  (gth y.ger 292.277.024.400)
            [a=& y=(sub y.ger 292.277.024.400)]
          [a=| y=+((sub 292.277.024.400 y.ger))]
      [m.ger d.ger h.rip m.rip s.rip f.rip]

Examples
--------

    ~zod/try=> (yore -<-)
    [[a=%.y y=2.014] m=8 t=[d=4 h=20 m=17 s=1 f=~[0x700d]]]
    ~zod/try=> (yore -<-)
    [[a=%.y y=2.014] m=8 t=[d=4 h=20 m=28 s=53 f=~[0x7b82]]]


