---
navhome: /docs/
---



### `++jo`

JSON reparsing core

Contains converters of [`++json`]() to [`++unit`]()s of well-typed structures.

Accepts
-------

A `fist` is a gate that produces a `grub`.

A `grub` is a unit of some JSON value.

Source
------

    ++  jo                                                  ::  json reparser
      =>  |%  ++  grub  (unit ,*) 
              ++  fist  $+(json grub)
      |%


### `++ar`

Parse array to list

Reparser modifier. Reparses an array to the [`++unit`]() of a homogenous
[`++list`]() using `wit` to reparse every element.

`wit` is a [`++fist`](), a JSON reparser.


Accepts
-------

A [`++fist`]().

Produces
--------

A [`++rule`]().

Source
------
      ++  ar                                                ::  array as list
        |*  wit=fist
        |=  jon=json
        ?.  ?=([%a *] jon)  ~
        %-  zl
        |-  
        ?~  p.jon  ~
        [i=(wit i.p.jon) t=$(p.jon t.p.jon)]
      ::

Examples
--------

    ~zod/try=> :type; ((ar ni):jo a/~[n/'1' n/'2'])
    [~ u=~[1 2]]
    {[%~ u=it(@)] %~}


### `++at`

Reparse array as tuple

Reparser generator. Reparses an array as a fixed-length tuple of
[`++unit`]()s, using a list of `++fist`s.

Accepts
-------

`wil` is a [`++pole`](), a [`face`]()less list of [`++fist`]()s.

Produces
--------

A [`++rule`]().

Source
------

      ++  at                                                ::  array as tuple
        |*  wil=(pole fist)
        |=  jon=json
        ?.  ?=([%a *] jon)  ~
        =+  raw=((at-raw wil) p.jon)
        ?.((za raw) ~ (some (zp raw)))
      ::

Examples
--------

    ~zod/try=> ((at ni so ni ~):jo a/~[n/'3' s/'to' n/'4'])
    [~ u=[q=3 ~.to q=4]]
    ~zod/try=> :type; ((at ni so ni ~):jo a/~[n/'3' s/'to' n/'4'])
    [~ u=[q=3 ~.to q=4]]
    {{[%~ u=[q=@ @ta q=@]] %~} %~}
    ~zod/try=> ((at ni so ni ~):jo a/~[n/'3' s/'to' n/''])
    ~

### `++at-raw`

Reparse array to tuple

Reparser generator. Reparses a list of [`++json`]() with `wil` to a tuple of [`++unit`]()s.

Accepts
-------

`wil` is a [`++pole`](), a [face]()less list of [`++fist`]()s.

Produces
--------

A [`++rule`]().

Source
------

        ++  at-raw                                            ::  array as tuple
        |*  wil=(pole fist)
        |=  jol=(list json)
        ?~  wil  ~
        :-  ?~(jol ~ (-.wil i.jol))
        ((at-raw +.wil) ?~(jol ~ t.jol))
      ::

Examples
--------

    ~zod/try=> ((at-raw ni ni bo ~):jo ~[s/'hi' n/'1' b/&])
    [~ [~ 1] [~ u=%.y] ~]

### `++bo`

Reparse boolean

Reparser modifier. Reparses a boolean to the [`++unit`]() of a
boolean.

Accepts
-------

A [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  bo                                                ::  boolean
        |=(jon=json ?.(?=([%b *] jon) ~ [~ u=p.jon]))
      ::

Examples
--------

    ~zod/try=> (bo:jo [%b &])
    [~ u=%.y]
    ~zod/try=> (bo:jo [%b |])
    [~ u=%.n]
    ~zod/try=> (bo:jo [%s 'hi'])
    ~

### `++bu`

Reparse boolean not

Reparser modifier. Reparses the inverse of a boolean to the [`++unit`]()
of a loobean.


Accepts
-------

A [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  bu                                                ::  boolean not
        |=(jon=json ?.(?=([%b *] jon) ~ [~ u=!p.jon]))
      ::

Examples
--------

    ~zod/try=> (bu:jo [%b &])
    [~ u=%.n]
    ~zod/try=> (bu:jo [%b |])
    [~ u=%.y]
    ~zod/try=> (bu:jo [%s 'hi'])
    ~

### `++cu`

Reparse and transform

Reparser modifier. Reparses `jon` and slams the result through `wit`,
producing a [`++unit`]().

Accepts
-------

`wit` is a [`++fist`]().

`poq` is a [`gate`]() that accepts and returns a [noun]().

Produces
--------

A [`++fist`]().

Source
------

      ++  cu                                                ::  transform
        |*  [poq=$+(* *) wit=fist]
        |=  jon=json
        (bind (wit jon) poq)
      ::

Examples
--------

    ~zod/try=> ((cu dec ni):jo [%n '20'])
    [~ 19]
    ~zod/try=> ((cu dec ni):jo [%b &])
    ~

### `++da`

Reparse UTC date

Reparser modifier. Reparses a UTC date string to a [`++unit`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  da                                                ::  UTC date
        |=  jon=json
        ?.  ?=([%s *] jon)  ~
        (bind (stud (trip p.jon)) |=(a=date (year a)))
      ::

Examples
--------

    ~zod/try=> (da:jo [%s 'Wed, 29 Oct 2014 0:26:15 +0000'])
    [~ ~2014.10.29..00.26.15]
    ~zod/try=> (da:jo [%s 'Wed, 29 Oct 2012 0:26:15'])
    [~ ~2012.10.29..00.26.15]
    ~zod/try=> (da:jo [%n '20'])
    ~

### `++di`

Reparse millisecond date

Reparser modifier. Reparses the javascript millisecond date integer to a
[`++unit`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  di                                                ::  millisecond date
        |=  jon=json
        %+  bind  (ni jon)
        |=  a=@u  ^-  @da
        (add ~1970.1.1 (div (mul ~s1 a) 1.000))
      ::

Examples
--------

    ~zod/try=> (di:jo [%s '2014-10-29'])
    ~
    ~zod/try=> (di:jo [%n '1414545548325'])
    [~ ~2014.10.29..01.19.08..5333.3333.3333.3333]
    ~zod/try=> (di:jo [%n '1414545615128'])
    [~ ~2014.10.29..01.20.15..20c4.9ba5.e353.f7ce]
    ~zod/try=> (di:jo [%n '25000'])
    [~ ~1970.1.1..00.00.25]

### `++mu`

Reparse unit

Reparser modifier. Reparses `wit` to a [`++unit`]().

JSON units are considered to be either JSON null or the requested
value, and are reparsed to results of \~ or (some {value}) respectively.

Accepts
-------

`wit` is a [`++fist`]().

Produces
--------

A [`++fist`]().

Source
------

      ++  mu                                                ::  true unit
        |*  wit=fist
        |=  jon=json
        ?~(jon (some ~) (bind (wit jon) some))
      ::

Examples
--------

    ~zod/try=> ((mu ni):jo [%n '20'])
    [~ [~ u=q=20]]
    ~zod/try=> ((mu ni):jo [%n '15'])
    [~ [~ u=q=15]]
    ~zod/try=> ((mu ni):jo ~)
    [~ u=~]
    ~zod/try=> ((mu ni):jo [%s 'ma'])
    ~

### `++ne`

Reparse number as real

XX Currently unimplemented

A- yup, this will eventually reparse a floating point atom, but
interfaces for the latter are not currently stable.

### `++ni`

Reparse number as integer

Reparser modifier. Reparses an integer representation to a [`++unit]().

Accepts
-------

`jon` is a ++[`++json`]().

Produces
--------

The `++unit` of an atom.

Source
------

      ++  ni                                                ::  number as integer
        |=  jon=json 
        ?.  ?=([%n *] jon)  ~
        (rush p.jon dem)
      ::

Examples
--------

    ~zod/try=> (ni:jo [%n '0'])
    [~ q=0]
    ~zod/try=> (ni:jo [%n '200'])
    [~ q=200]
    ~zod/try=> (ni:jo [%n '-2.5'])
    ~
    ~zod/try=> (ni:jo [%s '10'])
    ~
    ~zod/try=> (ni:jo [%b |])
    ~
    ~zod/try=> (ni:jo [%n '4'])
    [~ q=4]
    ~zod/try=> (ni:jo [%a ~[b/& b/& b/& b/&]])
    ~

### `++no`

Reparse number as text

Reparser modifier. Reparses a numeric representation to a [++cord]().

Accepts
-------

`jon` is a `++json`.

Produces
--------

The [`++unit`]() of a `++cord`.

Source
------

      ++  no                                                ::  number as text
        |=  jon=json
        ?.  ?=([%n *] jon)  ~
        (some p.jon)
      ::

Examples
--------

    ~zod/try=> (no:jo [%n '0'])
    [~ u=~.0]
    ~zod/try=> (no:jo [%n '200'])
    [~ u=~.200]
    ~zod/try=> (no:jo [%n '-2.5'])
    [~ u=~.-2.5]
    ~zod/try=> (no:jo [%s '10'])
    ~
    ~zod/try=> (no:jo [%b |])
    ~
    ~zod/try=> (no:jo [%n '4'])
    [~ u=~.4]
    ~zod/try=> (no:jo [%a ~[b/& b/& b/& b/&]])
    ~

### `++of`

Reparse object to frond

Reparser generator. Reparses an object, succeeding if it corresponds to
one of the key-value pairs in `wer`.

Accepts
-------

`wer` is a [`++pole`](), a [`++face`]()less list of [`++cord`]() and
[`++fist`]() key-value pairs.

Produces
--------

The [`++unit`]() of a cell of a.....

Source
------

      ++  of                                                ::  object as frond
        |*  wer=(pole ,[cord fist])
        |=  jon=json
        ?.  ?=([%o [@ *] ~ ~] jon)  ~
        |-
        ?~  wer  ~
        ?:  =(-.-.wer p.n.p.jon)  
          ((pe -.-.wer +.-.wer) q.n.p.jon)
        ((of +.wer) jon)
      ::

Examples
--------

    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'hi'] ~ ~)
    [~ [%sem "hi"]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som n/'20'] ~ ~)
    [~ [%som q=20]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som s/'he'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%som s/'5'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'5'] ~ ~)
    [~ [%sem "5"]]
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem n/'2'] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem b/&] ~ ~)
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %a ~[s/'som' n/'4'])
    ~
    ~zod/try=> ((of sem/sa som/ni ~):jo %o [%sem s/'hey'] ~ [%sam s/'other value'] ~ ~)
    ~

### `++ot`

Reparse object as tuple

Reparser generator. For every key in `wer` that matches a key in the
[`++edge`], the fist in `wer` is applied to the corresponding value in
the [`++edge`](), the results of which are produced in a tuple.


Accepts
-------

`wer` is a [`++pole`]() of [`++cord`]() to [`++fist`]() key-value pairs.

Produces
--------

A [`++unit`]() of a tuple XX?

Source
------

      ++  ot                                                ::  object as tuple
        |*  wer=(pole ,[cord fist])
        |=  jon=json
        ?.  ?=([%o *] jon)  ~
        =+  raw=((ot-raw wer) p.jon)
        ?.((za raw) ~ (some (zp raw)))
      ::

Examples
--------

    ~zod/try=> (jobe [%sem s/'ha'] [%som n/'20'] ~)
    [%o p={[p='sem' q=[%s p=~.ha]] [p='som' q=[%n p=~.20]]}]
    ~zod/try=> ((ot sem/sa som/ni sem/sa ~):jo (jobe [%sem s/'ha'] [%som n/'20'] ~))
    [~ u=["ha" q=20 "ha"]]

### `++ot-raw`

Reparser generator. Reparses a map `jom` using `wer`; for every key in
`wer` that matches a key in `map`, the corresponding `++fist` is applied
to the corresponding value in `jom`, the results of which are produced
in a tuple.


Accepts
-------

`wer` is a [`++pole`]() of [`++cord`]() to [`++fist`]() key-value pairs.

Produces
--------

A [`++unit`]() of.

Source
------

        ++  ot-raw                                            ::  object as tuple
        |*  wer=(pole ,[cord fist])
        |=  jom=(map ,@t json)
        ?~  wer  ~
        =+  ten=(~(get by jom) -.-.wer)
        [?~(ten ~ (+.-.wer u.ten)) ((ot-raw +.wer) jom)]
        ::

Examples
--------

    ~zod/try=> ((ot-raw sem/sa som/ni sem/sa ~):jo (mo [%sem s/'ha'] [%som n/'20'] ~))
    [[~ u="ha"] [~ q=20] [~ u="ha"] ~]
    ~zod/try=> ((ot-raw sem/sa som/ni sem/sa ~):jo (mo [%sem s/'ha'] [%som b/|] ~))
    [[~ u="ha"] ~ [~ u="ha"] ~]

### `++om`

Parse object to map

Reparser modifier. Reparses a [`++json`]() object to a homogenous map
using `wit`.

Accepts
-------

`wit` is a [`++fist`]().

Produces
--------

A [`++unit`]() of...

Source
------

        ++  om                                                ::  object as map
        |*  wit=fist
        |=  jon=json
        ?.  ?=([%o *] jon)  ~
        (zm ~(run by p.jon) wit)
      ::

Examples
--------

    ~zod/try=> ((om ni):jo (jobe [%sap n/'20'] [%sup n/'5'] [%sop n/'177'] ~))
    [~ {[p='sup' q=q=5] [p='sop' q=q=177] [p='sap' q=q=20]}]
    ~zod/try=> ((om ni):jo (jobe [%sap n/'20'] [%sup n/'0x5'] [%sop n/'177'] ~))
    ~    

### `++pe`

Add prefix

Reparser modifier. Adds a static prefix `pre` to the parse result of
`wit`. See also: [`++stag`]().

Accepts
-------

`pre` is a prefix [`noun`]().

Produces
--------

The [`++unit`]() of a cell of [noun]() and the result of parsing `wit`.

Source
------

      ++  pe                                                ::  prefix
        |*  [pre=* wit=fist]
        (cu |*(a=* [pre a]) wit)
      ::

Examples
--------

    ~zod/try=> (ni:jo n/'2')
    [~ q=2]
    ~zod/try=> (ni:jo b/|)
    ~
    ~zod/try=> ((pe %hi ni):jo n/'2')
    [~ [%hi q=2]]
    ~zod/try=> ((pe %hi ni):jo b/|)
    ~

### `++sa`

Reparse string to tape

Reparser modifier. Reparses a [`++json`]() string to a [`++tape`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of a [`++tape`]().

Source
------

      ++  sa                                                ::  string as tape
        |=  jon=json
        ?.(?=([%s *] jon) ~ (some (trip p.jon)))
      ::

Examples
--------

    ~zod/try=> (sa:jo s/'value')
    [~ u="value"]
    ~zod/try=> (sa:jo n/'46')
    ~
    ~zod/try=> (sa:jo a/~[s/'val 2'])
    ~

### `++so`

Reparse string to cord

Reparser modifier. Reparses a string to a [`++cord`]().

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of a [`++cord`]().

Source
------

      ++  so                                                ::  string as cord
        |=  jon=json
        ?.(?=([%s *] jon) ~ (some p.jon))
      ::

Examples
--------

    ~zod/try=> (so:jo s/'value')
    [~ u=~.value]
    ~zod/try=> (so:jo n/'46')
    ~
    ~zod/try=> (so:jo a/~[s/'val 2'])
    ~

### `++su`

Reparse string

Reparser generator. Produces a reparser that applies `sab` to a string.

Accepts
-------

`sab` is a [`++rule`].

Produces
--------

A [`++rule`]().

Source
------

      ++  su                                                ::  parse string
        |*  sab=rule
        |=  jon=json
        ?.  ?=([%s *] jon)  ~
        (rush p.jon sab)
      ::

Examples
--------

    ~zod/try=> ((su:jo fed:ag) s/'zod')
    [~ 0]
    ~zod/try=> ((su:jo fed:ag) s/'doznec')
    [~ 256]
    ~zod/try=> ((su:jo fed:ag) s/'notship')
    ~
    ~zod/try=> ((su:jo fed:ag) n/'20')
    ~

### `++ul`

Reparse null

Reparser modifier. Reparses a null value.

Accepts
-------

`jon` is a [`++json`]().

Produces
--------

The [`++unit`]() of null.

Source
------

      ++  ul  |=(jon=json ?~(jon (some ~) ~))               ::  null

Examples
--------

    ~zod/try=> (ul:jo `json`~)
    [~ u=~]
    ~zod/try=> (ul:jo s/'null')
    ~
    ~zod/try=> (ul:jo b/|)
    ~
    ~zod/try=> (ul:jo b/&)
    ~

### `++za`

Pole of nonempty units

Determines if `pod` contains all non-empty units, producing a boolean. Used
internally.

Accepts
-------

`pod` is a [`++pole`]() of [`++unit`]().

Produces
--------

A boolean.

Source
------

      ++  za                                                ::  full unit pole
        |*  pod=(pole (unit))
        ?~  pod  &
        ?~  -.pod  |
        (za +.pod)
      ::

Examples
--------

    ~zod/try=> (za:jo ~[`1 `2 `3])
    %.y
    ~zod/try=> (za:jo ~[`1 ~ `3])
    %.n

### `++zl`

Collapse unit list

Produces a unit of the values of `lut` if every unit in `lut` is
nonempty. Otherwise, produces `~`. 

Accepts
-------

`lut` is a [`++list`]() of [`++unit`]()s.

Produces
--------

A boolean.

Source
------

      ++  zl                                                ::  collapse unit list
        |*  lut=(list (unit))
        ?.  |-  ^-  ?
            ?~(lut & ?~(i.lut | $(lut t.lut)))
          ~
        %-  some
        |-
        ?~  lut  ~
        [i=u:+.i.lut t=$(lut t.lut)]
      ::

Examples
--------

    ~zod/try=> (zl:jo `(list (unit))`~[`1 `2 `3])
    [~ u=~[1 2 3]]
    ~zod/try=> (zl:jo `(list (unit))`~[`1 `17 `3])
    [~ u=~[1 17 3]]
    ~zod/try=> (zl:jo `(list (unit))`~[`1 ~ `3])
    ~

### `++zp`

XX

Collapses a `++pole` of `++unit`s `but`, producing a tuple.

Accepts
-------

`but` is a [`++pole`]() of [`++unit`]().

Produces
--------

??

Source
------

      ++  zp                                                ::  unit tuple
        |*  but=(pole (unit))
        ?~  but  !!
        ?~  +.but  
          u:->.but
        [u:->.but (zp +.but)]
      ::

Examples
--------

    ~zod/try=> (zp:jo `(pole (unit))`~[`1 `2 `3])
    [1 2 3]
    ~zod/try=> (zp:jo `(pole (unit))`~[`1 `17 `3])
    [1 17 3]
    ~zod/try=> (zp:jo `(pole (unit))`~[`1 ~ `3])
    ! exit

### `++zm`

Collapse unit map

Produces a [`++unit`]() of the [`++map`]() `lum` of term to `++unit` key value
pairs, with all of the nonempty values stripped of their `++unit`
wrappers. If any of the `++units` in `lum` are empty, `~` is produced.
See also: [`++zp`](), [`++zl`]().

Accepts
-------

`lum` is a map of [`++term`]() to [`++unit`]()s.

Produces
--------

The `++unit` of a tuple of what were the key-value pairs of `lum`.

Source
------

      ++  zm                                                ::  collapse unit map
        |*  lum=(map term (unit))
        ?:  (~(rep by lum) | |=([[@ a=(unit)] b=?] |(b ?=(~ a))))
          ~
        (some (~(run by lum) need))
    ::

Examples
--------

    ~zod/try=> (zm:jo `(map term (unit ,@u))`(mo a/`4 b/`1 c/`2 ~))
    [~ {[p=%a q=4] [p=%c q=2] [p=%b q=1]}]
    ~zod/try=> (zm:jo `(map term (unit ,@u))`(mo a/`4 b/~ c/`2 ~))
    ~
    ~zod/try=> (~(run by `(map ,@t ,@u)`(mo a/1 b/2 c/3 ~)) (flit |=(a=@ (lth a 5))))
    {[p='a' q=[~ u=1]] [p='c' q=[~ u=3]] [p='b' q=[~ u=2]]}
    ~zod/try=> (zm:jo (~(run by `(map ,@t ,@u)`(mo a/1 b/2 c/3 ~)) (flit |=(a=@ (lth a 5)))))
    [~ {[p='a' q=1] [p='c' q=3] [p='b' q=2]}]
    ~zod/try=> (zm:jo (~(run by `(map ,@t ,@u)`(mo a/1 b/7 c/3 ~)) (flit |=(a=@ (lth a 5)))))
    ~
    ~zod/try=> (~(run by `(map ,@t ,@u)`(mo a/1 b/7 c/3 ~)) (flit |=(a=@ (lth a 5))))
    {[p='a' q=[~ u=1]] [p='c' q=[~ u=3]] [p='b' q=~]}


