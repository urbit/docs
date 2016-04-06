---
sort: 1
next: true
title: Demo
---

# Demo

Here's everyone's favorite whiteboard example, FizzBuzz.  Each 
line is commented with its number:

```
:gate  end/atom                  ::  1
:var   count  1                  ::  2
:loop                            ::  3
:if  =(end count)                ::  4
   ~                             ::  5
:cons                            ::  6
  :if  =(0 (mod count 15))       ::  7
    "FizzBuzz"                   ::  8
  :if  =(0 (mod count 5))        ::  9
    "Fizz"                       ::  10
  :if  =(0 (mod count 3))        ::  11
    "Buzz"                       ::  12
  (text :wrap(count))            ::  13
:moar(count (add 1 count))       ::  14
```

Can you understand this code by just looking at it?  Hopefully,
but let's explain it anyway.

Hoon is a functional language.  FizzBuzz is usually defined as a
side effect, but Hoon has no side effects.  This code will
*make* a list of strings, not *print* a list of strings.

Line 1 defines a function of one argument, `end`, an unsigned
integer.

Line 2 declares a variable, `count`, with initial value `1`.

Line 3 begins a loop.

Line 4 checks if `count` equals `end`.  If so, line 5 (and the
whole loop) produces the value `~`, null.  If not, line 6 begins
an ordered pair.

The head of the pair is "FizzBuzz", or "Fizz", or "Buzz", if the
respective tests hit.  If not, line 13 wraps a runtime type
around `count`, then prints the type-value pair to a string (like
C `sprintf()`).  This string is the first item in the output list.

The tail of the pair is line 14, which repeats the loop (like
Clojure `recur`), with `count` incremented.  This list of strings
is the rest of the output list.

You can test this code by mounting your home desk with `|mount %home`;
copying it into `home/gen/fizzbuzz.hoon` in your Urbit pier; then
typing `+fizzbuzz 100` in the Urbit dojo (shell).
