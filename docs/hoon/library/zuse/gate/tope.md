---
navhome: /docs/
---


### `++tope`

Parse beam to path

Parses a [`++beam`]() `bem` to a [`++path`]().

Accepts
-------

`bem` is a `++beam`.

Produces
--------

A `++path`.

    ++tope
        |=  bem=beam
          ^-  path
          [(scot %p p.bem) q.bem (scot r.bem) (flop s.bem)]

Parses a [`++beam`]() to a [`++path`](/docs/hoon/library/1#++path).

    ~zod/try=/zop> (tope [~zod %main ud/1] /hook/down/sur)
    /~zod/main/1/sur/down/hook
    ~zod/try=/zop> (tope [~fyr %try da/~2015.1.1] /txt/test)
    /~fyr/try/~2015.1.1/test/txt
    ~zod/try=/zop> (tope [~doznec %try da/-<-] /txt/test)
    /~doznec/try/~2014.10.30..00.32.48..3ae4/test/txt

