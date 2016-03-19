### `++at`

    ++  at
      |_  a/@

XX document

### `++r`

      ++  r
        ?:  ?&  (gte (met 3 a) 2)
                |-
                ?:  =(0 a)
                  &
                =+  vis=(end 3 1 a)
                ?&  ?|(=('-' vis) ?&((gte vis 'a') (lte vis 'z')))
                    $(a (rsh 3 1 a))
                ==
            ==
          rtam
        ?:  (lte (met 3 a) 2)
          rud
        rux
      ::

XX document

### `++rf`

      ++  rf    `tape`[?-(a $& '&', $| '|', * !!) ~]


XX document

### `++rn`

        ++  rn    `tape`[?>(=(0 a) '~') ~]

XX document

### `++rt`

        ++  rt    `tape`['\'' (weld (mesc (trip a)) `tape`['\'' ~])]

XX document

### `++rta`

        ++  rta   rt

XX document

### `++rtam`

      ++  rtam  `tape`['%' (trip a)]

XX document

### `++rub`

      ++  rub   `tape`['0' 'b' (rum 2 ~ |=(b/@ (add '0' b)))]

XX document

### `++rud`

      ++  rud   (rum 10 ~ |=(b/@ (add '0' b)))

XX document

### `++rum`

      ++  rum
        |=  {b/@ c/tape d/$-(@ @)}
        ^-  tape
        ?:  =(0 a)
          [(d 0) c]
        =+  e=0
        |-  ^-  tape
        ?:  =(0 a)
          c
        =+  f=&(!=(0 e) =(0 (mod e ?:(=(10 b) 3 4))))
        %=  $
          a  (div a b)
          c  [(d (mod a b)) ?:(f [?:(=(10 b) ',' '-') c] c)]
          e  +(e)
        ==
      ::


XX document

### `++rup`

      ++  rup
        =+  b=(met 3 a)
        ^-  tape
        :-  '-'
        |-  ^-  tape
        ?:  (gth (met 5 a) 1)
          %+  weld
            $(a (rsh 5 1 a), b (sub b 4))
          `tape`['-' '-' $(a (end 5 1 a), b 4)]
        ?:  =(0 b)
          ['~' ~]
        ?:  (lte b 1)
          (trip (tos:po a))
        |-  ^-  tape
        ?:  =(2 b)
          =+  c=(rsh 3 1 a)
          =+  d=(end 3 1 a)
          (weld (trip (tod:po c)) (trip (tos:po (mix c d))))
        =+  c=(rsh 3 2 a)
        =+  d=(end 3 2 a)
        (weld ^$(a c, b (met 3 c)) `tape`['-' $(a (mix c d), b 2)])
      ::

XX document

### `++ruv`

      ++  ruv
        ^-  tape
        :+  '0'
          'v'
        %^    rum
            64
          ~
        |=  b/@
        ?:  =(63 b)
          '+'
        ?:  =(62 b)
          '-'
        ?:((lth b 26) (add 65 b) ?:((lth b 52) (add 71 b) (sub b 4)))
      ::

XX document

### `++rux`

      ++  rux  `tape`['0' 'x' (rum 16 ~ |=(b/@ (add b ?:((lth b 10) 48 87))))]
      --
      ::::::::::::::::::::::::::::::::::::::::::::::::::::::  ::

XX document

------------------------------------------------------------------------


***
