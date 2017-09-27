---
navhome: /docs/
---


### `++fuel`

Parse fcgi

Retrieieves the %eyre FCGI, producing a [`++epic`](). Used primarily in
[`/hook`]() files. See the [`%eyre`]() doc for more detail.

Accepts
-------

`bem` is a [`++beam`]().

`but` is a [`++path`]().

Produces
--------

A `++epic`.

Source
------

    ++  fuel                                                ::  parse fcgi
          |=  [bem=beam but=path]
          ^-  epic
          ?>  ?=([%web @ *] but)
          =+  dyb=(slay i.t.but)
          ?>  ?&  ?=([~ %many *] dyb)
                  ?=([* * *] p.u.dyb)
                  ::  ?=([%$ %tas *] i.p.u.dyb)
                  ?=([%many *] i.p.u.dyb)
                  ?=([%blob *] i.t.p.u.dyb)
              ==
          =+  ced=((hard cred) p.i.t.p.u.dyb)
          ::  =+  nep=q.p.i.p.u.dyb
          =+  ^=  nyp  ^-  path
              %+  turn  p.i.p.u.dyb
              |=  a=coin  ^-  @ta
              ?>  ?=([%$ %ta @] a)
              ?>(((sane %ta) q.p.a) q.p.a)
          =+  ^=  gut  ^-  (list ,@t)
              %+  turn  t.t.p.u.dyb
              |=  a=coin  ^-  @t
              ?>  ?=([%$ %t @] a)
              ?>(((sane %t) q.p.a) q.p.a)
          =+  ^=  quy
              |-  ^-  (list ,[p=@t q=@t])
              ?~  gut  ~
              ?>  ?=(^ t.gut)
              [[i.gut i.t.gut] $(gut t.t.gut)]
          :*  (~(gas by *(map cord cord)) quy)
              ced
              bem
              t.t.but
              nyp
          ==
        ::

Examples
--------

    ~zod/main=> (fuel [[p=~zod q=%try r=[%ud p=2]] s=/psal] /web/'._.~-~~~~.gen~-~-_~~05vg0001v09f0n30fbh7dn6ab2jakmmspdq04nef5h70qbd5lh6atr4c5j2qrbldpp62q1df1in0sr1ding0c3qgt7kclj74qb65lm6atrkc5k2qpr5e1mmispdchin4p3fegmiqrjpdlo62p1dchsn4p39comn8pbcehgmsbbef5p7crrifr3o035dhgfrk2b5__')
    [ qix={}
        ced
      [ hut=[p=%.y q=[~ 8.445] r=[%.n p=.0.0.0.0]]
        aut={[p=%$ q={'~rovryn-natlet-fidryd-dapmyn--todred-simpeg-hatwel-firfet'}]}
        orx='laspex-harnum-fadweb-mipbyn'
        acl=[~ 'en-US,en;q=0.8']
        cip=[%.y p=.127.0.0.1]
        cum={}
      ]
      bem=[[p=~zod q=%try r=[%ud p=2]] s=/psal]
      but=/
      nyp=/gen
    ]


