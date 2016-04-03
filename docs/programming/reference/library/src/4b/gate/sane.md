### `++sane`

Check odor validity

Check validity by odor. Produces a gate.

Accepts
-------

`a` is a `++span` (`@ta`).

`b` is an atom.

Produces
--------

A boolean.

Source
------

    ++  sane                                                ::  atom sanity
      |=  a/@ta
      |=  b/@  ^-  ?
      ?.  =(%t (end 3 1 a))
        ~|(%sane-stub !!)
      =+  [inx=0 len=(met 3 b)]
      ?:  =(%tas a)
        |-  ^-  ?
        ?:  =(inx len)  &
        =+  cur=(cut 3 [inx 1] b)
        ?&  ?|  &((gte cur 'a') (lte cur 'z'))
                &(=('-' cur) !=(0 inx) !=(len inx))
                &(&((gte cur '0') (lte cur '9')) !=(0 inx))
            ==
            $(inx +(inx))
        ==
      ?:  =(%ta a)
        |-  ^-  ?
        ?:  =(inx len)  &
        =+  cur=(cut 3 [inx 1] b)
        ?&  ?|  &((gte cur 'a') (lte cur 'z'))
                &((gte cur '0') (lte cur '9'))
                |(=('-' cur) =('~' cur) =('_' cur) =('.' cur))
            ==
            $(inx +(inx))
        ==
      |-  ^-  ?
      ?:  =(0 b)  &
      =+  cur=(end 3 1 b)
      ?:  &((lth cur 32) !=(10 cur))  |
      =+  len=(teff cur)
      ?&  |(=(1 len) =+(i=1 |-(|(=(i len) &((gte (cut 3 [i 1] b) 128) $(i +(i)))))))
          $(b (rsh 3 len b))
      ==
    ::

Examples
--------

    /~zod/try=> ((sane %tas) %mol)
    %.y
    /~zod/try=> ((sane %tas) 'lam')
    %.y
    /~zod/try=> ((sane %tas) 'more ace')
    %.n



***
