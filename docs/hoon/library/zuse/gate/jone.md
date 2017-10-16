---
navhome: /docs/
---


### `++jone`

`++json` number from unigned

Produces a `++json` number from an unsigned atom.

Accepts
-------

`a` is an atom of odor [`@u`]().

Produces
--------

A [`++json`]().

Source
------

    ++  jone                                                ::  number from unsigned
      |=  a=@u
      ^-  json
      :-  %n
      ?:  =(0 a)  '0'
      (crip (flop |-(^-(tape ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])))))
    ::

Examples
--------

    ~zod/try=> (jone 1)
    [%n p=~.1]
    ~zod/try=> (pojo (jone 1))
    "1"
    ~zod/try=> (jone 1.203.196)
    [%n p=~.1203196]
    ~zod/try=> (pojo (jone 1.203.196))
    "1203196"


