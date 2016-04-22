---
sort: 10
---

# `? wut` (test) 

<list dataPreview="true" className="runes" linkToFragments="true"></list>

<kids className="runes"></kids>

## Twigs

```
|%
++  twig
  $%  {$or p/(list twig)}                               ::  ?|
      {$case p/wing q/(list (pair twig twig))}          ::  ?-
      {$if p/twig q/twig r/twig}                        ::  ?:
      {$lest p/twig q/twig r/twig}                      ::  ?.
      {$ifcl p/wing q/twig r/twig}                      ::  ?^
      {$deny p/twig q/twig}                             ::  ?<
      {$sure p/twig q/twig}                             ::  ?>
      {$deft p/wing q/twig r/(list (pair twig twig))}   ::  ?+
      {$and p/(list twig)}                              ::  ?&
      {$ifat p/wing q/twig r/twig}                      ::  ?@
      {$ifno p/wing q/twig r/twig}                      ::  ?~
      {$fits p/twig q/wing}                             ::  ?=
      {$not p/twig}                                     ::  ?!
  ==
--
```
