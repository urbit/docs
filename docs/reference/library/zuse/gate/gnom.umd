---
navhome: /docs/
---


### `++gnom`

Display ship name

Fetches a ship's display name from %ames.

Accepts
-------

`our` is a [`@p`]().

`now` is a [`@da`]().

`him` is a [`@p`]().

Source
------

    ++  gnom                                                ::  ship display name
      |=  [[our=@p now=@da] him=@p]  ^-  @t
      =+  yow=(scot %p him)
      =+  pax=[(scot %p our) %name (scot %da now) yow ~]
      =+  woy=((hard ,@t) .^(%a pax))
      ?:  =(%$ woy)  yow
      (rap 3 yow ' ' woy ~)
    ::

Examples
--------

    ~zod/main=> (gnom [->-< -<-] ~zod)
    '~zod |Tianming|'
    ~zod/main=> (gnom [->-< -<-] ~doznec)
    '~doznec ~doznec'
    ~zod/main=> (gnom [->-< -<-] ~tug)
    '~tug |Go-Daigo|'


