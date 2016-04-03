---
sort: 1
---

# `:core, |%, "buccab", {$shoe p/twig}`

Generic core.

Produces: a core with `p`, an associative array with `++term` keys and `++foot` values.

Regular form: *Battery*

Example:

    /~zod/try=> 
    =a  |%
        ++  n  100
        ++  g  |=  b/@
                (add b n)
        --
    new var %a
    /~zod/try=> 
    (g.a 1)
    101

Here we create a core with two arms `n`, a constant, and `g`, a simple
function. `g` adds our constant `n` to whatever is passed to it.

    /~zod/try=> 
    =a  |%
        ++  l  |%
               ++  r  100
               ++  s  4
               --
        ++  g  |=  b/@
                (div (add b r:l) s:l)
        --
    changed %a
    /~zod/try=> 
    (g.a 4)
    26

Extending our previous example a bit, we nest a core inside our arm `l`
and make our function `g` a bit more complicated. `g` now computes the
sum of its argument and the arm `r` inside `l`, and divides that by `s`
inside `l`.

        ++  si                                                  ::  signed integer
          |%
          ++  abs  |=(a/@s (add (end 0 1 a) (rsh 0 1 a)))
          ++  dif  |=([a/@s b/@s] (sum a (new !(syn b) (abs b))))
          ++  dul  |=([a/@s b/@] =+(c=(old a) ?:(-.c (mod +.c b) (sub b +.c))))
          ++  fra  |=  [a/@s b/@s]
                   (new =(0 (mix (syn a) (syn b))) (div (abs a) (abs b)))
          ++  new  |=([a/? b/@] `@s`?:(a (mul 2 b) ?:(=(0 b) 0 +((mul 2 (dec b))))))
          ++  old  |=(a/@s [(syn a) (abs a)])
          ++  pro  |=  [a/@s b/@s]
                   (new =(0 (mix (syn a) (syn b))) (mul (abs a) (abs b)))
          ++  rem  |=([a/@s b/@s] (dif a (pro b (fra a b))))
          ++  sum  |=  [a/@s b/@s]
                   ~|  %si-sum
                   =+  [c=(old a) d=(old b)]
                   ?:  -.c
                     ?:  -.d
                       (new & (add +.c +.d))
                     ?:  (gte +.c +.d)
                       (new & (sub +.c +.d))
                     (new | (sub +.d +.c))
                   ?:  -.d
                     ?:  (gte +.c +.d)
                       (new | (sub +.c +.d))
                     (new & (sub +.d +.c))
                   (new | (add +.c +.d))
          ++  sun  |=(a/@u (mul 2 a))
          ++  syn  |=(a/@s =(0 (end 0 1 a)))
          --

`++si`, found in `hoon.hoon`, uses `|%` to create a core whose arms
contain functions used to calculate with signed integers, `@s`. In this
case our core is made up entirely of functions.
