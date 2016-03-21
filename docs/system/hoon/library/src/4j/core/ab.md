### `++ab`

Primitive parser engine

A core containing numeric parser primitives.

Source
------

    ++  ab
      |%

Examples
--------

    ~zod/try=> ab
    <36.ecc 414.gly 100.xkc 1.ypj %164>

------------------------------------------------------------------------

### `++bix`

Parse hex pair

Parsing `++rule`. Parses a pair of base-16 digits. Used in escapes.

Accepts
-------

XX

Produces
--------

A an atom. XX

Source
------

      ++  bix  (bass 16 (stun [2 2] six))

Examples
--------

    ~zod/try=> (scan "07" bix:ab)
    q=7
    ~zod/try=> (scan "51" bix:ab)
    q=81
    ~zod/try=> (scan "a3" bix:ab)
    q=163

------------------------------------------------------------------------

### `++hif`

Parse phonetic pair

Parsing `++rule`. Parses an atom of odor `@pE`, a phrase of two bytes
encoded phonetically.

Accepts
-------

XX

Produces
--------

An atom.

Source
------

      ++  hif  (boss 256 ;~(plug tip tiq (easy ~)))

Examples
--------

    ~zod/try=> (scan "doznec" hif:ab)
    q=256
    ~zod/try=> (scan "pittyp" hif:ab)
    q=48.626

------------------------------------------------------------------------

### `++huf`

Parse two phonetic pairs

Parsing `++rule`. Parses and unscrambles an atom of odor @pF, a phrase
of two two-byte pairs that are encoded (and scrambled) phonetically.

Accepts
-------

XX

Produces
--------

An atom. XX

Source
------

      ++  huf  %+  cook
                   |=([a/@ b/@] (wred:un ~(zug mu ~(zag mu [a b]))))
                 ;~(plug hif ;~(pfix hep hif))

Examples
--------

    ~zod/try=> (scan "pittyp-pittyp" huf:ab)
    328.203.557
    ~zod/try=> (scan "tasfyn-partyv" huf:ab)
    65.792
    ~zod/try=> `@ux`(scan "tasfyn-partyv" huf:ab)
    0x1.0100

------------------------------------------------------------------------

### `++hyf`

Parse 8 phonetic bytes

Parsing `++rule`. Parses an atom of odor @pG, a phrase of eight of
phonetic bytes.

Accepts
-------

An atom of odor `@pG`

Produces
--------

An atom. XX

Source
------

      ++  hyf  (bass 0x1.0000.0000 ;~(plug huf ;~(pfix hep huf) (easy ~)))

Examples
--------

    ~zod/try=> (scan "sondel-forsut-tillyn-nillyt" hyf:ab)
    q=365.637.097.828.335.095
    ~zod/try=> `@u`~sondel-forsut-tillyn-nillyt
    365.637.097.828.335.095

------------------------------------------------------------------------

### `++pev`

Parse \<= 5 base-32

Parsing `++rule`. Parses up to five base-32 digits without a leading zero.

Accepts
-------

Up to five @uv (base 64) digits.

Produces
--------

An atom.

Source
------

      ++  pev  (bass 32 ;~(plug sev (stun [0 4] siv)))

Examples
--------

    ~zod/try=> (scan "a" pev:ab)
    q=10
    ~zod/try=> (scan "290j" pev:ab)
    q=74.771
    ~zod/try=> (scan "123456" pev:ab)
    ! {1 6}
    ! exit
    ~zod/try=> (scan "090j" pev:ab)
    ~ <syntax error at [1 11]>

------------------------------------------------------------------------

### `++pew`

Parse \<= 5 base-64

Parsing `++rule`. Parses up to five base-64 digits without a leading zero.

Accepts
-------

Up to five @uw (base 64) digits.

Produces
--------



Source
------

      ++  pew  (bass 64 ;~(plug sew (stun [0 4] siw)))

Examples
--------

    ~zod/try=> (scan "Q" pew:ab)
    q=52
    ~zod/try=> (scan "aQ~9" pew:ab)
    q=2.838.473
    ~zod/try=> `@`0waQ~9
    2.838.473
    ~zod/try=> (scan "123456" pew:ab)
    ! {1 6}
    ! exit
    ~zod/try=> (scan "012345" pew:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++piv`

Parse 5 base-32

Parsing `++rule`. Parses exactly five base-32 digits.

Accepts
-------

Produces
--------

Source
------

      ++  piv  (bass 32 (stun [5 5] siv))

Examples
--------

    ~zod/try=> (scan "10b3l" piv:ab)
    q=1.059.957
    ~zod/try=> (scan "1" piv:ab)
    ! {1 2}
    ! exit

------------------------------------------------------------------------

### `++piw`

Parse 5 base-64

Parsing `++rule`. Parses exactly five base-64 digits.

Accepts
-------

Produces
--------

Source
------

      ++  piw  (bass 64 (stun [5 5] siw))

Examples
--------

    ~zod/try=> (scan "2C-pZ" piw:ab)
    q=43.771.517
    ~zod/try=> (scan "2" piv:ab)
    ! {1 2}
    ! exit

------------------------------------------------------------------------

### `++qeb`

Parse \<= 4 binary

Parsing `++rule`. Parses a binary number of up to 4 digits in length without
a leading zero.

Accepts
-------

Produces
--------

Source
------

      ++  qeb  (bass 2 ;~(plug seb (stun [0 3] sib)))

Examples
--------

    ~zod/try=> (scan "1" qeb:ab)
    q=1
    ~zod/try=> (scan "101" qeb:ab)
    q=5
    ~zod/try=> (scan "1111" qeb:ab)
    q=15
    ~zod/try=> (scan "11111" qeb:ab)
    ! {1 5}
    ! exit
    ~zod/try=> (scan "01" qeb:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++qex`

Parse \<= 4 hex

Parsing `++rule`. Parses a hexadecimal number of up to 4 digits in length
without a leading zero.

Accepts
-------

Produces
--------

Source
------

      ++  qex  (bass 16 ;~(plug sex (stun [0 3] hit)))

Examples
--------

    ~zod/try=> (scan "ca" qex:ab)
    q=202
    ~zod/try=> (scan "18ac" qex:ab)
    q=6.316
    ~zod/try=> (scan "18acc" qex:ab)
    ! {1 5}
    ! exit
    ~zod/try=> (scan "08ac" qex:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++qib`

Parse 4 binary

Parsing `++rule`. Parses exactly four binary digits.

Accepts
-------

Produces
--------

Source
------

      ++  qib  (bass 2 (stun [4 4] sib))

Examples
--------

    ~zod/try=> (scan "0001" qib:ab)
    q=1
    ~zod/try=> (scan "0100" qib:ab)
    q=4
    ~zod/try=> (scan "110" qib:ab)
    ! {1 4}
    ! exit

------------------------------------------------------------------------

### `++qix`

Parse 4 hex

Parsing `++rule`. Parses exactly four hexadecimal digits.

Accepts
-------

Produces
--------

Source
------

      ++  qix  (bass 16 (stun [4 4] six))

Examples
--------

    ~zod/try=> (scan "0100" qix:ab)
    q=256
    ~zod/try=> (scan "10ff" qix:ab)
    q=4.351
    ~zod/try=> (scan "0" qix:ab)
    ! {1 2}
    ! exit

------------------------------------------------------------------------

### `++seb`

Parse 1

Parsing `++rule`. Parses the number 1.

Accepts
-------

Produces
--------

Source
------

      ++  seb  (cold 1 (just '1'))

Examples
--------

    ~zod/try=> (scan "1" seb:ab)
    1
    ~zod/try=> (scan "0" seb:ab)
    ! ~zod/try/~2014.10.23..22.34.21..bfdd/:<[1 1].[1 18]>
    ! {1 1}
    ~zod/try=> (scan "2" seb:ab)
    ! ~zod/try/~2014.10.23..22.34.29..d399/:<[1 1].[1 18]>
    ! {1 1}

------------------------------------------------------------------------

### `++sed`

Parse decimal

Parsing `++rule`. Parses a nonzero decimal digit.

Accepts
-------

Produces
--------

Source
------

      ++  sed  (cook |=(a/@ (sub a '0')) (shim '1' '9'))

Examples
--------

    ~zod/try=> (scan "5" sed:ab)
    5
    ~zod/try=> (scan "0" sed:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++sev`

Parse base-32

Parsing `++rule`. Parses a nonzero base-32 digit

Accepts
-------

Produces
--------

Source
------

      ++  sev  ;~(pose sed sov)

Examples
--------

    ~zod/try=> (scan "c" sev:ab)
    12
    ~zod/socialnet=> (scan "0" sev:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++sew`

Parse base-64

Parsing `++rule`. Parses a nonzero base-64 digit

Accepts
-------

Produces
--------

Source
------

      ++  sew  ;~(pose sed sow)

Examples
--------

    ~zod/try=> (scan "M" sew:ab)
    48
    ~zod/try=> (scan "0" sew:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++sex`

Parse hex

Parsing `++rule`. Parses a nonzero hexadecimal digit.

Accepts
-------

Produces
--------

Source
------

      ++  sex  ;~(pose sed sox)

Examples
--------

    ~zod/try=> (scan "e" sex:ab)
    14
    ~zod/try=> (scan "0" sex:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++sib`

Parse binary

Parsing `++rule`. Parses a binary digit.

Accepts
-------

Produces
--------

Source
------

      ++  sib  (cook |=(a/@ (sub a '0')) (shim '0' '1'))

Examples
--------

    ~zod/try=> (scan "1" sib:ab)
    1
    ~zod/socialnet=> (scan "0" sib:ab)
    0

------------------------------------------------------------------------

### `++sid`

Parse decimal

Parsing `++rule`. Parses a decimal digit.

Accepts
-------

Produces
--------

Source
------

      ++  sid  (cook |=(a/@ (sub a '0')) (shim '0' '9'))

Examples
--------

    ~zod/try=> (scan "5" sid:ab)
    5

------------------------------------------------------------------------

### `++siv`

Parse base-32

Parsing `++rule`. Parses a base-32 digit.

Accepts
-------

Produces
--------

Source
------

      ++  siv  ;~(pose sid sov)

Examples
--------

    ~zod/try=> (scan "c" siv:ab)
    12

------------------------------------------------------------------------

### `++siw`

Parse base-64

Parsing `++rule`. Parses a base-64 digit.

Accepts
-------

Produces
--------

Source
------

      ++  siw  ;~(pose sid sow)

Examples
--------

    ~zod/try=> (scan "M" siw:ab)
    48

------------------------------------------------------------------------

### `++six`

Parse hex

Parsing `++rule`. Parses a hexadecimal digit.

Accepts
-------

Produces
--------

Source
------

      ++  six  ;~(pose sid sox)

Examples
--------

    ~zod/try=> (scan "e" six:ab)
    14

------------------------------------------------------------------------

### `++sov`

Parse base-32

Parsing `++rule`. Parses a base-32 letter.

Accepts
-------

Produces
--------

Source
------

      ++  sov  (cook |=(a/@ (sub a 87)) (shim 'a' 'v'))

Examples
--------

    ~zod/try=> (scan "c" sov:ab)
    12

------------------------------------------------------------------------

### `++sow`

Parse base-64

Parsing `++rule`. Parses a base-64 letter/symbol.

Accepts
-------

Produces
--------

Source
------

      ++  sow  ;~  pose
                 (cook |=(a/@ (sub a 87)) (shim 'a' 'z'))
                 (cook |=(a/@ (sub a 29)) (shim 'A' 'Z'))
                 (cold 62 (just '-'))
                 (cold 63 (just '~'))
               ==

Examples
--------

    ~zod/try=> (scan "M" sow:ab)
    48

------------------------------------------------------------------------

### `++sox`

Parse hex letter

Parsing `++rule`. Parses a hexadecimal letter.

Accepts
-------

Produces
--------

Source
------

      ++  sox  (cook |=(a/@ (sub a 87)) (shim 'a' 'f'))

Examples
--------

    ~zod/try=> (scan "e" sox:ab)
    14

------------------------------------------------------------------------

### `++ted`

Parse \<= 3 decimal

Parsing `++rule`. Parses a decimal number of up to 3 digits without a
leading zero.

Accepts
-------

Produces
--------

Source
------

      ++  ted  (bass 10 ;~(plug sed (stun [0 2] sid)))

Examples
--------

    ~zod/try=> (scan "21" ted:ab)
    q=21
    ~zod/try=> (scan "214" ted:ab)
    q=214
    ~zod/try=> (scan "2140" ted:ab)
    {1 4}
    ~zod/try=> (scan "0" ted:ab)
    ! {1 1}
    ! exit

------------------------------------------------------------------------

### `++tip`

Leading phonetic byte

Parsing `++rule`. Parses the leading phonetic byte, which represents a
syllable.

Accepts
-------

Produces
--------

Source
------

      ++  tip  (sear |=(a/@ (ins:po a)) til)

Examples
--------

    ~zod/try=> (scan "doz" tip:ab)
    0
    ~zod/try=> (scan "pit" tip:ab)
    242

------------------------------------------------------------------------

### `++tiq`

Trailing phonetic syllable

Parsing `++rule`. Parses the trailing phonetic byte, which represents a
syllable.

Accepts
-------

Produces
--------

Source
------

      ++  tiq  (sear |=(a/@ (ind:po a)) til)

Examples
--------

    ~zod/try=> (scan "zod" tiq:ab)
    0
    ~zod/try=> (scan "nec" tiq:ab)
    1

------------------------------------------------------------------------

### `++tid`

Parse 3 decimal digits

Parsing `++rule`. Parses exactly three decimal digits.

Accepts
-------

Produces
--------

Source
------

      ++  tid  (bass 10 (stun [3 3] sid))

Examples
--------

    ~zod/try=> (scan "013" tid:ab)
    q=13
    ~zod/try=> (scan "01" tid:ab)
    ! {1 3}
    ! exit

------------------------------------------------------------------------

### `++til`

Parse 3 lowercase

Parsing `++rule`. Parses exactly three lowercase letters.

Accepts
-------

Produces
--------

Source
------

      ++  til  (boss 256 (stun [3 3] low))

Examples
--------

    ~zod/try=> (scan "mer" til:ab)
    q=7.497.069
    ~zod/try=> `@t`(scan "mer" til:ab)
    'mer'
    ~zod/try=> (scan "me" til:ab)
    ! {1 3}
    ! exit

------------------------------------------------------------------------

### `++urs`

Parse span characters

Parsing rule. Parses characters from an atom of the span odor `@ta`.

Accepts
-------

Produces
--------

Source
------

      ++  urs  %+  cook
                 |=(a/tape (rap 3 ^-((list @) a)))
               (star ;~(pose nud low hep dot sig cab))

Examples
--------

    ~zod/try=> `@ta`(scan "asa-lom_tak" urs:ab)
    ~.asa-lom_tak 
    ~zod/try=> `@t`(scan "asa-lom_tak" urs:ab)
    'asa-lom_tak'

------------------------------------------------------------------------

### `++urt`

Parse non-`_` span

Parsing rule. Parses all characters of the span odor `@ta` except
for cab, `_`.

Accepts
-------

Produces
--------

Source
------

      ++  urt  %+  cook
                 |=(a/tape (rap 3 ^-((list @) a)))
               (star ;~(pose nud low hep dot sig))

Examples
--------

    ~zod/try=> `@t`(scan "asa-lom.t0k" urt:ab)
    'asa-lom.t0k'

------------------------------------------------------------------------

### `++voy`

Parse bas, soq, or bix

Parsing rule. Parses an escaped backslash, single quote, or hex pair
byte.

Accepts
-------

Produces
--------

Source
------

      ++  voy  ;~(pfix bas ;~(pose bas soq bix))

Examples
--------

    ~zod/try=> (scan "\\0a" voy:ab)
    q=10
    ~zod/try=> (scan "\\'" voy:ab)
    q=39

------------------------------------------------------------------------

### `++ag`

Top-level atom parser engine

A core containing top-level atom parsers.

Accepts
-------

Produces
--------

Source
------

    ++  ag
      |%

Examples
--------

    ~zod/try=> ag
    <14.vpu 414.mof 100.xkc 1.ypj %164>

------------------------------------------------------------------------

### `++ape`

Parse 0 or rule

Parser modifier. Parses 0 or the sample rule `fel`.

Accepts
-------

Produces
--------

`fel` is a `rule`.

Source
------

      ++  ape  |*(fel/rule ;~(pose (cold 0 (just '0')) fel))


Examples
--------

    ~zod/try=> (scan "202" (star (ape:ag (cold 2 (just '2')))))
    ~[2 0 2]

------------------------------------------------------------------------

### `++bay`

Parses binary number

Parsing rule. Parses a binary number without a leading zero.

Accepts
-------

Produces
--------

Source
------

      ++  bay  (ape (bass 16 ;~(plug qeb:ab (star ;~(pfix dog qib:ab)))))

Examples
--------

    ~zod/try=> (scan "10.0110" bay:ag)
    q=38

------------------------------------------------------------------------

### `++bip`

Parse IPv6

Parsing rule. Parses a `@is`, an IPv6 address.

Accepts
-------

Produces
--------

Source
------

      ++  bip  =+  tod=(ape qex:ab)
               (bass 0x1.0000 ;~(plug tod (stun [7 7] ;~(pfix dog tod))))

Examples
--------

    ~zod/try=> (scan "0.0.ea.3e6c.0.0.0.0" bip:ag)
    q=283.183.420.760.121.105.516.068.864
    ~zod/try=> `@is`(scan "0.0.ea.3e6c.0.0.0.0" bip:ag)
    .0.0.ea.3e6c.0.0.0.0

------------------------------------------------------------------------

### `++dem`

Parse decimal with dots

Parsing rule. Parses a decimal number that includes dot separators.

Accepts
-------

Produces
--------

Source
------

      ++  dem  (ape (bass 1.000 ;~(plug ted:ab (star ;~(pfix dog tid:ab)))))


Examples
--------

    ~zod/try=> (scan "52" dem:ag)
    q=52
    ~zod/try=> (scan "13.507" dem:ag)
    q=13.507

------------------------------------------------------------------------

### `++dim`

Parse decimal number

Parsing rule. Parses a decimal number without a leading zero.

Accepts
-------

Produces
--------

Source
------

      ++  dim  (ape (bass 10 ;~(plug sed:ab (star sid:ab))))

Examples
--------

    ~zod/try=> (scan "52" dim:ag)
    q=52
    ~zod/try=> (scan "013507" dim:ag)
    ! {1 2}
    ! exit

------------------------------------------------------------------------

### `++dum`

Parse decimal with leading `0`

Parsing rule. Parses a decmial number with leading zeroes.

Accepts
-------

Produces
--------

Source
------

      ++  dum  (bass 10 (plus sid:ab))

Examples
--------

    ~zod/try=> (scan "52" dum:ag)
    q=52
    ~zod/try=> (scan "0000052" dum:ag)
    q=52
    ~zod/try=> (scan "13507" dim:ag)
    q=13.507

------------------------------------------------------------------------

### `++fed`

Parse phonetic base

Parsing rule. Parses an atom of odor `@p`, the phonetic base.

Accepts
-------

Produces
--------

Source
------

      ++  fed  ;~  pose
                 (bass 0x1.0000.0000.0000.0000 (most doh hyf:ab))
                 huf:ab
                 hif:ab
                 tiq:ab
               ==

Examples
--------

    ~zod/try=> (scan "zod" fed:ag)
    0
    ~zod/try=> (scan "nec" fed:ag)
    1
    ~zod/try=> (scan "sondel" fed:ag)
    9.636
    ~zod/try=> ~tillyn-nillyt
    ~tillyn-nillyt
    ~zod/try=> (scan "tillyn-nillyt" fed:ag)
    3.569.565.175
    ~zod/try=> (scan "tillyn-nillyt-tasfyn-partyv" fed:ag)
    15.331.165.687.565.582.592
    ~zod/try=> (scan "tillyn-nillyt-tasfyn-partyv--novweb-talrud-talmud-sonfyr" fed:ag)
    282.810.089.790.159.633.869.501.053.313.363.681.181

------------------------------------------------------------------------

### `++hex`

Parse hex

Parsing rule. Parses a hexadecimal number

Accepts
-------

Produces
--------

Source
------

      ++  hex  (ape (bass 0x1.0000 ;~(plug qex:ab (star ;~(pfix dog qix:ab)))))

Examples
--------

    ~zod/try=> (scan "4" hex:ag)
    q=4
    ~zod/try=> (scan "1a" hex:ag)
    q=26
    ~zod/try=> (scan "3.ac8d" hex:ag)
    q=240.781
    ~zod/try=> `@ux`(scan "3.ac8d" hex:ag)
    0x3.ac8d

------------------------------------------------------------------------

### `++lip`

Parse IPv4 address

Parsing rule. Parses an IPv4 address.

Accepts
-------

Produces
--------

Source
------

      ++  lip  =+  tod=(ape ted:ab)
               (bass 256 ;~(plug tod (stun [3 3] ;~(pfix dog tod))))

Examples
--------

    ~zod/try=> (scan "127.0.0.1" lip:ag)
    q=2.130.706.433
    ~zod/try=> `@if`(scan "127.0.0.1" lip:ag)
    .127.0.0.1
    ~zod/try=> `@if`(scan "8.8.8.8" lip:ag)
    .8.8.8.8

------------------------------------------------------------------------

### `++viz`

Parse Base-32 with dots

Parsing rule. Parses a Base-32 number with dot separators.

Accepts
-------

Produces
--------

Source
------

      ++  viz  (ape (bass 0x200.0000 ;~(plug pev:ab (star ;~(pfix dog piv:ab)))))

Examples
--------

    ~zod/try=> (scan "e2.ol4pm" viz:ag)
    q=15.125.353.270

------------------------------------------------------------------------

### `++vum`

Parse base-32 string

Parsing rule. Parses a raw base-32 string.

Accepts
-------

Produces
--------

Source
------

      ++  vum  (bass 32 (plus siv:ab))

Examples
--------

    ~zod/try=> (scan "e2ol4pm" vum:ag)
    q=15.125.353.270

------------------------------------------------------------------------

### `++wiz`

Parse base-64

Parsing rule. Parses a base-64 number.

Accepts
-------

Produces
--------

Source
------

      ++  wiz  (ape (bass 0x4000.0000 ;~(plug pew:ab (star ;~(pfix dog piw:ab)))))
      --
    ::

Examples
--------

    ~zod/try=> (scan "e2O.l4Xpm" wiz:ag)
    q=61.764.130.813.526

***
