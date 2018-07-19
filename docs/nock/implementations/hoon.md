---
navhome: /docs/
title: Hoon
sort: 11
---

# Hoon 

```
|=  {sub/* fol/*}
^-  *
?<  ?=(@ fol)
?:  ?=(^ -.fol)
  [$(fol -.fol) $(fol +.fol)]
?+    fol 
  !!
    {$0 b/@}
  ?<  =(0 b.fol)
  ?:  =(1 b.fol)  sub
  ?<  ?=(@ sub)
  =+  [now=(cap b.fol) lat=(mas b.fol)]
  $(b.fol lat, sub ?:(=(2 now) -.sub +.sub))
::
    {$1 b/*}
  b.fol
::
    {$2 b/{^ *}}
  =+  ben=$(fol b.fol)
  $(sub -.ben, fol +.ben)
::
    {$3 b/*}
  =+  ben=$(fol b.fol)
  .?(ben)
::
    {$4 b/*}
  =+  ben=$(fol b.fol)
  ?>  ?=(@ ben)
  +(ben)
::
    {$5 b/*}
  =+  ben=$(fol b.fol)
  ?>  ?=(^ ben)
  =(-.ben +.ben)
::
    {$6 b/* c/* d/*}
  $(fol =>(fol [2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]))
::
    {$7 b/* c/*}         $(fol =>(fol [2 b 1 c]))
    {$8 b/* c/*}         $(fol =>(fol [7 [[7 [0 1] b] 0 1] c]))
    {$9 b/* c/*}         $(fol =>(fol [7 c 2 [0 1] 0 b]))
    {$10 @ c/*}          $(fol c.fol)
    {$10 {b/* c/*} d/*}  =+($(fol c.fol) $(fol d.fol))
==
```
