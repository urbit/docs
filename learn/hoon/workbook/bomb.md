+++
title = "Bomb Defusing"
weight = 7
template = "doc.html"
+++
In this exercise, we will build a generator that takes a list of wires to be cut
in order to defuse a bomb. The bomb is defused according to the following rules.

There are 6 possible colors of wire: white, black, purple, red, green, and
orange.

If you cut a white cable, you cannot cut white or black cable.

If you cut a red cable, you must cut a green cable.

If you cut a black cable, you cannot cut a white, green, or orange cable.

If you cut an orange cable, you must cut a red or cable.

If you cut a green cable, you must cut an orange or white cable.

If you cut a purple cable, you cannot cut a purple, green, orange, or white
cable.

If the list of cuts does not result in the bomb exploding, the output should be
a tape `bomb defused`. If any of the rules were broken, it should output the
tape `boom`.


```
!:
:-  %say
|=  [* [cuts=(list tape) ~] ~]
:-  %noun
=<
(defuse cuts)
|%
++  defuse
  |=  cuts=(list tape)
    =|  bad=(list tape)
    |-
    ?~  cuts
      "bomb defused"
    =/  cut  i.cuts
    ?~  bad
      $(bad (~(got by rules) cut), cuts t.cuts)
    ?~  (find [cut ~] bad)
      $(bad (~(got by rules) cut), cuts t.cuts)
    "boom"
++  rules
  %-  ~(gas by *(map tape (list tape)))
  :~  :-  "white"
      :~  "white"
          "black"
      ==
      :-  "red"
      :~  "white"
          "red"
          "black"
          "orange"
          "purple"
      ==
      :-  "black"
      :~  "white"
          "green"
          "orange"
      ==
      :-  "orange"
      :~  "white"
          "orange"
          "green"
          "purple"
      ==
      :-  "green"
      :~  "red"
          "black"
          "green"
          "purple"
      ==
      :-  "purple"
      :~  "purple"
          "green"
          "orange"
          "white"
      ==
  ==
--
```

The start of our generator is simple enough. The `!:` in the first line enables
a full stack trace in the event of an error. The following three lines create a
`%say` generator that takes a list of tape as an argument.

We next use the `=<` rune to compose two hoons, inverted. Remember that it's
good Hoon style is to have the heaviest parts to the bottom -- that's what we're
doing here.

We call `defuse` and pass it `cuts`, the list of tapes we were provided with
when the generator started.

Next is the core that has two arms, `defuse` and `rules`. Let's look at `rules`
quickly.

We can see that it is a `map` of `tape` to `list` of `tape`. For each of the
rules above we have specified when you cut a wire, which of the other wires you
cannot cut. This required some reformulating of the rules given to use at the
start, but it is much simpler to work with.

```
++  defuse
  |=  cuts=(list tape)
    =|  bad=(list tape)
    |-
    ?~  cuts
      "bomb defused"
    =/  cut  i.cuts
    ?~  bad
      $(bad (~(got by rules) cut), cuts t.cuts)
    ?~  (find [cut ~] bad)
      $(bad (~(got by rules) cut), cuts t.cuts)
    "boom"
```

The `defuse` arm is the meat of our program. It is a `gate` that takes a `list`
of `tape`. We combine a defaulted `list` of `tape` with the face `bad` with the
subject.

If `cuts` is empty, the bomb has been successfully defused.

Otherwise, we give `i.cuts`, the first item in the list, a face called `cut`.

If `bad` is empty, we recurse. This recursion sets `bad` to be the list of
wires we can not cut from the `rules` map and make `cuts` `t.cuts` or the tail
of `cuts`, removing the first element of the list.

If `bad` is not empty, we want to search inside of it for the current `cut`. If
it's not listed, then we are safe to continue and recurse to process the rest of
the cuts. However, if it is found in the bad list, the user has failed and the
bomb explodes.
