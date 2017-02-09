---
navhome: /docs/
---


### `++joba`

`++json` from key-value pair

Produces a ++json object with one key-value pair.

Accepts
-------

`p` is a `@t` key.

`q` is a [`++json`]().

Produces
--------

A [`++json`]().

Source
------

    ++  joba                                                ::  object from k-v pair
      |=  [p=@t q=json]
      ^-  json
      [%o [[p q] ~ ~]]
    ::

Examples
--------

    ~zod/try=> (joba %hi %b |)
    [%o p={[p='hi' q=[%b p=%.n]]}]
    ~zod/try=> (crip (pojo (joba %hi %b |)))
    '{"hi":false}'
    ~zod/try=> (joba %hi (jone 2.130))
    [%o p={[p='hi' q=[%n p=~.2130]]}]
    ~zod/try=> (crip (pojo (joba %hi (jone 2.130))))
    '{"hi":2130}'


