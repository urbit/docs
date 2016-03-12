### `++stab`

Parse span to path

Parsing rule. Parses a span `zep` to a static [`++path`](/doc/hoon/library/1#++path).

Accepts
-------

Produces
--------

Source
------

    ++  stab                                                ::  parse span to path
      |=  zep=@ta  ^-  path
      (rash zep ;~(pfix fas ;~(sfix (more fas urs:ab) fas)))

Examples
--------

    ~zod/try=> (stab '/as/lek/tor')
    /as/lek/tor
    ~zod/try=> `(pole ,@ta)`(stab '/as/lek/tor')
    [~.as [~.lek [~.tor ~]]]
    ~zod/try=> (stab '~zod/arvo/~2014.10.28..18.48.41..335f/zuse')
    ~zod/arvo/~2014.10.28..18.48.41..335f/zuse
    ~zod/try=> `(pole ,@ta)`(stab '~zod/arvo/~2014.10.28..18.48.41..335f/zuse')
    [~.~zod [~.arvo [~.~2014.10.28..18.48.41..335f [~.zuse ~]]]]
    ~zod/try=> (stab '/a/~pillyt/pals/1')
    /a/~pillyt/pals/1
    ~zod/try=> `(pole ,@ta)`(stab '/a/~pillyt/pals/1')
    [~.a [~.~pillyt [~.pals [~.1 ~]]]]


***
