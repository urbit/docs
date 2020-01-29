+++
title = "2.3.2 Molds"
weight = 28
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/molds/"]
+++

A mold is a function that coerces a [noun](/docs/glossary/noun/) to a type or crashes.

Let's take some examples from `hoon.hoon`. `|$` is a new rune as of the writing of this document so you may see this spelled in slightly different way if you don't have the latest version of `hoon.hoon`. `|$` is the mold builder rune which takes a list of molds and produces a mold.

```hoon
++  pair
  |$  [head tail]
  [p=head q=tail]
```

Here is a very simple mold builder. It takes two molds and produces a mold that is a pair of those with the faces `p` and `q`. An example of using this would be `(pair @ud @ud)` which would produce a mold for a cell of `@ud` and `@ud`.

```hoon
++  each
  |$  [this that]
  $%  [%| p=that]
      [%& p=this]
  ==
```

`++each` is very slightly more complicated than `pair`. `$%` is a rune that is a tagged union. The mold produced by this will match either `this` or `that`. An example of this would be `(each @ud @tas)` which will match either an `@ud` or a `@tas`.

```hoon
++  list
  |$  [item]
  $@(~ [i=item t=(list item)])
```
Here is a mold builder you've used previously. `$@` is a rune that will match the first thing if its sample is an [atom](/docs/glossary/atom/) and the second if the sample is a cell. You should be familiar at this point that a `list` is either `~`  or a pair of an item and a list of item.


```hoon
++  lest
  |$  [item]
  [i/item t/(list item)]
```
`lest` you may have heard of as a "non empty list." You can see that it lacks the `~` case that `list` has but it matches the second part of the `list` definition. Remember that Hoon types are defined by shape. `list` could also have been defined in terms of `lest` like this:

```hoon
++  list
  |$  [item]
  $@(~ lest)
```

Another possible way to write it could have been

```hoon
++  list
  |$  [item]
  $@(~ [i=item t=$])
```

Any of these would be equivalent.
