---
navhome: /docs/
sort: 2
---

# `:lest  ?.  "wutdot"` 

`{$lest p/seed q/seed r/seed}`: branch on a boolean test, inverted.

## Expands to

```
:if  p
  r
q
```

```
?:(p r q)
```

## Syntax

Regular: *3-fixed*.

## Discussion

As usual with inverted forms, use `:lest` when the positive
twig of an `:if` is much heavier than the negative twig.

## Examples

```
~zod:dojo> :lest((gth 1 2) 3 4)
3
~zod:dojo> :lest(:fits(%a 'a') %not-a %yup)
%yup
~zod:dojo> :lest  %.y
             'this false case is less heavy than the true case'
           :if  =(2 3)
             'two not equal to 3'
           'but see how \'r is much heavier than \'q?'
'but see how \'r is much heavier than \'q?'
```

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
