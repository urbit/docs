---
navhome: /docs/
---


### `++epur`

Top-level URL parser

Parses an entire URL.

Accepts
-------

`a` is a [`++cord`](/docs/hoon/library/1#++cord).

Produces
--------

A [`++purl`]().

Source
------

    ++  epur                                                ::  url/header parser
          =<  |=(a=cord (rush a auri))
          |%

Examples
--------

    ~zod/main=> (epur 'http://127.0.0.1/')
    [~ [p=[p=%.n q=~ r=[%.n p=.127.0.0.1]] q=[p=~ q=<||>] r=~]]
    ~zod/main=> (epur 'http://www.google.com/')
    [~ [p=[p=%.n q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~]]
    ~zod/main=> (epur 'https://www.google.com/')
    [~ [p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~]]
    ~zod/main=> (epur 'https//www.google.com/')
    ~
    ~zod/main=> (epur 'https://www.google.com:200/')
    [~ [p=[p=%.y q=[~ 200] r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~]]
    ~zod/main=> (epur 'https://www.google.com:200/search')
    [ ~
      [p=[p=%.y q=[~ 200] r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~]
    ]
    ~zod/main=> (epur 'https://www.google.com/search')
    [~ [p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~]]
    ~zod/main=> (epur 'https://www.google.com/search?q=urbit')
    [ ~ 
      [ p=[p=%.y q=~ r=[%.y p=<|com google www|>]]
        q=[p=~ q=<|search|>]
        r=~[[p='q' q='urbit']]
      ]
    ]
    ~zod/main=> (epur 'https://www.google.com/search?q=urb it')
    ~
    ~zod/main=> (epur 'https://www.google.com/search?q=urb%20it')
    [ ~
      [ p=[p=%.y q=~ r=[%.y p=<|com google www|>]] 
        q=[p=~ q=<|search|>] 
        r=~[[p='q' q='urb it']]
      ]
    ]
    ~zod/main=> (epur 'https://www.google.com/search?q=urbit%20escaping%3F')
    [ ~ 
      [ p=[p=%.y q=~ r=[%.y p=<|com google www|>]] 
        q=[p=~ q=<|search|>]
        r=~[[p='q' q='urbit escaping?']]
      ]
    ]

### `++apat`

URL path as ++pork

Parses a URL path as a [`++pork`]().

Produces
--------

A [`++rule`]().

Source
------

    ++  apat                                              ::  2396 abs_path
            %+  cook  deft
            (ifix [fas ;~(pose fas (easy ~))] (more fas smeg))

Examples
--------

    ~zod/try=> (scan "/foo/mol/lok" apat:epur)
    [p=~ q=<|foo mol lok|>]
    ~zod/try=> (scan "/foo/mol/lok.htm" apat:epur)
    [p=[~ ~.htm] q=<|foo mol lok|>]

### `++auri`

URL parsing rule

Accepts
-------

A [`++purl`]().

Produces
--------

XX

Source
------

    ++  auri
            %+  cook
              |=  a=purl
              ?.(=([& /localhost] r.p.a) a a(p.p &))
            ;~  plug
              ;~  plug
                %+  sear
                  |=  a=@t
                  ^-  (unit ,?)
                  ?+(a ~ %http [~ %|], %https [~ %&])
                ;~(sfix scem ;~(plug col fas fas))
                thor
              ==
              ;~(plug ;~(pose apat (easy *pork)) yque)
            ==

Examples
--------

    ~zod/main=> (auri:epur [1 1] "http://127.0.0.1/")
    [ p=[p=1 q=18] 
        q
      [ ~
          u
        [ p=[p=[p=%.n q=~ r=[%.n p=.127.0.0.1]] q=[p=~ q=<||>] r=~]
          q=[p=[p=1 q=18] q=""]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "http://www.google.com/")
    [ p=[p=1 q=23]
        q
      [ ~
         u
        [ p=[p=[p=%.n q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~] 
          q=[p=[p=1 q=23] q=""]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/")
    [ p=[p=1 q=24]
        q
      [ ~
         u
        [ p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~] 
          q=[p=[p=1 q=24] q=""]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "https//www.google.com/")
    [ p=[p=1 q=6] q=~]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com:200/")
    [ p=[p=1 q=28]
      q=[~ u=[p=[p=[p=%.y q=[~ 200] r=[%.y p=<|com google www|>]] q=[p=~ q=<||>] r=~] q=[p=[p=1 q=28] q=""]]]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com:200/search")
    [ p=[p=1 q=34]
      q=[~ u=[p=[p=[p=%.y q=[~ 200] r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~] q=[p=[p=1 q=34] q=""]]]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/search")
    [ p=[p=1 q=30]
      q=[~ u=[p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~] q=[p=[p=1 q=30] q=""]]]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/search?q=urbit")
    [ p=[p=1 q=38]
        q
      [ ~
          u
        [ p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~[[p='q' q='urbit']]]
          q=[p=[p=1 q=38] q=""]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/search?q=urb it")
    [ p=[p=1 q=36]
        q
      [ ~
          u
        [ p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~[[p='q' q='urb']]]
          q=[p=[p=1 q=36] q=" it"]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/search?q=urb%20it")
    [ p=[p=1 q=41]
        q
      [ ~
          u
        [ p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~[[p='q' q='urb it']]]
          q=[p=[p=1 q=41] q=""]
        ]
      ]
    ]
    ~zod/main=> (auri:epur [1 1] "https://www.google.com/search?q=urbit%20escaping%3F")
    [ p=[p=1 q=52]
        q
      [ ~
          u
        [ p=[p=[p=%.y q=~ r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~[[p='q' q='urbit escaping?']]]
          q=[p=[p=1 q=52] q=""]
        ]
      ]
    ]

### `++cock`

HTTP cookies, results in associative list of cord to cord.

Accepts
-------

Produces
--------

Source
------

    ++  cock                                              ::  cookie
            (most ;~(plug sem ace) ;~(plug toke ;~(pfix tis tosk)))

Examples
--------

    ~zod/try=> (scan "sam=lop" cock:epur)
    [['sam' 'lop'] ~]
    ~zod/try=> (scan "sam=lop; res=\"salo don -keg!mo\"" cock:epur)
    [['sam' 'lop'] ~[['res' 'salo don -keg!mo']]]
    ~zod/try=> (scan "sam=lop; res=\"salo don -keg!mo\";  so" cock:epur)
    ! {1 34}
    ! exit

### `++dlab`

Domain label: alphanumeric, with `-` allowed in middle.

Accepts
-------

Produces
--------

Source
------

    ++  dlab                                              ::  2396 domainlabel
            %+  sear
              |=  a=@ta
              ?.(=('-' (rsh 3 (dec (met 3 a)) a)) [~ u=a] ~)
            %+  cook  cass
            ;~(plug aln (star alp))
          ::

Examples
--------

    ~zod/try=> (scan "google" dlab:epur)
    ~.google
    ~zod/try=> (scan "lera2" dlab:epur)
    ~.lera2
    ~zod/try=> (scan "gor-tem" dlab:epur)
    ~.gor-tem
    ~zod/try=> (scan "gortem-" dlab:epur)
    ! {1 8}
    ! exit

### `++fque`

One or more query string characters

Accepts
-------

Produces
--------

Source
------

    ++  fque  (cook crip (plus pquo))                     ::  normal query field

Examples
--------

    ~zod/try=> (scan "%20" fque:epur)
    ' '
    ~zod/try=> (scan "sam" fque:epur)
    'sam'
    ~zod/try=> (scan "les+tor" fque:epur)
    'les tor'
    ~zod/try=> (scan "sore-%22mek%22" fque:epur)
    'sore-"mek"'
    ~zod/try=> (scan "" fque:epur)
    ! {1 1}
    ! exit

### `++fquu`

Zero or more query string characters

Accepts
-------

Produces
--------

Source
------

    ++  fquu  (cook crip (star pquo))                     ::  optional field

Examples
--------

    ~zod/try=> (scan "%20" fquu:epur)
    ' '
    ~zod/try=> (scan "sam" fquu:epur)
    'sam'
    ~zod/try=> (scan "les+tor" fquu:epur)
    'les tor'
    ~zod/try=> (scan "sore-%22mek%22" fquu:epur)
    'sore-"mek"'
    ~zod/try=> (scan "" fquu:epur)
    ''

### `++pcar`

Single URL path character: literal, `%` escape, subpath delimiter, `:`
or `@`

Accepts
-------

Produces
--------

Source
------

    ++  pcar  ;~(pose pure pesc psub col pat)             ::  2396 path char

Examples
--------

    ~zod/try=> (scan "a" pcar:epur)
    ~~a
    ~zod/try=> (scan "ab" pcar:epur)
    ! {1 2}
    ! exit
    ~zod/try=> (scan "-" pcar:epur)
    ~~-
    ~zod/try=> (scan "." pcar:epur)
    ~~~.
    ~zod/try=> (scan "%20" pcar:epur)
    ~~.
    ~zod/try=> (scan "!" pcar:epur)
    ~~~21.

### `++pcok`

Cookie character

Accepts
-------

Produces
--------

Source
------

    ++  pcok  ;~(less bas sem com doq prn)                ::  cookie char

Examples
--------

    ~zod/try=> (scan "a" pcok:epur)
    ~~a
    ~zod/try=> (scan "ab" pcok:epur)
    ! {1 2}
    ! exit
    ~zod/try=> (scan "!" pcok:epur)
    ~~~21.
    ~zod/try=> (scan ";" pcok:epur)
    ! {1 2}
    ! exit

### `++pesc`

URL `%` escape, by two hex characters.

Accepts
-------

Produces
--------

Source
------

    ++  pesc  ;~(pfix cen mes)                            ::  2396 escaped

Examples
--------

    ~zod/try=> `@t`(scan "%22" pesc:epur)
    '"'
    ~zod/try=> `@t`(scan "%20" pesc:epur)
    ' '

### `++pold`

Old URL `' '` escape

Accepts
-------

Produces
--------

Source
------

    ++  pold  (cold ' ' (just '+'))                       ::  old space code

Examples
--------

    ~zod/try=> `@t`(scan "+" pold:epur)
    ' '
    ~zod/try=> `@t`(scan " " pold:epur)
    ! {1 1}
    ! exit

### `++pque`

Irregular query string character.

Accepts
-------

Produces
--------

Source
------

    ++  pque  ;~(pose pcar fas wut)                       ::  3986 query char

Examples
--------

    ~zod/try=> `@t`(scan "a" pque:epur)
    'a'
    ~zod/try=> `@t`(scan "?" pque:epur)
    '?'
    ~zod/try=> `@t`(scan "%20" pque:epur)
    ' '
    ~zod/try=> `@t`(scan "+" pque:epur)
    '+'

### `++pquo`

Character in query string key/value

Accepts
-------

Produces
--------

Source
------

    ++  pquo  ;~(pose pure pesc pold)                     ::  normal query char

Examples
--------

    ~zod/try=> (scan "a" pquo:epur)
    'a'
    ~zod/try=> (scan "ab" pquo:epur)
    ! {1 2}
    ! exit
    ~zod/try=> (scan "%22" pquo:epur)
    '"'
    ~zod/try=> (scan "%20" pquo:epur)
    ' '
    ~zod/try=> (scan "+" pquo:epur)
    ' '

### `++pure`

URL-safe character

Accepts
-------

Produces
--------

Source
------

    ++  pure  ;~(pose aln hep dot cab sig)                ::  2396 unreserved

Examples
--------

    ~zod/try=> (scan "a" pure:epur)
    ~~a
    ~zod/try=> (scan "%20" pure:epur)
    ! {1 1}
    ! exit
    ~zod/try=> (scan "." pure:epur)
    ~~~.
    ~zod/try=> (scan "-" pure:epur)
    ~~-

### `++psub`

URL path subdelimeter

Accepts
-------

Produces
--------

Source
------

    ++  psub  ;~  pose                                    ::  3986 sub-delims
                      zap  buc  pam  soq  pel  per
                      tar  lus  com  sem  tis
                    ==

Examples
--------

    ~zod/try=> `@t`(scan "+" psub:epur)
    '+'
    ~zod/try=> `@t`(scan "(" psub:epur)
    '('
    ~zod/try=> `@t`(scan "$" psub:epur)
    '$'
    ~zod/try=> `@t`(scan "a" psub:epur)
    ! {1 1}
    ! exit

### `++ptok`

Character valid in HTTP token

Accepts
-------

Produces
--------

Source
------

    ++  ptok  ;~  pose                                    ::  2616 token
                      aln  zap  hax  buc  cen  pam  soq  tar  lus
                      hep  dot  ket  cab  tec  bar  sig
                    ==

Examples
--------

    ~zod/try=> `tape`(murn =+(a=' ' |-(`tape`?:(=(0x7f a) ~ [a $(a +(a))]))) (curr rush ptok):epur)
    "!#$%&'*+-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ^_`abcdefghijklmnopqrstuvwxyz|~"
    ~zod/try=> `tape`(skim =+(a=' ' |-(`tape`?:(=(0x7f a) ~ [a $(a +(a))]))) |=(a=char ?=(~ (rush a ptok:epur))))
    " "(),/:;<=>?@[\]{}"

### `++scem`

URI scheme: alphabetic character, followed by any number of
alphanumeric, `+` `-` or `.`

Accepts
-------

Produces
--------

Source
------

    ++  scem                                              ::  2396 scheme
            %+  cook  cass
            ;~(plug alf (star ;~(pose aln lus hep dot)))
          ::

Examples
--------

    ~zod/try=> `@t`(scan "http" scem:epur)
    'http'
    ~zod/try=> `@t`(scan "https" scem:epur)
    'https'
    ~zod/try=> `@t`(scan "chrome-extension" scem:epur)
    'chrome-extension'

### `++smeg`

URL path segment

Accepts
-------

Produces
--------

Source
------

    ++  smeg  (cook crip (plus pcar))                     ::  2396 segment

Examples
--------

    ~zod/try=> (scan "foo" smeg:epur)
    'foo'
    ~zod/try=> (scan "bar%20baz-bam" smeg:epur)
    'bar baz-bam'

### `++tock`

HTTP cookie value

Accepts
-------

Produces
--------

Source
------

    ++  tock  (cook crip (plus pcok))                     ::  6265 cookie-value

Examples
--------

    ~zod/try=> (rush 'sam' tock:epur)
    [~ 'sam']
    ~zod/try=> (rush 'las!tore' tock:epur)
    [~ 'las!tore']
    ~zod/try=> (rush '"sop""les"tor' tock:epur)
    ~
    ~zod/try=> (rush '"zemug"' tock:epur)
    ~

### `++tosk`

Possibly quoted HTTP cookie value

Accepts
-------

Produces
--------

Source
------

    ++  tosk  ;~(pose tock (ifix [doq doq] tock))         ::  6265 cookie-value

Examples
--------

    ~zod/try=> (rush 'sam' tosk:epur)
    [~ 'sam']
    ~zod/try=> (rush 'las!tore' tosk:epur)
    [~ 'las!tore']
    ~zod/try=> (rush '"sop""les"tor' tosk:epur)
    ~
    ~zod/try=> (rush '"zemug"' tosk:epur)
    [~ 'zemug']

### `++toke`

HTTP cookie name

Accepts
-------

Produces
--------

Source
------

    ++  toke  (cook crip (plus ptok))                     ::  2616 token

Examples
--------

    ~zod/try=> (rush 'sam' toke:epur)
    [~ 'sam']
    ~zod/try=> (rush 'las!tore' toke:epur)
    [~ 'las!tore']
    ~zod/try=> (rush 'sop""les"tor' toke:epur)
    ~
    ~zod/try=> (rush '"zemug"' toke:epur)
    ~

### `++thor`

Parse ++host and unit `@ui` port.

Accepts
-------

Produces
--------

Source
------

    ++  thor                                              ::  2396 host/port
            %+  cook  |*(a=[* *] [+.a -.a])
            ;~  plug
              thos
              ;~(pose (stag ~ ;~(pfix col dim:ag)) (easy ~))
            ==

Examples
--------

    ~zod/try=> (scan "localhost" thor:epur)
    [~ [%.y i='localhost' t=~]]
    ~zod/try=> (scan "localhost:8080" thor:epur)
    [[~ q=8.080] [%.y i='localhost' t=~]]
    ~zod/try=> (scan "192.168.0.1:8080" thor:epur)
    [[~ q=8.080] [%.n q=3.232.235.521]]
    ~zod/try=> (scan "www.google.com" thor:epur)
    [~ [%.y i='com' t=~['google' 'www']]]

### `++thos`

URI host: dot-separated segments, or IP address.

Accepts
-------

Produces
--------

Source
------

    ++  thos                                              ::  2396 host, no local
            ;~  plug
              ;~  pose
                %+  stag  %&
                %+  sear                                        ::  LL parser weak here
                  |=  a=(list ,@t)
                  =+  b=(flop a)
                  ?>  ?=(^ b)
                  =+  c=(end 3 1 i.b)
                  ?.(&((gte c 'a') (lte c 'z')) ~ [~ u=b])
                (most dot dlab)
              ::
                %+  stag  %|
                =+  tod=(ape:ag ted:ab)
                %+  bass  256
                ;~(plug tod (stun [3 3] ;~(pfix dot tod)))
              ==
            ==

Examples
--------

    ~zod/try=> (scan "localhost" thos:epur)
    [%.y i='localhost' t=~]
    ~zod/try=> (scan "192.168.0.1" thos:epur)
    [%.n q=3.232.235.521]
    ~zod/try=> (scan "192.168.0.1:80" thos:epur)
    ! {1 12}
    ! exit
    ~zod/try=> (scan "www.google.com" thos:epur)
    [%.y i='com' t=~['google' 'www']]

### `++yque`

Parses query string, or lack thereof. Result type ++quay

Accepts
-------

Produces
--------

Source
------

    ++  yque                                              ::  query ending
            ;~  pose
              ;~(pfix wut yquy)
              (easy ~)
            ==

Examples
--------

    ~zod/try=> (scan "?sar=tok" yque:epur)
    [['sar' 'tok'] ~]
    ~zod/try=> (scan "?les=urbit%20sep&met=kam" yque:epur)
    [['les' 'urbit sep'] ~[['met' 'kam']]]
    ~zod/try=> (scan "" yque:epur)
    ~

### `++yquy`

Parse query string after `?`

Accepts
-------

Produces
--------

Source
------

    ++  yquy                                              ::  query
            ;~  pose                                            ::  proper query
              %+  more
                ;~(pose pam sem)
              ;~(plug fque ;~(pose ;~(pfix tis fquu) (easy '')))
            ::
              %+  cook                                          ::  funky query
                |=(a=tape [[%$ (crip a)] ~])
              (star pque)
            ==

Examples
--------

    ~zod/try=> (scan "sar=tok" yquy:epur)
    [['sar' 'tok'] ~]
    ~zod/try=> (scan "les=urbit%20sep&met=kam" yquy:epur)
    [['les' 'urbit sep'] ~[['met' 'kam']]]
    ~zod/try=> (scan "" yquy:epur)
    ~

### `++zest`

Parse ++quri absolute or relative request path

Accepts
-------

Produces
--------

Source
------

    ++  zest                                              ::  2616 request-uri
            ;~  pose
              (stag %& (cook |=(a=purl a) auri))
              (stag %| ;~(plug apat yque))
            ==
          --

Examples
--------

    ~zod/try=> (scan "http://www.google.com:80/search?q=foo" zest:epur)
    [%.y p=[p=%.n q=[~ 80] r=[%.y p=<|com google www|>]] q=[p=~ q=<|search|>] r=~[[p='q' q='foo']]]
    ~zod/try=> (scan "/rel/bat" zest:epur)
    [%.n [p=~ q=<|rel bat|>] ~]

