### `++wine`

Printable type

Used for pretty printing.

Source
------

        ++  wine  $|  ?(%noun %path %tank %void %wall %wool %yarn)
                  [%list p=term q=wine]                     ::
                  [%pear p=term q=@]                        ::
                  [%pick p=(list wine)]                     ::
                  [%plot p=(list wine)]                     ::
                  [%stop p=@ud]                             ::
                  [%tree p=term q=wine]                     ::
                  [%unit p=term q=wine]                     ::
              ==                                            ::

Examples
--------

See also: [`++calf`]()

    ~zod/try=> ~(dole ut p:!>(*@tas))
    [p={} q=[%atom p=%tas]]
    ~zod/try=> `wine`q:~(dole ut p:!>(*@tas))
    [%atom p=%tas]

    ~zod/try=> ~(dole ut p:!>(*path))
    [   p
      { [ p=1
            q
          [ %pick
              p
            ~[
              [%pear p=%n q=0]
              [%plot p=~[[%face p=%i q=[%atom p=%ta]] [%face p=%t q=[%stop p=1]]]]
            ]
          ]
        ]
      }
      q=%path
    ]
    ~zod/try=> `wine`q:~(dole ut p:!>(*path))
    %path

    ~zod/try=> ~(dole ut p:!>(*(map time cord)))
    [   p
      { [ p=1
            q
          [ %pick
              p
            ~[
              [%pear p=%n q=0]
              [ %plot
                  p
                ~[
                  [ %face
                    p=%n
                      q
                    [ %plot
                      p=~[[%face p=%p q=[%atom p=%da]] [%face p=%q q=[%atom p=%t]]]
                    ]
                  ]
                  [%face p=%l q=[%stop p=1]]
                  [%face p=%r q=[%stop p=1]]
                ]
              ]
            ]
          ]
        ]
      }
        q
      [ %tree
        p=%nlr
        q=[%plot p=~[[%face p=%p q=[%atom p=%da]] [%face p=%q q=[%atom p=%t]]]]
      ]
    ]
    ~zod/try=> `wine`q:~(dole ut p:!>(*(map time cord)))
    [ %tree
      p=%nlr
      q=[%plot p=~[[%face p=%p q=[%atom p=%da]] [%face p=%q q=[%atom p=%t]]]]
    ]


