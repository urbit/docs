---
sort: 4
comments: true
---

# Sets, Maps, and Queues

Sets are constructed with `++silt`.  A set is a non-ordered
collection of unique elements.  

```
(silt `(list @t)`['urbit' 'arvo' 'hoon' 'arvo' ~])
```

We'll refer to this particular set as `s` in the exercises.  It
is of type `(set @t)` since each element is a `@t`.

The `++in` core contains library functions for dealing with sets.
For example, `++has:in` checks whether an element is in the set.
Thus, `(~(has in s) 'arvo')` returns yes.


