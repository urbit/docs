section 2eK, formatting (layout)
================================

### `++re`

Pretty-printing engine

Pretty-printing engine that accepts a [`++tank`](/doc/hoon/library/1#++tank) [sample]() and contains arms that perform computation on it.

Accepts
-------

`tac` is a `++tank`.

Produces
--------

    ++  re
      |_  tac=tank

Examples
--------

    /~zod/try=> ~(. re leaf/"ham")
    <2.ghl [[%leaf ""] <414.gly 100.xkc 1.ypj %164>]>

### `++ram`

Flatten to tape

Flatten [`++tank`]() out into a [`++tape`]().

Accepts
-------

`tac` is a `++tank`, taken from [sample]() of `++re` [core]().

Produces
--------

A `++tape`.

Source
------

      ++  ram
        ^-  tape
        ?-    -.tac
            %leaf  p.tac
            %palm  ram(tac [%rose [p.p.tac (weld q.p.tac r.p.tac) s.p.tac] q.tac])
            %rose
          %+  weld
            q.p.tac
          |-  ^-  tape
          ?~  q.tac
            r.p.tac
          =+  voz=$(q.tac t.q.tac)
          (weld ram(tac i.q.tac) ?~(t.q.tac voz (weld p.p.tac voz)))
        ==
      ::

Examples
--------

    /~zod/try=> ~(ram re leaf/"foo")
    "foo"
    /~zod/try=> ~(ram re rose/["." "(" ")"]^~[leaf/"bar" leaf/"baz" leaf/"bam"])
    "(bar.baz.bam)"

### `++win`

Render at indent

Render at indent level `tab` and width `edg`.

Accepts
-------

`tac` is a `++tank`, taken from [sample]() of `++re` [core]().

`tab` and `edg` are atoms.

Produces
--------

A [`++wall`]() ([`++list`]() of [`++tapes`]()).

Source
------

      ++  win
        |=  [tab=@ edg=@]
        =+  lug=`wall`~
        |^  |-  ^-  wall
            ?-    -.tac
                %leaf  (rig p.tac)
                %palm
              ?:  fit
                (rig ram)
              ?~  q.tac
                (rig q.p.tac)
              ?~  t.q.tac
                (rig(tab (add 2 tab), lug $(tac i.q.tac)) q.p.tac)
              =>  .(q.tac `(list tank)`q.tac)
              =+  lyn=(mul 2 (lent q.tac))
              =+  ^=  qyr
                  |-  ^-  wall
                  ?~  q.tac
                    lug
                  %=  ^$
                    tac  i.q.tac
                    tab  (add tab (sub lyn 2))
                    lug  $(q.tac t.q.tac, lyn (sub lyn 2))
                  ==
              (wig(lug qyr) q.p.tac)
            ::
                %rose
              ?:  fit
                (rig ram)
              =+  ^=  gyl
                |-  ^-  wall
                ?~  q.tac
                  ?:(=(%$ r.p.tac) lug (rig r.p.tac))
                ^$(tac i.q.tac, lug $(q.tac t.q.tac), tab din)
              ?:  =(%$ q.p.tac)
                gyl
              (wig(lug gyl) q.p.tac)
            ==
        ::

Examples
--------

    /~zod/try=> (~(win re leaf/"samoltekon-lapdok") 0 20)
    <<"samoltekon-lapdok">>
    /~zod/try=> (~(win re leaf/"samoltekon-lapdok") 0 10)
    <<"\/samolt\/" "  ekon-l" "  apdok" "\/      \/">>
    /~zod/try=> (~(win re rose/["--" "[" "]"]^~[leaf/"1423" leaf/"2316"]) 0 20)
    <<"[1423--2316]">>
    /~zod/try=> (~(win re rose/["--" "[" "]"]^~[leaf/"1423" leaf/"2316"]) 0 10)
    <<"[ 1423" "  2316" "]">>

### `++din`

XX document

Accepts
-------

Produces
--------

Source
------

        ++  din  (mod (add 2 tab) (mul 2 (div edg 3)))


----------------------------------------------------------------------

### `++fit`

Fit on one line test

Determine whether `tac` fits on one line. Internal to `++win`

Accepts
-------

Produces
--------

Source
------

++  fit  (lte (lent ram) (sub edg tab))


Examples
--------




----------------------------------------------------------------------

### `++rig`

Wrap in `\/`

Wrap [`++tape`]() in `\/` if it doesn't fit at current indentation. Internal to
[`++win`]()

Accepts
-------

`tac` is a `++tank`, taken from [sample]() of `++re` [core]().

`hom` is a `++tape`.

Produces
--------

A [`++wall`]() (list of `++tape`s).

Source
------

        ++  rig
          |=  hom=tape
          ^-  wall
          ?:  (lte (lent hom) (sub edg tab))
            [(runt [tab ' '] hom) lug]
          =>  .(tab (add tab 2), edg (sub edg 2))
          =+  mut=(trim (sub edg tab) hom)
          :-  (runt [(sub tab 2) ' '] ['\\' '/' (weld p.mut `_hom`['\\' '/' ~])])
          =>  .(hom q.mut)
          |-
          ?~  hom
            :-  %+  runt
                  [(sub tab 2) ' ']
                ['\\' '/' (runt [(sub edg tab) ' '] ['\\' '/' ~])]
            lug
          =>  .(mut (trim (sub edg tab) hom))
          [(runt [tab ' '] p.mut) $(hom q.mut)]
        ::

Examples
--------

### `++wig`

`++win` render tape

Render [`++tape`](). Internal to [`++win`]().

Accepts
-------

`tac` is a `++tank`, taken from [sample]() of `++re` [core]().

`hom` is a `++tape`.

Produces
--------

        ++  wig
          |=  hom=tape
          ^-  wall
          ?~  lug
            (rig hom)
          =+  lin=(lent hom)
          =+  wug=:(add 1 tab lin)
          ?.  =+  mir=i.lug
              |-  ?~  mir
                    |
                  ?|(=(0 wug) ?&(=(' ' i.mir) $(mir t.mir, wug (dec wug))))
            (rig hom)       :: ^ XX regular form?
          [(runt [tab ' '] (weld hom `tape`[' ' (slag wug i.lug)])) t.lug]
        --
      --

Examples
--------
