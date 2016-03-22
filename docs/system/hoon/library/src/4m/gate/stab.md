### `++stab`

Parse span to path

Parsing rule. Parses a span `zep` to a static `++path`.

Accepts
-------

Produces
--------

Source
------

    ++  stab                                                ::  parse cord to path
      =+  fel=;~(pfix fas (more fas urs:ab))
      |=(zep/@t `path`(rash zep fel))


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
