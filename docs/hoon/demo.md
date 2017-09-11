---
navhome: '/docs/'
next: True
sort: 11
title: Demo
---

# Demo

Here's everyone's favorite whiteboard example, FizzBuzz. Each line is commented
with its number:

    :gate  end/atom                  ::  1
    :var   count  1                  ::  2
    :loop                            ::  3
    :cast  (list tape)               ::  4
    :if  =(end count)                ::  5
       ~                             ::  6
    :cons                            ::  7
      :if  =(0 (mod count 15))       ::  8
        "FizzBuzz"                   ::  9
      :if  =(0 (mod count 5))        ::  10
        "Fizz"                       ::  11
      :if  =(0 (mod count 3))        ::  12
        "Buzz"                       ::  13
      (pave :wrap(count))            ::  14
    :moar(count (add 1 count))       ::  15

Can you understand this code by just looking at it? Maybe. But let's explain it
anyway.

Hoon is a functional language. FizzBuzz is usually defined as a side effect, but
Hoon has no side effects. This code will *make* a list of strings, not *print* a
list of strings.

Line 1 defines a function of one argument, `end`, an unsigned integer.

Line 2 declares a variable, `count`, with initial value `1`.

Line 3 begins a loop.

Line 4 casts the product of the loop to a list of `tape` (string as a character
list).

Line 5 checks if `count` equals `end`. If so, line 6 (and the whole loop)
produces the value `~`, null, the empty list. If not, line 7 begins an ordered
pair.

The head of the pair is "FizzBuzz", or "Fizz", or "Buzz", if the respective
tests hit. If not, line 14 wraps a runtime type around `count`, then prints the
type-value pair to a string (like C `sprintf()`). This string is the first item
in the output list.

The tail of the pair is line 15, which repeats the loop (like Clojure `recur`),
with `count` incremented. This list of strings is the rest of the output list.

You can test this code by mounting your home desk with `|mount %`; copying it
into `home/gen/fizzbuzz.hoon` in your Urbit pier; then typing `+fizzbuzz 100` in
the Urbit dojo (shell).
