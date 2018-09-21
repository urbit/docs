---
navhome: /docs/
---


### `++urle`

Encode URL

The inverse of [`++urld`](). Accepts a tape `tep` and replaces all
characters other than alphanumerics and `.`, `-`, `~`, and `_`, with URL
escape sequences.

Accepts
-------

`tep` is a [`++tape`]().

Produces
--------

A `++tape`.

Source
------

    ++  urle                                                ::  URL encode
          |=  tep=tape
          ^-  tape
          %-  zing
          %+  turn  tep
          |=  tap=char
          =+  xen=|=(tig=@ ?:((gte tig 10) (add tig 55) (add tig '0')))
          ?:  ?|  &((gte tap 'a') (lte tap 'z'))
                  &((gte tap 'A') (lte tap 'Z'))
                  &((gte tap '0') (lte tap '9'))
                  =('.' tap)
                  =('-' tap)
                  =('~' tap)
                  =('_' tap)
              ==
            [tap ~]
          ['%' (xen (rsh 0 4 tap)) (xen (end 0 4 tap)) ~]
        ::

Examples
--------

    ~zod/main=> (urle "hello")
    "hello"
    ~zod/main=> (urle "hello dear")
    "hello%20dear"
    ~zod/main=> (urle "hello-my?=me  !")
    "hello-my%3F%3Dme%20%20%21"


