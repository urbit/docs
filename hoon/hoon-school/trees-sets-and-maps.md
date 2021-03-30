+++
title = "2.4 Standard Library: Trees, Sets, and Maps"
weight = 30
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/trees-sets-and-maps/"]
+++

Along with lists, the Hoon standard library also supports trees, sets, and maps as data structures. A Hoon `tree` is the data structure for a binary tree. A Hoon `set` is the data structure for a set of values. A Hoon `map` is the data structure for a set of `[key value]` pairs.

In this lesson we'll cover each.

## Trees

We use `tree` to make a binary tree data structure in Hoon, e.g., `(tree @)` for a binary tree of [atoms](/docs/glossary/atom/).

There are two kinds of `tree` in Hoon: (1) the null tree, `~`, and (2) a non-null tree which is a cell with three parts. Part (i) is the node value, part (ii) is the left child of the node, and part (iii) is the right child of the node. Each child is itself a tree. The node value has the face `n`, the left child has the face `l`, and the right child has the face `r`. The following diagram provides an illustration of a `(tree @)` (without the faces):

```
          12
        /    \
      8       14
    /   \    /   \
   4     ~  ~     16
 /  \            /  \
~    ~          ~    ~
```

Hoon supports trees of any type that can be constructed in Hoon, e.g.: `(tree @)`, `(tree ^)`, `(tree [@ ?])`, etc. Let's construct the tree in the diagram above in the dojo, casting it accordingly:

```hoon
> `(tree @)`[12 [8 [4 ~ ~] ~] [14 ~ [16 ~ ~]]]
{4 8 12 14 16}
```

Notice that we don't have to insert the faces manually; by casting the [noun](/docs/glossary/noun/) above to a `(tree @)` Hoon inserts the faces for us. Let's put this noun in the dojo subject with the face `b` and pull out the tree at the left child of the `12` node:

```hoon
> =b `(tree @)`[12 [8 [4 ~ ~] ~] [14 ~ [16 ~ ~]]]

> b
{4 8 12 14 16}

> l.b
-find.l.b
find-fork-d
```

This didn't work because we haven't first proved to Hoon that `b` is a non-null tree. A null tree has no `l` in it, after all. Let's try again, using `?~` to prove that `b` isn't null. We can also look at `r` and `n`:

```hoon
> ?~(b ~ l.b)
{4 8}

> ?~(b ~ r.b)
{14 16}

> ?~(b ~ n.b)
12
```

### Find and Replace

Here's a program that finds and replaces certain atoms in a `(tree @)`.

```hoon
|=  [nedl=@ hay=(tree @) new=@]
^-  (tree @)
?~  hay  ~
:+  ?:  =(n.hay nedl)
      new
    n.hay
  $(hay l.hay)
$(hay r.hay)
```

`nedl` is the atom to be replaced, `hay` is the tree, and `new` is the new atom with which to replace `nedl`. Save this as `findreplacetree.hoon` and run in the dojo:

```hoon
> b
{4 8 12 14 16}

> +findreplacetree [8 b 94]
{4 94 12 14 16}

> +findreplacetree [14 b 94]
{4 8 12 94 16}
```

## Sets

Use `set` to create a data structure for a set of values, e.g., `(set @)` for a set of atoms. The `in` [core](/docs/glossary/core/) in the Hoon standard library contains the various functions for operating on sets. See the standard library reference documentation for sets [here](@/docs/hoon/reference/stdlib/2h.md).

As with `list`s and `tree`s, there are two categories of sets: null `~`, and non-null. Hoon implements sets using trees for the underlying noun.

Two common methods for populating a set include (1) creating it from a list of values using the `sy` function, and (2) inserting items into a set using the `put` [arm](/docs/glossary/arm/) of the `in` core.

Using `sy`:

```hoon
> =c (sy ~[11 22 33 44 55])

> c
[n=11 l={} r={22 55 33 44}]

> `(set @)`c
{11 22 55 33 44}

> =c `(set @)`c
```

Note that the dojo does not necessarily print elements of a set in the same order they were given. Mathematically speaking, sets are not ordered, so this is alright. There is no difference between two sets with the same elements written in a different order. Try forming `c` with a different ordering and check this.

And we can add an item to the set using `put` of `in`:

```hoon
> (~(put in c) 77)
[n=11 l={} r={22 77 55 33 44}]

> `(set @)`(~(put in c) 77)
{11 22 77 55 33 44}
```

You can remove items using `del` of `in`:

```hoon
> (~(del in c) 55)
[n=11 l={} r={22 33 44}]

> `(set @)`(~(del in c) 55)
{11 22 33 44}
```

Check whether an item is in the set using `has` of `in`:

```hoon
> (~(has in c) 33)
%.y

> (~(has in c) 100)
%.n
```

You can apply a [gate](/docs/glossary/gate/) to each item of a set using `run` of `in` and produce a new set from the products:

```hoon
> c
{11 22 55 33 44}

> (~(run in c) |=(a=@ +(a)))
{56 45 23 12 34}
```

You can also apply a gate to all items of the set and return an accumulated value using `rep` of `in`:

```hoon
> c
{11 22 55 33 44}

> (~(rep in c) add)
b=165
```

The standard library also has the union and intersection functions for sets:

```hoon
> c
{11 22 55 33 44}

> =d `(set @)`(sy ~[33 44 55 66 77])

> d
{66 77 55 33 44}

> (~(int in c) d)
[n=33 l=[n=55 l={} r={}] r=[n=44 l={} r={}]]

> `(set @)`(~(int in c) d)
{55 33 44}

> (~(uni in c) d)
[n=11 l=[n=66 l={} r={}] r=[n=33 l={22 77 55} r={44}]]

> `(set @)`(~(uni in c) d)
{66 11 22 77 55 33 44}
```

It may be convenient to turn a set into a list for some operation and then operate on the list. You can convert a set to a list using `tap` of `in`:

```hoon
> c
{11 22 33 44 55}

> ~(tap in c)
~[44 33 55 22 11]
```

There are other set functions in the Hoon standard library we won't cover here.

### Cartesian Product

Here's a program that takes two sets of atoms and returns the [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product) of those sets. A Cartesian product of two sets `a` and `b` is a set of all the cells whose head is a member of `a` and whose tail is a member of `b`.

```hoon
|=  [a=(set @) b=(set @)]
=/  c=(list @)  ~(tap in a)
=/  d=(list @)  ~(tap in b)
=|  acc=(set [@ @])
|-  ^-  (set [@ @])
?~  c  acc
%=  $
  c  t.c
  acc  |-  ?~  d  acc
       %=  $
         d  t.d
         acc  (~(put in acc) [i.c i.d])
       ==
==
```

Save this as `cartesian.hoon` in your urbit's pier and run in the dojo:

```hoon
> =c `(set @)`(sy ~[1 2 3])

> c
{1 2 3}

> =d `(set @)`(sy ~[4 5 6])

> d
{5 6 4}

> +cartesian [c d]
{[2 6] [1 6] [3 6] [1 4] [1 5] [2 4] [3 5] [3 4] [2 5]}
```

## Maps

Use `map` to create a set of key-value pairs, e.g., `(map @tas *)` for a set of `@tas` and `*` pairs. The `@tas` value serves as the 'key', which is a mechanism for tagging or naming the value, `*`. The key of each key-value pair is unique; every value in a map gets its own unique name.

One example use case is for storing customer information as a set of pairs: `(map [employee-name employee-data])`.

The `by` core in the Hoon standard library contains the various functions for operating on maps. Many of these functions are similar to the set functions of the `in` core. See the standard library reference documentation for maps [here](@/docs/hoon/reference/stdlib/2i.md). As was the case with sets, the underlying noun of each map is a tree.

Two common methods for populating a map include (1) creating it from a list of key-value cells using the `my` function, and (2) inserting items into a map using the `put` arm of the `by` core.

Using `my`:

```hoon
> =c (my ~[[%one 1] [%two 2] [%three 3]])

> c
[n=[p=%one q=1] l={[p=%two q=2]} r={[p=%three q=3]}]

> =c `(map @tas @)`c

> c
{[p=%two q=2] [p=%one q=1] [p=%three q=3]}
```

We can add a key-value pair with `put` of `by`:

```hoon
> (~(put by c) [%four 4])
[n=[p=%one q=1] l={[p=%four q=4] [p=%two q=2]} r={[p=%three q=3]}]

> `(map @tas @)`(~(put by c) [%four 4])
{[p=%four q=4] [p=%two q=2] [p=%one q=1] [p=%three q=3]}
```

Delete a key-value pair with `del` of `by`, keeping in mind that you only need to pick the key of the pair to be deleted:

```hoon
> `(map @tas @)`(~(del by c) %two)
{[p=%one q=1] [p=%three q=3]}
```

You can produce the value of a key-value pair using `get` of `by` on the key:

```hoon
> (~(get by c) %two)
[~ 2]
```

This result may be unexpected. Why didn't it just give us `2`? The answer has to do with the possibility that a requested key may not be in the map. For example:

```hoon
> (~(get by c) %chicken)
~
```

Because there is no `%chicken` key in `c`, `get` simply returns `~` to indicate it's not in the map. Otherwise it returns a pair like the one you see in the next to last example.

`get` of `by` returns the key's value as a `unit`, not as raw data. There are two kinds of `unit`s: null `~`, and non-null. A non-null `unit` is a pair of `[~ value]`. Unit types are constructed the way list, set, and map types are; for example, `(unit @)` is the type for a unit whose value is an atom.

If you want to get some key value without producing a unit, use `got` instead:

```hoon
> (~(got by c) %two)
2

> (~(got by c) %chicken)
####
ford: %ride failed to execute:
```

Use `has` of `by` to see whether a certain key is in the map:

```hoon
> (~(has by c) %two)
%.y

> (~(has by c) %chicken)
%.n
```

You can use `run` of `by` to apply a gate to each value in a map, producing a map with the modified values:

```hoon
> (~(run by c) |=(a=@ (mul 2 a)))
{[p=%two q=4] [p=%one q=2] [p=%three q=6]}
```

There are other map functions in the Hoon standard library that didn't cover here.
