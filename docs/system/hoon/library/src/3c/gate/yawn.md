### `++yawn`

Days since beginning of time

Inverse of `yall`, computes number of days A.D. from y/m/d date as the
tuple `[yer=@ud mot=@ud day=@ud]`.

Accepts
-------

`yer` is an unsigned decimal, `@ud`.

`mon` is an unsigned decimal, `@ud`.

`day` is an unsigned decimal, `@ud`.

Produces
--------

A [`@ud`]().

Source
------

    ++  yawn                                                ::  days since Jesus
      |=  [yer=@ud mot=@ud day=@ud]
      ^-  @ud
      =>  .(mot (dec mot), day (dec day))
      =>  ^+  .
          %=    .
              day
            =+  cah=?:((yelp yer) moy:yo moh:yo)
            |-  ^-  @ud
            ?:  =(0 mot)
              day
            $(mot (dec mot), cah (slag 1 cah), day (add day (snag 0 cah)))
          ==
      |-  ^-  @ud
      ?.  =(0 (mod yer 4))
        =+  ney=(dec yer)
        $(yer ney, day (add day ?:((yelp ney) 366 365)))
      ?.  =(0 (mod yer 100))
        =+  nef=(sub yer 4)
        $(yer nef, day (add day ?:((yelp nef) 1.461 1.460)))
      ?.  =(0 (mod yer 400))
        =+  nec=(sub yer 100)
        $(yer nec, day (add day ?:((yelp nec) 36.525 36.524)))
      (add day (mul (div yer 400) (add 1 (mul 4 36.524))))

Examples
--------

    ~zod/try=> (yawn 2.014 8 4)
    735.814
    ~zod/try=> (yawn 1.776 7 4)
    648.856
    ~zod/try=> (yawn 1.990 10 11)
    727.116


