---
sort: 6
---

# `:gill, |*, "bartar", {$gill p/moss q/twig}`

Make a wet gate, a generically typed Hoon function.

## Expands to

```
:new   p
:core
+-  $
  q
--
```

## Syntax

Regular: *2-fixed*.

## Discussion

In a normal (dry) gate, your argument is converted into the
sample type.  In a generic (wet) gate, your argument type passes
through the function, rather as if it was a macro (there is still
only one copy of the code, however).

Genericity is a powerful and dangerous tool.  Use wet gates only
if you think you know what you're doing.  They are generally used
for system infrastructure, not user-level code.

## Examples

Wet and dry gates in a nutshell:

```
~zod:dojo> =foo :gate({a/* b/*} [b a])
~zod:dojo> =bar :gill({a/* b/*} [b a])
~zod:dojo> (foo %cat %dog)
[6.778.724 7.627.107]
~zod:dojo> (bar %cat %dog)
[%dog %cat]
```
