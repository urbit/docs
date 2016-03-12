### `++date`

Point in time

A boolean designating AD or BC, a year atom, a month
atom, and a [`++tarp`](), which is a day atom and a time.

Source
------

        ++  date  ,[[a=? y=@ud] m=@ud t=tarp]                   ::  parsed date

Examples
--------

See also: [`++year`](), [`++yore`]() [`++stud`](), [`++dust`]()

    ~zod/try=> `date`(yore ~2014.6.6..21.09.15..0a16)
    [[a=%.y y=2.014] m=6 t=[d=6 h=21 m=9 s=15 f=~[0xa16]]]


***
