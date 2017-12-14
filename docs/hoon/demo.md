---
navhome: /docs/
sort: 12
next: true
title: Demo
---

# Demo

Here's everyone's favorite whiteboard example, FizzBuzz.  Each
line is commented with its number:

```
|=  end=@ud                                             ::  1
=/  count=@ud  1                                        ::  2
|-                                                      ::  3
^-  (list tape)                                         ::  4
?:  =(end count)                                        ::  5
  ~                                                     ::  6
:-                                                      ::  7
  ?:  =(0 (mod count 15))                               ::  8
    "FizzBuzz"                                          ::  9
  ?:  =(0 (mod count 5))                                ::  10
    "Fizz"                                              ::  11
  ?:  =(0 (mod count 3))                                ::  12
    "Buzz"                                              ::  13
  (scow %ud count)                                      ::  14
$(count (add 1 count))                                  ::  15
```

Hoon is a functional language.  FizzBuzz is usually defined as a
side effect, but officially Hoon has no side effects.  Accordingly,
this code will *produce* a list of strings, not *print* a list of 
strings. (Of course, if you run this code from the Urbit 
[_Dojo_](../../using/shell) (shell) you will be able to see the 
product.)

The code produces a list in which each item is either a number 
(as a string), "Fizz", "Buzz", or "Fizzbuzz". The value `~` is 
"null" and indicates the end of the list.

Line 1 uses the _[rune](../../about/glossary#rune)_ `|=` (pronounced 
["bar-tis"](../syntax/#-glyphs-and-characters)) to define a function 
that takes one argument, labelled `end`. The argument must be of the 
type `@ud`, an unsigned decimal number.

Line 2 uses the rune `=/` (pronounced "tis-fas") to declare a variable, 
`count` of the unsigned decimal number type, with initial value `1`.

Line 3 uses the rune `|-` ("bar-hep") to begin a loop.

Line 4 defines the product of the loop as a list of `tape`s. 
(A `tape` is a list of characters, one of Hoon's two string 
types.)  The rune `^-` ("ket-hep") is used for defining 
the type of value the function must produce. 

Line 5 uses the rune `?:` ("wut-tis"), which is your classic "if, then, 
else" conditional. The "if" clause uses the irregular form of the rune 
`.=` ("dot-tis"), one of the fundamental [Nock](../../nock/definition) 
instructions, to perform an equality test on the values of `count` and 
`end`. This will produce either `%.y` (yes, the number 0) or `%.n` 
(no, 1) and consequently compute the "then" or "else" clause 
respectively. 

If the values of `count` and `end` are equal, line 6 (and the whole loop) 
returns the value `~`. The list is finished.  

If not, line 7 uses the rune `:-` ("col-hep") to produce a 'cell', which
is an ordered pair of Hoon values. This pair will be: (a) the next item 
in the list, determined by more `?:` conditionals in lines 8-14; and (b) 
the rest of the list, determined by line 15.

(a) The head of the pair is: (i) "FizzBuzz", or "Fizz", or 
"Buzz", if the respective tests hit; otherwise, it's 
(ii) the number in question, `count`.  In case (ii), line 14 
uses the Hoon standard library function `++scow` to take the value of 
`count`, of type `@ud`, and pretty-print it as a `tape`.

(b) The tail of the pair&mdash;the rest of the output list&mdash;is 
produced at line 15, which uses the irregular `$()` syntax for the rune
`%=` ("cen-tis") to repeat the loop set above (with the `|-` in line 3) 
with `count` incremented. 

You can test this code by mounting your home desk with 
`|mount %` from the Dojo; saving the above code as 
`home/gen/fizzbuzz.hoon` in your Urbit 
[pier](../../about/glossary#pier); then typing 
`+fizzbuzz 100` in the dojo.
