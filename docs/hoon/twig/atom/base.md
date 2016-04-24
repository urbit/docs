---
sort: 1
---

# `:base`

`{$base p/$@(?($noun $cell $bean $null) {$atom p/aura})}`; atom mold

## Produces

A mold for the base in `p`.  `$noun` is any noun; `$atom` is any
atom; `$cell` is a cell of nouns; `$bean` is a loobean, `?(`@f`0
`@f`1)`.  `$null` is zero with aura `@n`.

## Syntax 

Irregular: `*` makes `$noun`, `^` makes `$cell`, `?` makes
`$bean`, `$~` makes `$null`, `@aura` makes atom `aura`.

## Examples

```
~zod:dojo> (* %foo)
7.303.014
~zod:dojo> ($~ 0)
~
~zod:dojo> (^ 0)
^
~zod:dojo> (@ux [1 1])
0x0
```

## Conventional auras


++  base                                                ::  base mold
  $@  $?  $noun                                         ::  any noun
          $cell                                         ::  any cell
          $bean                                         ::  loobean
          $void                                         ::  no nouns
          $null                                         ::  ~ == 0
      ==                                                ::
  {$atom p/aura}                                        ::  atom
    {$base p/base}                                      ::  base
