---
navhome: /docs/
---


### `++earn`

Purl to tape

Parses a [`++purl`]() `pul` to a [`++tape`]().

Accepts
-------

`pul` is a `++purl`.

Produces
--------

A `++tape`.

Source
------

    ++  earn                                                ::  purl to tape
          |^  |=  pul=purl
              ^-  tape
              :(weld (head p.pul) "/" (body q.pul) (tail r.pul))
          ::

Examples
--------

    ~zod/main=> (earn [| ~ [%| .127.0.0.1]] [~ ~] ~)
    "http://127.0.0.1/"
    ~zod/main=> (earn [| ~ `/com/google/www] [~ ~] ~)
    "http://www.google.com/"
    ~zod/main=> (earn [& ~ `/com/google/www] [~ ~] ~)
    "https://www.google.com/"
    ~zod/main=> (earn [& `200 `/com/google/www] [~ ~] ~)
    "https://www.google.com:200/"
    ~zod/main=> (earn [& `200 `/com/google/www] [~ /search] ~)
    "https://www.google.com:200/search"
    ~zod/main=> (earn [& ~ `/com/google/www] [`%html /search] ~)
    "https://www.google.com/search"
    ~zod/main=> (earn [& ~ `/com/google/www] [~ /search] [%q 'urbit'] ~)
    "https://www.google.com/search?q=urbit"
    ~zod/main=> (earn [& ~ `/com/google/www] [~ /search] [%q 'urbit escaping?'] ~)
    "https://www.google.com/search?q=urbit%20escaping%3F"

### `++body`

Render URL path

Renders URL path `pok` as a [`++tape`]().

Accepts
-------

`pok` is a [`++pork`]().

Produces
--------

A `++tape`.

Source
------

    ++  body
            |=  pok=pork  ^-  tape
            ?~  q.pok  ~
            |-
            =+  seg=(trip i.q.pok)
            ?~  t.q.pok
              ?~(p.pok seg (welp seg '.' (trip u.p.pok)))
            (welp seg '/' $(q.pok t.q.pok))
          ::
          
Examples
--------

    ~zod/main=> (body:earn ~ /foo/mol/lok)
    "foo/mol/lok"
    ~zod/main=> (body:earn `%htm /foo/mol/lok)
    "foo/mol/lok.htm"
    ~zod/main=> (body:earn `%htm /)
    ""

### `++head`

Render URL beginning

Renders a `++hart`, usually the beginning of a URL, as the [`++tape`]()
of a traditional URL.

Accepts
-------

`har` is a `++heart`.

Produces
--------

A `++tape`.

Source
------

    ++  head
            |=  har=hart
            ^-  tape
            ;:  weld
              ?:(&(p.har !=([& /localhost] r.har)) "https://" "http://")
            ::
              ?-  -.r.har
                |  (trip (rsh 3 1 (scot %if p.r.har)))
                &  =+  rit=(flop p.r.har)
                   |-  ^-  tape
                   ?~(rit ~ (weld (trip i.rit) ?~(t.rit "" `tape`['.' $(rit t.rit)])))
              ==
            ::
              ?~(q.har ~ `tape`[':' (trip (rsh 3 2 (scot %ui u.q.har)))])
            ==
          ::

Examples
--------

    ~zod/main=> (head:earn | ~ %| .127.0.0.1)
    "http://127.0.0.1"
    ~zod/main=> (head:earn & ~ %| .127.0.0.1)
    "https://127.0.0.1"
    ~zod/main=> (head:earn & [~ 8.080] %| .127.0.0.1)
    "https://127.0.0.1:8080"
    ~zod/main=> (head:earn & [~ 8.080] %& /com/google/www)
    "https://www.google.com:8080"

### `++tail`

Render query string

Renders a [`++quay`](), a query string in hoon, to the [`++tape`]() of a
traditional query string.

Accepts
-------

`kay` is a `++quay`.

Produces
--------

A `++tape`.

Source
------

    ++  tail
            |=  kay=quay
            ^-  tape
            ?:  =(~ kay)  ~
            :-  '?'
            |-  ^-  tape
            ?~  kay  ~
            ;:  weld
              (urle (trip p.i.kay))
              "="
              (urle (trip q.i.kay))
              ?~(t.kay ~ `tape`['&' $(kay t.kay)])
            ==
          --
        ::

Examples
--------

    ~zod/main=> (tail:earn ~)
    ""
    ~zod/main=> (tail:earn [%ask 'bid'] ~)
    "?ask=bid"
    ~zod/main=> (tail:earn [%ask 'bid'] [%make 'well'] ~)
    "?ask=bid&make=well"


