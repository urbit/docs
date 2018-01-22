---
navhome: /docs/
---


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


