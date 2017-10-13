---
navhome: /docs/
---


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


