---
navhome: /docs/
---


### `++lead`

Subtract leap seconds

Produces an absolute date ([`@ud`]()) with the 25 leap seconds
subtracted.

Accepts
-------

`ley` is a [`++date`]().

Produces
--------

An atom of [odor]() [`@da`](), which represents an absolute date.

Source
------

    ++  lead                                                ::  from leap sec time
      |=  ley=date
      =+  ler=(year ley)
      =+  n=0
      |-  ^-  @da
      =+  led=(sub ler (mul n ~s1))
      ?:  (gte ler (add (snag n les:yu) ~s1))
        led
      ?:  &((gte ler (snag n les:yu)) (lth ler (add (snag n les:yu) ~s1)))
        ?:  =(s.t.ley 60)
          (sub led ~s1)
        led
      ?:  =(+(n) (lent les:yu))
        (sub led ~s1)
      $(n +(n))
    ::

Examples
--------

    ~zod/try=> (yore `@da`(bex 127))
    [[a=%.y y=226] m=12 t=[d=5 h=15 m=30 s=8 f=~]]
    ~zod/try=> (lead (yore `@da`(bex 127)))
    ~226.12.5..15.29.43
    ~zod/try=> (lead (yore `@da`(bex 126)))
    ~146138512088-.6.19..07.44.39


