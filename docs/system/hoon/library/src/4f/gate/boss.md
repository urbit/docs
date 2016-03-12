
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


***
