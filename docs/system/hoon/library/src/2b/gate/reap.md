### `++reap`

Replicate

Replicate: produces a [`++list`]() containing `a` copies of `b`.

Accepts
-------

`b` is a [noun]()

Produces
--------

A list. 

Source
------

    ++  reap                                                ::  replicate
      |*  [a=@ b=*]
      |-  ^-  (list ,_b)
      ?~  a  ~
      [b $(a (dec a))]

Examples
--------

    ~zod/try=> (reap 20 %a)
    ~[%a %a %a %a %a %a %a %a %a %a %a %a %a %a %a %a %a %a %a %a]
    ~zod/try=> (reap 5 ~s1)
    ~[~s1 ~s1 ~s1 ~s1 ~s1]
    ~zod/try=> `@dr`(roll (reap 5 ~s1) add)
    ~s5


