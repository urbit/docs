### `++rege`

Regex caases

`++rege` defines the cases of a regular expression.

Source
------

        ++  rege  $|  ?(%dote %ende %sart %empt %boun %bout)    ::  parsed regex
                  [%brac p=@]                               ::  p is 256 bitmask
                  [%eith p=rege q=rege]                     ::  either
                  [%mant p=rege]                            ::  greedy 0 or more
                  [%plls p=rege]                            ::  greedy 1 or more
                  [%betw p=rege q=@u r=@u]                  ::  between q and r
                  [%bint p=rege q=@u]                       ::  min q
                  [%bant p=rege q=@u]                       ::  exactly q
                  [%manl p=rege]                            ::  lazy 0 or more
                  [%plll p=rege]                            ::  lazy 1 or more
                  [%betl p=rege q=@u r=@u]                  ::  between q and r lazy
                  [%binl p=rege q=@u]                       ::  min q lazy
              ==                                            ::

Examples
--------

See also: [`++rexp`](), [`++repg`](), [`++pars`]()

    ~zod/try=> (pars "[a-z]")
    [~ [%brac p=10.633.823.807.823.001.954.701.781.295.154.855.936]]
    ~zod/try=> (rexp "[a-z]" "abc1")
    [~ [~ {[p=0 q="a"]}]]


