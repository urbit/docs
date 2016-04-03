### `++wood`

Escape cord

Escape `++cord` codepoints.

Accepts
-------

`a` is a `++span` (`@ta`).

Produces
--------

A `++span` (`@ta`).

Source
------

    ++  wood                                                ::  cord format
      |=  a/@t
      ^-  @ta
      %+  rap  3
      |-  ^-  (list @)
      ?:  =(`@`0 a)
        ~
      =+  b=(teff a)
      =+  c=(turf (end 3 b a))
      =+  d=$(a (rsh 3 b a))
      ?:  ?|  &((gte c 'a') (lte c 'z'))
              &((gte c '0') (lte c '9'))
              =(`@`'-' c)
          ==
        [c d]
      ?+  c
        :-  '~'
        =+  e=(met 2 c)
        |-  ^-  tape
        ?:  =(0 e)
          ['.' d]
        =.  e  (dec e)
        =+  f=(rsh 2 e c)
        [(add ?:((lte f 9) 48 87) f) $(c (end 2 e c))]
      ::

Examples
--------

    /~zod/try=> (wood 'my ßam')
    ~.my.~df.am


***
