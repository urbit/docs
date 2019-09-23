+++
title = "2.3.2 Molds"
weight = 28
template = "doc.html"
+++

A mold is a function that coerces a noun to a type or crashes.

Let's take some examples from `hoon.hoon`. `|$` is a new rune as of the writing of this document so you may see this spelled in slightly different way if you don't have the latest version of `hoon.hoon`. `|$` is the mold builder rune which takes a list of molds and produces a mold.

```
++  pair
  |$  [head tail]
  [p=head q=tail]
```

Here is a very simple mold builder. It takes two molds and produces a mold that is a pair of those with the faces `p` and `q`. An example of using this would be `(pair @ud @ud)` which would produce a mold for a cell of `@ud` and `@ud`.

```
++  each
  |$  [this that]
  $%  [%| p=that]
      [%& p=this]
  ==
```

`++each` is very slightly more complicated than `pair`. `$%` is a rune that is a tagged union. The mold produced by this will match either `this` or `that`. An example of this would be `(each @ud @tas)` which will match either an `@ud` or a `@tas`.

```
++  list
  |$  [item]
  $@(~ [i=item t=(list item)])
```
Here is a mold builder you've used previously. `$@` is a rune that will match the first thing if it's sample is an atom and the second if the sample is a cell. You should be familiar at this point that a `list` is either `~`  or a pair of an item and a list of item.


```
++  lest
  |$  [item]
  [i/item t/(list item)]
```
`lest` you may have heard of as a "non empty list." You can see that it lacks the `~` case that `list` has but it matches the second part of the `list` definition. Remember that Hoon types are defined by shape. `list` could also have been defined in terms of `lest` like this:

```
++  list
  |$  [item]
  $@(~ lest)
```

Another possible way to write it could have been

```
++  list
  |$  [item]
  $@(~ [i=item t=$])
```

Any of these would be equivalent.
