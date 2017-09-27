---
navhome: /docs/
---


### `++jape`

`++json` string from tape

Produces a [`++json`]() string from a [`++tape`]().

Accepts
-------

A [`++tape`]().

Produces
--------

A `++json`.

Source
------

    ++  jape                                                ::  string from tape
      |=  a=tape
      ^-  json
      [%s (crip a)]
    ::

Examples
--------

    ~zod/try=> (jape ~)
    [%s p=~.]
    ~zod/try=> (jape "lam")
    [%s p=~.lam]
    ~zod/try=> (crip (pojo (jape "lam")))
    '"lam"'
    ~zod/try=> (crip (pojo (jape "semtek som? zeplo!")))
    '"semtek som? zeplo!"'


