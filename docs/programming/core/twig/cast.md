---
sort: 10
---

# Type manipulation (`^` runes).

`$cast`, `$like`, and `$name` let us adjust spans without
violating type constraints.

The `nest` algorithm which tests span subtyping is conservative;
it never allows invalid nests, it sometimes rejects valid nests.

## Regular forms

### `:like`, `^+`, "ketlus", `{$like p/twig q/twig}`

Syntax: *2-fixed*.

The product is the formula of `q` with the span of `p`, provided
nouns within the span of `q` can be shown to nest within the span
of `p`.

### `:cast`, `^-`, "ketlus", `{$like p/moss q/twig}`

Syntax: *2-fixed*.

Expands to: `:like($.p q)`.

`$like` is a typecheck by example; `$cast` is a typecheck by
mold.

### `:name`, `^=`, "kettis", `{$name p/@tas q/twig}

Syntax: *2-fixed*.

The product: the formula of `q`, with the span of `q` labeled by
symbol `p`.

### Irregular forms

### Backtick cast: `\`foo\`bar`

Translation:
```
`foo`bar    ^-(foo bar)
```

### Infix name: `foo=bar`

Translation:
```
foo=bar     ^=(foo bar)
```
