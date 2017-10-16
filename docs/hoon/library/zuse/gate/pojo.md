---
navhome: /docs/
---


### `++pojo`

Print JSON

Renders a [`++json`]() `val` as a [`++tape`]().

Accepts
-------

`val` is a [`json`]().

Produces
--------

A `++tape`.

Source
------

    ++  pojo                                                ::  print json
      |=  val=json
      ^-  tape
      ?~  val  "null"
      ?-    -.val
          %a
        ;:  weld
          "["
          =|  rez=tape
          |-  ^+  rez
          ?~  p.val  rez
          $(p.val t.p.val, rez :(weld rez ^$(val i.p.val) ?~(t.p.val ~ ",")))
          "]"
        ==
     ::
          %b  ?:(p.val "true" "false")
          %n  (trip p.val)
          %s
        ;:  welp
          "\""
          %+  reel
            (turn (trip p.val) jesc)
          |=([p=tape q=tape] (welp +<))
          "\""
        ==
          %o
        ;:  welp
          "\{"
          =+  viz=(~(tap by p.val) ~)
          =|  rez=tape
          |-  ^+  rez
          ?~  viz  rez
          %=    $
              viz  t.viz
              rez
            :(welp rez "\"" (trip p.i.viz) "\":" ^$(val q.i.viz) ?~(t.viz ~ ","))
          ==
          "}"
        ==
      ==
    ::

Examples
--------

    ~zod/try=> (pojo [%n '12.6'])
    "12.6"
    ~zod/try=> (crip (pojo %n '12.6'))
    '12.6'
    ~zod/try=> (crip (pojo %s 'samtel'))
    '"samtel"'
    ~zod/try=> (crip (pojo %a ~[(jone 12) (jape "ha")]))
    '[12,"ha"]'
    ~zod/try=> (crip (pojo %a ~[(jone 12) ~ (jape "ha")]))
    '[12,null,"ha"]'
    ~zod/try=> (crip (pojo %o (mo sale/(jone 12) same/b/| ~)))
    '{"same":false,"sale":12}'


