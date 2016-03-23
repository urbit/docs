### `++stew`

Switch by first

    ++  stew                                                ::  switch by first char
      ~/  %stew
      |*  leh/(list {p/?(@ {@ @}) q/rule})                  ::  char+range keys
      =+  ^=  wor                                           ::  range complete lth
          |=  {ort/?(@ {@ @}) wan/?(@ {@ @})}
          ?@  ort
            ?@(wan (lth ort wan) (lth ort -.wan))
          ?@(wan (lth +.ort wan) (lth +.ort -.wan))
      =+  ^=  hel                                           ::  build parser map
          =+  hel=`(tree _?>(?=(^ leh) i.leh))`~
          |-  ^+  hel
          ?~  leh
            ~
          =+  yal=$(leh t.leh)
          |-  ^+  hel
          ?~  yal
            [i.leh ~ ~]
          ?:  (wor p.i.leh p.n.yal)
            =+  nuc=$(yal l.yal)
            ?>  ?=(^ nuc)
            ?:  (vor p.n.yal p.n.nuc)
              [n.yal nuc r.yal]
            [n.nuc l.nuc [n.yal r.nuc r.yal]]
          =+  nuc=$(yal r.yal)
          ?>  ?=(^ nuc)
          ?:  (vor p.n.yal p.n.nuc)
            [n.yal l.yal nuc]
          [n.nuc [n.yal l.yal l.nuc] r.nuc]
      ~%  %fun  ..^$  ~
      |=  tub/nail
      ?~  q.tub
        (fail tub)
      |-
      ?~  hel
        (fail tub)
      ?:  ?@  p.n.hel
            =(p.n.hel i.q.tub)
          ?&((gte i.q.tub -.p.n.hel) (lte i.q.tub +.p.n.hel))
        ::  (q.n.hel [(lust i.q.tub p.tub) t.q.tub])
        (q.n.hel tub)
      ?:  (wor i.q.tub p.n.hel)
        $(hel l.hel)
      $(hel r.hel)
    ::



Parser generator. From an associative `++list` of characters or character
ranges to `++rule`s, construct a `++map`, and parse `++tape`s only
with `++rules` associated with a range that the `++tape`'s first character falls in.



***
