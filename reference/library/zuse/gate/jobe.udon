---
navhome: /docs/
---


### `++jobe`

Object from key-value list

Produces a `++json` object from a [`++list`]() `a` of key to `++json` values.

Accepts
-------

`a` is a [`++list`]() of [`++cord`]() to [`++json`]() values.

Produces
--------

A `++json`.

Source
------

    ++  jobe                                                ::  object from k-v list
      |=  a=(list ,[p=@t q=json])
      ^-  json
      [%o (~(gas by *(map ,@t json)) a)]
    ::

Examples
--------

    ~zod/try=> (jobe a/n/'20' b/~ c/a/~[s/'mol'] ~)
    [%o p={[p='a' q=[%n p=~.20]] [p='c' q=[%a p=~[[%s p=~.mol]]]] [p='b' q=~]}]
    ~zod/try=> (crip (pojo (jobe a/n/'20' b/~ c/a/~[s/'mol'] ~)))
    '{"b":null,"c":["mol"],"a":20}'


