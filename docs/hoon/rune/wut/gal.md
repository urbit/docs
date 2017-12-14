---
navhome: /docs/
next: true
sort: 4
title: ?< "wutgal"
---

# `?< "wutgal"`

`[%wtgl p=hoon q=hoon]`: negative assertion.

## Expands to

```
?:(p !! q)
```

## Syntax

Regular: *2-fixed*.

## Examples

```
~zod:dojo> ?<(=(3 4) %foo)
%foo

~zod:dojo> ?<(=(3 3) %foo)
ford: build failed
```

