### `++wall`

List of lines


A `++wall` is used instead of a single [`++tape`]() with
`\n`.

Source
------

    ++  wall  (list tape)                                   ::  text lines (no \n)

Examples
--------

See also: [`++wash`]()

    ~zod/try=> `wall`(wash [0 20] leaf/<(bex 256)>)
    <<
      "\/115.792.089.237.\/"
      "  316.195.423.570."
      "  985.008.687.907."
      "  853.269.984.665."
      "  640.564.039.457."
      "  584.007.913.129."
      "  639.936"
      "\/                \/"
    >>


