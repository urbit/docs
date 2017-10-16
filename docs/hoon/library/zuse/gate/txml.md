---
navhome: /docs/
---


### `++txml`

Tape to xml CDATA node

Converts a [`++tape`]() to an xml CDATA node XX

Accepts
-------

`tep` is a [`++tape`]().

Produces
--------

A [`++manx`]().

Source
------

    ++  txml                                                ::  string to xml
      |=  tep=tape  ^-  manx
      [[%$ [%$ tep] ~] ~]
    ::

Examples
--------

    ~zod/try=> (txml "hi")
    [g=[n=%$ a=~[[n=%$ v="hi"]]] c=~]
    ~zod/try=> (txml "larton bestok")
    [

