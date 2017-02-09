---
navhome: /docs/
sort: 2
---

# `:wing`

`{$wing p/(list limb)`; a limb search path.

### Produces

If `p` is null, the subject at leg `1`.  Otherwise, let `x` be
the `$wing` of `t.p`.  `x` is either an arm or a leg.  We compute
limb `i.p` on some subject leg `s`, where:

If `x` is a leg/slot number, `s` is `x`.

If `x` is an arm/subject-formula pair `[s f]`, `s` is `s.x`.

### Syntax

Irregular: `a.b` finds limb `a` within limb `b` of the subject.

### Discussion

It may be slightly hard to follow the formal definition above.

Intuitively, Hoon wings are written in the opposite order
from attribute dot-paths in most languages.  Hoon `a.b.c` is Java
`c.b.a`; it means "a within b within c."

Any item in the wing can resolve to a leg (fragment) or arm
(computation).  But if a non-terminal item in the wing would
resolve to an arm, it resolves instead to the subject of the arm
-- in other words, the core exporting that name.

The mysterious idiom `..foo` produces the leg `foo` if `foo`
is a leg; the core exporting `foo` if `foo` is an arm.  Since `.`
is the same limb as `+`, `..foo` is the same wing as `+1.foo`.

### Examples

```
~zod:dojo> =a [foo=3 bar=[baz=1 moo=2]]
~zod:dojo> bar.a
[baz=1 moo=2]
~zod:dojo> moo.bar.a
2
```
