---
navhome: /docs/
sort: 11
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
```

Can you understand this code by just looking at it?  Maybe.
But let's explain it anyway.

Hoon is a functional language.  FizzBuzz is usually defined as a
side effect, but officially Hoon has no side effects.  This code 
will *return* a list of strings, not *print* a list of strings. 
(Of course, if you run this code from the Urbit `dojo` (shell) you 
will be able to see the product.)

The code produces a list in which each item is either a number 
(as a string), "Fizz", "Buzz", or "Fizzbuzz". The value `~` is 
"null" and indicates the end of the list.

Line 1 defines a function of one argument, `end`, an unsigned
integer.

Line 2 declares a variable, `count`, with initial value `1`.

Line 3 begins a loop.

Line 4 defines the product of the loop as a list of `tape`s. 
(A `tape` is a list of characters, one of Hoon's two string 
types.)

Line 5 checks if `count` equals `end`.  If so, line 6 (and the
whole loop) returns the value `~`.  If not, line 7 produces an 
ordered pair.  (This pair will be: (a) the next item in the list, 
and (b) the rest of the list.)

(a) The head of the pair is: (i) "FizzBuzz", or "Fizz", or 
"Buzz", if the respective tests hit; otherwise, it's 
(ii) the number in question, `count`.  In case (ii), line 14 
makes `count` into a `tape`, first by using `:wrap` to produce a 
pair: runtime type of `count`, and `count` itself. `pave` is a 
Hoon function that converts the type-value pair to a `tape` 
(like C `sprintf()`).

(b) The tail of the pair&mdash;the rest of the output list&mdash;is 
produced at line 15, which repeats the loop (like Clojure 
`recur`), with `count` incremented.

You can test this code by mounting your home desk by entering 
`|mount %` from the dojo; saving the above code as 
`home/gen/fizzbuzz.hoon` in your Urbit pier; then typing 
`+fizzbuzz 100` in the dojo.
