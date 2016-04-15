### `++slaw`

Parse span to input odor

Parses a span `txt` to an atom of the odor specified by `mod`.

Accepts
-------

Produces
--------

`mod` is a term, an atom of odor `@tas`.

`txt` is a span, an atom of odor `@ta`.

Source
------

    ++  slaw
      ~/  %slaw
      |=  {mod/@tas txt/@ta}
      ^-  (unit @)
      =+  con=(slay txt)
      ?.(&(?=({$~ $$ @ @} con) =(p.p.u.con mod)) ~ [~ q.p.u.con])


Examples
--------

    ~zod/try=> `(unit @p)`(slaw %p '~pillyt')
    [~ ~pillyt]
    ~zod/try=> `(unit @p)`(slaw %p '~pillam')
    ~
    ~zod/try=> `(unit @ux)`(slaw %ux '0x12')
    [~ 0x12]
    ~zod/try=> `(unit @ux)`(slaw %ux '0b10')
    ~
    ~zod/try=> `(unit @if)`(slaw %if '.127.0.0.1')
    [~ .127.0.0.1]
    ~zod/try=> `(unit @if)`(slaw %if '.fe80.0.0.202')
    ~
    ~zod/try=> `(unit @ta)`(slaw %ta '~.asd_a')
    [~ ~.asd_a]
    ~zod/try=> `(unit @ta)`(slaw %ta '~~asd-a')
    ~



***
