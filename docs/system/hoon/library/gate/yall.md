### `++yall`

Time since beginning of time

Produce the date tuple of `[y=@ud m=@ud d=@ud]` of the year, month, and
day from a number of days from the beginning of time.

Accepts
-------

`day` is a [`@ud`]()

Produces
--------


Source
------

    ++  yall                                                ::  day # to day of year
      |=  day=@ud
      ^-  [y=@ud m=@ud d=@ud]
      =+  [era=0 cet=0 lep=_?]
      =>  .(era (div day era:yo), day (mod day era:yo))
      =>  ^+  .
          ?:  (lth day +(cet:yo))
            .(lep &, cet 0)
          =>  .(lep |, cet 1, day (sub day +(cet:yo)))
          .(cet (add cet (div day cet:yo)), day (mod day cet:yo))
      =+  yer=(add (mul 400 era) (mul 100 cet))
      |-  ^-  [y=@ud m=@ud d=@ud]
      =+  dis=?:(lep 366 365)
      ?.  (lth day dis)
        =+  ner=+(yer)
        $(yer ner, day (sub day dis), lep =(0 (end 0 2 ner)))
      |-  ^-  [y=@ud m=@ud d=@ud]
      =+  [mot=0 cah=?:(lep moy:yo moh:yo)]
      |-  ^-  [y=@ud m=@ud d=@ud]
      =+  zis=(snag mot cah)
      ?:  (lth day zis)
        [yer +(mot) +(day)]
      $(mot +(mot), day (sub day zis))

Examples
--------

    ~zod/try=> (yall 198)
    [y=0 m=7 d=17]
    ~zod/try=> (yall 90.398)
    [y=247 m=7 d=3]
    ~zod/try=> (yall 0)
    [y=0 m=1 d=1]


