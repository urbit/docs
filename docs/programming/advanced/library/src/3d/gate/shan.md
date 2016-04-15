### `++shan`

    ++  shan                                                ::  sha-1 (deprecated)
      |=  ruz/@
      =+  [few==>(fe .(a 5)) wac=|=({a/@ b/@} (cut 5 [a 1] b))]
      =+  [sum=sum.few ror=ror.few rol=rol.few net=net.few inv=inv.few]
      =+  ral=(lsh 0 3 (met 3 ruz))
      =+  ^=  ful
          %+  can  0
          :~  [ral ruz]
              [8 128]
              [(mod (sub 960 (mod (add 8 ral) 512)) 512) 0]
              [64 (~(net fe 6) ral)]
          ==
      =+  lex=(met 9 ful)
      =+  kbx=0xca62.c1d6.8f1b.bcdc.6ed9.eba1.5a82.7999
      =+  hax=0xc3d2.e1f0.1032.5476.98ba.dcfe.efcd.ab89.6745.2301
      =+  i=0
      |-
      ?:  =(i lex)
        (rep 5 (flop (rip 5 hax)))
      =+  ^=  wox
          =+  dux=(cut 9 [i 1] ful)
          =+  wox=(rep 5 (turn (rip 5 dux) net))
          =+  j=16
          |-  ^-  @
          ?:  =(80 j)
            wox
          =+  :*  l=(wac (sub j 3) wox)
                  m=(wac (sub j 8) wox)
                  n=(wac (sub j 14) wox)
                  o=(wac (sub j 16) wox)
              ==
          =+  z=(rol 0 1 :(mix l m n o))
          $(wox (con (lsh 5 j z) wox), j +(j))
      =+  j=0
      =+  :*  a=(wac 0 hax)
              b=(wac 1 hax)
              c=(wac 2 hax)
              d=(wac 3 hax)
              e=(wac 4 hax)
          ==
      |-  ^-  @
      ?:  =(80 j)
        %=  ^$
          i  +(i)
          hax  %+  rep  5
               :~
                   (sum a (wac 0 hax))
                   (sum b (wac 1 hax))
                   (sum c (wac 2 hax))
                   (sum d (wac 3 hax))
                   (sum e (wac 4 hax))
               ==
        ==
      =+  fx=(con (dis b c) (dis (not 5 1 b) d))
      =+  fy=:(mix b c d)
      =+  fz=:(con (dis b c) (dis b d) (dis c d))
      =+  ^=  tem
          ?:  &((gte j 0) (lte j 19))
            :(sum (rol 0 5 a) fx e (wac 0 kbx) (wac j wox))
          ?:  &((gte j 20) (lte j 39))
            :(sum (rol 0 5 a) fy e (wac 1 kbx) (wac j wox))
          ?:  &((gte j 40) (lte j 59))
            :(sum (rol 0 5 a) fz e (wac 2 kbx) (wac j wox))
          :(sum (rol 0 5 a) fy e (wac 3 kbx) (wac j wox))
      $(j +(j), a tem, b a, c (rol 0 30 b), d c, e d)
    ::

XX document



***
