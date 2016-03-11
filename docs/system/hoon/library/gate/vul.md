### `++vul`

Comments to null

Source
------

    ++  vul  %-  cold  :-  ~                                ::  comments
             ;~  plug  col  col
               (star prn)
               (just `@`10)
             ==

Parse comments and produce a null. Note that a comment must be ended
with a newline character.

Examples
--------

    ~zod/try=> (scan "::this is a comment \0a" vul)
    ~
    ~zod/try=> (scan "::this is a comment " vul)
    ! {1 21}
    ! exit


