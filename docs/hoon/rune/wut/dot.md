---
navhome: /docs/
next: true
sort: 2
title: ?. "wutdot"
---

# `?. "wutdot"` 

`[%wtdt p=hoon q=hoon r=hoon]`: branch on a boolean test, inverted.

## Expands to

```
?:(p r q)
```

## Syntax

Regular: *3-fixed*.

## Discussion

As usual with inverted forms, use `?.` ("wutdot") when the positive
hoon of an `?:` ("wutcol") is much heavier than the negative hoon.

## Examples

```
~zod:dojo> ?.((gth 1 2) 3 4)
3

~zod:dojo> ?.(?=(%a 'a') %not-a %yup)
%yup

~zod:dojo> ?.  %.y
             'this false case is less heavy than the true case'
           ?:  =(2 3)
             'two not equal to 3'
           'but see how \'r is much heavier than \'q?'
'but see how \'r is much heavier than \'q?'
```
