---
sort: 12
---

# Irregular leaves

<list dataPreview="true" className="runes" linkToFragments="true"></list>

<kids className="runes"></kids>

## Twigs

```
|%
++  base                                                ::  base mold
  $@  $?  $noun                                         ::  any noun
          $cell                                         ::  any cell
          $bean                                         ::  loobean
          $void                                         ::  no nouns
          $null                                         ::  ~ == 0
      ==                                                ::
  {$atom p/odor}                                        ::  atom
::                                                      ::
++  pint  {p/{p/@ q/@} q/{p/@ q/@}}                     ::  line+column range
++  spot  {p/path q/pint}                               ::  range in file
++  woof  $@(@ {$~ p/twig})                             ::  string w/embed
::                                                      ::
++  tune                                                ::  complex face
  $:  p/(map term (unit twig))                          ::  definitions
      q/(list twig)                                     ::  bridges
  ==                                                    ::
::                                                      ::
++  twig                                                ::
  $%  {$base p/base}                                    ::  base
      {$bust p/base}                                    ::  bunt base
      {$dbug p/spot q/twig}                             ::  debug info in trace
      {$hand p/span q/nock}                             ::  premade result
      {$knit p/(list woof)}                             ::  assemble string
      {$leaf p/(pair term @)}                           ::  symbol
      {$limb p/term}                                    ::  pulls limb p
      {$lost p/twig}                                    ::  not to be taken
      {$rock p/term q/*}                                ::  fixed constant
      {$sand p/term q/*}                                ::  unfixed constant
      {$tell p/(list twig)}                             ::  render as tape
      {$tune p/$@(term tune)}                           ::  face on subject
      {$wing p/wing}                                    ::  pulls p
      {$yell p/(list twig)}                             ::  render as tank
  ==
--
```
