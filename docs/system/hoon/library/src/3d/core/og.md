
### `++og`

    ++  og                                                  ::  shax-powered rng
      ~/  %og
      |_  a=@

XX document

### `++rad`

      ++  rad                                               ::  random in range
        |=  b=@  ^-  @
        =+  c=(raw (met 0 b))
        ?:((lth c b) c $(a +(a)))
        ::

XX document

### `++rads`

      ++  rads                                              ::  random continuation
        |=  b=@
        =+  r=(rad b)
        [r +>.$(a (shas %og-s r))]

XX document

### `++raw`

      ++  raw                                               ::  random bits
        ~/  %raw
        |=  b=@  ^-  @
        %+  can
          0
        =+  c=(shas %og-a (mix b a))
        |-  ^-  (list ,[@ @])
        ?:  =(0 b)
          ~
        =+  d=(shas %og-b (mix b (mix a c)))
        ?:  (lth b 256)
          [[b (end 0 b d)] ~]
        [[256 d] $(c d, b (sub b 256))]

XX document

### `++raws`

      ++  raws                                              ::  random bits continuation
        |=  b=@
        =+  r=(raw b)
        [r +>.$(a (shas %og-s r))]
      --



***
