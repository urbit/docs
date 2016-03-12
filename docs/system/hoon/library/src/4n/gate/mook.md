### `++mook`

Intelligently render crash annotation

Converts a `%2` `++tone` nock stack trace to a list of [`++tank`]().
Each may be a tank, cord, [`++spot`](), or trapped tank.

Accepts
-------

`ton` is a [`++tone`]().

Produces
--------

A [`++toon`]().

Source
------

    ++  mook
      |=  ton=tone
      ^-  toon
      ?.  ?=([2 *] ton)  ton
      :-  %2
      =+  yel=(lent p.ton)
      =.  p.ton
        ?.  (gth yel 256)  p.ton
        %+  weld
          (scag 128 p.ton)
        ^-  (list ,[@ta *])
        :_  (slag (sub yel 128) p.ton)
        :-  %lose
        %+  rap  3
        ;:  weld
          "[skipped "
          ~(rend co %$ %ud (sub yel 256))
          " frames]"
        ==
      |-  ^-  (list tank)
      ?~  p.ton  ~
      =+  rex=$(p.ton t.p.ton)
      ?+    -.i.p.ton  rex
          %hunk  [(tank +.i.p.ton) rex]
          %lose  [[%leaf (rip 3 (,@ +.i.p.ton))] rex]
          %mean  :_  rex
                 ?@  +.i.p.ton  [%leaf (rip 3 (,@ +.i.p.ton))]
                 =+  mac=(mack +.i.p.ton +<.i.p.ton)
                 ?~(mac [%leaf "####"] (tank u.mac))
          %spot  :_  rex
                 =+  sot=(spot +.i.p.ton)
                 :-  %leaf
                 ;:  weld
                   ~(ram re (smyt p.sot))
                   ":<["
                   ~(rend co ~ %ud p.p.q.sot)
                   " "
                   ~(rend co ~ %ud q.p.q.sot)
                   "].["
                   ~(rend co ~ %ud p.q.q.sot)
                   " "
                   ~(rend co ~ %ud q.q.q.sot)
                   "]>"
                 ==
      ==
    ::

Examples
--------

    ~zod/try=> (mook [%0 5 4 5 1])
    [%0 p=[5 4 5 1]]
    ~zod/try=> (mook [%2 ~[[%hunk %rose ["<" "," ">"] ~[[%leaf "err"]]]]])
    [%2 p=~[[%rose p=[p="<" q="," r=">"] q=[i=[%leaf p="err"] t=~]]]]
    ~zod/try=> (mook [%2 ~[[%malformed %elem] [%lose 'do print']]])
    [%2 p=~[[%leaf p="do print"]]]
    ~zod/try=> (mook [%2 ~[[%mean |.(>(add 5 6)<)]]])
    [%2 p=~[[%leaf p="11"]]]
    ~zod/try=> (mook [%2 ~[[%spot /b/repl [1 1]^[1 2]] [%mean |.(!!)]]])
    [%2 p=~[[%leaf p="/b/repl/:<[1 1].[1 2]>"] [%leaf p="####"]]]



***
