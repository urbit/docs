---
navhome: /docs/
sort: 3
comments: true
---

# Lists

In the following exercises, let `l` be `` `(list @t)`['u' 'r' 'b'
'i' 't' ~]``

1.  A list is a null-terminated tuple of values.  For example,
    `[1 2 3 ~]` is a list of three integers, and
    `['a' 'b' 'c' ~]` is a list of three cords.  Try casting
    `['a' 'b' 'c' ~]` to `(list @t)` and to `(list @)`.  Lists
    are parameterized with the type of the values.

1.  `++flop` takes a list and produces its reverse.  Use it to
    reverse `l`.

1.  Repeat the above exercise without using `++flop`.

1.  `++sort` takes a list and a comparison function to sort a
    list.  The function must take two elements of the list and
    produce true if the first element is "less than" the other.
    Sort `l` alphabetically.  Sort it reverse alphabetically.

1.  `++turn` takes a list and a function and applies the function
    to each element in the list, forming a new list of the
    results.  This is called "map" in many functional languages.
    The function must accept an element of the list.  Use the
    fact that subtracting 32 from a lowercase letter gives the
    equivalent uppercase letter (i.e. `(sub 'a' 'A')` is 32) to
    change every character in `l` to uppercase.

1.  `++welp` concatentates two lists.  Concatenate `l` with the
    reverse of `l`.

1.  `++snag` takes a number `n` and a list and produces the
    element at index `n`.  Pull out the `'i'` in `l`.
