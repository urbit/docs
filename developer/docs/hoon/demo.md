---
navhome: /developer/docs/
sort: 11
next: true
title: Demo
---

# Demo

Here's everyone's favorite whiteboard example, FizzBuzz.  Each
line is commented with its number:

```
|=  end/atom                    :: 1
=/  count  1                    :: 2
|-                              :: 3
^-  (list tape)                 :: 4
?:  =(end count)                :: 5
  ~                             :: 6
:-                              :: 7
  ?:  =(0 (mod count 15))       :: 8
    "FizzBuzz"                  :: 9
  ?:  =(0 (mod count 5))        :: 10
    "Fizz"                      :: 11
  ?:  =(0 (mod count 3))        :: 12
    "Buzz"                      :: 13
  (pave !>(count))              :: 14
$(count (add 1 count))          :: 15
```

Hoon is a functional language.  FizzBuzz is usually defined as a
side effect, but officially Hoon has no side effects.  This code 
will *return* a list of strings, not *print* a list of strings. 
(Of course, if you run this code from the Urbit `dojo` (shell) you 
will be able to see the product.)

The code produces a list in which each item is either a number 
(as a string), "Fizz", "Buzz", or "Fizzbuzz". The value `~` is 
"null" and indicates the end of the list.

Line 1 uses the `|=` 
*[rune](https://urbit.org/docs/about/glossary#rune)* to define a 
function of one argument, `end`, which is of the type `atom` (i.e. 
an unsigned integer).

Line 2 declares a variable, `count`, with initial value `1`.

Line 3 begins a loop.

Line 4 defines the product of the loop as a list of `tape`s. 
(A `tape` is a list of characters, one of Hoon's two string 
types.)  The `^-` rune is used for defining the product type the function 
is to return. 

Line 5 uses the `?:` rune, which is a conditional. This line 
checks whether `count` equals `end`.  If so, line 6 (and the
whole loop) returns the value `~`.  The list is finished.  If not, 
line 7 produces an ordered pair.  This pair will be: (a) the next 
item in the list, determined by lines 8-14; and (b) the rest of 
the list, determined by line 15.

(a) The head of the pair is: (i) "FizzBuzz", or "Fizz", or 
"Buzz", if the respective tests hit; otherwise, it's 
(ii) the number in question, `count`.  In case (ii), line 14 
makes `count` into a `tape`, first by using `!>` to produce a 
pair: runtime type of `count`, and `count` itself. `pave` is a 
Hoon function that converts the type-value pair to a `tape` 
(like C `sprintf()`).

(b) The tail of the pair&mdash;the rest of the output list&mdash;is 
produced at line 15, which uses `$()` to repeat the loop (like 
Clojure `recur`), with `count` incremented.

You can test this code by mounting your home desk with 
`|mount %` from the dojo; saving the above code as 
`home/gen/fizzbuzz.hoon` in your Urbit 
[pier](https://urbit.org/docs/about/glossary#pier); then typing 
`+fizzbuzz 100` in the dojo.
