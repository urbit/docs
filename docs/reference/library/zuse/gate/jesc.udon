---
navhome: /docs/
---


### `++jesc`

Escape JSON character

Produces a [`++tape`]() of an escaped [`++json`](/docs/hoon/library/3bi#++json) character `a`.

Accepts
-------

`a` is an atom of odor [`@tD`](), aka a [`++char`]().

Produces
--------

A [`++tape`]().

Source
------

    ++  jesc
      |=  a=@  ^-  tape
      ?+  a  [a ~]
        10  "\\n"
        34  "\\\""
        92  "\\\\"
      ==
    ::

Examples
--------

    ~zod/try=> (jesc 'a')
    "a"
    ~zod/try=> (jesc 'c')
    "c"
    ~zod/try=> (jesc '\\')
    "\\"
    ~zod/try=> (jesc '"')
    "\""


