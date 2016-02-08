section 2ee, parsing (composers)
================================

### `++bass`

Parser modifier: [LSB](http://en.wikipedia.org/wiki/Least_significant_bit)
ordered [`++list`]() as atom of a [`++base`]().

Accepts
-------

`wuc` is an atom.

`tyd` is a [`++rule`]().

Produces
--------

A [`++rule`]().

Source
------

    ++  bass
      |*  [wuc=@ tyd=_rule]
      %+  cook
        |=  waq=(list ,@)
        %+  roll
          waq
        =|([p=@ q=@] |.((add p (mul wuc q))))
      tyd

Examples
--------
    
    ~zod/try=> (scan "123" (bass 10 (star dit)))
    q=123
    ~zod/try=> (scan "123" (bass 8 (star dit)))
    q=83
    ~zod/try=> `@ub`(scan "123" (bass 8 (star dit)))
    0b101.0011

------------------------------------------------------------------------

### `++boss`

Parser modifier: [LSB](http://en.wikipedia.org/wiki/Least_significant_bit)
ordered [`++list`]() as atom of a [`++base`]().

Accepts
-------

`wuc` is an atom.

`tyd` is a [`++rule`]().

Produces
--------

A [`++rule`]().

Source
------

    ++  boss
      |*  [wuc=@ tyd=_rule]
      %+  cook
        |=  waq=(list ,@)
        %+  reel
          waq
        =|([p=@ q=@] |.((add p (mul wuc q))))
      tyd

Examples
--------
    
    ~zod/try=> (scan "123" (boss 10 (star dit)))
    q=321
    ~zod/try=> `@t`(scan "bam" (boss 256 (star alp)))
    'bam'
    ~zod/try=> `@ux`(scan "bam" (boss 256 (star alp)))
    0x6d.6162

------------------------------------------------------------------------

### `++ifix`

Surround

Parser modifier: surround with pair of [`++rule`]()s, the output of which is
discarded.

Accepts
-------

`fel` is a pair of `++rule`s.

`hof` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  ifix
      |*  [fel=[p=_rule q=_rule] hof=_rule]
      ;~(pfix p.fel ;~(sfix hof q.fel))

Examples
--------
    
    ~zod/try=> (scan "-40-" (ifix [hep hep] dem))
    q=40
    ~zod/try=> (scan "4my4" (ifix [dit dit] (star alf)))
    "my"

------------------------------------------------------------------------

### `++more`

Parse list with delimiter

Parser modifier: Parse a list of matches using a delimiter [`++rule`]().

Accepts
-------

`bus` is a `++rule`.

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  more
      |*  [bus=_rule fel=_rule]
      ;~(pose (most bus fel) (easy ~))

Examples
--------
    
    ~zod/try=> (scan "" (more ace dem))
    ~
    ~zod/try=> (scan "40 20" (more ace dem))
    [q=40 ~[q=20]]
    ~zod/try=> (scan "40 20 60 1 5" (more ace dem))
    [q=40 ~[q=20 q=60 q=1 q=5]]

------------------------------------------------------------------------

### `++most`

Parse list of at least one match

Parser modifier: parse a [`++list`]() of at least one match using a delimiter [`++rule`]().

Accepts
-------

`bus` is a `++rule`.

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  most
      |*  [bus=_rule fel=_rule]
      ;~(plug fel (star ;~(pfix bus fel)))

Examples
--------
    
    ~zod/try=> (scan "40 20" (most ace dem))
    [q=40 ~[q=20]]
    ~zod/try=> (scan "40 20 60 1 5" (most ace dem))
    [q=40 ~[q=20 q=60 q=1 q=5]]
    ~zod/try=> (scan "" (most ace dem))
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++plus`

List of at least one match.

Parser modifier: parse [`++list`]() of at least one match.

Accepts
-------

`fel` is a [`++rule`]().

Produces
--------

A `++rule`.

Source
------

    ++  plus  |*(fel=_rule ;~(plug fel (star fel)))

Examples
--------
    
    ~zod/try=> (scan ">>>>" (cook lent (plus gar)))
    4
    ~zod/try=> (scan "-  - " (plus ;~(pose ace hep)))
    [~~- "  - "]
    ~zod/try=> `tape`(scan "-  - " (plus ;~(pose ace hep)))
    "-  - "
    ~zod/try=> `(pole ,@t)`(scan "-  - " (plus ;~(pose ace hep)))
    ['-' [' ' [' ' ['-' [' ' ~]]]]]

------------------------------------------------------------------------

### `++slug`

Use gate to parse delimited list

Parser modifier: By composing with a [gate](), parse a delimited [`++list`]() of
matches.

Accepts
-------

`bus` is a [`++rule`]().

`fel` is a `++rule`.

Produces
--------

A `++rule`.

Source
------

    ++  slug
      |*  raq=_|*([a=* b=*] [a b])
      |*  [bus=_rule fel=_rule]
      ;~((comp raq) fel (stir +<+.raq raq ;~(pfix bus fel)))

Examples
--------
    
    ~zod/try=> (scan "20+5+110" ((slug add) lus dem))
    135
    ~zod/try=> `@t`(scan "a b c" ((slug |=(a=[@ @t] (cat 3 a))) ace alp))
    'abc'

------------------------------------------------------------------------

### `++star`

List of matches

Parser modifier: parse [`++list`]() of matches.

Accepts
-------

`fel` is a [`++rule`]().

Produces
--------

    ++  star                                                ::  0 or more times
      |*  fel=_rule
      (stir `(list ,_(wonk *fel))`~ |*([a=* b=*] [a b]) fel)

Examples
--------
        
        ~zod/try=> (scan "aaaaa" (just 'a'))
        ! {1 2}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "aaaaa" (star (just 'a')))
        "aaaaa"
        ~zod/try=> (scan "abcdef" (star (just 'a')))
        ! {1 2}
        ! 'syntax-error'
        ! exit
        ~zod/try=> (scan "abcabc" (star (jest 'abc')))
        <|abc abc|>
        ~zod/try=> (scan "john smith" (star (shim 0 200)))
        "john smith"

------------------------------------------------------------------------
