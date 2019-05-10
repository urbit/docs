+++
title = "Simple One-Gate Programs"
weight = 23
template = "doc.html"
+++
In this lesson we'll try to cover enough basic Hoon so that you can write (and understand) your own simple programs.  Each of the programs given in this lesson produces a gate.  (Gates are one-armed cores of Hoon that can be used as functions -- this is covered in [lesson 1.5](../gates).)

For each program we encourage you to: (1) write out the program yourself, (2) save it to the `/home/gen` directory of your urbit's pier, and (3) run it from the dojo.  The best way to learn to program in Hoon is by getting your hands dirty.

We will also continue to run one-line snippets of code in the dojo.  We encourage you to enter these for yourself as well.

## Writing Gates: A Review

Let's look at a really simple gate: `|=(a=@ 15)`.  This gate takes any atom as input and returns the value `15`.

The `|=` rune takes two subexpressions.  The first must indicate a type, and the second may evaluate to any value.  The first defines the gate's sample type and possibly binds a face to it, and the second defines the output of the gate.  In the example `|=(a=@ 15)` the `|=` subexpressions are `a=@` and `15`.

The following characters represent basic Hoon types: `@` for atoms, `^` for cells, `?` for flags, and `*` for nouns.  You should already know what atoms, cells, and nouns are.  (See [lesson 1.2](../nouns) if you need a reminder.)  There are two values for the `?` type: `%.y` for yes, and `%.n` for no.  In other words, `?` is for the [Boolean values](https://en.wikipedia.org/wiki/Boolean_data_type) of Hoon.

You could have picked a different type for the first subexpression of `|=(a=@ 15)` and left off the face.  To illustrate this let's call different versions of the gate with the `(gate arg)` function call syntax:

```
> (|=(@ 15) 11)
15

> (|=(@ 15) 22)
15

> (|=(* 15) 22)
15

> (|=(^ 15) 11)
nest-fail [crash message]
```

The argument for each of these function calls is either `11` or `22`.  These are atoms, `@`, and hence also nouns, `*`.  So when you define the sample to be either `@` or `*` the evaluation works as desired.

In the last function call, however, the gate's sample is defined to be a cell, `^`, and `11` isn't a cell.  This is why, when that gate is called with `11`, the result is a `nest-fail` crash message.  For all function calls, Hoon's type system checks whether the type of the argument matches the type of the sample.  If not, the the function will not be evaluated and you get the `nest-fail`.  (What counts as "nesting" will be covered more carefully in the next few lessons.)

Ordinarily a face is included in the first subexpression after the `|=` rune.  This makes it easier to refer to the sample in the second `|=` subexpression.  Usually you'll want the gate product to depend on the arguments passed.

```
> (|=(a=@ (add 2 a)) 12)
14

> (|=(a=@ (add 2 a)) 14)
16
```

### Checking the Gate's Output

You are probably fallible.  A fallible person will, at least occasionally, write code that produces output of the wrong type.  Hoon's type system is designed to help you avoid this problem, but to take full advantage of this help you have to ask.  You can do this with a 'cast' expression.  It is good practice to include a cast in every gate expression you write in Hoon.

A cast is a test that the value produced by an expression is provably of the desired type.  When the code is compiled, the compiler does type inference on the expression in question.  (We'll talk in more detail about how Hoon's type inference works later in the chapter.)  If the inferred type 'nests' under the desired type then the cast succeeds and the program is compiled.  Otherwise, the compile halts with a `nest-fail` crash.  In the latter case the program -- at least potentially -- produces the wrong kind of value and needs to be debugged.

There are different ways to cast, but for now we'll just use the `^-` rune.  Consider the even number checker given in the last lesson:

```
|=  a=@                                                 ::  even number checker
^-  ?                                                   ::  output is a flag
=(0 (mod a 2))                                          ::  if remainder=0 'yes'
```

The first subexpression after `|=` is `a=@`, and the second is the rather more complex:

```
^-  ?
=(0 (mod a 2))
```

This latter subexpression begins with the `^-` rune, which itself takes two subexpressions.  The first `^-` subexpression must indicate a type, `?`, and the second is to be evaluated, `=(0 (mod a 2))`.  The value of the second subexpression is the value produced by the whole `^-` expression.

The inferred type of `=(0 (mod a 2))` is compared against `?`.  If the former type fits under the latter, the type-check passes.  Otherwise the program will fail to compile, `nest-fail`.

Save the even number checker to the `/home/gen` directory of your pier as `even.hoon` and run it from the dojo:

```
> +even 11
%.n

> +even 22
%.y
```

Now replace the `=(0 (mod a 2))` in the third line with just `15`.  The result:

```
|=  a=@                                                 ::  even number checker
^-  ?                                                   ::  output is a flag
15                                                      ::  return 15
```

Save this and try to run it from the dojo again:

```
> +even 22
nest-fail
```

You changed the gate so that the output is `15`, which is an atom, `@`.  But you're casting for a flag, `?` -- either `%.y` or `%.n`.  Because `@` doesn't nest under `?` the program fails to compile.

### Multiple Inputs and Outputs

A gate is a one-armed core with a sample:

```
         [gate]
        /      \
    [$ arm]  [payload]
             /       \
        [sample]   [context]
```

When a function call to a gate occurs, the `$` arm is evaluated with the gate itself as the subject.  But the gate's payload is usually modified.  The modification in question is to the sample: the default gate sample is replaced with the argument(s) of the function call.  This is how the `$` arm 'knows' what the argument(s) of the function are.

The sample is just the noun in that slot of the gate, `+6`.  The product of the arm evaluation is just another noun.  Thus, gates always have a single noun for input and a single noun for output.

But we would like to use functions that take multiple inputs as well as functions with multiple outputs.  How?  The obvious solution is to use cells.

Let's write a program that checks two numbers at a time and tells us if each is even:

```
::
::  even2.hoon
::
::  this gate takes a pair of atoms, tests whether each is even, and then
::  returns two flags.
::
|=  [a=@ b=@]                                           ::  check two numbers
^-  [? ?]                                               ::  output is two flags
:-  =(0 (mod a 2))                                      ::  :-(x y) makes [x y]
=(0 (mod b 2))                                          ::
```

The first `|=` subexpression is now `[a=@ b=@]`.  This indicates a complex type for the gate's sample.  The gate takes a pair of atoms, labeling the first `a` and the second `b`.

The second `|=` subexpression is:

```
^-  [? ?]
:-  =(0 (mod a 2))
=(0 (mod b 2))
```

The first of two `^-` subexpressions is `[? ?]`, indicating another complex type.  The inferred type of the second `^-` subexpression must be a cell of two flags, or else the program will fail to compile.  The second `^-` subexpression:

```
:-  =(0 (mod a 2))
=(0 (mod b 2))
```

The `:-` rune takes two subexpressions and makes them into a cell.  Each of these, `=(0 (mod a 2))` and `=(0 (mod b 2))`, evaluates to a flag value, `?`.

Save the whole program in your pier as `even2.hoon` (or as something else if you like) and test it in the dojo.  Remembering to pass the two arguments as a cell:

```
> +even2 [2 2]
[%.y %.y]

> +even2 [2 3]
[%.y %.n]

> +even2 [3 3]
[%.n %.n]

> +even2 [22 33]
[%.y %.n]
```

A gate may take as input or produce as output arbitrarily complex cells.  For example, one could write a gate that takes a cell of five different things:

```
|=  [a=* b=@ud c=^ d=? e=@sb]
...
```

## Basic Tools

### `.+` and `.=`

The `.+` rune is for 'incrementing'; it takes an atom and adds `1` to it.  That's it!  Here it is in action:

```
> .+  22
23

> .+(22)
23

> .+(101)
102
```

But it's nearly always used in its irregular form, which lacks the `.`:

```
> +(22)
23

> +(101)
102
```

You've already used the `.=` rune in its irregular form, `=( )`.  This rune takes two subexpressions, evaluates them, and then does a simple test of equality on the resulting values.

```
> =(22 11)
%.n

> =(22 (add 11 11))
%.y
```

But there's one more quirk that you should know about: `.=(a b)` includes a type check.  Of the inferred types of `a` and `b`, one must nest in the other or else the code won't compile:

```
> =(12 [12 14])
nest-fail
```

The inferred type of `12` is `@ud`, and the inferred type of `[12 14]` is `[@ud @ud]`.  Neither type nests under the other, so the code fails to compile.  There is a way to get around this type check, which we'll explain later in this chapter.  The best policy is to avoid wiggling out of type safety checks, however.

### Introduction to Conditionals: The `?` Rune Family

We won't cover all the `?` runes here -- we'll save some for the upcoming lesson on types.  But we'll cover enough to get you writing simple Hoon programs.

#### `?:` if-then-else

The `?:` rune indicates an 'if-then-else' expression and takes three subexpressions: (1) the condition, which must evaluate to a flag, (2) an expression to be evaluated if the condition evaluates to `%.y`, and (3) an expression to be evaluated if the condition evaluates to `%.n`.

```
> ?:(%.y 11 22)
11

> ?:  %.y
    11
  22
11

> ?:(%.n 11 22)
22
```

#### `?.` ifnot-then-else

The `?.` rune does precisely the same thing as `?:`, except reversed: if the condition evaluates to `%.n` then the second subexpression is evaluated, otherwise the third is evaluated.

```
> ?.(%.y 11 22)
22

> ?.  %.y
    11
  22
22

> ?.(%.n 11 22)
11
```

The reasons for Hoon's having both `?:` and `?.` involve code neatness and clarity.  Use whichever makes your code better.

#### `?&` logical 'AND'

The `?&` rune is for logical 'AND'.  It takes two or more subexpressions, each of which must evaluate to a flag, `?`; and if all of them evaluate to `%.y` then the result of the `?&` expression is `%.y`.  Otherwise it's `%.n`.  In tall form the expression is terminated with `==`.

```
> ?&  %.y  %.y  %.y  ==
%.y

> ?&  &  |  &  ==
%.n

> ?&(%.y %.y %.y)
%.y

> ?&(& =(1 2) &)
%.n
```

You may be confused about the lone `&` and `|` characters in the second and fourth examples above.  The `&` character (used by itself) is another alias for 'yes', and `|` (used by itself) is another alias for 'no':

```
> &
%.y

> |
%.n
```

The irregular form of `?&` allows you to drop the `?` symbol:

```
> &(& & &)
%.y

> &(| & &)
%.n

> &(& | &)
%.n

> &(& & |)
%.n
```

To be clear, in `&(blah-1 blah-2)` the `&()` is the irregular `?&` rune; and anywhere else in the code `&` by itself means 'yes', `%.y`.

#### `?|` logical 'OR'

The `?|` rune is for logical 'OR'.  It takes two or more subexpressions, each of which must evaluate to a flag, `?`.  If at least one evaluates to `%.y` then the whole `?|` expression evals to `%.y`; otherwise it's `%.n`:

```
> ?|  %.n  %.n  %.n  ==
%.n

> ?|  |  |  &  ==
%.y

> ?|(=(12 12) | |)
%.y
```

The irregular form drops the `?` symbol:

```
> |(=(12 12) | |)
%.y

> |(=(12 13) | |)
%.n
```

#### `?!` logical 'NOT'

The `?!` rune is for logical 'NOT'.  It takes one subexpression that evaluates to a flag and returns the opposite value.

```
> ?!  &
%.n

> ?!(|)
%.y
```

The irregular form drops the `?` symbol and uses no parentheses:

```
> !|
%.y

> =(22 33)
%.n

> !=(22 33)
%.y
```

#### Are All Three Even?

Let's write a program that takes three atoms, `@`, and returns `%.y` if they're all even, otherwise `%.n`.

```
|=  [a=@ b=@ c=@]                                       ::  check three @
^-  ?                                                   ::  output is a flag
?&  =(0 (mod a 2))                                      ::  `a` is even AND
    =(0 (mod b 2))                                      ::  `b` is even AND
    =(0 (mod c 2))                                      ::  `c` is even
==
```

Save this in your urbit's pier as `even3.hoon` and run it from the dojo:

```
> +even3 [12 13 14]
%.n

> +even3 [12 16 14]
%.y
```

#### If So, Multiply -- Otherwise Add

Let's write a slightly more complicated program.  The gate takes three atoms, `@`, and if all three are even it multiplies all of them together.  Otherwise, it adds them all together.

```
|=  [a=@ b=@ c=@]                                       ::  take three @
^-  @                                                   ::  output is an @
?:  ?&  =(0 (mod a 2))                                  ::  if `a` is even AND
        =(0 (mod b 2))                                  ::  `b` is even AND
        =(0 (mod c 2))                                  ::  `c` is even
    ==
  (mul a (mul b c))                                     ::  then multiply
(add a (add b c))                                       ::  otherwise add
```

Save this as `addmul.hoon` and try it from the dojo:

```
> +addmul [2 2 2]
8

> +addmul [2 2 3]
7

> +addmul [4 4 4]
64

> +addmul [4 4 5]
13
```

### Subject Modification: The `=` Rune Family

As with the `?` family, we won't explain all the runes of the `=` family -- just a few to get you started.

#### `=>` Evaluate a Hoon Against a Subject

The `=>` rune takes two subexpressions.  The first is evaluated, with the result becoming the new subject; the second subexpression is evaluated against that subject.

A few examples:

```
> =>  [[a=12 b=14] [c=16 d=18]]  +
[c=16 d=18]

> =>  [[a=12 b=14] [c=16 d=18]]  -
[a=12 b=14]

> =>  [[a=12 b=14] [c=16 d=18]]  +>
d=18

> =>  [[a=12 b=14] [c=16 d=18]]  a
12

> =>  [[a=12 b=14] [c=16 d=18]]  d
18
```

#### `=<` Evaluate a Hoon Against a Subject, Reversed

The `=<` rune is just like `=>` but reversed.  The second subexpression is evaluated, with the result becoming the new subject; the first subexpression is evaluated against that subject.

A few examples:

```
> =<  +  [[a=12 b=14] [c=16 d=18]]
[c=16 d=18]

> =<  -  [[a=12 b=14] [c=16 d=18]]
[a=12 b=14]

> =<  +>  [[a=12 b=14] [c=16 d=18]]
d=18

> =<  a.-  [[a=12 b=14] [c=16 d=18]]
12

> =<  d.+  [[a=12 b=14] [c=16 d=18]]
18
```

The `=>` and `=<` runes should seem vaguely familiar, in spirit if not otherwise.  You've already used the irregular version of `=<`, with the `:` character:

```
> +:[[a=12 b=14] [c=16 d=18]]
[c=16 d=18]

> -:[[a=12 b=14] [c=16 d=18]]
[a=12 b=14]

> +>:[[a=12 b=14] [c=16 d=18]]
d=18

> a:[[a=12 b=14] [c=16 d=18]]
12

> d:[[a=12 b=14] [c=16 d=18]]
18
```

#### `=+` 'Pin' a Noun to the Subject

The `=+` rune takes two subexpressions.  The first is evaluated and then the resulting value is 'pinned' to the head of the subject -- that is, the old subject becomes the tail of the new subject, and the value produced by the first `=+` subexpression becomes the head of the new subject.  The second `=+` subexpression is evaluated against the new subject.  Examples:

```
> =>  [22 33 44]  =+(101 -)
101

> =>  [22 33 44]  =+(101 +)
[22 33 44]

> =>  [22 33 44]  =+(101 +1)
[101 22 33 44]

> =>  [b=22 c=33 d=44]  a
-find.a

> =>  [b=22 c=33 d=44]  =+(a=101 a)
101
```

#### `=/` Pin a Faced (and Possibly Typed) Noun To the Subject

The `=/` rune is a more powerful variation of `=+`.  `=/` takes three subexpressions: (1) the first is the face for the noun to be pinned (e.g., `a`), and possibly includes a type (e.g., `a=@`); (2) the second is the noun to be pinned; and (3) the third is the expression to be evaluated on the modified subject.

Some examples:

```
> =/(b=@ 22 [b b b])
[22 22 22]

> =/(b=@ 22 (add b b))
44
```

The `=/` rune is the closest thing Hoon has to an instruction for 'initializing a variable' while giving it an initial value.  What actually occurs in Hoon is that the value is pinned to the head of the subject, and the indicated face is bound to that value.

#### `=|` Pin a Faced, Typed Default Noun to the Subject

The `=|` is a lot like the `=/` rune except that (1) you must include type information when you use it, and (2) the programmer doesn't set the initial value of the face -- it's a default value for the type in question, sometimes called a 'bunt' value.  The `=|` rune takes two subexpressions.  The first is a face names (e.g., `a`), followed by `=`, followed by a type (e.g., `@`).  The second is to be evaluated against the modified subject.

```
> =|  a=@  a
0

> =|  a=^  a
[0 0]

> =|  a=?  a
%.y
```

The `=|` rune is a lot like 'initializing a variable' but for faces, without giving the face an interesting initial value (a default value for the type is used instead, i.e., the 'bunt' value).

#### `=.` Change a Leg of the Subject

The `=.` rune takes three subexpression.  The first is a wing expression, indicating the leg of the subject whose value is to be changed.  The second is the new value for the indicated leg.  The third is the expression to be evaluated against the modified subject.

```
> =/  a=@  22  =.(a 99 a)
99

> =/  a=@  22  [a =.(a 99 a)]
[22 99]

> =>  [12 14]  =.(+2 22 .)
[22 14]
```

This rune is often used for modifying the value of a face whose value was set beforehand.

## Recursion

How do we do loops in Hoon?  Like other functional programming languages Hoon uses [recursion](https://en.wikipedia.org/wiki/Recursion_%28computer_science%29).  In rough terms, a recursive function solves a problem in part by calling on itself to solve a slightly easier or smaller case of the same problem.  The self-calling loop continues until the simplified problem is so simple that it has a trivial solution.

Seeing an example will make this process easier to understand.

### Addition

Let's write a gate that takes a pair of atoms, `@`, and which returns the sum of these atoms.  There is a cheap solution to this problem, of course.  The Hoon standard library has `add` in it:

```
> (add 22 33)
55
```

But let's solve the problem without using `add` from the Hoon standard library.  We have the `.+` rune for adding `1` and the `.=` rune for testing equality.  We'll also use `dec` from the standard library and some recursion.  That's it!

What's `dec`?  It takes some atom, `@`, and returns the decrement -- i.e., it takes some number `a` and returns `a - 1`:

```
> (dec 101)
100

> (dec 51)
50

> (dec 11)
10
```

For adding two atoms together, the algorithm we'll use is very simple.  We start with two numbers, `a` and `b`.  If `b` is `0`, then the answer is `a`.  (This is the trivial case of addition for our algorithm, sometimes also called the 'base' case.)  Otherwise, the answer is the sum of `a + 1` and `b - 1` -- now do *that* addition.  (This is the *recursive* case.)

Do you see how this process calls for a loop of sorts?  If you want to sum `7` and `2`, check to see whether the second number is `0`.  It isn't, so now figure out the sum of `8` and `1`.  Is the second number `0`?  No, so do the sum of `9` and `0`.  Now the second number is `0` -- the answer is `9`.

Here's the program:

```
|=  [a=@ b=@]                                           ::  take two @
^-  @                                                   ::  output is one @
?:  =(b 0)                                              ::  if b is 0
  a                                                     ::    return a, else
$(a +(a), b (dec b))                                    ::  add a+1 and b-1
```

Save it as `add.hoon` in your urbit's pier and run it from the dojo:

```
> +add [22 33]
55

> +add [122 33]
155
```

It works!

Every line of `add.hoon` should be clear up to the last one.  What's going on there?  The `$( )` is used for recursive function calls.  That is, it's a way for a function to call itself, but with certain values modified according to the instructions inside the parentheses.  Two values are being modified for the call: `a` is modified to `+(a)`, and `b` is modified to `(dec b)`.  A comma is used to separate the two modification instructions.  (Of course, in programs that call for it, more than two modifications may be made here.)

### `%=` Resolve to a Wing with Changes

The `$( )` syntax is an irregular form of the the `%=` rune.  We can rewrite that part of `add.hoon` in regular form:

```
|=  [a=@ b=@]                                           ::  take two @
^-  @                                                   ::  output is one @
?:  =(b 0)                                              ::  if b is 0
  a                                                     ::    return a, else
%=  $                                                   ::  resolve to $
  a  +(a)                                               ::  but change a to +(a)
  b  (dec b)                                            ::  and b to (dec b)
==
```

This version is precisely equivalent to the old one.  The first `%=` subexpression is for a wing.  In the program above, this is just `$`.  The other subexpressions of `%=` indicate the changes to be made upon resolution to the wing.  You can make as many of these changes as desired when using `%=`, so the expression is ended with `==`.

Remember from lessons [1.4](../arms-and-cores) and [1.5](../gates) that wing resolution works in two different ways.  If the wing resolves to a leg, that fragment of the subject is returned.  If the wing resolves to an arm, the arm is evaluated with its parent core as the subject.  In [lesson 1.5](../gates) you learned that `$` is the special name of the arm of a gate.  (Remember, a gate is a one-armed core with a sample.)  Because we wrote `add.hoon` with `|=` it produces a gate.  The `%=` expression above thus evaluates the `$` arm of the gate, but only after having made changes to the parent core: `a` is incremented, and `b` is decremented.

### Decrement

We've used `dec`, but now let's write our own version.  That is, let's write a gate that takes some atom, `@`, and returns the 'decrement' of that value.  There is a cheap solution to this problem too.  The Hoon standard library has the `sub` function in it for subtraction:

```
> (sub 100 50)
50

> (sub 100 1)
99
```

But let's solve the problem without using the Hoon standard library.  We have the `.+` rune for adding `1`, the `.=` rune for testing equality, and various runes of the `=` family for manipulating the subject.  And we'll again use recursion.

How do we decrement using only those tools?  The algorithm is pretty simple.  We'll start by defining a counter value, `0`, and binding it to `c`.

If `c + 1` equals the value to be decremented, then `c` is the answer.  (This is the trivial case.)  Otherwise, we increment `c` by `1` and try again.  (This is the recursive case.)

There's one quirk about this algorithm that makes it different from the addition algorithm.  We didn't set any initial values in the addition program, and so calling the whole function at the end was an acceptable option.  If we do the same thing with decrement -- call the whole function at the end -- we'll end up setting the same face, `c`, to the same initial value again, `0`.  We don't want that.  We want the counter to increase in value for each loop!  There should be a recursion start point that comes after `c` is set initially.  For that you can use the `|-` rune.

Here's the program:

```
|=  a=@                                                 ::  take one @
=/  c=@  0                                              ::  set c to 0
|-                                                      ::  recursion start
^-  @                                                   ::  output is @
?:  =(a +(c))                                           ::  if a = c+1
  c                                                     ::    return c, else
$(c +(c))                                               ::  add 1 to c, recurse
                                                        ::    back to the |-
```

Save it as `dec.hoon` and try it from the dojo:

```
> +dec 101
100

> +dec 97
96

> +dec 11
10
```

At an intuitive level this code should make sense.  The `$( )` at the end effectively serves as a loop going back to the `|-` rune, with a modification to the value of `c`.  But isn't `$` the name of the gate's single arm?  What's going on?  Let's take a moment to understand how `|-` works at a deeper level.

### `|-` Make and Call a One-armed Core

The `|-` rune makes a one-armed core whose arm has the name `$`, and then it calls `$`.  The `|-` rune takes one subexpression, which determines what `$` does:

```
> |-  2
2

> |-  (add 22 33)
55
```

Let's look at the decrement program again, this time using the regular version of the `%=` rune.

```
|=  a=@                                                 ::  take one @
=/  c=@  0                                              ::  set c to 0
|-                                                      ::  recursion start
^-  @                                                   ::  output is @
?:  =(a +(c))                                           ::  if a = c+1
  c                                                     ::    return c, else
%=  $                                                   ::  resolve to $
  c  +(c)                                               ::  add 1 to c
==
```

Strictly speaking, when you use `$( )` or `%=  $` you're asking for a resolution to `$` (with changes indicated in parentheses).  And because `$` is an arm, that means evaluating it with its parent core as the subject.

When you use `|-` in the decrement program, you're defining a _new_ core whose arm name is `$`, in addition to the one created by `|=`.  So the subject ends up having two arms named `$` in it: one for the gate defined by `|=`, and one for the core defined by `|-`.

When `$( )` or `%=  $` is executed, the subject is searched for the `$` arm.  The `|-` `$` arm is found first because it was defined later than the `|=` arm.  You can skip the first name match for `$` by using `^`, if you like.  That is, if you like, you can recurse all the way to the beginning of the function using `^$( )` or `%=  ^$`.

### Exercises

You should know enough at this point to write some basic Hoon programs.  Practice with some of these exercises.  Solutions are provided at the bottom of the page.

#### Exercise 2.3.1: Subtraction

Write a program that takes two numbers and returns the difference.  You may use `dec`, but don't use anything else from the Hoon standard library.

#### Exercise 2.3.2: Factorial

Write a program that takes a number `n` and returns the factorial of `n`, `n!`.  `1!` is `1`, `2!` is `2 x 1`, `3!` is `3 x 2 x 1`, `4!` is `4 x 3 x 2 x 1`, and so on.  You may use the Hoon standard library.

#### Exercise 2.3.3: Prime Number Checker

Write a program that takes a number `n` and returns `%.y` if it's prime, and `%.n` if it isn't.  You may use the Hoon standard library.

## Fizzbuzz

Let's write a Hoon implementation of [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz).  Fizzbuzz takes some number `n` and then makes a list of numbers from `1` to `n`, except that numbers evenly divisible by `3` are replaced with 'Fizz', numbers evenly divisible by `5` are replaced with 'Buzz', and numbers evenly divisible by both are replaced with 'FizzBuzz'.

You already saw a program that produces a list of atoms from `1` to `n` in [lesson 2.1](../hoon-programs), `listnum.hoon`:

```
|=  end=@                                               ::  1
=/  count=@  1                                          ::  2
|-                                                      ::  3
^-  (list @)                                            ::  4
?:  =(end count)                                        ::  5
  ~                                                     ::  6
:-  count                                               ::  7
$(count (add 1 count))                                  ::  8
```

The difference for FizzBuzz is that certain items of the product list must be replaced with strings: `"Fizz"`, `"Buzz"`, and `"FizzBuzz"`.

Below is our implementation of FizzBuzz.  Each line is commented with a number for convenient line reference:

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
  ?:  =(0 (mod count 3))                                ::  10
    "Fizz"                                              ::  11
  ?:  =(0 (mod count 5))                                ::  12
    "Buzz"                                              ::  13
  <count>                                               ::  14
$(count (add 1 count))                                  ::  15
```

Save this as 'fizzbuzz.hoon' in `/home/gen` of your urbit's pier.  To run it enter `+fizzbuzz 25` in the dojo:

```
> +fizzbuzz 25
<<
  "1"
  "2"
  "Fizz"
  "4"
  "Buzz"
  "Fizz"
  "7"
  "8"
  "Fizz"
  "Buzz"
  "11"
  "Fizz"
  "13"
  "14"
  "FizzBuzz"
  "16"
  "17"
  "Fizz"
  "19"
  "Buzz"
  "Fizz"
  "22"
  "23"
  "Fizz"
>>
```

### Explaining Fizzbuzz

```
|=  end=@                                               ::  1
=/  count=@  1                                          ::  2
|-                                                      ::  3
^-  (list tape)                                         ::  4
```

This gate takes an atom, `end`, for its sample.  The initial value of `count`, an atom, is `1`.  Line `3` uses `|-` for a recursion (or loop) starting point, so that `count` is only set to `1` once.

The gate output is cast to `(list tape)`, i.e., to a list of `tape`s.  A `tape` is one of Hoon's two string types and is pretty-printed as a string in double quotes.

```
> "This is a tape."
"This is a tape."

> "So is this!"
"So is this!"
```

Moving on:

```
?:  =(end count)                                        ::  5
  ~                                                     ::  6
```

If `end` and `count` are the same value, then the list is finished.  The null character, `~`, is returned.  (Reminder: Hoon lists are null-terminated.)

Otherwise...

```
:-                                                      ::  7
  ?:  =(0 (mod count 15))                               ::  8
    "FizzBuzz"                                          ::  9
  ?:  =(0 (mod count 3))                                ::  10
    "Fizz"                                              ::  11
  ?:  =(0 (mod count 5))                                ::  12
    "Buzz"                                              ::  13
  <count>                                               ::  14
$(count (add 1 count))                                  ::  15
```

If not, line 7 uses the rune `:-` to produce a cell.  This cell is the FizzBuzz list, in which the head is the first list item and the tail is the rest of the list, itself another list.

The head of this cell is produced by lines 8-14, and the tail by line 15.

For value of the head there are two possibilities .  First, the value is "FizzBuzz", or "Fizz", or "Buzz", if any of the respective conditional tests hit.  For example, if `=(0 (mod count 15))` is true -- i.e., if `count` is evenly divisible by 15 -- then the value returned is "FizzBuzz".  Second, if none of the three test conditions is true, then the value is the number in question, `count`.  In the latter case, line 14 uses the `< >` syntax to convert `count` from an `@` to a `tape`.  Remember that the cast is for a list of `tape`s, so each list item must be a `tape`.

For the value of the cell's tail: the rest of the output list is produced by line 15.  This line uses `$( )` to loop back to the `|-` in line 3, but only after modifying the value of `count`: `count` is increased in value by `1`.

The product of the `$( )` call on line 15 is another list.  Either the modified `count` equals `end`, in which case the null list, `~`, is returned on line 6; or a new cell is produced in which case the head is an item determined by lines 7-14 and the tail is determined by line 15.  The process repeats until `count` equals `end`.

## Exercise Answers

There are many possible solutions so yours may look a bit different from the ones we have below.  These solutions aren't optimized for performance.  Instead, clarity and simplicity have been prioritized.

#### Exercise 2.3.1 Solution: Subtraction

```
|=  [x=@ y=@]
^-  @
?:  =(y 0)
  x
$(x (dec x), y (dec y))
```

#### Exercise 2.3.2 Solution: Factorial

```
|=  n=@
^-  @
?:  (lte n 1)
  1
(mul n $(n (dec n)))
```

#### Exercise 2.3.3 Solution: Prime

```
|=  a=@
?:  (lth a 2)  |
?:  =(a 2)  &
=/  c  2
|-  ^-  ?
?:  =(0 (mod a c))  |
?:  (gth (mul c 2) a)  &
$(c +(c))
```

### [Next Lesson: Atoms, Auras, and Simple Cell Types](../atoms-auras-and-simple-cell-types)
