---
navhome: /docs/
---


### `++scanf` XX

Formatted scan

    ++  scanf                                              ::  formatted scan
      |*  [tape (pole ,_:/(*$&(_rule tape)))]
      =>  .(+< [a b]=+<)
      (scan a (parsf b))

Scan with `;"`-interpolated parsers.

A- here there be monsters, monsters of my making. But the basic idea is
you use `;"` (which currently is parsed by sail but shouldn't be) to mix
literal text and [++rule]s, and apply this to text which is a
correspending mixture of aforementioned literals and sections parsable
by the relevant rules. ++parsf is the parser form that combines a
tape-rule mix into one big ++rule, ++norm being a parsf internal that
winnows the `;"` result into a list of discriminate literals and rules,
and ++bill doing the actual composing: ++\$:parsf just adds a layer that
collapses the result list to a tuple, such that (scanf "foo 1 2 bar"
;"foo {dem} {dem} bar") parses [1 2] and not [1 2 \~].

    ~zod/try=> `[p=@ud q=@ud]`(scanf "Score is 5 to 2" [;"Score is {n} to {n}"]:n=dim:ag)
    [p=5 q=2]

    ~zod/try=> =n ;~(pfix (star (just '0')) (cook |=(@ud +<) dim:ag))
    ~zod/try=> (scanf "2014-08-12T23:10:58.931Z" ;"{n}\-{n}\-{n}T{n}:{n}:{n}.{n}Z")
    [2.014 8 12 23 10 58 931]
    ~zod/try=> =dat (scanf "2014-08-12T23:10:58.931Z" ;"{n}\-{n}\-{n}T{n}:{n}:{n}.{n}Z")
    ~zod/try=> `@da`(year `date`dat(- [%& -.dat], |6 ~[(div (mul |6.dat (bex 16)) 1.000)]))
    ~2014.8.12..23.10.58..ee56

### `++parsf` XX

    ++  parsf                                              ::  make parser from:
      |^  |*  a=(pole ,_:/(*$&(_rule tape)))               ::  ;"chars{rule}chars"
          %-  cook  :_  (bill (norm a))
          |*  (list)
          ?~  +<  ~
          ?~  t  i
          [i $(+< t)]
      ::

`parsf` generates a `_rule` from a tape with rules embedded in it,
literal sections being matched verbatim. The parsed type is a tuple of
the embedded rules' results.

Two intermediate arms are used:

#### ++norm XX

      ::  .=  (norm [;"{n}, {n}"]:n=dim:ag)  ~[[& dim] [| ", "] [& dim]]:ag
      ++  norm                                             
        |*  (pole ,_:/(*$&(_rule tape)))
        ?~  +<  ~
        =>  .(+< [i=+<- t=+<+])
        :_  t=$(+< t)
        =+  rul=->->.i
        ^=  i
        ?~  rul     [%| p=rul]
        ?~  +.rul   [%| p=rul]
        ?@  &2.rul  [%| p=;;(tape rul)]
        [%& p=rul]
      ::

`norm` converts a `;"` pole of `[[%~. [%~. ?(tape _rule)] ~] ~]` into a
more convenient list of discriminated tapes and rules.

#### ++bill XX

      ::  .=  (bill ~[[& dim] [| ", "] [& dim]]:ag)
      ::  ;~(plug dim ;~(pfix com ace ;~(plug dim (easy)))):ag
      ++  bill
        |*  (list (each ,_rule tape))
        ?~  +<  (easy ~)
        ?:  ?=(| -.i)  ;~(pfix (jest (crip p.i)) $(+< t))
        %+  cook  |*([* *] [i t]=+<)
        ;~(plug p.i $(+< t))
      --
    ::

`bill` builds a parser out of rules and tapes, ignoring the literal
sections and producing a list of the rules' results.
