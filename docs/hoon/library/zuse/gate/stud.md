---
navhome: /docs/
---


### `++stud`

Parse UTC format

Accepts a [`++tape`]() containing a date in UTC format and produces the
[`++unit`]() of a [`++date`]().

Accepts
-------

`cud` is a `++tape`.

Produces
--------

The `++unit` of a `++date`.

Source
------

    ++  stud                                                ::  parse UTC format
      |=  cud=tape
      ^-  (unit date)
      =-  ?~  tud  ~ 
          `[[%.y &3.u.tud] &2.u.tud &1.u.tud &4.u.tud &5.u.tud &6.u.tud ~]
      ^=  tud
      %+  rust  cud
      ;~  plug
        ;~(pfix (stun [5 5] next) dim:ag)
      ::
        %+  cook
          |=  a=tape
          =+  b=0
          |-  ^-  @
          ?:  =(a (snag b (turn mon:yu |=(a=tape (scag 3 a)))))
              +(b)
          $(b +(b))
        (ifix [ace ace] (star alf))
      ::
        ;~(sfix dim:ag ace)  
        ;~(sfix dim:ag col)
        ;~(sfix dim:ag col)  
        dim:ag  
        (cold ~ (star next))
      ==
    ::

Examples
--------

    ~zod/try=> (stud "Tue, 21 Oct 2014 21:21:55 +0000")
    [~ [[a=%.y y=2.014] m=10 t=[d=21 h=21 m=21 s=55 f=~]]]
    ~zod/try=> (stud "Wed, 11 Oct 2002 12:20:55 +0000")
    [~ [[a=%.y y=2.002] m=10 t=[d=11 h=12 m=20 s=55 f=~]]]
    ~zod/try=> (stud "Wed, 11 Oct 2002")
    ~


