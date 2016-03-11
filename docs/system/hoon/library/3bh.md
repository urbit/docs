3bH names etc
=============

### `++gnow`

    ++  gnow
      |=  [who=@p gos=gcos]  ^-  @t
      ?-    -.gos
          %czar                 (rap 3 '|' (rap 3 (glam who)) '|' ~)
          %king                 (rap 3 '_' p.gos '_' ~)
          %earl                 (rap 3 ':' p.gos ':' ~)
          %pawn                 ?~(p.gos %$ (rap 3 '.' u.p.gos '.' ~))
          %duke
        ?:  ?=(%anon -.p.gos)  %$
        %+  rap  3
        ^-  (list ,@)
        ?-    -.p.gos
            %punk  ~['"' q.p.gos '"']
            ?(%lord %lady)
          =+  ^=  nad
              =+  nam=`name`s.p.p.gos
              %+  rap  3
              :~  p.nam
                  ?~(q.nam 0 (cat 3 ' ' u.q.nam))
                  ?~(r.nam 0 (rap 3 ' (' u.r.nam ')' ~))
                  ' '
                  s.nam
              ==
          ?:(=(%lord -.p.gos) ~['[' nad ']'] ~['(' nad ')'])
        ==
      ==
    ::

XX Document

### `++hunt`

    ++  hunt                                                ::  first of unit dates
      |=  [one=(unit ,@da) two=(unit ,@da)]
      ^-  (unit ,@da)
      ?~  one  two
      ?~  two  one
      ?:((lth u.one u.two) one two)
    ::

XX Document

### `++mojo`

    ++  mojo                                                ::  compiling load
      |=  [pax=path src=*]
      ^-  (each twig (list tank))
      ?.  ?=(@ src)
        [%| ~[[leaf/"musk: malformed: {<pax>}"]]]
      =+  ^=  mud
          %-  mule  |.
          ((full vest) [1 1] (trip src))
      ?:  ?=(| -.mud)  mud
      ?~  q.p.mud
        :~  %|
            leaf/"musk: syntax error: {<pax>}"
            leaf/"musk: line {<p.p.p.mud>}, column {<q.p.p.mud>}"
        ==
      [%& p.u.q.p.mud]
    ::

XX Document

### `++mole`

    ++  mole                                                ::  new to old sky
      |=  ska=$+(* (unit (unit)))
      |=  a=*
      ^-  (unit)
      =+  b=(ska a)
      ?~  b  ~
      ?~  u.b  ~
      [~ u.u.b]
    ::

XX Document

### `++much`

    ++  much                                                ::  constructing load
      |=  [pax=path src=*]
      ^-  gank
       =+  moj=(mojo pax src)
      ?:  ?=(| -.moj)  moj
      (mule |.((slap !>(+>.$) `twig`p.moj)))
    ::

XX Document

### `++musk`

    ++  musk                                                ::  compiling apply
      |=  [pax=path src=* sam=vase]
      ^-  gank
      =+  mud=(much pax src)
      ?:  ?=(| -.mud)  mud
      (mule |.((slam p.mud sam)))
    ::

XX Document

