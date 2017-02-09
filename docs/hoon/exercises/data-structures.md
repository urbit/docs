---
navhome: /docs/
sort: 4
comments: true
---

# Sets and Maps

Sets are constructed with `++silt`.  A set is a non-ordered
collection of unique elements.  

```
(silt `(list @t)`['urbit' 'arvo' 'hoon' 'arvo' ~])
```

We'll refer to this particular set as `s` in the exercises.  It
is of type `(set @t)` since each element is a `@t`.

The `++in` core contains library functions for dealing with sets.
For example, `++has:in` checks whether an element is in the set.
Thus, `(~(has in s) 'arvo')` returns yes.  To complete these
exercises, you'll need to refer to the [library reference for
`++in`](/docs/hoon/library/2h).

1.  Create another set, `l`, with members `'c'`, `'hoon'`,
    `'javacript'`, `'python'`.

1.  At the dojo, take the union of `s` and `l`.  Delete
    `'javascript'` from the result, and add `'coffeescript'`.

1.  Create an alphabetized list of the members of the set created
    in the previous exercise.

1.  Take the Cartesian product of `s` and `l`.  The Cartesian
    product of two sets is the set of all cells `[a b]` where
    `a` is in `s` and `b` is in `l`.

The `++by` core is to maps as `++in` is to sets.  Refer to its
[library reference](/docs/hoon/library/2i).  Note that since a
map is basically a set of pairs (although not every set of pairs
is a map), most functions in `++in` have analogues in `++by`.

The constructor for maps is `++malt`.

```
(malt `(list {@t @ud})`[['kaylee' 3] ['wash' 2] ['mal' 4] ['summer' 1] ~])
```

Let this map be `m`.

1.  Create another map, `s`, with `'spring'` mapped to `1`,
    `'summer'` mapped to `2`, `'autumn'` mapped to `'3'`, and
    `'winter'` mapped to `4`.

1.  In `m`, change the value at `'mal'` to 5 and add `'cobb'`
    with value 4.

1.  Take the union of `m` and `s`, then get the value at the key
    `summer`.  Try taking the union of `s` and `m` (i.e. flip the
    order) and see if it makes a difference.  Try intersecting
    them in both orders.

