### `++each`

Mold of fork between two

mold generator: produces a dicriminated fork between two types.

Source
------

        ++  each
          |*  {a/$-(* *) b/$-(* *)}                     ::  either a or b
          $%({$& p/a} {$| p/b})                         ::    a default


Examples
--------

    > ? *(each cord time)
      ?({$.y p/@t} {$.n p/@da})
    [%.y p='']

***
