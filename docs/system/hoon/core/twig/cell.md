---
sort: 4
---

# Cell construction (`:` runes)

The cell twigs, `$cons` and friends, are simple and regular.
All `:` twigs expand to `$cons`.

## Twigs

```
|%
++  twig
  {$scon p/twig q/twig}
  {$conq p/twig q/twig r/twig s/twig}
  {$cons p/twig q/twig}
  {$cont p/twig q/twig r/twig}
  {$conl p/(list twig)} 
  {$conp p/(list twig)}
--
```

All construction stems expand to one natural stem, `$cons`, the
pair constructor, named for the Lisp special form.

Synthetic stems change the last letter to indicate the bulb type:
`$cont` for triple, `$conq` for quad, `$conp` for tuple, `$conl`
for list.  `$scon` is the reverse.

## Regular forms

The rune prefix is `:`.  Suffixes:  `-` for pair, `+` for triple,
`^` for quad, `*` for tuple, `~` for list, `_` for reverse.

### `:cons`, `:-`, "colhep", `{$cons p/twig q/twig}`, "construct"

Syntax: *2-fixed*.

The product: the cell of `p` and `q`, each compiled against
the subject.

### `:cont`, `:+`, "collus", `{$cont p/twig q/twig r/twig}`, "cons-3"

Syntax: *3-fixed*.

Expands to: `:cons(p :cons(q r))`.

### `:conq`, `:^`, "colket", `{$cont p/twig q/twig r/twig s/twig}`, "cons-4"

Syntax: *4-fixed*.

Expands to: `:cons(p :cont(q r s))`.

### `:conp`, `:*`, "coltar", `{$conp p/(list twig)}`, "construct tuple"

Syntax: *running*.

Expands by: `|-(?~(p ~ ?~(t.p i.p [%cons i.p $(p t.p)])))`.

### `:conl`, `:~`, "colsig", `{$conl p/(list twig)}`, "construct list"

Syntax: *running*.

Expands by: `|-(?~(p [%rock %n ~] [%cons i.p $(p t.p)]))`.

### `:scon`, `:_`, "colcab", `{$scon p/twig q/twig}`, "construct backward"

Syntax: *running*.

Expands to: `[%cons q p]`.

## Irregular forms

### Bracket tuple, `[p q r s]`

Translation:

```
[p q r s]   :conp(p q r s)
```
