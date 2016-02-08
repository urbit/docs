section 2eG, parsing (whitespace)
=================================

### `++dog`

`.` optional gap

Dot followed by an optional gap, used with numbers.

Source
------

    ++  dog  ;~(plug dot gay)                               ::

Examples
--------

    /~zod/try=> 1.234.
                703
    1.234.703
    ~zod/try=> (scan "a.        " ;~(pfix alf dog))
    [~~~. ~]

------------------------------------------------------------------------

### `++doh`

`@p` separator

Phonetic base phrase separator

Source
------

    ++  doh  ;~(plug ;~(plug hep hep) gay)                  ::

Examples
--------

    /~zod/try=> ~nopfel-botduc-nilnev-dolfyn--haspub-natlun-lodmur-holtyd
    ~nopfel-botduc-nilnev-dolfyn--haspub-natlun-lodmur-holtyd
    /~zod/try=> ~nopfel-botduc-nilnev-dolfyn--
                haspub-natlun-lodmur-holtyd
    ~nopfel-botduc-nilnev-dolfyn--haspub-natlun-lodmur-holtyd
    ~zod/try=> (scan "--" doh)
    [[~~- ~~-] ~]
    ~zod/try=> (scan "--      " doh)
    [[~~- ~~-] ~]

------------------------------------------------------------------------

### `++dun`

`--` to `~`

Parse phep, `--`, to null, `~`.

Source
------

    ++  dun  (cold ~ ;~(plug hep hep))                      ::  -- (phep) to ~

Examples
--------

    ~zod/try=> (scan "--" dun)
    ~
    ~zod/try=> (dun [[1 1] "--"])
    [p=[p=1 q=3] q=[~ u=[p=~ q=[p=[p=1 q=3] q=""]]]]

------------------------------------------------------------------------

### `++duz`

`==` to `~`

Parse stet, `==`, to null `~`.

Source
------

    ++  duz  (cold ~ ;~(plug tis tis))                      ::  == (stet) to ~

Examples
--------

    ~zod/try=> (scan "==" duz)
    ~
    ~zod/try=> (duz [[1 1] "== |=..."])
    [p=[p=1 q=3] q=[~ u=[p=~ q=[p=[p=1 q=3] q=" |=..."]]]]

------------------------------------------------------------------------

### `++gah`

Newline or ' '

Whitespace component, either newline or space.

Source
------

    ++  gah  (mask [`@`10 ' ' ~])                           ::  newline or ace

Examples
--------

    /~zod/try=> ^-  *  ::  show spaces
                """
                   -
                 -
                  -
                """
    [32 32 32 45 10 32 45 10 32 32 45 0]
    /~zod/try=> ^-  *
                """

                """
    [32 32 32 10 32 10 32 32 0]
    /~zod/try=> ^-  (list ,@)
                %-  scan  :_  (star gah)
                """

                """
    ~[32 32 32 10 32 10 32 32]

------------------------------------------------------------------------

### `++gap`

Plural whitespace

Separates tall runes

Source
------

    ++  gap  (cold ~ ;~(plug gaq (star ;~(pose vul gah))))  ::  plural whitespace

------------------------------------------------------------------------

### `++gaq`

End of line

Two spaces, a newline, or comment.
    
Source
------

    ++  gaq  ;~  pose                                       ::  end of line
                 (just `@`10)
                 ;~(plug gah ;~(pose gah vul))
                 vul
             ==


------------------------------------------------------------------------

### `++gaw`

Classic whitespace

Terran whitespace.

Source
------

    ++  gaw  (cold ~ (star ;~(pose vul gah)))               ::  classic white

------------------------------------------------------------------------

### `++gay`

Optional gap

Optional gap.

Source
------

    ++  gay  ;~(pose gap (easy ~))                          ::

------------------------------------------------------------------------

### `++vul`

Comments to null

Source
------

    ++  vul  %-  cold  :-  ~                                ::  comments
             ;~  plug  col  col
               (star prn)
               (just `@`10)
             ==

Parse comments and produce a null. Note that a comment must be ended
with a newline character.

Examples
--------

    ~zod/try=> (scan "::this is a comment \0a" vul)
    ~
    ~zod/try=> (scan "::this is a comment " vul)
    ! {1 21}
    ! exit

------------------------------------------------------------------------
