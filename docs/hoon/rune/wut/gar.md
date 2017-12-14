---
navhome: /docs/
next: true
sort: 3
title: ?> "wutgar"
---

# `?> "wutgar"`

`[%wtgr p=hoon q=hoon]`: positive assertion.

## Expands to

```
?.(p !! q)
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> ?>(=(3 3) %foo)
%foo

~zod:dojo> ?>(=(3 4) %foo)
ford: build failed
```
