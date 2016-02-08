section 2eF, parsing (ascii)
============================

### `++ace`

Parse space

Parses ASCII character 32, space.

Source
------

    ++  ace  (just ' ')

Examples
--------

    ~zod/try=> (scan " " ace)
    ~~. 
    ~zod/try=> `cord`(scan " " ace)
    ' '
    ~zod/try=> (ace [[1 1] " "])
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ace [[1 1] " abc "])
    [p=[p=1 q=2] q=[~ [p=~~. q=[p=[p=1 q=2] q="abc "]]]]

------------------------------------------------------------------------

### `++bar`

Parse vertical bar

Parses ASCII character 124, the vertical bar.

Source
------

    ++  bar  (just '|')

Examples
--------

    ~zod/try=> (scan "|" bar)
    ~~~7c. 
    ~zod/try=> `cord`(scan "|" bar)
    '|'
    ~zod/try=> (bar [[1 1] "|"])
    [p=[p=1 q=2] q=[~ [p=~~~7c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (bar [[1 1] "|="])
    [p=[p=1 q=2] q=[~ [p=~~~7c. q=[p=[p=1 q=2] q="="]]]]

------------------------------------------------------------------------

### `++bas`

Parse backslash

Parses ASCII character 92, the backslash. Note the extra `\` in the calling of
`bas` with [`++just`](/doc/hoon/library/2ec#++just) is to escape the escape
character, `\`.

Source
------

    ++  bas  (just '\\')

Examples
--------

    ~zod/try=> (scan "\\" bas)
    ~~~5c.
    ~zod/try=> `cord`(scan "\\" bas)
    '\'
    ~zod/try=> (bas [[1 1] "\"])
    ~ <syntax error at [1 18]>
    ~zod/try=> (bas [[1 1] "\\"])
    [p=[p=1 q=2] q=[~ [p=~~~5c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (bas [[1 1] "\""])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++buc`

Parse dollar sign

Parses ASCII character 36, the dollar sign.

Source
------

    ++  buc  (just '$')

Examples
--------

    ~zod/try=> (scan "$" buc)
    ~~~24.
    ~zod/try=> `cord`(scan "$" buc)
    '$'
    ~zod/try=> (buc [[1 1] "$"])
    [p=[p=1 q=2] q=[~ [p=~~~24. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (buc [[1 1] "$%"])
    [p=[p=1 q=2] q=[~ [p=~~~24. q=[p=[p=1 q=2] q="%"]]]]

------------------------------------------------------------------------

### `++cab`

Parse underscore

Parses ASCII character 95, the underscore.

Source
------

    ++  cab  (just '_')

Examples
--------

    ~zod/try=> (scan "_" cab)
    ~~~5f.
    ~zod/try=> `cord`(scan "_" cab)
    '_'
    ~zod/try=> (cab [[1 1] "_"])
    [p=[p=1 q=2] q=[~ [p=~~~5f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (cab [[1 1] "|_"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++cen`

Parses percent sign

Parses ASCII character 37, the percent sign.

Source
------

    ++  cen  (just '%')

Examples
--------

    ~zod/try=> (scan "%" cen)
    ~~~25.
    ~zod/try=> `cord`(scan "%" cen)
    '%'
    ~zod/try=> (cen [[1 1] "%"])
    [p=[p=1 q=2] q=[~ [p=~~~25. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (cen [[1 1] "%^"])
    [p=[p=1 q=2] q=[~ [p=~~~25. q=[p=[p=1 q=2] q="^"]]]] 

------------------------------------------------------------------------

### `++col`

Parse colon

Parses ASCII character 58, the colon

Source
------

    ++  col  (just ':')

Examples
--------

    ~zod/try=> (scan ":" col)
    ~~~3a.
    ~zod/try=> `cord`(scan ":" col)
    ':'
    ~zod/try=> (col [[1 1] ":"])
    [p=[p=1 q=2] q=[~ [p=~~~3a. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (col [[1 1] ":-"])
    [p=[p=1 q=2] q=[~ [p=~~~3a. q=[p=[p=1 q=2] q="-"]]]]

------------------------------------------------------------------------

### `++com`

Parse comma

Parses ASCII character 44, the comma.

Source
------

    ++  com  (just ',')

Examples
--------

    ~zod/try=> (scan "," com)
    ~~~2c.
    ~zod/try=> `cord`(scan "," com)
    ','
    ~zod/try=> (com [[1 1] ","])
    [p=[p=1 q=2] q=[~ [p=~~~2c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (com [[1 1] "not com"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++doq`

Parse double quote

Parses ASCII character 34, the double quote.

Source
------

    ++  doq  (just '"')

Examples
--------

    ~zod/try=> (scan "\"" doq)
    ~~~22.
    ~zod/try=> `cord`(scan "\"" doq)
    '"'
    ~zod/try=> (doq [[1 1] "\""])
    [p=[p=1 q=2] q=[~ [p=~~~22. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (doq [[1 1] "not successfully parsed"])
    [p=[p=1 q=1] q=~]
    ~zod/try=> (scan "see?" doq)
    ! {1 1}
    ! 'syntax-error'
    ! exit 

------------------------------------------------------------------------

### `++dot`

Parse period

Parses ASCII character 46, the period.

Source
------

    ++  dot  (just '.')

Examples
--------

    ~zod/try=> (scan "." dot)
    ~~~.
    ~zod/try=> `cord`(scan "." dot)
    '.'
    ~zod/try=> (dot [[1 1] "."])
    [p=[p=1 q=2] q=[~ [p=~~~. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (dot [[1 1] ".^"])
    [p=[p=1 q=2] q=[~ [p=~~~. q=[p=[p=1 q=2] q="^"]]]]

------------------------------------------------------------------------

### `++fas`

Parse forward slash

Parses ASCII character 47, the forward slash.

Source
------

    ++  fas  (just '/')

Examples
--------

    ~zod/try=> (scan "/" fas)
    ~~~2f.
    ~zod/try=> `cord`(scan "/" fas)
    '/'
    ~zod/try=> (fas [[1 1] "/"])
    [p=[p=1 q=2] q=[~ [p=~~~2f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (fas [[1 1] "|/"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++gal`

Parse less-than sign

Parses ASCII character 60, the less-than sign.

Source
------

    ++  gal  (just '<')

Examples
--------

    ~zod/try=> (scan "<" gal)
    ~~~3c.
    ~zod/try=> `cord`(scan "<" gal)
    '<'
    ~zod/try=> (gal [[1 1] "<"])
    [p=[p=1 q=2] q=[~ [p=~~~3c. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (gal [[1 1] "<+"])
    [p=[p=1 q=2] q=[~ [p=~~~3c. q=[p=[p=1 q=2] q="+"]]]]
    ~zod/try=> (gal [[1 1] "+<"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++gar`

Parse greater-than sign

Parses ASCII character 62, the greater-than sign.

Source
------

    ++  gar  (just '>')

Examples
--------

    ~zod/try=> (scan ">" gar)
    ~~~3e.
    ~zod/try=> `cord`(scan ">" gar)
    '>'
    ~zod/try=> (gar [[1 1] ">"])
    [p=[p=1 q=2] q=[~ [p=~~~3e. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (gar [[1 1] "=>"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++hax`

Parse number sign

Parses ASCII character 35, the number sign.

Source
------

    ++  hax  (just '#')

Examples
--------

    ~zod/try=> (scan "#" hax)
    ~~~23.
    ~zod/try=> `cord`(scan "#" hax)
    '#'
    ~zod/try=> (hax [[1 1] "#"])
    [p=[p=1 q=2] q=[~ [p=~~~23. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (hax [[1 1] "#!"])
    [p=[p=1 q=2] q=[~ [p=~~~23. q=[p=[p=1 q=2] q="!"]]]]

------------------------------------------------------------------------

### `++kel`

Parse left curley bracket

Parses ASCII character 123, the left curly bracket. Note that `{`
(`kel`) and `}` (`ker`) open and close a Hoon expression for Hoon string
interpolation. To parse either of them, they must be escaped.

Source
------

    ++  kel  (just '{')

Examples
--------

    ~zod/try=> (scan "\{" kel)
    ~~~7b.
    ~zod/try=> `cord`(scan "\{" kel)
    '{'
    ~zod/try=> (kel [[1 1] "\{"])
    [p=[p=1 q=2] q=[~ [p=~~~7b. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (kel [[1 1] " \{"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++ker`

Parse right curley bracket

Parses ASCII character 125, the right curly bracket. Note that `{`
(`kel`) and `}` (`ker`) open and close a Hoon expression for Hoon string
interpolation. To parse either of them, they must be escaped.

Source
------

    ++  ker  (just '}')

Examples
--------

    ~zod/try=> (scan "}" ker)
    ~~~7d.
    ~zod/try=> `cord`(scan "}" ker)
    '}'
    ~zod/try=> (ker [[1 1] "}"])
    [p=[p=1 q=2] q=[~ [p=~~~7d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ker [[1 1] "\{}"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++ket`

Parse caret

Parses ASCII character 94, the caret.

Source
------

    ++  ket  (just '^')

Examples
--------

    ~zod/try=> (scan "^" ket)
    ~~~5e.
    ~zod/try=> `cord`(scan "^" ket)
    '^'
    ~zod/try=> (ket [[1 1] "^"])
    [p=[p=1 q=2] q=[~ [p=~~~5e. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ket [[1 1] ".^"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++lus`

Parse plus sign

Parses ASCII character 43, the plus sign.

Source
------

    ++  lus  (just '+')

Examples
--------

        ~zod/try=> (scan "+" lus)
        ~~~2b.
        ~zod/try=> `cord`(scan "+" lus)
        '+'
        ~zod/try=> (lus [[1 1] "+"])
        [p=[p=1 q=2] q=[~ [p=~~~2b. q=[p=[p=1 q=2] q=""]]]]
        ~zod/try=> (lus [[1 1] ".+"])
        [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++hep`

Parse hyphen

Parses ASCII character 45, the hyphen.

Source
------

    ++  hep  (just '-')

Examples
--------

    ~zod/try=> (scan "-" hep)
    ~~-
    ~zod/try=> `cord`(scan "-" hep)
    '-'
    ~zod/try=> (hep [[1 1] "-"])
    [p=[p=1 q=2] q=[~ [p=~~- q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (hep [[1 1] ":-"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++pel`

Parse left parenthesis

Parses ASCII character 40, the left parenthesis.

Source
------

    ++  pel  (just '(')

Examples
--------

    ~zod/try=> (scan "(" pel)
    ~~~28.
    ~zod/try=> `cord`(scan "(" pel)
    '('
    ~zod/try=> (pel [[1 1] "("])
    [p=[p=1 q=2] q=[~ [p=~~~28. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pel [[1 1] ";("])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++pam`

Parse ampersand

Parses ASCII character 38, the ampersand.

Source
------

    ++  pam  (just '&')

Examples
--------

    ~zod/try=> (scan "&" pam)
    ~~~26.
    ~zod/try=> `cord`(scan "&" pam)
    '&'
    ~zod/try=> (pam [[1 1] "&"])
    [p=[p=1 q=2] q=[~ [p=~~~26. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pam [[1 1] "?&"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++per`

Parse right parenthesis

Parses ASCII character 41, the right parenthesis.

Source
------

    ++  per  (just ')')

Examples
--------

    ~zod/try=> (scan ")" per)
    ~~~29.
    ~zod/try=> `cord`(scan ")" per)
    ')'
    ~zod/try=> (per [[1 1] ")"])
    [p=[p=1 q=2] q=[~ [p=~~~29. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (per [[1 1] " )"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++pat`

Parse "at" sign

Parses ASCII character 64, the "at" sign.

Source
------

    ++  pat  (just '@')

Examples
--------

    ~zod/try=> (scan "@" pat)
    ~~~4.
    ~zod/try=> `cord`(scan "@" pat)
    '@'
    ~zod/try=> (pat [[1 1] "@"])
    [p=[p=1 q=2] q=[~ [p=~~~4. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (pat [[1 1] "?@"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++sel`

Parse left square bracket

Parses ASCII character 91, the left square bracket.

Source
------

    ++  sel  (just '[')

Examples
--------

        ~zod/try=> (scan "[" sel)
        ~~~5b.
        ~zod/try=> `cord`(scan "[" sel)
        '['
        ~zod/try=> (sel [[1 1] "["])
        [p=[p=1 q=2] q=[~ [p=~~~5b. q=[p=[p=1 q=2] q=""]]]]
        ~zod/try=> (sel [[1 1] "-["])
        [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++sem`

Parse semicolon

Parses ASCII character 59, the semicolon.

Source
------

    ++  sem  (just ';')

Examples
--------

    ~zod/try=> (scan ";" sem)
    ~~~3b.
    ~zod/try=> `cord`(scan ";" sem)
    ';'
    ~zod/try=> (sem [[1 1] ";"])
    [p=[p=1 q=2] q=[~ [p=~~~3b. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (sem [[1 1] " ;"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++ser`

Parse right square bracket

Parses ASCII character 93, the right square bracket.

Source
------

    ++  ser  (just ']')

Examples
--------

    ~zod/try=> (scan "]" ser)
    ~~~5d.
    ~zod/try=> `cord`(scan "]" ser)
    ']'
    ~zod/try=> (ser [[1 1] "]"])
    [p=[p=1 q=2] q=[~ [p=~~~5d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (ser [[1 1] "[ ]"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++sig`

Parse tilde

Parses ASCII character 126, the tilde.

Source
------

    ++  sig  (just '~')

Examples
--------

    ~zod/try=> (scan "~" sig)
    ~~~~
    ~zod/try=> `cord`(scan "~" sig)
    '~'
    ~zod/try=> (sig [[1 1] "~"])
    [p=[p=1 q=2] q=[~ [p=~~~~ q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (sig [[1 1] "?~"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++soq`

Parse single quote

Parses ASCII character 39, soq. Note the extra '' is to escape the first
`soq` because soq delimits a [`++cord`]().

Source
------

    ++  soq  (just '\'')

Examples
--------

    ~zod/try=> (scan "'" soq)
    ~~~27.
    ~zod/try=> `cord`(scan "'" soq)
    '''
    ~zod/try=> (soq [[1 1] "'"])
    [p=[p=1 q=2] q=[~ [p=~~~27. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (soq [[1 1] ">'"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++tar`

Parse asterisk

Parses ASCII character 42, the asterisk.

Source
------

    ++  tar  (just '*')

Examples
--------

    ~zod/try=> (scan "*" tar)
    ~~~2a.
    ~zod/try=> `cord`(scan "*" tar)
    '*'
    ~zod/try=> (tar [[1 1] "*"])
    [p=[p=1 q=2] q=[~ [p=~~~2a. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tar [[1 1] ".*"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++tec`

Parse backtick

Parses ASCII character 96, the backtick (also known as the "grave
accent").

Source
------

    ++  tec  (just '`')                                     ::  backTiCk

Examples
--------

    ~zod/try=> (scan "`" tec)
    ~~~6.
    ~zod/try=> `cord`(scan "`" tec)
    '`'
    ~zod/try=> (tec [[1 1] "`"])
    [p=[p=1 q=2] q=[~ [p=~~~6. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tec [[1 1] " `"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++tis`

Parse equals sign

Parses ASCII character 61, the equals sign.

Source
------

    ++  tis  (just '=')

Examples
--------

    ~zod/try=> (scan "=" tis)
    ~~~3d.
    ~zod/try=> `cord`(scan "=" tis)
    '='
    ~zod/try=> (tis [[1 1] "="])
    [p=[p=1 q=2] q=[~ [p=~~~3d. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (tis [[1 1] "|="])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++wut`

Parses question mark

Parses ASCII character 63, the question mark.

Source
------

    ++  wut  (just '?')

Examples
--------

    ~zod/try=> (scan "?" wut)
    ~~~3f.
    ~zod/try=> `cord`(scan "?" wut)
    '?'
    ~zod/try=> (wut [[1 1] "?"])
    [p=[p=1 q=2] q=[~ [p=~~~3f. q=[p=[p=1 q=2] q=""]]]]
    ~zod/try=> (wut [[1 1] ".?"])
    [p=[p=1 q=1] q=~]

------------------------------------------------------------------------

### `++zap`

Exclamation point

Parses ASCII character 33, the exclamation point zap.

Source
------

    ++  zap  (just '!')

Examples
--------

        ~zod/try=> (scan "!" zap)
        ~~~21.
        ~zod/try=> `cord`(scan "!" zap)
        '!'
        ~zod/try=> (zap [[1 1] "!"])
        [p=[p=1 q=2] q=[~ [p=~~~21. q=[p=[p=1 q=2] q=""]]]]
        ~zod/try=> (zap [[1 1] "?!"])
        [p=[p=1 q=1] q=~]

------------------------------------------------------------------------
