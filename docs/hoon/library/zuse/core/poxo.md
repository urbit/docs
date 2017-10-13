---
navhome: /docs/
---


### `++poxo`

Print XML

Renders a `++manx` `a` as a [`++tape`]().

Accepts
-------

`a` is a [`++manx`]().

Produces
--------

A `++tape`.

Source
------

    ++  poxo                                                ::  node to tape
      =<  |=(a=manx `tape`(apex a ~))
      |_  unq=?                                             ::  unq

Examples
--------

    ~zod/try=> (poxo ;div;)
    "<div></div>"
    ~zod/try=> (poxo ;div:(p a))
    "<div><p></p><a></a></div>"
    ~zod/try=> (poxo ;div:(p:"tree > text" a))
    "<div><p>tree &gt; text</p><a></a></div>"


### `++apex`

Inner XML printer

Renders a [`++manx`]() as a [`++tape`](), appending a suffix `rez`.

XX is `rez/` a typo or is the `/` intentional

Accepts
-------

`rez` is a [`++tape`]().

Produces
--------

A `++tape`.

Source
------

      ++  apex                                              ::  top level
        |=  [mex=manx rez=tape]
        ^-  tape
        ?:  ?=([%$ [[%$ *] ~]] g.mex)
          (escp v.i.a.g.mex rez)
        =+  man=`mane`n.g.mex
        =.  unq  |(unq =(%script man) =(%style man))
        =+  tam=(name man)
        =.  rez  :(weld "</" tam ">" rez)
        =+  att=`mart`a.g.mex
        :-  '<'
        %+  welp  tam
        =.  rez  ['>' (many c.mex rez)]
        ?~(att rez [' ' (attr att rez)])
      ::  

Examples
--------

    ~zod/try=> (apex:poxo ;div; "")
    "<div></div>"
    ~zod/try=> (apex:poxo ;div:(p a) "").
    "<div><p></p><a></a></div>"
    ~zod/try=> (apex:poxo ;div:(p a) "--sfix")
    "<div><p></p><a></a></div>--sfix"
    ~zod/try=> (apex:poxo ;div:(p:"tree > text" a) "")
    "<div><p>tree &gt; text</p><a></a></div>"
    ~zod/try=> (~(apex poxo &) ;div:(p:"tree > text" a) "")
    "<div><p>tree > text</p><a></a></div>"

### `++attr`

Print attributes

Render XML attributes as a [`++tape`]().

Accepts
-------

`tat` is a [`++mart`]().

`rez` is a `++tape`.

Produces
--------

A `++tape`.

Source
------

      ++  attr                                              ::  attributes to tape
        |=  [tat=mart rez=tape]
        ^-  tape
        ?~  tat  rez
        =.  rez  $(tat t.tat)
        ;:  weld 
          (name n.i.tat)
          "=\"" 
          (escp(unq |) v.i.tat '"' ?~(t.tat rez [' ' rez]))
        ==

Examples
--------

    ~zod/try=> (attr:poxo ~ "")
    ""
    ~zod/try=> (crip (attr:poxo ~[sam/"hem" [%tok %ns]^"reptor"] ""))
    'sam="hem" tok:ns="reptor"'
    ~zod/try=> (crip (attr:poxo ~[sam/"hem" [%tok %ns]^"reptor"] "|appen"))
    'sam="hem" tok:ns="reptor"|appen'

### `++escp`

Escape XML

Escapes the XML special characters `"`, `&`, `'`, `<`, `>`.

Accepts
-------

`tex`is a [`++tape`]().

`rez` is a `++tape`.

Produces
--------

`++tape`.

Source
------

      ++  escp                                              ::  escape for xml
        |=  [tex=tape rez=tape]
        ?:  unq
          (weld tex rez)
        =+  xet=`tape`(flop tex)
        |-  ^-  tape
        ?~  xet  rez
        %=    $
          xet  t.xet
          rez  ?-  i.xet
                 34  ['&' 'q' 'u' 'o' 't' ';' rez]
                 38  ['&' 'a' 'm' 'p' ';' rez]
                 39  ['&' '#' '3' '9' ';' rez]
                 60  ['&' 'l' 't' ';' rez]
                 62  ['&' 'g' 't' ';' rez]
                 *   [i.xet rez]
               ==
        ==
      ::

Examples
--------

    ~zod/try=> (escp:poxo "astra" ~)
    ~[~~a ~~s ~~t ~~r ~~a]
    ~zod/try=> `tape`(escp:poxo "astra" ~)
    "astra"
    ~zod/try=> `tape`(escp:poxo "x > y" ~)
    "x &gt; y"
    ~zod/try=> `tape`(~(escp poxo &) "x > y" ~)
    "x > y"

### `++name`

Print name

Renders a [`++mane`]() as a [`++tape`]().

Accepts
-------

`man` is a `++mane`.

Produces
--------

A `++tape`.

Source
------

      ++  name                                              ::  name to tape
        |=  man=mane  ^-  tape
        ?@  man  (trip man)
        (weld (trip -.man) `tape`[':' (trip +.man)])
      ::

Examples
--------

    ~zod/try=> (name:poxo %$)
    ""
    ~zod/try=> (name:poxo %ham)
    "ham"
    ~zod/try=> (name:poxo %ham^%tor)
    "ham:tor"

### `++many`

Print node list

Renders multiple XML nodes as a [`++tape`]().

Accepts
-------

`lix` is a [`++list`]() of [`++manx`]().

`rez` is a `++tape`.

Produces
--------

A `++tape`.

Source
------

      ++  many                                              ::  nodelist to tape
        |=  [lix=(list manx) rez=tape]
        |-  ^-  tape
        ?~  lix  rez
        (apex i.lix $(lix t.lix))
      ::

Examples
--------

    ~zod/try=> (many:poxo ~ "")
    ""
    ~zod/try=> (many:poxo ;"hare" "")
    "hare"
    ~zod/try=> (many:poxo ;"hare;{lep}ton" "")
    "hare<lep></lep>ton"
    ~zod/try=> ;"hare;{lep}ton"
    [[[%~. [%~. "hare"] ~] ~] [[%lep ~] ~] [[%~. [%~. "ton"] ~] ~] ~]

