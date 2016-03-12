### `++tarp`

Day through second

The remaining part of a [`++date`](): day, hour, minute, second and a list
of [`@ux`]() for precision.

Source
------

    @ud h=@ud m=@ud s=@ud f=(list ,@ux)]      ::  parsed time

Examples
--------

See also: [`++date`](), [`++yell`[]()/`++yule`]()

    ~zod/try=> -<-
    ~2014.9.20..00.43.33..b52a
    ~zod/try=> :: the time is always in your context at -<-
    ~zod/try=> (yell -<-)
    [d=106.751.991.820.278 h=0 m=43 s=39 f=~[0x54d1]]

    ~zod/try=> (yell ~d20)
    [d=20 h=0 m=0 s=0 f=~]



***
