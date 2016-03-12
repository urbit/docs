### `++shax`

    ++  shax                                                ::  sha-256
      ~/  %shax
      |=  ruz=@  ^-  @
      ~|  %sha
      =+  [few==>(fe .(a 5)) wac=|=([a=@ b=@] (cut 5 [a 1] b))]
      =+  [sum=sum.few ror=ror.few net=net.few inv=inv.few]
      =+  ral=(lsh 0 3 (met 3 ruz))
      =+  ^=  ful
          %+  can  0
          :~  [ral ruz]
              [8 128]
              [(mod (sub 960 (mod (add 8 ral) 512)) 512) 0]
              [64 (~(net fe 6) ral)]
          ==
      =+  lex=(met 9 ful)
      =+  ^=  kbx  0xc671.78f2.bef9.a3f7.a450.6ceb.90be.fffa.
                     8cc7.0208.84c8.7814.78a5.636f.748f.82ee.
                     682e.6ff3.5b9c.ca4f.4ed8.aa4a.391c.0cb3.
                     34b0.bcb5.2748.774c.1e37.6c08.19a4.c116.
                     106a.a070.f40e.3585.d699.0624.d192.e819.
                     c76c.51a3.c24b.8b70.a81a.664b.a2bf.e8a1.
                     9272.2c85.81c2.c92e.766a.0abb.650a.7354.
                     5338.0d13.4d2c.6dfc.2e1b.2138.27b7.0a85.
                     1429.2967.06ca.6351.d5a7.9147.c6e0.0bf3.
                     bf59.7fc7.b003.27c8.a831.c66d.983e.5152.
                     76f9.88da.5cb0.a9dc.4a74.84aa.2de9.2c6f.
                     240c.a1cc.0fc1.9dc6.efbe.4786.e49b.69c1.
                     c19b.f174.9bdc.06a7.80de.b1fe.72be.5d74.
                     550c.7dc3.2431.85be.1283.5b01.d807.aa98.
                     ab1c.5ed5.923f.82a4.59f1.11f1.3956.c25b.
                     e9b5.dba5.b5c0.fbcf.7137.4491.428a.2f98
      =+  ^=  hax  0x5be0.cd19.1f83.d9ab.9b05.688c.510e.527f.
                     a54f.f53a.3c6e.f372.bb67.ae85.6a09.e667
      =+  i=0
      |-  ^-  @
      ?:  =(i lex)
        (rep 5 (turn (rip 5 hax) net))
      =+  ^=  wox
          =+  dux=(cut 9 [i 1] ful)
          =+  wox=(rep 5 (turn (rip 5 dux) net))
          =+  j=16
          |-  ^-  @
          ?:  =(64 j)
            wox
          =+  :*  l=(wac (sub j 15) wox)
                  m=(wac (sub j 2) wox)
                  n=(wac (sub j 16) wox)
                  o=(wac (sub j 7) wox)
              ==
          =+  x=:(mix (ror 0 7 l) (ror 0 18 l) (rsh 0 3 l))
          =+  y=:(mix (ror 0 17 m) (ror 0 19 m) (rsh 0 10 m))
          =+  z=:(sum n x o y)
          $(wox (con (lsh 5 j z) wox), j +(j))
      =+  j=0
      =+  :*  a=(wac 0 hax)
              b=(wac 1 hax)
              c=(wac 2 hax)
              d=(wac 3 hax)
              e=(wac 4 hax)
              f=(wac 5 hax)
              g=(wac 6 hax)
              h=(wac 7 hax)
          ==
      |-  ^-  @
      ?:  =(64 j)
        %=  ^$
          i  +(i)
          hax  %+  rep  5
               :~  (sum a (wac 0 hax))
                   (sum b (wac 1 hax))
                   (sum c (wac 2 hax))
                   (sum d (wac 3 hax))
                   (sum e (wac 4 hax))
                   (sum f (wac 5 hax))
                   (sum g (wac 6 hax))
                   (sum h (wac 7 hax))
               ==
        ==
      =+  l=:(mix (ror 0 2 a) (ror 0 13 a) (ror 0 22 a))    ::  s0
      =+  m=:(mix (dis a b) (dis a c) (dis b c))            ::  maj
      =+  n=(sum l m)                                       ::  t2
      =+  o=:(mix (ror 0 6 e) (ror 0 11 e) (ror 0 25 e))    ::  s1
      =+  p=(mix (dis e f) (dis (inv e) g))                 ::  ch
      =+  q=:(sum h o p (wac j kbx) (wac j wox))            ::  t1
      $(j +(j), a (sum q n), b a, c b, d c, e (sum d q), f e, g f, h g)
    ::

XX document



***
