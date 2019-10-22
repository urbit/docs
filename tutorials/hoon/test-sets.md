+++
title = "2.8.1 Unit Testing with Ford"
weight = 39
template = "doc.html"
+++

# Unit Testing with Ford

In this walkthrough we will show how to use Ford as a testing suite.

First we will cover the essential molds, arms, and generators used for testing, followed by walking through the code that implements a series of tests for standard library sets, as described [here](../trees-sets-and-maps.md).

## Running our first test

To start with, lets try running the unit tests on sets by entering the following into the Dojo, and then we will work backwards to see how we obtained this output:
```hoon
> +test /sys/hoon/set
OK      /sys/hoon/set/test-set-all
OK      /sys/hoon/set/test-set-any
OK      /sys/hoon/set/test-set-apt
OK      /sys/hoon/set/test-set-bif
OK      /sys/hoon/set/test-set-del
OK      /sys/hoon/set/test-set-dif
OK      /sys/hoon/set/test-set-dig
OK      /sys/hoon/set/test-set-gas
OK      /sys/hoon/set/test-set-has
OK      /sys/hoon/set/test-set-int
OK      /sys/hoon/set/test-set-put
OK      /sys/hoon/set/test-set-rep
OK      /sys/hoon/set/test-set-run
OK      /sys/hoon/set/test-set-tap
OK      /sys/hoon/set/test-set-uni
OK      /sys/hoon/set/test-set-wyt
```
Here, we ran a generator called `+test` with a path argument `/sys/hoon/set`. The output tells us that all tests ran successfully. Running this generator automatically appends `/tests/` to the front of the path entered, so lets look at the beginning of `/tests/sys/hoon/set.hoon` to see what the `+test` generator took as an input:

```hoon
::  Tests for +in (set logic)
::
/+  *test
::
::  Testing arms
::
|%
```
We note that the first line that isn't a comment is `/+  *test`, which from [the previous lesson](../ford.md) you know means that we are importing the shared library `lib/test.hoon`. This is followed by a core which will contain arms that perform our tests, which we will see an example of shortly.

In `lib/test.hoon`, we find a core with a few gates: `expect-eq`, `expect-fail`, and `category`. The source for `expect-eq` is:
```hoon
++  expect-eq
  |=  [expected=vase actual=vase]
  ^-  tang
  ::
  =|  result=tang
  ::
  =?  result  !=(q.expected q.actual)
    %+  weld  result
    ^-  tang
    :~  [%palm [": " ~ ~ ~] [leaf+"expected" (sell expected) ~]]
        [%palm [": " ~ ~ ~] [leaf+"actual" (sell actual) ~]]
    ==
  ::
  =?  result  !(~(nest ut p.actual) | p.expected)
    %+  weld  result
    ^-  tang
    :~  :+  %palm  [": " ~ ~ ~]
        :~  [%leaf "failed to nest"]
            (~(dunk ut p.actual) %actual)
            (~(dunk ut p.expected) %expected)
    ==  ==
  result
```
This is the most frequently used gate in testing, so we may conclude that any testing suite will likely have the line `/+  *test` at the top so that we may utilize this gate. What does this gate do? Recall that a `vase` consists of `[p=type q=*]`. Then what `expect-eq` does is check to see if two `vase`s are equal, and pretty-prints the result of that test.

## Testing the functionality of set intersection

Here's one of the testing arms in the set testing core:
```hoon
++  test-set-int  ^-  tang
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  =/  s-des=(set @)  (sy (flop (gulf 1 7)))
  =/  s-dos=(set @)  (sy (gulf 8 9))
  =/  s-dup  (sy ~[1 1 4 1 3 5 9 4])
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-nul) s-asc)
    %+  expect-eq
      !>  ~
      !>  (~(int in s-asc) s-nul)
    ::  Checks with all elements different
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-dos) s-asc)
    ::  Checks success (total intersection)
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(int in s-asc) s-des)
    ::  Checks success (partial intersection)
    ::
    %+  expect-eq
      !>  (sy ~[9])
      !>  (~(int in s-dos) s-dup)
  ==
```
This arm is used to test whether the set intersection functionality works as expected. Let's walk through it line by line.
```hoon
++  test-set-int  ^-  tang
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  =/  s-des=(set @)  (sy (flop (gulf 1 7)))
  =/  s-dos=(set @)  (sy (gulf 8 9))
  =/  s-dup  (sy ~[1 1 4 1 3 5 9 4])
```
We see that this arm returns a `tang`, i.e. a pretty-printed message, and adds several sets to the subject which will be utilized in our tests.
```hoon
;:  weld
```
`;:  weld` calls `weld`, which is typically a binary function, as an n-ary function. This will allow us to concatenate all of `tang`s that are to be generated into a single `tang`.
```hoon
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-nul) s-asc)
```
`%+` is used to call a gate with a cell sample.  `expect-eq` is the gate, `!>  ~` is the head of the sample, and `!>  (~(int in s-nul) s-asc)` is the tail of the sample.  `!>` is a rune used to wrap a noun in its type - in other words, it produces a `vase`. We've seen this rune before when we learned about the type spear `-:!>`. Thus, what this block of code is doing is checking whether the expected `vase` that is the product of `!>  ~` is equal to the `vase` that is the product of `!>  (~(int in s-nul) s-asc)`. `s-nul` is simply the empty set, and here we are taking the intersection of the empty set with `s-asc`, a non-empty set. This ought to produce the empty set of course, and so when this block of code runs, we compare the expected result `!>  ~` (which is something we determined by hand) with the actual result `!>  (~(int in s-nul) s-asc)`.
```hoon
    %+  expect-eq
      !>  ~
      !>  (~(int in s-asc) s-nul)
```
This is another test to check if intersection works with the empty set, but we have swapped where `s-asc` and `s-nul` are. We do not know a priori whether this ordering matters (and of course it shouldn't), which is why it is important to perform both tests.


```hoon
    ::  Checks with all elements different
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-dos) s-asc)
```
Now we are checking if intersection works correctly when two non-empty sets share no common elements. We expect the intersection to be empty, so our expected `vase` is `!>  ~`, and we then compare it with what the set library produces when it takes the intersection of `s-dos` and `s-asc`.

```hoon
    ::  Checks success (total intersection)
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(int in s-asc) s-des)
```
`s-asc` and `s-des` both ought to be the set containing the integers 1 through 7, but `s-asc` was generated with the list `~[1,2,3,4,5,6,7]` while `s-des` was generated with the list `~[7,6,5,4,3,2,1]`. Sets have no ordering, so they ought to be the same. Thus, when we take their intersection, we should get the same set back. So, our expected `vase` is `!>  s-asc` and our actual `vase` is `!>  (~(int in s-asc) s-des)`.

```hoon
    ::  Checks success (partial intersection)
    ::
    %+  expect-eq
      !>  (sy ~[9])
      !>  (~(int in s-dos) s-dup)
```
Our last test in this arm is to check whether partial intersection works. Here, we compute the intersection of `s-dos` and `s-dup`. Our expectation is that this should return the set whose only element is 9, and so our expected vase is `!>  (sy ~[9])`. Then our actual vase is given by actually computing this intersection: `!>  (~(int in s-dos) s-dup)`.

We invite you to look further into the source of `/tests/sys/hoon/set.hoon` to see how other tests are written.

## Running many tests

When we ran the command `+test /sys/hoon/set` in the Dojo, what ultimately happened is that Ford looked inside of `/tests/sys/hoon/set.hoon` and found each of the tests in there and performed them in sequence. However, it is not necessary to put all tests you would like to run in a single source file, or even in a single folder. What `+test` actually does is take in a path and then performs all tests located in that folder (if it is a folder) and then looks for additional folders inside of the given path to find additional tests.

In other words, if you want to run all of the tests located in `/tests/sys/hoon/`, you would run `+test /sys/hoon`:

```hoon
> +test /sys/hoon
OK      /sys/hoon/auras/test-parse-p
OK      /sys/hoon/auras/test-parse-q
OK      /sys/hoon/auras/test-render-p
OK      /sys/hoon/auras/test-render-q
OK      /sys/hoon/bits/test-bits
OK      /sys/hoon/differ/test-berk
OK      /sys/hoon/differ/test-loss
OK      /sys/hoon/differ/test-lurk
OK      /sys/hoon/differ/test-lusk
OK      /sys/hoon/hashes/test-mug
OK      /sys/hoon/hashes/test-muk
OK      /sys/hoon/map/test-map-all
OK      /sys/hoon/map/test-map-any
...
```
We have truncated the results here, but you can already see that this command is performing tests found in subfolders of `/tests/sys/hoon`. This command runs quicky, but if you ran e.g. `+test /sys` you may be waiting quite awhile.
