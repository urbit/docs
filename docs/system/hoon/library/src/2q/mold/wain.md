### `++wain`

    ++  wain  (list cord)                                   ::  text lines (no \n)

A list of lines. A `++wain` is used instead of a single [`++cord`]() with
`\n`.

See also: [`++lore`](), [`++role`]()

    ~zod/try=> `wain`/som/del/rok
    <|som del rok|>
    ~zod/try=> `wain`(lore ^:@t/=main=/bin/tree/hoon)
    <|
      !:
      ::  /===/bin/tree/hoon
      |=  ^  
      |=  [pax=path fla=$|(~ [%full ~])]
      =-  ~[te/-]~
      =+  len=(lent pax)
      =+  rend=?~(fla |=(a=path +:(spud (slag len a))) spud)
      |-  ^-  wain
      =+  ark=;;(arch .^(cy/pax))
      =-  ?~  q.ark  -
          [(crip (rend pax)) -]
      %-  zing
      %-  turn  :_  |=(a=@t ^$(pax (weld pax `path`/[a])))
      %-  sort  :_  aor
      %-  turn  :_  |=([a=@t ~] a)
      (~(tap by r.ark))
    |>



***
