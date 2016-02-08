section 3bD, JSON and XML
=========================

### `++moon`

Mime type to `++cord`

Renders a [mime](http://en.wikipedia.org/wiki/MIME) type path with infix
`/` to a [`++cord`]().
Accepts
-------

`myn` is a ++[`mite`](), a [`++list`]() of [`@ta`]().

Produces
--------

A `++cord`.

Source
------

    ++  moon                                                ::  mime type to text
      |=  myn=mite
      %+  rap
        3
      |-  ^-  tape
      ?~  myn  ~
      ?:  =(~ t.myn)  (trip i.myn)
      (weld (trip i.myn) `tape`['/' $(myn t.myn)])
    ::

Examples
--------

    ~zod/try=> `@t`(moon /image/png)
    'image/png'
    ~zod/try=> `@t`(moon /text/x-hoon)
    'text/x-hoon'
    ~zod/try=> `@t`(moon /application/x-pnacl)
    'application/x-pnacl'

### `++perk`

Parse cube with fork

Parser generator. Produces a parser that succeeds upon encountering one
of the [`++term`]()s in a faceless list `a`.

A perk is an arm used to parse one of a finite set of options, formally
a choice between [`++term`]()s: if you want to match "true" or "false", and
nothing else, (perk \~[%true %false]) produces the relevant parser,
whose result type is `?(%true %false)`. For more complicated
transformations, a combintation of ++[`++sear`]() and map ++[`++get`]() is recommended,
e.g. `(sear ~(get by (mo ~[[%true &] [%false |]]))) sym)` will have a
similar effect but produce `?(& |)` , a [boolean](). However, constructions
such as `(sear (flit ~(has in (sa %true %false %other ~))) sym)` are
needlessly unwieldy.

Accepts
-------

`a` is a [`++pole`](), which is a [`++list`]() without [`%face`]()s.

Produces
--------

XX

Source
------

    ++  perk                                                ::  parse cube with fork
      |*  a=(pole ,@tas)
      ?~  a  fail
      ;~  pose 
        (cold -.a (jest -.a))
        $(a +.a)
      ==
    ::

Examples
--------

    ~zod/try=> (scan "ham" (perk %sam %ham %lam ~))
    %ham
    ~zod/try=> (scan "ram" (perk %sam %ham %lam ~))
    ! {1 1}
    ! exit

### `++poja`

JSON parser core

JSON parser core: parses a [`++cord`]() `a` to the hoon structure for JSON,
a [`++json`]().

Accepts
-------

`a` is [`++cord`]().

Produces
--------


A `(like json)`.

Source
------

    ++  poja                                                ::  JSON parser core
      =<  |=(a=cord (rush a apex))
      |%

Examples
--------

    ~zod/try=> (poja '[1,2,3]')
    [~ [%a p=~[[%n p=~.1] [%n p=~.2] [%n p=~.3]]]]
    ~zod/try=> (poja 'null')
    [~ ~]
    ~zod/try=> (poja 'invalid{json')
    ~

### `++tops`

Parse object

Top level parsing [`++rule`](). Parses either a single JSON object, or an array
of JSON objects to a [`++json`](). See also: [`++abox`](), [`++obox`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like json)`.

Source
------

       ++  apex  ;~(pose abox obox)                          ::  JSON object

Examples
--------

    ~zod/try=> (rash '[1,2]' apex:poja)
    [%a p=~[[%n p=~.1] [%n p=~.2]]]
    ~zod/try=> (rash '{"sam": "kot"}' apex:poja)
    [%o p={[p=~.sam q=[%s p=~.kot]]}]
    ~zod/try=> (rash 'null' apex:poja)
    ! {1 1}
    ! exit

### `++apex`

Parse value

Parsing [`++rule`](). Parses JSON values to [`++json`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like json)`.

Source
------

      ++  valu                                              ::  JSON value
        %+  knee  *json  |.  ~+
        ;~  pfix  spac
          ;~  pose
            (cold ~ (jest 'null'))
            (jify %b bool)
            (jify %s stri)
            (cook |=(s=tape [%n p=(rap 3 s)]) numb)
            abox
            obox
          ==
        ==

Examples
--------

    ~zod/try=> (rash '[1,2]' valu:poja)
    [%a p=~[[%n p=~.1] [%n p=~.2]]]
    ~zod/try=> (rash '{"sam": "kot"}' valu:poja)
    [%o p={[p='sam' q=[%s p=~.kot]]}]
    ~zod/try=> (rash 'null' valu:poja)
    ~
    ~zod/try=> (rash '20' valu:poja)
    [%n p=~.20]
    ~zod/try=> (rash '"str"' valu:poja)
    [%s p=~.str]
    ~zod/try=> (rash 'true' valu:poja)
    [%b p=%.y]

### `++abox`

Parse array

Parsing rule. Parses a JSON array with values enclosed within `[]` and
delimited by a `,`.

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like json)`.

Source
------

      ++  abox  (stag %a (ifix [sel (ws ser)] (more (ws com) valu)))

Examples
--------

    ~zod/try=> (rash '[1, 2,4]' abox:poja)
    [[%n p=~.1] ~[[%n p=~.2] [%n p=~.4]]]

JSON Objects
------------

### `++pair`

Parse key value pair

Parsing rule. Parses a [`++json`]() from a JSON key-value pair of a
string and value delimited by `:`.

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like json)`.

Source
------

      ++  pair  ;~(plug ;~(sfix (ws stri) (ws col)) valu)

Examples
--------

    ~zod/try=> (rash '"ham": 2' pair:poja)
    ['ham' [%n p=~.2]]

### `++obje`

Parse array of objects

Parsing rule. Parses a [`++json`]() from an array of JSON object
key-value pairs that are enclosed within `{}` and separated by `,`.

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like ,[%o p=(map ,@t json)])`

Source
------

      ++  obje  (ifix [(ws kel) (ws ker)] (more (ws com) pair))

Examples
--------

    ~zod/try=> (rash '{"ham": 2, "lam":true}' obje:poja)
    [['ham' [%n p=~.2]] ~[['lam' [%b p=%.y]]]]

### `++obox`

Parse boxed object

Parsing rule. Parses an array of JSON objects to an object of [`++json`](). See also: [`++json`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like ,[%o p=(map ,@t json)])`

Source
------

      ++  obox  (stag %o (cook mo obje))

Examples
--------

    ~zod/try=> (rash '{"ham": 2, "lam":true}' obox:poja)
    [%o {[p='lam' q=[%b p=%.y]] [p='ham' q=[%n p=~.2]]}]

JSON Booleans
-------------

### `++bool`

Parse boolean

Parsing rule. Parses a string of either `true` or `false` to a
[`++json`]() boolean.


Accepts
-------

A [`++nail`]().

Produces
--------


A `(like ,[%b p=?])`

Source
------

      ++  bool  ;~(pose (cold & (jest 'true')) (cold | (jest 'false')))

Examples
--------

    ~zod/try=> (rash 'true' bool:poja)
    %.y
    ~zod/try=> (rash 'false' bool:poja)
    %.n
    ~zod/try=> (rash 'null' bool:poja)
    ! {1 1}
    ! exit

JSON strings
------------

### `++stri`

Parse string

Parsing rule. Parse a string to a [`++cord`](). A JSON string is a list
of characters enclosed in double quotes along with escaping `\`s, to a
[`++cord`](). See also [`++jcha`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like ,[%s p=@t])`.

Source
------

      ++  stri
        (cook crip (ifix [doq doq] (star jcha)))

Examples
--------

    ~zod/try=> (rash '"ham"' stri:poja)
    'ham'
    ~zod/try=> (rash '"h\\nam"' stri:poja)
    'h
      am'
    ~zod/try=> (rash '"This be \\"quoted\\""' stri:poja)
    'This be "quoted"'

### `++jcha`

Parse char from string

Parsing rule. Parses either a literal or escaped character from a JSON
string to a [`++cord`]().


Accepts
-------

A [`++nail`]().

Produces
--------

A `(like cord)`.

Source
------

     ++  jcha  ;~(pose ;~(less doq bas prn) esca)           :: character in string

Examples
--------

    ~zod/try=> (rash 'a' jcha:poja)
    'a'.
    ~zod/try=> (rash '!' jcha:poja)
    '!'
    ~zod/try=> (rash '\\"' jcha:poja)
    '"'
    ~zod/try=> (rash '\\u00a4' jcha:poja)
    '¤'
    ~zod/try=> (rash '\\n' jcha:poja)
    '
     '

### `++esca`

Parse escaped char

Parsing rule. Parses a backslash-escaped special character, low ASCII,
or UTF16 codepoint, to a [`++cord`]().


Accepts
-------

A [`++nail`]().

Produces
--------

A `(like cord)`.

Source
------

      ++  esca                                               :: Escaped character
        ;~  pfix  bas
          ;~  pose
            doq  fas  soq  bas
            (sear ~(get by `(map ,@t ,@)`(mo b/8 t/9 n/10 f/12 r/13 ~)) low)
            ;~(pfix (just 'u') (cook tuft qix:ab))           :: 4-digit hex to UTF-8
          ==

Examples
--------

    ~zod/try=> (rash 'b' esca:poja)
    ! {1 1}
    ! exit
    ~zod/try=> (rash '\n' esca:poja)
    ~ <syntax error at [1 9]>
    ~zod/try=> (rash '\\n' esca:poja)
    '
     '
    ~zod/try=> `@`(rash '\\r' esca:poja)
    13
    ~zod/try=> (rash '\\u00c4' esca:poja)
    'Ä'
    ~zod/try=> (rash '\\u00df' esca:poja)
    'ß'

JSON numbers
------------

A JSON numbers are stored as cords internally in lieu of full float
support, so ++numb and subarms are really more *validators* than parsers
per se.

### `++numb`

Parse number

Parsing rule. Parses decimal numbers with an optional `-`, fractional
part, or exponent part, to a [`++tape`]().

Accepts
-------

A [`++nail`]().

Produces
--------

An [`++edge`]() of a [`++tape`]().

Source
------

      ++  numb
        ;~  (comp twel)
          (mayb (piec hep))
          ;~  pose
            (piec (just '0'))
            ;~(plug (shim '1' '9') digs)
          ==
          (mayb frac)
          (mayb expo)
        ==

Examples
--------

    ~zod/try=> (rash '0' numb:poja)
    ~[~~0]
    ~zod/try=> (rash '1' numb:poja)
    ~[~~1]
    ~zod/try=> `tape`(rash '1' numb:poja)
    "1"
    ~zod/try=> `tape`(rash '12.6' numb:poja)
    "12.6"
    ~zod/try=> `tape`(rash '-2e20' numb:poja)
    "-2e20"
    ~zod/try=> `tape`(rash '00e20' numb:poja)
    ! {1 2}
    ! exit

### `++digs`

Parse 1-9

Parsing rule. Parses digits `0` through `9` to a [`++tape`]().

Accepts
-------

A [`++nail`]().

Produces
--------

The [`++edge`]() of a `++tape`.

Source
------

      ++  digs  (star (shim '0' '9'))

Examples
--------

    ~zod/try=> (rash '' digs:poja)
    ""
    ~zod/try=> (rash '25' digs:poja)
    "25"
    ~zod/try=> (rash '016' digs:poja)
    "016"
    ~zod/try=> (rash '7' digs:poja)
    "7"

### `++expo`

Parse exponent part

Parsing rule. Parses an exponent to a [`++tape`]() .An exponent is an
`e` or 'E', followed by an optional `+` or `-`, and then by digits.

Accepts
-------

A [`++nail`]().

Produces
--------

The [`++edge`]() of a `++tape`.

Source
------

      ++  expo                                               :: Exponent part
        ;~  (comp twel)
          (piec (mask "eE"))
          (mayb (piec (mask "+-")))
          digs
        ==

Examples
--------

    ~zod/try=> `tape`(rash 'e7' expo:poja)
    "e7"
    ~zod/try=> `tape`(rash 'E17' expo:poja)
    "E17"
    ~zod/try=> `tape`(rash 'E-4' expo:poja)
    "E-4"

### `++frac`

Fractional part

Parsing rule. Parses a dot followed by digits to a [`++cord`]().

Accepts
-------

A `++nail`.

Produces
--------

The [`++edge`]() of a `++tape`.

Source
------

      ++  frac   ;~(plug dot digs)                          :: Fractional part

Examples
--------

    ~zod/try=> (rash '.25' frac:poja)
    [~~~. "25"]
    ~zod/try=> (rash '.016' frac:poja)
    [~~~. "016"]
    ~zod/try=> (rash '.7' frac:poja)
    [~~~. "7"]

whitespace
----------

### `++spac`

Parse whitespace

Parsing rule. Parses a whitespace to a [`++tape`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like tape)`.

Source
------

      ++  spac  (star (mask [`@`9 `@`10 `@`13 ' ' ~]))

Examples
--------

    ~zod/try=> (scan "" spac:poja)
    ""
    ~zod/try=> (scan "   " spac:poja)
    "   "
    ~zod/try=> `*`(scan `tape`~[' ' ' ' ' ' `@`9 ' ' ' ' `@`13] spac:poja)
    [32 32 32 9 32 32 13 0]
    ~zod/try=> (scan "   m " spac:poja)
    ! {1 4}
    ! exit

### `++ws`

Allow prefix whitespace

Parser modifier. Produces a rule that allows for a whitespace before
applying `sef`.

Accepts
-------

`sef` is a [`++rule`]().

Produces
--------

A `++rule`.

Source
------

      ++  ws  |*(sef=_rule ;~(pfix spac sef))

Examples
--------

    ~zod/try=> (rash '   4' digs:poja)
    ! {1 1}
    ! exit
    ~zod/try=> (rash '   4' (ws digs):poja)
    "4"
    ~zod/try=> (rash '''
                     
                     4
                     ''' (ws digs):poja)
    "4"

Plumbing
--------

### `++mayb`

Maybe parse

Parser modifier. Need to document, an example showing failure.

Accepts
-------

XX

Produces
--------

XX

Source
------

      ++  mayb  |*(bus=_rule ;~(pose bus (easy "")))

Examples
--------

    ~zod/try=> (abox:poja 1^1 "not-an-array")
    [p=[p=1 q=1] q=~]
    ~zod/try=> ((mayb abox):poja 1^1 "not-an-array")
    [p=[p=1 q=1] q=[~ [p="" q=[p=[p=1 q=1] q="not-an-array"]]]]

### `++twel`

Weld two tapes

Concatenates two tapes, `a` and `b`, producing a [`++tape`]().

Accepts
-------

`a` is a [`++tape`]().

`b` is a [`++tape`]().

Produces
--------

The [`++edge`]() of a `++tape`.

Source
------

      ++  twel  |=([a=tape b=tape] (weld a b))

Examples
--------

    ~zod/try=> (twel "sam" "hok"):poja
    ~[~~s ~~a ~~m ~~h ~~o ~~k]
    ~zod/try=> (twel "kre" ""):poja
    ~[~~k ~~r ~~e]

### `++piec`

Parse char to list

Parser modifer. Parses an atom with `bus` and then wraps it in a
[`++list`]().

Accepts
-------

`bus` is a [`++rule`]().

Produces
--------

A `++rule`.

Source
------

      ++  piec
        |*  bus=_rule
        (cook |=(a=@ [a ~]) bus)
    ::

Examples
--------

    d~zod/try=> (scan "4" (piec:poja dem:ag))
    [4 ~]

### `++pojo`

Print JSON

Renders a [`++json`]() `val` as a [`++tape`]().

Accepts
-------

`val` is a [`json`]().

Produces
--------

A `++tape`.

Source
------

    ++  pojo                                                ::  print json
      |=  val=json
      ^-  tape
      ?~  val  "null"
      ?-    -.val
          %a
        ;:  weld
          "["
          =|  rez=tape
          |-  ^+  rez
          ?~  p.val  rez
          $(p.val t.p.val, rez :(weld rez ^$(val i.p.val) ?~(t.p.val ~ ",")))
          "]"
        ==
     ::
          %b  ?:(p.val "true" "false")
          %n  (trip p.val)
          %s
        ;:  welp
          "\""
          %+  reel
            (turn (trip p.val) jesc)
          |=([p=tape q=tape] (welp +<))
          "\""
        ==
          %o
        ;:  welp
          "\{"
          =+  viz=(~(tap by p.val) ~)
          =|  rez=tape
          |-  ^+  rez
          ?~  viz  rez
          %=    $
              viz  t.viz
              rez
            :(welp rez "\"" (trip p.i.viz) "\":" ^$(val q.i.viz) ?~(t.viz ~ ","))
          ==
          "}"
        ==
      ==
    ::

Examples
--------

    ~zod/try=> (pojo [%n '12.6'])
    "12.6"
    ~zod/try=> (crip (pojo %n '12.6'))
    '12.6'
    ~zod/try=> (crip (pojo %s 'samtel'))
    '"samtel"'
    ~zod/try=> (crip (pojo %a ~[(jone 12) (jape "ha")]))
    '[12,"ha"]'
    ~zod/try=> (crip (pojo %a ~[(jone 12) ~ (jape "ha")]))
    '[12,null,"ha"]'
    ~zod/try=> (crip (pojo %o (mo sale/(jone 12) same/b/| ~)))
    '{"same":false,"sale":12}'

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

------------------------------------------------------------------------

### `++poxa`

Parse XML

Parses an XML node from a [`++cord`](), producing a [`++unit`]() [`++manx`]().

Accepts
-------

`a` is a [`++cord`]().

Produces
--------

A `(unit manx)`.

Source
------

    ++  poxa                                                ::  xml parser
      =<  |=(a=cord (rush a apex))
      |%

Examples
--------

    ~zod/try=> (poxa '<div />')
    [~ [g=[n=%div a=~] c=~]]
    ~zod/try=> (poxa '<html><head/> <body/></html>')
    [~ [g=[n=%html a=~] c=~[[g=[n=%head a=~] c=~] [g=[n=%body a=~] c=~]]]]
    ~zod/try=> (poxa '<script src="/gep/hart.js"/>')
    [~ [g=[n=%script a=~[[n=%src v="/gep/hart.js"]]] c=~]]
    ~zod/try=> (poxa '<<<<')
    ~

### `++apex`

Top level parser

Parses a node of XML, type [`++manx`]().

Accepts
-------

A [`++nail`]().

Produces
--------

A `++manx`.

Source
------

      ++  apex
        =+  spa=;~(pose comt whit)
        %+  knee  *manx  |.  ~+
        %+  ifix  [(star spa) (star spa)]
        ;~  pose
          %+  sear  |=([a=marx b=marl c=mane] ?.(=(c n.a) ~ (some [a b])))
            ;~(plug head (more (star comt) ;~(pose apex chrd)) tail)
          empt
        == 
      :: 

Examples
--------

    ~zod/try=> (rash '<div />' apex:poxa)
    [g=[n=%div a=~] c=~]
    ~zod/try=> (rash '<html><head/> <body/></html>' apex:poxa)
    [g=[n=%html a=~] c=~[[g=[n=%head a=~] c=~] [g=[n=%body a=~] c=~]]]
    ~zod/try=> (rash '<script src="/gep/hart.js"/>' apex:poxa)
    [g=[n=%script a=~[[n=%src v="/gep/hart.js"]]] c=~]
    ~zod/try=> (rash '<<<<' apex:poxa)
    ! {1 2}
    ! exit

### `++attr`

Parse XML attributes

Parses the list of attributes inside the opening XML tag, which is zero
or more space-prefixed name to string values.

Accepts
-------

A [`++nail`]().

Produces
--------

A [`++mart`]().

Source
------

      ++  attr                                              ::  attributes
        %+  knee  *mart  |.  ~+ 
        %-  star
        ;~  plug
            ;~(sfix name tis)
            ;~  pose 
                (ifix [doq doq] (star ;~(less doq escp)))
                (ifix [soq soq] (star ;~(less soq escp)))
            ==
          ==  
      ::

Examples
--------

    ~zod/try=> (rash '' attr:poxa)
    ~
    ~zod/try=> (rash 'sam=""' attr:poxa)
    ! {1 1}
    ! exit
    ~zod/try=> (rash ' sam=""' attr:poxa)
    ~[[n=%sam v=""]]
    ~zod/try=> (rash ' sam="hek"' attr:poxa)
    ~[[n=%sam v="hek"]]
    ~zod/try=> (rash ' sam="hek" res="actor"' attr:poxa)
    ~[[n=%sam v="hek"] [n=%res v="actor"]]
    ~zod/try=> (rash ' sam=\'hek\' res="actor"' attr:poxa)
    ~[[n=%sam v="hek"] [n=%res v="actor"]]
    ~zod/try=> (rash ' sam=\'hek" res="actor"' attr:poxa)
    ! {1 23}
    ! exit

### `++chrd`

Parse character data

Parsing rule. Parses XML character data.

Accepts
-------

A [`++nail`]().

Produces
--------

A [`++mars`]().

Source
------

      ++  chrd                                              ::  character data
        %+  cook  |=(a=tape ^-(mars :/(a)))
        (plus ;~(less soq doq ;~(pose (just `@`10) escp)))
      ::

Examples
--------

    ~zod/try=> (rash 'asa' chrd:poxa)
    [g=[n=%$ a=~[[n=%$ v="asa"]]] c=~]
    ~zod/try=> (rash 'asa &gt; are' chrd:poxa)
    [g=[n=%$ a=~[[n=%$ v="asa > are"]]] c=~]
    ~zod/try=> (rash 'asa > are' chrd:poxa)
    ! {1 6}
    ! exit

### `++comt`

Parses comments

Parsing rule. Parses XML comment blocks.

Accepts
-------

A [`++nail`]().

Produces
--------

A [`++like`]().

Source
------

      ++  comt                                              ::  comments 
        =-  (ifix [(jest '<!--') (jest '-->')] (star -))
        ;~  pose 
          ;~(less hep prn) 
          whit
          ;~(less (jest '-->') hep)
        ==
      ::
A [`++unit`]() of.

Examples
--------

    ~zod/try=> (rash '<!--  bye -->' comt:poxa)
    "  bye "
    ~zod/try=> (rash '<!--  bye  ><<<>< - - -->' comt:poxa)
    "  bye  ><<<>< - - "
    ~zod/try=> (rash '<!--  invalid -->-->' comt:poxa)
    ! {1 18}
    ! exit

### `++escp`

Parse (possibly) escaped char

Parsing rule. Parses a nonspecial or escaped character. Result type
[`++char`]()

Accepts
-------

A [`++nail`]().

Produces
--------

The [`++edge`]() of a [`++cord`]().

Source
------

      ++  escp
        ;~  pose
          ;~(less gal gar pam prn)
          (cold '>' (jest '&gt;'))
          (cold '<' (jest '&lt;'))
          (cold '&' (jest '&amp;'))
          (cold '"' (jest '&quot;'))
          (cold '\'' (jest '&apos;'))
        ==

Examples
--------

    ~zod/try=> (rash 'a' escp:poxa)
    'a'
    ~zod/try=> (rash 'ab' escp:poxa)
    ! {1 2}
    ! exit
    ~zod/try=> (rash '.' escp:poxa)
    '.'
    ~zod/try=> (rash '!' escp:poxa)
    '!'
    ~zod/try=> (rash '>' escp:poxa)
    ! {1 2}
    ! exit
    ~zod/try=> (rash '&gt;' escp:poxa)
    '>'
    ~zod/try=> (rash '&quot;' escp:poxa)
    '"'

### `++empt`

Parse self-closing tag

Parsing rule. Parses self-closing XML tags that end in `/>`.

Accepts
-------

A [`++nail`]().

Produces
--------


A `(like tape)`.

Source
------

      ++  empt                                              ::  self-closing tag
        %+  ifix  [gal (jest '/>')]  
        ;~(plug ;~(plug name attr) (cold ~ (star whit)))  
      ::

Examples
--------

    ~zod/try=> (rash '<div/>' empt:poxa)
    [[%div ~] ~]
    ~zod/try=> (rash '<pre color="#eeffee" />' empt:poxa)
    [[%pre ~[[n=%color v="#eeffee"]]] ~]
    ~zod/try=> (rash '<pre color="#eeffee"></pre>' empt:poxa)
    ! {1 21}
    ! exit

### `++head`

Parse opening tag

Parsing rule. Parses the opening tag of an XML node. Result type
[`++marx`]()

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like marx)`.

Source
------

      ++  head                                              ::  opening tag
        (ifix [gal gar] ;~(plug name attr))
      ::

Examples
--------

    ~zod/try=> (rash '<a>' head:poxa)
    [n=%a a=~]
    ~zod/try=> (rash '<div mal="tok">' head:poxa)
    [n=%div a=~[[n=%mal v="tok"]]]
    ~zod/try=> (rash '<div mal="tok" />' head:poxa)
    ! {1 16}
    ! exit

### `++name`

Parse tag name

Parsing rule. Parses the name of an XML tag.

Accepts
-------

A [`++nail`]().

Produces
--------

An [`++edge`]() of a [`++mane`]().

Source
------

      ++  name                                              ::  tag name 
        %+  knee  *mane  |.  ~+
        =+  ^=  chx
            %+  cook  crip 
            ;~  plug 
                ;~(pose cab alf) 
                (star ;~(pose cab dot alp))
            ==
        ;~(pose ;~(plug ;~(sfix chx col) chx) chx)
      ::

Examples
--------

    ~zod/try=> (scan "ham" name:poxa)
    %ham
    ~zod/try=> (scan "ham:tor" name:poxa)
    [%ham %tor]
    ~zod/try=> (scan "ham-tor" name:poxa)
    %ham-tor
    ~zod/try=> (scan "ham tor" name:poxa)
    ! {1 4}
    ! exit

### `++tail`

Parse closing tag

Parsing rule. Parses an XML closing tag.

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like tail)`.

Source
------

      ++  tail  (ifix [(jest '</') gar] name)               ::  closing tag

Examples
--------

    ~zod/try=> (scan "</div>" tail:poxa)
    %div
    ~zod/try=> (scan "</a>" tail:poxa)
    %a
    ~zod/try=> (scan "</>" tail:poxa)
    ! {1 3}
    ! exit

### `++whit`

Parse whitespace, etc.

Parsing rule. Parses newlines, tabs, and spaces.

Accepts
-------

A [`++nail`]().

Produces
--------

A `(like char)`.

Source
------

      ++  whit  (mask ~[' ' `@`0x9 `@`0xa])                 ::  whitespace
    ::

Examples
--------

    ~zod/try=> `@`(scan " " whit:poxa)
    32
    ~zod/try=> `@`(scan "  " whit:poxa)
    ! {1 2}
    ! exit
    ~zod/try=> `@`(scan "\0a" whit:poxa)
    10
    ~zod/try=> `@`(scan "\09" whit:poxa)
    9
    ~zod/try=> `@`(scan "\08" whit:poxa)
    ! {1 1}
    ! exit

### `++jo`

JSON reparsing core

Contains converters of [`++json`]() to [`++unit`]()s of well-typed structures.

Accepts
-------

A `fist` is a gate that produces a `grub`.

A `grub` is a unit of some JSON value.

Source
------

    ++  jo                                                  ::  json reparser
      =>  |%  ++  grub  (unit ,*) 
              ++  fist  $+(json grub)
      |%


### `++ar`

Parse array to list

Reparser modifier. Reparses an array to the [`++unit`]() of a homogenous
[`++list`]() using `wit` to reparse every element.

`wit` is a [`++fist`](), a JSON reparser.


Accepts
-------

A [`++fist`]().

Produces
--------

A [`++rule`]().

Source
------
      ++  ar                                                ::  array as list
        |*  wit=fist
        |=  jon=json
        ?.  ?=([%a *] jon)  ~
        %-  zl
        |-  
        ?~  p.jon  ~
        [i=(wit i.p.jon) t=$(p.jon t.p.jon)]
      ::

Examples
--------

    ~zod/try=> :type; ((ar ni):jo a/~[n/'1' n/'2'])
    [~ u=~[1 2]]
    {[%~ u=it(@)] %~}


### `++at`

Reparse array as tuple

Reparser generator. Reparses an array as a fixed-length tuple of
[`++unit`]()s, using a list of `++fist`s.

Accepts
-------

`wil` is a [`++pole`](), a [`face`]()less list of [`++fist`]()s.

Produces
--------

A [`++rule`]().

Source
------

      ++  at                                                ::  array as tuple
        |*  wil=(pole fist)
        |=  jon=json
        ?.  ?=([%a *] jon)  ~
        =+  raw=((at-raw wil) p.jon)
        ?.((za raw) ~ (some (zp raw)))
      ::

Examples
--------

    ~zod/try=> ((at ni so ni ~):jo a/~[n/'3' s/'to' n/'4'])
    [~ u=[q=3 ~.to q=4]]
    ~zod/try=> :type; ((at ni so ni ~):jo a/~[n/'3' s/'to' n/'4'])
    [~ u=[q=3 ~.to q=4]]
    {{[%~ u=[q=@ @ta q=@]] %~} %~}
    ~zod/try=> ((at ni so ni ~):jo a/~[n/'3' s/'to' n/''])
    ~

### `++at-raw`

Reparse array to tuple

Reparser generator. Reparses a list of [`++json`]() with `wil` to a tuple of [`++unit`]()s.

Accepts
-------

`wil` is a [`++pole`](), a [face]()less list of [`++fist`]()s.

Produces
--------

A [`++rule`]().

Source
------

        ++  at-raw                                            ::  array as tuple
        |*  wil=(pole fist)
        |=  jol=(list json)
        ?~  wil  ~
        :-  ?~(jol ~ (-.wil i.jol))
        ((at-raw +.wil) ?~(jol ~ t.jol))
      ::

Examples
--------

    ~zod/try=> ((at-raw ni ni bo ~):jo ~[s/'hi' n/'1' b/&])
    [~ [~ 1] [~ u=%.y] ~]

### `++bo`

Reparse boolean

Reparser modifier. Reparses a boolean to the [`++unit`]() of a
boolean.

Accepts
-------

A [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  bo                                                ::  boolean
        |=(jon=json ?.(?=([%b *] jon) ~ [~ u=p.jon]))
      ::

Examples
--------

    ~zod/try=> (bo:jo [%b &])
    [~ u=%.y]
    ~zod/try=> (bo:jo [%b |])
    [~ u=%.n]
    ~zod/try=> (bo:jo [%s 'hi'])
    ~

### `++bu`

Reparse boolean not

Reparser modifier. Reparses the inverse of a boolean to the [`++unit`]()
of a loobean.


Accepts
-------

A [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  bu                                                ::  boolean not
        |=(jon=json ?.(?=([%b *] jon) ~ [~ u=!p.jon]))
      ::

Examples
--------

    ~zod/try=> (bu:jo [%b &])
    [~ u=%.n]
    ~zod/try=> (bu:jo [%b |])
    [~ u=%.y]
    ~zod/try=> (bu:jo [%s 'hi'])
    ~

### `++cu`

Reparse and transform

Reparser modifier. Reparses `jon` and slams the result through `wit`,
producing a [`++unit`]().

Accepts
-------

`wit` is a [`++fist`]().

`poq` is a [`gate`]() that accepts and returns a [noun]().

Produces
--------

A [`++fist`]().

Source
------

      ++  cu                                                ::  transform
        |*  [poq=$+(* *) wit=fist]
        |=  jon=json
        (bind (wit jon) poq)
      ::

Examples
--------

    ~zod/try=> ((cu dec ni):jo [%n '20'])
    [~ 19]
    ~zod/try=> ((cu dec ni):jo [%b &])
    ~

### `++da`

Reparse UTC date

Reparser modifier. Reparses a UTC date string to a [`++unit`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  da                                                ::  UTC date
        |=  jon=json
        ?.  ?=([%s *] jon)  ~
        (bind (stud (trip p.jon)) |=(a=date (year a)))
      ::

Examples
--------

    ~zod/try=> (da:jo [%s 'Wed, 29 Oct 2014 0:26:15 +0000'])
    [~ ~2014.10.29..00.26.15]
    ~zod/try=> (da:jo [%s 'Wed, 29 Oct 2012 0:26:15'])
    [~ ~2012.10.29..00.26.15]
    ~zod/try=> (da:jo [%n '20'])
    ~

### `++di`

Reparse millisecond date

Reparser modifier. Reparses the javascript millisecond date integer to a
[`++unit`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  di                                                ::  millisecond date
        |=  jon=json
        %+  bind  (ni jon)
        |=  a=@u  ^-  @da
        (add ~1970.1.1 (div (mul ~s1 a) 1.000))
      ::

Examples
--------

    ~zod/try=> (di:jo [%s '2014-10-29'])
    ~
    ~zod/try=> (di:jo [%n '1414545548325'])
    [~ ~2014.10.29..01.19.08..5333.3333.3333.3333]
    ~zod/try=> (di:jo [%n '1414545615128'])
    [~ ~2014.10.29..01.20.15..20c4.9ba5.e353.f7ce]
    ~zod/try=> (di:jo [%n '25000'])
    [~ ~1970.1.1..00.00.25]

### `++mu`

Reparse unit

Reparser modifier. Reparses `wit` to a [`++unit`]().

JSON units are considered to be either JSON null or the requested
value, and are reparsed to results of \~ or (some {value}) respectively.

Accepts
-------

`wit` is a [`++fist`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  mu                                                ::  true unit
        |*  wit=fist
        |=  jon=json
        ?~(jon (some ~) (bind (wit jon) some))
      ::

Examples
--------

    ~zod/try=> ((mu ni):jo [%n '20'])
    [~ [~ u=q=20]]
    ~zod/try=> ((mu ni):jo [%n '15'])
    [~ [~ u=q=15]]
    ~zod/try=> ((mu ni):jo ~)
    [~ u=~]
    ~zod/try=> ((mu ni):jo [%s 'ma'])
    ~

### `++ne`

Reparse number as real

XX Currently unimplemented

A- yup, this will eventually reparse a floating point atom, but
interfaces for the latter are not currently stable.

### `++ni`

Reparse number as integer

Reparser modifier. Reparses an integer representation to a [`++unit]().

Accepts
-------

`jon` is a ++[`++json`]().

Produces
--------

The `++unit` of an atom.

Source
------

      ++  ni                                                ::  number as integer
        |=  jon=json 
        ?.  ?=([%n *] jon)  ~
        (rush p.jon dem)
      ::

Examples
--------

    ~zod/try=> (ni:jo [%n '0'])
    [~ q=0]
    ~zod/try=> (ni:jo [%n '200'])
    [~ q=200]
    ~zod/try=> (ni:jo [%n '-2.5'])
    ~
    ~zod/try=> (ni:jo [%s '10'])
    ~
    ~zod/try=> (ni:jo [%b |])
    ~
    ~zod/try=> (ni:jo [%n '4'])
    [~ q=4]
    ~zod/try=> (ni:jo [%a ~[b/& b/& b/& b/&]])
    ~

### `++no`

Reparse number as text

Reparser modifier. Reparses a numeric representation to a [++cord]().

Accepts
-------

`jon` is a `++json`.

Produces
--------

The [`++unit`]() of a `++cord`.

Source
------

      ++  no                                                ::  number as text
        |=  jon=json
        ?.  ?=([%n *] jon)  ~
        (some p.jon)
      ::

Examples
--------

    ~zod/try=> (no:jo [%n '0'])
    [~ u=~.0]
    ~zod/try=> (no:jo [%n '200'])
    [~ u=~.200]
    ~zod/try=> (no:jo [%n '-2.5'])
    [~ u=~.-2.5]
    ~zod/try=> (no:jo [%s '10'])
    ~
    ~zod/try=> (no:jo [%b |])
    ~
    ~zod/try=> (no:jo [%n '4'])
    [~ u=~.4]
    ~zod/try=> (no:jo [%a ~[b/& b/& b/& b/&]])
    ~

### `++of`

Reparse object to frond

Reparser generator. Reparses an object, succeeding if it corresponds to
one of the key-value pairs in `wer`.

Accepts
-------

`wer` is a [`++pole`](), a [`++face`]()less list of [`++cord`]() and
[`++fist`]() key-value pairs.

Produces
--------

The [`++unit`]() of a cell of a.....

Source
------

      ++  of                                                ::  object as frond
        |*  wer=(pole ,[cord fist])
        |=  jon=json
        ?.  ?=([%o [@ *] ~ ~] jon)  ~
        |-
        ?~  wer  ~
        ?:  =(-.-.wer p.n.p.jon)  
          ((pe -.-.wer +.-.wer) q.n.p.jon)
        ((of +.wer) jon)
      ::

Examples
--------

    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'hi'] ~ ~)
    [~ [%sem "hi"]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som n/'20'] ~ ~)
    [~ [%som q=20]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som s/'he'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som s/'5'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'5'] ~ ~)
    [~ [%sem "5"]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem n/'2'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem b/&] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %a ~[s/'som' n/'4'])
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'hey'] ~ [%sam s/'other value'] ~ ~)
    ~

### `++ot`

Reparse object as tuple

Reparser generator. For every key in `wer` that matches a key in the
[`++edge`], the fist in `wer` is applied to the corresponding value in
the [`++edge`](), the results of which are produced in a tuple.


Accepts
-------

`wer` is a [`++pole`]() of [`++cord`]() to [`++fist`]() key-value pairs.

Produces
--------

A [`++unit`]() of a tuple XX?

Source
------

      ++  ot                                                ::  object as tuple
        |*  wer=(pole ,[cord fist])
        |=  jon=json
        ?.  ?=([%o *] jon)  ~
        =+  raw=((ot-raw wer) p.jon)
        ?.((za raw) ~ (some (zp raw)))
      ::

Examples
--------

    ~zod/try=> (jobe [%sem s/'ha'] [%som n/'20'] ~)
    [%o p={[p='sem' q=[%s p=~.ha]] [p='som' q=[%n p=~.20]]}]
    ~zod/try=> ((ot sem/sa som/ni sem/sa ~):jo (jobe [%sem s/'ha'] [%som n/'20'] ~))
    [~ u=["ha" q=20 "ha"]]

### `++ot-raw`

Reparser generator. Reparses a map `jom` using `wer`; for every key in
`wer` that matches a key in `map`, the corresponding `++fist` is applied
to the corresponding value in `jom`, the results of which are produced
in a tuple.


Accepts
-------

`wer` is a [`++pole`]() of [`++cord`]() to [`++fist`]() key-value pairs.

Produces
--------

A [`++unit`]() of.

Source
------

        ++  ot-raw                                            ::  object as tuple
        |*  wer=(pole ,[cord fist])
        |=  jom=(map ,@t json)
        ?~  wer  ~
        =+  ten=(~(get by jom) -.-.wer)
        [?~(ten ~ (+.-.wer u.ten)) ((ot-raw +.wer) jom)]
        ::

Examples
--------

    ~zod/try=> ((ot-raw sem/sa som/ni sem/sa ~):jo (mo [%sem s/'ha'] [%som n/'20'] ~))
    [[~ u="ha"] [~ q=20] [~ u="ha"] ~]
    ~zod/try=> ((ot-raw sem/sa som/ni sem/sa ~):jo (mo [%sem s/'ha'] [%som b/|] ~))
    [[~ u="ha"] ~ [~ u="ha"] ~]

### `++om`

Parse object to map

Reparser modifier. Reparses a [`++json`]() object to a homogenous map
using `wit`.

Accepts
-------

`wit` is a [`++fist`]().

Produces
--------

A [`++unit`]() of...

Source
------

        ++  om                                                ::  object as map
        |*  wit=fist
        |=  jon=json
        ?.  ?=([%o *] jon)  ~
        (zm ~(run by p.jon) wit)
      ::

Examples
--------

    ~zod/try=> ((om ni):jo (jobe [%sap n/'20'] [%sup n/'5'] [%sop n/'177'] ~))
    [~ {[p='sup' q=q=5] [p='sop' q=q=177] [p='sap' q=q=20]}]
    ~zod/try=> ((om ni):jo (jobe [%sap n/'20'] [%sup n/'0x5'] [%sop n/'177'] ~))
    ~    

### `++pe`

Add prefix

Reparser modifier. Adds a static prefix `pre` to the parse result of
`wit`. See also: [`++stag`]().

Accepts
-------

`pre` is a prefix [`noun`]().

Produces
--------

The [`++unit`]() of a cell of [noun]() and the result of parsing `wit`.

Source
------

      ++  pe                                                ::  prefix
        |*  [pre=* wit=fist]
        (cu |*(a=* [pre a]) wit)
      ::

Examples
--------

    ~zod/try=> (ni:jo n/'2')
    [~ q=2]
    ~zod/try=> (ni:jo b/|)
    ~
    ~zod/try=> ((pe %hi ni):jo n/'2')
    [~ [%hi q=2]]
    ~zod/try=> ((pe %hi ni):jo b/|)
    ~

### `++sa`

Reparse string to tape

Reparser modifier. Reparses a [`++json`]() string to a [`++tape`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of a [`++tape`]().

Source
------

      ++  sa                                                ::  string as tape
        |=  jon=json
        ?.(?=([%s *] jon) ~ (some (trip p.jon)))
      ::

Examples
--------

    ~zod/try=> (sa:jo s/'value')
    [~ u="value"]
    ~zod/try=> (sa:jo n/'46')
    ~
    ~zod/try=> (sa:jo a/~[s/'val 2'])
    ~

### `++so`

Reparse string to cord

Reparser modifier. Reparses a string to a [`++cord`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of a [`++cord`]().

Source
------

      ++  so                                                ::  string as cord
        |=  jon=json
        ?.(?=([%s *] jon) ~ (some p.jon))
      ::

Examples
--------

    ~zod/try=> (so:jo s/'value')
    [~ u=~.value]
    ~zod/try=> (so:jo n/'46')
    ~
    ~zod/try=> (so:jo a/~[s/'val 2'])
    ~

### `++su`

Reparse string

Reparser generator. Produces a reparser that applies `sab` to a string.

Accepts
-------

`sab` is a [`++rule`].

Produces
--------

A [`++rule`]().

Source
------

      ++  su                                                ::  parse string
        |*  sab=rule
        |=  jon=json
        ?.  ?=([%s *] jon)  ~
        (rush p.jon sab)
      ::

Examples
--------

    ~zod/try=> ((su:jo fed:ag) s/'zod')
    [~ 0]
    ~zod/try=> ((su:jo fed:ag) s/'doznec')
    [~ 256]
    ~zod/try=> ((su:jo fed:ag) s/'notship')
    ~
    ~zod/try=> ((su:jo fed:ag) n/'20')
    ~

### `++ul`

Reparse null

Reparser modifier. Reparses a null value.

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of null.

Source
------

      ++  ul  |=(jon=json ?~(jon (some ~) ~))               ::  null

Examples
--------

    ~zod/try=> (ul:jo `json`~)
    [~ u=~]
    ~zod/try=> (ul:jo s/'null')
    ~
    ~zod/try=> (ul:jo b/|)
    ~
    ~zod/try=> (ul:jo b/&)
    ~

### `++za`

Pole of nonempty units

Determines if `pod` contains all non-empty units, producing a boolean. Used
internally.

Accepts
-------

`pod` is a [`++pole`]() of [`++unit`]().

Produces
--------

A boolean.

Source
------

      ++  za                                                ::  full unit pole
        |*  pod=(pole (unit))
        ?~  pod  &
        ?~  -.pod  |
        (za +.pod)
      ::

Examples
--------

    ~zod/try=> (za:jo ~[`1 `2 `3])
    %.y
    ~zod/try=> (za:jo ~[`1 ~ `3])
    %.n

### `++zl`

Collapse unit list

Produces a unit of the values of `lut` if every unit in `lut` is
nonempty. Otherwise, produces `~`. 

Accepts
-------

`lut` is a [`++list`]() of [`++unit`]()s.

Produces
--------

A boolean.

Source
------

      ++  zl                                                ::  collapse unit list
        |*  lut=(list (unit))
        ?.  |-  ^-  ?
            ?~(lut & ?~(i.lut | $(lut t.lut)))
          ~
        %-  some
        |-
        ?~  lut  ~
        [i=u:+.i.lut t=$(lut t.lut)]
      ::

Examples
--------

    ~zod/try=> (zl:jo `(list (unit))`~[`1 `2 `3])
    [~ u=~[1 2 3]]
    ~zod/try=> (zl:jo `(list (unit))`~[`1 `17 `3])
    [~ u=~[1 17 3]]
    ~zod/try=> (zl:jo `(list (unit))`~[`1 ~ `3])
    ~

### `++zp`

XX

Collapses a `++pole` of `++unit`s `but`, producing a tuple.

Accepts
-------

`but` is a [`++pole`]() of [`++unit`]().

Produces
--------

??

Source
------

      ++  zp                                                ::  unit tuple
        |*  but=(pole (unit))
        ?~  but  !!
        ?~  +.but  
          u:->.but
        [u:->.but (zp +.but)]
      ::

Examples
--------

    ~zod/try=> (zp:jo `(pole (unit))`~[`1 `2 `3])
    [1 2 3]
    ~zod/try=> (zp:jo `(pole (unit))`~[`1 `17 `3])
    [1 17 3]
    ~zod/try=> (zp:jo `(pole (unit))`~[`1 ~ `3])
    ! exit

### `++zm`

Collapse unit map

Produces a [`++unit`]() of the [`++map`]() `lum` of term to `++unit` key value
pairs, with all of the nonempty values stripped of their `++unit`
wrappers. If any of the `++units` in `lum` are empty, `~` is produced.
See also: [`++zp`](), [`++zl`]().

Accepts
-------

`lum` is a map of [`++term`]() to [`++unit`]()s.

Produces
--------

The `++unit` of a tuple of what were the key-value pairs of `lum`.

Source
------

      ++  zm                                                ::  collapse unit map
        |*  lum=(map term (unit))
        ?:  (~(rep by lum) | |=([[@ a=(unit)] b=?] |(b ?=(~ a))))
          ~
        (some (~(run by lum) need))
    ::

Examples
--------

    ~zod/try=> (zm:jo `(map term (unit ,@u))`(mo a/`4 b/`1 c/`2 ~))
    [~ {[p=%a q=4] [p=%c q=2] [p=%b q=1]}]
    ~zod/try=> (zm:jo `(map term (unit ,@u))`(mo a/`4 b/~ c/`2 ~))
    ~
    ~zod/try=> (~(run by `(map ,@t ,@u)`(mo a/1 b/2 c/3 ~)) (flit |=(a=@ (lth a 5))))
    {[p='a' q=[~ u=1]] [p='c' q=[~ u=3]] [p='b' q=[~ u=2]]}
    ~zod/try=> (zm:jo (~(run by `(map ,@t ,@u)`(mo a/1 b/2 c/3 ~)) (flit |=(a=@ (lth a 5)))))
    [~ {[p='a' q=1] [p='c' q=3] [p='b' q=2]}]
    ~zod/try=> (zm:jo (~(run by `(map ,@t ,@u)`(mo a/1 b/7 c/3 ~)) (flit |=(a=@ (lth a 5)))))
    ~
    ~zod/try=> (~(run by `(map ,@t ,@u)`(mo a/1 b/7 c/3 ~)) (flit |=(a=@ (lth a 5))))
    {[p='a' q=[~ u=1]] [p='c' q=[~ u=3]] [p='b' q=~]}

### `++joba`

`++json` from key-value pair

Produces a ++json object with one key-value pair.

Accepts
-------

`p` is a `@t` key.

`q` is a [`++json`]().

Produces
--------

A [`++json`]().

Source
------

    ++  joba                                                ::  object from k-v pair
      |=  [p=@t q=json]
      ^-  json
      [%o [[p q] ~ ~]]
    ::

Examples
--------

    ~zod/try=> (joba %hi %b |)
    [%o p={[p='hi' q=[%b p=%.n]]}]
    ~zod/try=> (crip (pojo (joba %hi %b |)))
    '{"hi":false}'
    ~zod/try=> (joba %hi (jone 2.130))
    [%o p={[p='hi' q=[%n p=~.2130]]}]
    ~zod/try=> (crip (pojo (joba %hi (jone 2.130))))
    '{"hi":2130}'

### `++jobe`

Object from key-value list

Produces a `++json` object from a [`++list`]() `a` of key to `++json` values.

Accepts
-------

`a` is a [`++list`]() of [`++cord`]() to [`++json`]() values.

Produces
--------

A `++json`.

Source
------

    ++  jobe                                                ::  object from k-v list
      |=  a=(list ,[p=@t q=json])
      ^-  json
      [%o (~(gas by *(map ,@t json)) a)]
    ::

Examples
--------

    ~zod/try=> (jobe a/n/'20' b/~ c/a/~[s/'mol'] ~)
    [%o p={[p='a' q=[%n p=~.20]] [p='c' q=[%a p=~[[%s p=~.mol]]]] [p='b' q=~]}]
    ~zod/try=> (crip (pojo (jobe a/n/'20' b/~ c/a/~[s/'mol'] ~)))
    '{"b":null,"c":["mol"],"a":20}'

### `++jape`

`++json` string from tape

Produces a [`++json`]() string from a [`++tape`]().

Accepts
-------

A [`++tape`]().

Produces
--------

A `++json`.

Source
------

    ++  jape                                                ::  string from tape
      |=  a=tape
      ^-  json
      [%s (crip a)]
    ::

Examples
--------

    ~zod/try=> (jape ~)
    [%s p=~.]
    ~zod/try=> (jape "lam")
    [%s p=~.lam]
    ~zod/try=> (crip (pojo (jape "lam")))
    '"lam"'
    ~zod/try=> (crip (pojo (jape "semtek som? zeplo!")))
    '"semtek som? zeplo!"'

### `++jone`

`++json` number from unigned

Produces a `++json` number from an unsigned atom.

Accepts
-------

`a` is an atom of odor [`@u`]().

Produces
--------

A [`++json`]().

Source
------

    ++  jone                                                ::  number from unsigned
      |=  a=@u
      ^-  json
      :-  %n
      ?:  =(0 a)  '0'
      (crip (flop |-(^-(tape ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])))))
    ::

Examples
--------

    ~zod/try=> (jone 1)
    [%n p=~.1]
    ~zod/try=> (pojo (jone 1))
    "1"
    ~zod/try=> (jone 1.203.196)
    [%n p=~.1203196]
    ~zod/try=> (pojo (jone 1.203.196))
    "1203196"

### `++jesc`

Escape JSON character

Produces a [`++tape`]() of an escaped [`++json`](/doc/hoon/library/3bi#++json) character `a`.

Accepts
-------

`a` is an atom of odor [`@tD`](), aka a [`++char`]().

Produces
--------

A [`++tape`]().

Source
------

    ++  jesc
      |=  a=@  ^-  tape
      ?+  a  [a ~]
        10  "\\n"
        34  "\\\""
        92  "\\\\"
      ==
    ::

Examples
--------

    ~zod/try=> (jesc 'a')
    "a"
    ~zod/try=> (jesc 'c')
    "c"
    ~zod/try=> (jesc '\\')
    "\\"
    ~zod/try=> (jesc '"')
    "\""

### `++scanf` XX

Formatted scan

    ++  scanf                                              ::  formatted scan
      |*  [tape (pole ,_:/(*$&(_rule tape)))]
      =>  .(+< [a b]=+<)
      (scan a (parsf b))

Scan with `;"`-interpolated parsers.

A- here there be monsters, monsters of my making. But the basic idea is
you use `;"` (which currently is parsed by sail but shouldn't be) to mix
literal text and [++rule]s, and apply this to text which is a
correspending mixture of aforementioned literals and sections parsable
by the relevant rules. ++parsf is the parser form that combines a
tape-rule mix into one big ++rule, ++norm being a parsf internal that
winnows the `;"` result into a list of discriminate literals and rules,
and ++bill doing the actual composing: ++\$:parsf just adds a layer that
collapses the result list to a tuple, such that (scanf "foo 1 2 bar"
;"foo {dem} {dem} bar") parses [1 2] and not [1 2 \~].

    ~zod/try=> `[p=@ud q=@ud]`(scanf "Score is 5 to 2" [;"Score is {n} to {n}"]:n=dim:ag)
    [p=5 q=2]

    ~zod/try=> =n ;~(pfix (star (just '0')) (cook |=(@ud +<) dim:ag))
    ~zod/try=> (scanf "2014-08-12T23:10:58.931Z" ;"{n}\-{n}\-{n}T{n}:{n}:{n}.{n}Z")
    [2.014 8 12 23 10 58 931]
    ~zod/try=> =dat (scanf "2014-08-12T23:10:58.931Z" ;"{n}\-{n}\-{n}T{n}:{n}:{n}.{n}Z")
    ~zod/try=> `@da`(year `date`dat(- [%& -.dat], |6 ~[(div (mul |6.dat (bex 16)) 1.000)]))
    ~2014.8.12..23.10.58..ee56

### `++parsf` XX

    ++  parsf                                              ::  make parser from:
      |^  |*  a=(pole ,_:/(*$&(_rule tape)))               ::  ;"chars{rule}chars"
          %-  cook  :_  (bill (norm a))
          |*  (list)
          ?~  +<  ~
          ?~  t  i
          [i $(+< t)]
      ::

`parsf` generates a `_rule` from a tape with rules embedded in it,
literal sections being matched verbatim. The parsed type is a tuple of
the embedded rules' results.

Two intermediate arms are used:

#### ++norm XX

      ::  .=  (norm [;"{n}, {n}"]:n=dim:ag)  ~[[& dim] [| ", "] [& dim]]:ag
      ++  norm                                             
        |*  (pole ,_:/(*$&(_rule tape)))
        ?~  +<  ~
        =>  .(+< [i=+<- t=+<+])
        :_  t=$(+< t)
        =+  rul=->->.i
        ^=  i
        ?~  rul     [%| p=rul]
        ?~  +.rul   [%| p=rul]
        ?@  &2.rul  [%| p=;;(tape rul)]
        [%& p=rul]
      ::

`norm` converts a `;"` pole of `[[%~. [%~. ?(tape _rule)] ~] ~]` into a
more convenient list of discriminated tapes and rules.

#### ++bill XX

      ::  .=  (bill ~[[& dim] [| ", "] [& dim]]:ag)
      ::  ;~(plug dim ;~(pfix com ace ;~(plug dim (easy)))):ag
      ++  bill
        |*  (list (each ,_rule tape))
        ?~  +<  (easy ~)
        ?:  ?=(| -.i)  ;~(pfix (jest (crip p.i)) $(+< t))
        %+  cook  |*([* *] [i t]=+<)
        ;~(plug p.i $(+< t))
      --
    ::

`bill` builds a parser out of rules and tapes, ignoring the literal
sections and producing a list of the rules' results.

### `++taco`

Converts an atom to an octet stream [`++octs`](), which contains a length, to
encode trailing zeroes.

Produces
--------

An `++octs`.

Source
------

    ++  taco                                                ::  atom to octstream
      |=  tam=@  ^-  octs
      [(met 3 tam) tam]
    ::

Examples
--------

    ~zod/try=> (taco 'abc')
    [p=3 q=6.513.249]
    ~zod/try=> `@t`6.513.249
    'abc'

### `++tact`

tape to octs

Converts a `++tape` to an octet stream ([`++octs`](), which contains a length
to encode trailing zeroes.

Accepts
-------

A `++tape`.

Produces
--------

An [`++octs`]().

Source
------

    ++  tact                                                ::  tape to octstream
      |=  tep=tape  ^-  octs
      (taco (rap 3 tep))
    ::

Examples
--------

    ~zod/try=> (tact "abc")
    [p=3 q=6.513.249]
    ~zod/try=> `@t`6.513.249
    'abc'

### `++tell`

octs from wall

Converts a [`++wall`]() to an octet stream ([`++octs`](), which contains a length
to encode trailing zeroes.

Accepts
-------

`wol` is a [`++wall`]().

Produces
--------

An `++octs`.

Source
------

    ++  tell                                                ::  wall to octstream
      |=  wol=wall  ^-  octs
      =+  buf=(rap 3 (turn wol |=(a=tape (crip (weld a `tape`[`@`10 ~])))))
      [(met 3 buf) buf]
    ::

Examples
--------

    ~zod/try=> (tell ~["abc" "line" "3"])
    [p=11 q=12.330.290.663.108.538.769.039.969]
    ~zod/try=> `@t`12.330.290.663.108.538.769.039.969
    '''
    abc
    line
    3
    '''

### `++txml`

Tape to xml CDATA node

Converts a [`++tape`]() to an xml CDATA node XX

Accepts
-------

`tep` is a [`++tape`]().

Produces
--------

A [`++manx`]().

Source
------

    ++  txml                                                ::  string to xml
      |=  tep=tape  ^-  manx
      [[%$ [%$ tep] ~] ~]
    ::

Examples
--------

    ~zod/try=> (txml "hi")
    [g=[n=%$ a=~[[n=%$ v="hi"]]] c=~]
    ~zod/try=> (txml "larton bestok")
    [
