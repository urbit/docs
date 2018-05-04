---
navhome: /docs/
sort: 12
next: true
title: Demo
---

# Demo

Here's everyone's favorite whiteboard example, 
[FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz).  Each 
line is commented with its number:

```
|=  end=@                                               ::  1
=/  count=@  1                                          ::  2
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
  <count>                                               ::  14
$(count (add 1 count))                                  ::  15
```

When FizzBuzz is written in non-functional languages the 
output is generated as a side effect of the program, e.g., with 
`printf()`.  Hoon is a functional language so technically it 
has no side effects.  Accordingly, the code above *returns* a 
list of strings, it doesn't print them. (If you run it from the 
Urbit shell, [_Dojo_](../../using/shell), you will of course be 
able to see the product.)

The code produces a list in which each item is either a number, 
"Fizz", "Buzz", or "Fizzbuzz". The value `~` is "null" and indicates 
the end of the list.

Line 1 uses the _[rune](../../about/glossary#rune)_ `|=` to define 
a function that takes one input, `end`. The input value must be of 
the type `@`, an atom (i.e., an unsigned integer).

Line 2 uses `=/` to declare a variable, `count`, as an atom with an 
initial value of `1`.

Line 3 uses `|-` to indicate the starting point of a loop.

Line 4 defines the product of the loop as a list of `tape`s.
(A `tape` is a list of characters, one of Hoon's two string 
types.)  The rune `^-` is used for defining the type of value the 
function is required to produce.

Line 5 uses the rune `?:` which is an ordinary "if-then-else" 
conditional.  If `=(end count)` evaluates as true, then line 6 is 
evaluated next.  Otherwise line 7 and on is evaluated.

If the values of `count` and `end` are equal then line 6 produces the 
value `~`, indicating the end of the list. The program is finished.  

If not, line 7 uses the rune `:-` to produce an 
[ordered pair](https://en.wikipedia.org/wiki/Ordered_pair) of values. 
The pair created will be `[a b]`: (a) the product of lines 8-14; and 
(b) the product of line 15.

(a) The first value of the pair is: (i) "FizzBuzz", or "Fizz", or
"Buzz", if the respective conditional tests hit; otherwise, it's
(ii) the number in question, `count`.  In case (ii), line 14
uses the `< >` symbols to convert `count` from an `@` to a `tape`.

(b) The second value of the pair&mdash;i.e., the rest of the output 
list&mdash;is produced by line 15.  This line uses `$()` to loop back 
to the `|-` in line 3, but with `count` increased in value by `1`.

You can test this code for yourself by (i) entering `|mount %` in the 
Dojo to mount your home desk, if you haven't already done so; (ii) 
saving the above code as `home/gen/fizzbuzz.hoon` in your Urbit's 
[pier](../../about/glossary#pier); then (iii) entering `+fizzbuzz 100` 
in the dojo.
