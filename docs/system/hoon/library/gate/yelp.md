### `++yelp`

Leap-week?

Determines whether a year contains an ISO 8601 leap week. Produces a
loobean.

Accepts
-------

`yer` is an unsigned decimal, `@ud`.

Produces
--------

A boolean.

Source
------

    ++  yelp                                                ::  leap year
      |=  yer=@ud  ^-  ?
      &(=(0 (mod yer 4)) |(!=(0 (mod yer 100)) =(0 (mod yer 400))))

Examples
--------

    ~zod/try=> (yelp 2.014)
    %.n
    ~zod/try=> (yelp 2.008)
    %.y
    ~zod/try=> (yelp 0)
    %.y
    ~zod/try=> (yelp 14.011)
    %.n


