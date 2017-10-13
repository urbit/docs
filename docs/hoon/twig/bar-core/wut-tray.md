---
navhome: /docs
sort: 9

---

# `:tray  |?  "barwut"`

`{$tray p/seed}`: form a lead trap.

## Expands to

```
:lead  :trap  p
```

```
^?  |.  p
```

## Syntax

Regular: *1-fixed*.

## Discussion

See this [discussion of the core variance model](../../../advanced).

## Examples

```
~zod:dojo> :per  ~  :like  :tray(%a)  :trap(%a)
<1?pqz $~>
~zod:dojo> :per  ~  :like  :tray(%a)  :trap(%b)
nest-fail
```
```
~zod:dojo> =>  ~  ^+  |?(%a)  |.(%a)
<1?pqz $~>
~zod:dojo> =>  ~  ^+  |?(%a)  |.(%b)
nest-fail
```
