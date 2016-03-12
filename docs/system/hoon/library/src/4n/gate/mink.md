### `++mink`

Mock interpreter

Bottom-level [mock]() (virtual nock) interpreter. Produces a
[`++tone`](), a nock computation result. If nock 11 is invoked, `sky`
computes on the subject and produces a [`++unit`]() result. An empty
result becomes a `%1` `++tone`, indicating a block.

Accepts
-------

`sub` is the subject as a [noun]().

`fol` is the formula as a noun.

`sky` is an [`%iron`]() gate invoked with [nock operator 11]().

Produces
--------

A `++tone`.

Source
------

    ++  mink
      ~/  %mink
      |=  [[sub=* fol=*] sky=$+(* (unit))]
      =+  tax=*(list ,[@ta *])
      |-  ^-  tone
      ?@  fol
        [%2 tax]
      ?:  ?=(^ -.fol)
        =+  hed=$(fol -.fol)
        ?:  ?=(%2 -.hed)
          hed
        =+  tal=$(fol +.fol)
        ?-  -.tal
          %0  ?-(-.hed %0 [%0 p.hed p.tal], %1 hed)
          %1  ?-(-.hed %0 tal, %1 [%1 (weld p.hed p.tal)])
          %2  tal
        ==
      ?+    fol
        [%2 tax]
      ::
          [0 b=@]
        ?:  =(0 b.fol)  [%2 tax]
        ?:  =(1 b.fol)  [%0 sub]
        ?:  ?=(@ sub)   [%2 tax]
        =+  [now=(cap b.fol) lat=(mas b.fol)]
        $(b.fol lat, sub ?:(=(2 now) -.sub +.sub))
      ::
          [1 b=*]
        [%0 b.fol]
      ::
          [2 b=[^ *]]
        =+  ben=$(fol b.fol)
        ?.  ?=(%0 -.ben)  ben
        ?>(?=(^ p.ben) $(sub -.p.ben, fol +.p.ben))
        ::?>(?=(^ p.ben) $([sub fol] p.ben)
      ::
          [3 b=*]
        =+  ben=$(fol b.fol)
        ?.  ?=(%0 -.ben)  ben
        [%0 .?(p.ben)]
      ::
          [4 b=*]
        =+  ben=$(fol b.fol)
        ?.  ?=(%0 -.ben)  ben
        ?.  ?=(@ p.ben)  [%2 tax]
        [%0 .+(p.ben)]
      ::
          [5 b=*]
        =+  ben=$(fol b.fol)
        ?.  ?=(%0 -.ben)  ben
        ?.  ?=(^ p.ben)  [%2 tax]
        [%0 =(-.p.ben +.p.ben)]
      ::
          [6 b=* c=* d=*]
        $(fol =>(fol [2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]))
      ::
          [7 b=* c=*]       $(fol =>(fol [2 b 1 c]))
          [8 b=* c=*]       $(fol =>(fol [7 [[0 1] b] c]))
          [9 b=* c=*]       $(fol =>(fol [7 c 0 b]))
          [10 @ c=*]        $(fol c.fol)
          [10 [b=* c=*] d=*]
        =+  ben=$(fol c.fol)
        ?.  ?=(%0 -.ben)  ben
        ?:  ?=(?(%hunk %lose %mean %spot) b.fol)
          $(fol d.fol, tax [[b.fol p.ben] tax])
        $(fol d.fol)
      ::
          [11 b=*]
        =+  ben=$(fol b.fol)
        ?.  ?=(%0 -.ben)  ben
        =+  val=(sky p.ben)
        ?~(val [%1 p.ben ~] [%0 u.val])
      ::
      ==
    ::

Examples
--------

    ~zod/try=> (mink [20 [4 0 1]] ,~)
    [%0 p=21]
    ~zod/try=> (mink [[90 5 3] [0 3]] ,~)
    [%0 p=[5 3]]
    ~zod/try=> (mink 20^[4 0 1] ,~)
    [%0 p=21]
    ~zod/try=> (mink [90 5 3]^[0 3] ,~)
    [%0 p=[5 3]]
    ~zod/try=> (mink [0]^[11 1 20] ,~)
    [%1 p=~[20]]
    ~zod/try=> (mink [0]^[11 1 20] |=(a=* `[40 a]))
    [%0 p=[40 20]]
    ~zod/try=> (mink [5]^[0 2] ,~)
    [%2 p=~]
    ~zod/try=> (mink [5]^[10 yelp/[0 1] 0 0] ,~)
    [%2 p=~[[~.yelp 5]]]


***
