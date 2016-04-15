### `++woad`

Unescape cord

Unescape `++cord` codepoints.

Accepts
-------

`a` is a `@ta`.

Produces
--------

A `++cord`.

Source
------

    ++  woad                                                ::  cord format
      |=  a/@ta
      ^-  @t
      %+  rap  3
      |-  ^-  (list @)
      ?:  =(`@`0 a)
        ~
      =+  b=(end 3 1 a)
      =+  c=(rsh 3 1 a)
      ?:  =('.' b)
        [' ' $(a c)]
      ?.  =('~' b)
        [b $(a c)]
      =>  .(b (end 3 1 c), c (rsh 3 1 c))
      ?+  b  =-  (weld (rip 3 (tuft p.d)) $(a q.d))
             ^=  d
             =+  d=0
             |-  ^-  {p/@ q/@}
             ?:  =('.' b)
               [d c]
             ?<  =(0 c)
             %=    $
                b  (end 3 1 c)
                c  (rsh 3 1 c)
                d  %+  add  (mul 16 d)
                   %+  sub  b
                   ?:  &((gte b '0') (lte b '9'))  48
                   ?>(&((gte b 'a') (lte b 'z')) 87)
             ==
        $'.'  ['.' $(a c)]
        $'~'  ['~' $(a c)]
      ==
    ::

Examples
--------

    /~zod/try=> (woad ~.~b6.20.as)
    '¶20 as'



***
