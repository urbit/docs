### `++qut`

Cord

Parse single-soq cord with `\{gap}/` anywhere in the middle, or triple-single
quote (aka triple-soq) cord, between which must be in an indented block.

Source
------

     ++  qut  ;~  pose                                       ::  cord
                 ;~  less  soqs
                   (ifix [soq soq] (boss 256 (more gon qit)))
                 ==
                 %-  inde  %+  ifix
                   :-  ;~  plug  soqs
                         ;~(pose ;~(plug (plus ace) vul) (just '\0a'))
                       ==
                   ;~(plug (just '\0a') soqs)
                 (boss 256 (star qat))
             ==
    ::

Examples
--------

    ~zod/try=> (scan "'cord'" qut)
    q=1.685.221.219
    ~zod/try=> 'cord'
    'cord'
    ~zod/try=> `@ud`'cord'
    1.685.221.219
    /~zod/try=> '''
                Heredoc isn't prohibited from containing quotes
                '''
    'Heredoc isn't prohibited from containing quotes'



***
