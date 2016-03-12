### `++year`

Accept a parsed date of form `[[a=? y=@ud] m=@ud t=tarp]` and produce
its `@d`representation.

Accepts
-------

`det` is a [`++date`]()

Produces
--------

A [`@d`]().

Source
------

    ++  year                                                ::  date to @d
      |=  det=date
      ^-  @d
      =+  ^=  yer
          ?:  a.det
            (add 292.277.024.400 y.det)
          (sub 292.277.024.400 (dec y.det))
      =+  day=(yawn yer m.det d.t.det)
      (yule day h.t.det m.t.det s.t.det f.t.det)

Examples
--------

    ~zod/try=> (year [[a=%.y y=2.014] m=8 t=[d=4 h=20 m=4 s=57 f=~[0xd940]]])
    0x8000000d227df4e9d940000000000000


