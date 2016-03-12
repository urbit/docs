### `++nock`

Virtual machine. See [Nock doc]().


Source
------

        ++  nock  $&  [p=nock q=nock]                           ::  autocons
                  [%3 p=nock]                               ::  cell test
                  [%4 p=nock]                               ::  increment
                  [%5 p=nock q=nock]                        ::  equality test
                  [%6 p=nock q=nock r=nock]                 ::  if, then, else
                  [%7 p=nock q=nock]                        ::  serial compose
                  [%8 p=nock q=nock]                        ::  push onto subject
                  [%9 p=@ q=nock]                           ::  select arm and fire
                  [%10 p=?(@ [p=@ q=nock]) q=nock]          ::  hint
                  [%11 p=nock]                              ::  grab data from sky
              ==                                            ::

Examples
--------

    ~zod/try=> !=([+(.) 20 -<])
    [[4 0 1] [1 20] 0 4]
    ~zod/try=> (nock !=([+(.) 20]))
    [p=[%4 p=[%0 p=1]] q=[%1 p=20]]



***
