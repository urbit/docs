### `++co`

Literal rendering engine

A [door]() that contains arms that operate on the sample coin `lot`.

Accepts
-------

Produces
--------

`lot` is a [`++coin`]().

Source
------

    ++  co
      =<  |_  lot=coin

Examples
--------

    ~zod/try=> ~(. co many/~[`ta/'mo' `ud/5])
    < 3.dhd
      [ [ %many
          [%~ %ta @t]
          [%~ %ud @ud]
          %~
        ]
        <10.utz 3.zid [rex="" <414.hmb 100.xkc 1.ypj %164>]>
      ]
    >

------------------------------------------------------------------------

### `++rear`

Prepend & render as tape

Renders a coin `lot` as a [tape]() prepended to the sample tape `rom`.

Accepts
-------

Produces
--------

`rom` is a [`pe`]()

`lot` is a [`++coin`]().

Source
------

          ++  rear  |=(rom=tape =>(.(rex rom) rend))

Examples
--------

    ~zod/try=> (~(rear co %$ %ux 200) "--ha")
    "0xc8--ha"

------------------------------------------------------------------------

### `++rent`

Render as span

Renders a coin `lot` as a span.

Accepts
-------

Produces
--------

`lot` is a [`++coin`]().

Source
------

          ++  rent  `@ta`(rap 3 rend)

Examples
--------

    ~zod/try=> ~(rent co %$ %ux 200)
    ~.0xc8
    ~zod/try=> `@t`~(rent co %$ %ux 200)
    '0xc8'

------------------------------------------------------------------------

### `++rend`

Render as tape

Renders a coin `lot` as a tape.

Accepts
-------

Produces
--------

`lot` is a [`++coin`]().

Source
------

          ++  rend
            ^-  tape
            ?:  ?=(%blob -.lot)
              ['~' '0' ((v-co 1) (jam p.lot))]
            ?:  ?=(%many -.lot)
              :-  '.'
              |-  ^-  tape
              ?~   p.lot
                ['_' '_' rex]
              ['_' (weld (trip (wack rent(lot i.p.lot))) $(p.lot t.p.lot))]
            =+  [yed=(end 3 1 p.p.lot) hay=(cut 3 [1 1] p.p.lot)]
            |-  ^-  tape
            ?+    yed  (z-co q.p.lot)
                %c   ['~' '-' (weld (rip 3 (wood (tuft q.p.lot))) rex)]
                %d
              ?+    hay  (z-co q.p.lot)
                  %a
                =+  yod=(yore q.p.lot)
                =>  ^+(. .(rex ?~(f.t.yod rex ['.' (s-co f.t.yod)])))
                =>  ^+  .
                    %=    .
                        rex
                      ?:  &(=(~ f.t.yod) =(0 h.t.yod) =(0 m.t.yod) =(0 s.t.yod))
                        rex
                      =>  .(rex ['.' (y-co s.t.yod)])
                      =>  .(rex ['.' (y-co m.t.yod)])
                      ['.' '.' (y-co h.t.yod)]
                    ==
                =>  .(rex ['.' (a-co d.t.yod)])
                =>  .(rex ['.' (a-co m.yod)])
                =>  .(rex ?:(a.yod rex ['-' rex]))
                ['~' (a-co y.yod)]
              ::
                  %r
                =+  yug=(yell q.p.lot)
                =>  ^+(. .(rex ?~(f.yug rex ['.' (s-co f.yug)])))
                :-  '~'
                ?:  &(=(0 d.yug) =(0 m.yug) =(0 h.yug) =(0 s.yug))
                  ['.' 's' '0' rex]
                =>  ^+(. ?:(=(0 s.yug) . .(rex ['.' 's' (a-co s.yug)])))
                =>  ^+(. ?:(=(0 m.yug) . .(rex ['.' 'm' (a-co m.yug)])))
                =>  ^+(. ?:(=(0 h.yug) . .(rex ['.' 'h' (a-co h.yug)])))
                =>  ^+(. ?:(=(0 d.yug) . .(rex ['.' 'd' (a-co d.yug)])))
                +.rex
              ==
            ::
                %f
              ?:  =(& q.p.lot)
                ['.' 'y' rex]
              ?:(=(| q.p.lot) ['.' 'n' rex] (z-co q.p.lot))
            ::
                %n   ['~' rex]
                %i
              ?+  hay  (z-co q.p.lot)
                %f  ((ro-co [3 10 4] |=(a=@ ~(d ne a))) q.p.lot)
                %s  ((ro-co [4 16 8] |=(a=@ ~(x ne a))) q.p.lot)
              ==
            ::
                %p
              =+  dyx=(met 3 q.p.lot)
              :-  '~'
              ?:  (lte dyx 1)
                (weld (trip (tod:po q.p.lot)) rex)
              ?:  =(2 dyx)
                ;:  weld
                  (trip (tos:po (end 3 1 q.p.lot)))
                  (trip (tod:po (rsh 3 1 q.p.lot)))
                  rex
                ==
              =+  [dyz=(met 5 q.p.lot) fin=|]
              |-  ^-  tape
              ?:  =(0 dyz)
                rex
              %=    $
                  fin      &
                  dyz      (dec dyz)
                  q.p.lot  (rsh 5 1 q.p.lot)
                  rex
                =+  syb=(wren:un (end 5 1 q.p.lot))
                =+  cog=~(zig mu [(rsh 4 1 syb) (end 4 1 syb)])
                ;:  weld
                  (trip (tos:po (end 3 1 p.cog)))
                  (trip (tod:po (rsh 3 1 p.cog)))
                  `tape`['-' ~]
                  (trip (tos:po (end 3 1 q.cog)))
                  (trip (tod:po (rsh 3 1 q.cog)))
                  `tape`?:(fin ['-' ?:(=(1 (end 0 1 dyz)) ~ ['-' ~])] ~)
                  rex
                ==
              ==
            ::
                %r
              ?+  hay  (z-co q.p.lot)
                %d  
              =+  r=(rlyd q.p.lot)
              ?~  e.r
                ['.' '~' (r-co r)]
              ['.' '~' u.e.r]
                %h  ['.' '~' '~' (r-co (rlyh q.p.lot))]
                %q  ['.' '~' '~' '~' (r-co (rlyq q.p.lot))]
                %s  ['.' (r-co (rlys q.p.lot))]
              ==
            ::
                %u
              =-  (weld p.gam ?:(=(0 q.p.lot) `tape`['0' ~] q.gam))
              ^=  gam  ^-  [p=tape q=tape]
              ?+  hay  [~ ((ox-co [10 3] |=(a=@ ~(d ne a))) q.p.lot)]
                %b  [['0' 'b' ~] ((ox-co [2 4] |=(a=@ ~(d ne a))) q.p.lot)]
                %i  [['0' 'i' ~] ((d-co 1) q.p.lot)]
                %x  [['0' 'x' ~] ((ox-co [16 4] |=(a=@ ~(x ne a))) q.p.lot)]
                %v  [['0' 'v' ~] ((ox-co [32 5] |=(a=@ ~(x ne a))) q.p.lot)]
                %w  [['0' 'w' ~] ((ox-co [64 5] |=(a=@ ~(w ne a))) q.p.lot)]
              ==
            ::
                %s
              %+  weld
                ?:((syn:si q.p.lot) "--" "-")
              $(yed 'u', q.p.lot (abs:si q.p.lot))
            ::
                %t
              ?:  =('a' hay)
                ?:  =('s' (cut 3 [2 1] p.p.lot))
                  
                  (weld (rip 3 q.p.lot) rex)
                ['~' '.' (weld (rip 3 q.p.lot) rex)]
              ['~' '~' (weld (rip 3 (wood q.p.lot)) rex)]
            ==
          --
      =+  rex=*tape
      =<  |%
          ++  a-co  |=(dat=@ ((d-co 1) dat))
          ++  d-co  |=(min=@ (em-co [10 min] |=([? b=@ c=tape] [~(d ne b) c])))
          ++  r-co
            |=  [syn=? nub=@ der=@ ign=(unit tape) ne=?]
            =>  .(rex ['.' (t-co ((d-co 1) der) ne)])
            =>  .(rex ((d-co 1) nub))
            ?:(syn rex ['-' rex])
          ++  t-co  |=  [a=tape n=?]  ^-  tape 
            ?:  n  a
            ?~  a  ~|(%empty-frac !!)  t.a
          ::
          ++  s-co
            |=  esc=(list ,@)  ^-  tape
            ~|  [%so-co esc]
            ?~  esc
              rex
            :-  '.'
            =>(.(rex $(esc t.esc)) ((x-co 4) i.esc))
            
        ::
          ++  v-co  |=(min=@ (em-co [32 min] |=([? b=@ c=tape] [~(v ne b) c])))
          ++  w-co  |=(min=@ (em-co [64 min] |=([? b=@ c=tape] [~(w ne b) c])))
          ++  x-co  |=(min=@ (em-co [16 min] |=([? b=@ c=tape] [~(x ne b) c])))
          ++  y-co  |=(dat=@ ((d-co 2) dat))
          ++  z-co  |=(dat=@ `tape`['0' 'x' ((x-co 1) dat)])
          --
      ~%  %co  +>  ~
      |%
      ++  em-co
        ~/  %emco
        |=  [[bas=@ min=@] [par=$+([? @ tape] tape)]]
        |=  hol=@
        ^-  tape
        ?:  &(=(0 hol) =(0 min))
          rex
        =+  [rad=(mod hol bas) dar=(div hol bas)]
        %=  $
          min  ?:(=(0 min) 0 (dec min))
          hol  dar
          rex  (par =(0 dar) rad rex)
        ==
      ::
      ++  ox-co
        ~/  %oxco
        |=  [[bas=@ gop=@] dug=$+(@ @)]
        %+  em-co
          [|-(?:(=(0 gop) 1 (mul bas $(gop (dec gop))))) 0]
        |=  [top=? seg=@ res=tape]
        %+  weld
          ?:(top ~ `tape`['.' ~])
        %.  seg
        %+  em-co(rex res)
          [bas ?:(top 0 gop)]
        |=([? b=@ c=tape] [(dug b) c])
      ::
      ++  ro-co
        ~/  %roco
        |=  [[buz=@ bas=@ dop=@] dug=$+(@ @)]
        |=  hol=@
        ^-  tape
        ?:  =(0 dop)
          rex
        =>  .(rex $(dop (dec dop)))
        :-  '.'
        %-  (em-co [bas 1] |=([? b=@ c=tape] [(dug b) c]))
        [(cut buz [(dec dop) 1] hol)]
      --
    ::

Examples
--------

    ~zod/try=> ~(rend co ~ %ux 200)
    "0xc8"
    ~zod/try=> ~(rend co %many ~[[%$ ux/200] [%$ p/40]])
    "._0xc8_~~tem__"
    ~zod/try=> ~(rend co ~ %p 32.819)
    "~pillyt"
    ~zod/try=> ~(rend co ~ %ux 18)
    "0x12"
    ~zod/try=> ~(rend co [~ p=[p=%if q=0x7f00.0001]])
    ".127.0.0.1"
    ~zod/try=> `@ux`.127.0.0.1
    2.130.706.433
    ~zod/try=> ~(rend co %many ~[[~ %ud 20] [~ %uw 133] [~ %tas 'sam']])
    "._20_0w25_sam__"
    ~zod/try=> ~(rend co %blob [1 1])
    "~0ph"
    ~zod/try=> ~0ph
    [1 1]
    ~zod/try=> `@uv`(jam [1 1])
    0vph



***
