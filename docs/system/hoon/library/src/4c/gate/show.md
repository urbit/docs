### `++show`

    ++  show                            ::  XX deprecated, use type
      |=  vem=*
      |^  ^-  tank
          ?:  ?=(@ vem)
            [%leaf (mesc (trip vem))]
          ?-    vem
              [s=~ c=*]
            [%leaf '\'' (weld (mesc (tape +.vem)) `tape`['\'' ~])]
          ::
              [s=%a c=@]        [%leaf (mesc (trip c.vem))]
              [s=%b c=*]        (shop c.vem |=(a=@ ~(rub at a)))
              [s=[%c p=@] c=*]
            :+  %palm
              [['.' ~] ['-' ~] ~ ~]
            [[%leaf (mesc (trip p.s.vem))] $(vem c.vem) ~]
          ::
              [s=%d c=*]        (shop c.vem |=(a=@ ~(rud at a)))
              [s=%k c=*]        (tank c.vem)
              [s=%h c=*]
            ?:  =(0 c.vem)      ::  XX remove after 220
              [%leaf '#' ~]
            :+  %rose
              [['/' ~] ['/' ~] ~]
            =+  yol=((list ,@ta) c.vem)
            (turn yol |=(a=@ta [%leaf (trip a)]))
          ::
              [s=%o c=*]
            %=    $
                vem
              :-  [%m '%h:<[%d %d].[%d %d]>']
              [-.c.vem +<-.c.vem +<+.c.vem +>-.c.vem +>+.c.vem ~]
            ==
          ::
              [s=%p c=*]        (shop c.vem |=(a=@ ~(rup at a)))
              [s=%q c=*]        (shop c.vem |=(a=@ ~(r at a)))
              [s=%r c=*]        $(vem [[%r ' ' '{' '}'] c.vem])
              [s=%t c=*]        (shop c.vem |=(a=@ ~(rt at a)))
              [s=%v c=*]        (shop c.vem |=(a=@ ~(ruv at a)))
              [s=%x c=*]        (shop c.vem |=(a=@ ~(rux at a)))
              [s=[%m p=@] c=*]  (shep p.s.vem c.vem)
              [s=[%r p=@] c=*]
            $(vem [[%r ' ' (cut 3 [0 1] p.s.vem) (cut 3 [1 1] p.s.vem)] c.vem])
          ::
              [s=[%r p=@ q=@ r=@] c=*]
            :+  %rose
              :*  p=(mesc (trip p.s.vem))
                  q=(mesc (trip q.s.vem))
                  r=(mesc (trip r.s.vem))
              ==
            |-  ^-  (list tank)
            ?@  c.vem
              ~
            [^$(vem -.c.vem) $(c.vem +.c.vem)]
          ::
              [s=%z c=*]        $(vem [[%r %$ %$ %$] c.vem])
              *                 !!
          ==

XX document

### `++shep`

      ++  shep
        |=  [fom=@ gar=*]
        ^-  tank
        =+  l=(met 3 fom)
        =+  i=0
        :-  %leaf
        |-  ^-  tape
        ?:  (gte i l)
          ~
        =+  c=(cut 3 [i 1] fom)
        ?.  =(37 c)
          (weld (mesc [c ~]) $(i +(i)))
        =+  d=(cut 3 [+(i) 1] fom)
        ?.  .?(gar)
          ['\\' '#' $(i (add 2 i))]
        (weld ~(ram re (show d -.gar)) $(i (add 2 i), gar +.gar))
      ::

XX document

### `++shop`

      ++  shop
        |=  [aug=* vel=$+(a=@ tape)]
        ^-  tank
        ?:  ?=(@ aug)
          [%leaf (vel aug)]
        :+  %rose
          [[' ' ~] ['[' ~] [']' ~]]
        =>  .(aug `*`aug)
        |-  ^-  (list tank)
        ?:  ?=(@ aug)
          [^$ ~]
        [^$(aug -.aug) $(aug +.aug)]
      --

XX document


