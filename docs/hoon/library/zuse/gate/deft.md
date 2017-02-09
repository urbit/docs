---
navhome: /docs/
---


### `++deft`

Import URL path

Parse the extension the from last element of url, which is delimited
either by a `.` or a `/`.

Accepts
-------

`rax` is a [`++list`]() of [`@t`]().

Produces
--------

A [`++pork`]().

Source
------

    ++  deft                                                ::  import url path
          |=  rax=(list ,@t)
          |-  ^-  pork
          ?~  rax
            [~ ~]
          ?~  t.rax
            =+  den=(trip i.rax)
            =+  ^=  vex
              %-  %-  full
                  ;~(plug sym ;~(pose (stag ~ ;~(pfix dot sym)) (easy ~)))
              [[1 1] (trip i.rax)]
            ?~  q.vex
              [~ [i.rax ~]]
            [+.p.u.q.vex [-.p.u.q.vex ~]]
          =+  pok=$(rax t.rax)
          :-  p.pok
          [i.rax q.pok]
        ::

Examples
--------

    ~zod/try=> (deft /foo/bar/'baz.txt')
    [p=[~ ~.txt] q=<|foo bar baz|>]
    ~zod/try=> (deft /foo/bar/baz)
    [p=~ q=<|foo bar baz|>]


