+++
title = "2.2 Type Checking and Type Inference"
weight = 25
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/type-checking-and-type-inference/"]
+++

As the Hoon compiler compiles your Hoon code, it does a **type check** on certain expressions to make sure they are guaranteed to produce a value of the correct type.  If it cannot be proved that the output value is correctly typed, the compile will fail with a `nest-fail` crash.  In order to figure out what type of value is produced by a given expression, the compiler uses **type inference** on that code.  In this lesson we'll cover various cases in which a type check is performed, and also how the compiler does type inference on an expression.

## Type Checking

Let's enumerate the most common cases where a type check is called for in Hoon.

### Cast Runes

The most obvious case is when there is a cast rune in your code.  These runes don't directly have any effect on the compiled result of your code; they simply indicate that a type check should be performed on a piece of code at compile-time.

#### `^-` Cast with a Type

You've already seen one rune that calls for a type check: `^-`:

```
> ^-(@ 12)
12

> ^-(@ 123)
123

> ^-(@ [12 14])
nest-fail

> ^-(^ [12 14])
[12 14]

> ^-(* [12 14])
[12 14]

> ^-(* 12)
12

> ^-([@ *] [12 [23 43]])
[12 [23 43]]

> ^-([@ *] [[12 23] 43])
nest-fail
```

#### `^+` Cast with an Example Value

The rune `^+` is like `^-`, except that instead of using a type name for the cast, it uses an example value of the type in question.  E.g.:

```
> ^+(7 12)
12

> ^+(7 123)
123

> ^+(7 [12 14])
nest-fail
```

The `^+` rune takes two subexpressions.  The first subexpression is evaluated and its type is inferred.  The second subexpression is evaluated and its inferred type is compared against the type of the first.  If the type of the second provably nests under the type of the first, the result of the `^+` expression is just the value of its second subexpression.  Otherwise, the code fails to compile.

This rune is useful for casting when you already have a [noun](/docs/glossary/noun/) -- or expression producing a [noun](/docs/glossary/noun/) -- whose type you may not know or be able to construct easily.  If you want your output value to be of the same type, you can use `^+`.

More examples:

```
> ^+([12 13] [123 456])
[123 456]

> ^+([12 13] [123 [12 14]])
nest-fail

> ^+([12 [1 2]] [123 [12 14]])
[123 12 14]
```

### The `.=` and `.+` Runes

You saw earlier in Chapter 1 how a type check is performed when `.=` -- or its irregular variant, `=( )` -- is used.  For any expression of the form `=(a b)`, either the type of `a` must be a subset of the type of `b` or the type of `b` must be a subset of the type of `a`.  Otherwise, the type check fails and you'll get a `nest-fail`.

```
> =(12 [33 44])
nest-fail

> =([77 88] [33 44])
%.n
```

You can evade the `.=` type-check by casting one of its subexpressions to a `*`, under which all other types nest:

```
> .=(`*`12 [33 44])
%.n
```

It isn't recommended that you evade the rules in this way, however.

The `.+` increment rune -- including its `+( )` irregular form -- does a type check to ensure that its subexpression must evaluate to an [atom](/docs/glossary/atom/).

```
> +(12)
13

> +([12 14])
nest-fail
```

### Arm Evaluation

Whenever an [arm](/docs/glossary/arm/) is evaluated in Hoon it expects to have some version of its parent [core](/docs/glossary/core/) as the subject.  Specifically, a type check is performed to see whether the [arm](/docs/glossary/arm/) subject is of the appropriate **type**.  We see this in action whenever a [gate](/docs/glossary/gate/) or a multi-arm [door](/docs/glossary/door/) is called.

A gate is a one-armed core with a sample.  When it is called, its `$` arm is evaluated with (a version of) the gate as the subject.  The only part of the core that might change is the [payload](/docs/glossary/payload/), including the sample.  Of course, we want the sample to be able to change.  The sample is where the argument(s) of the function call are placed.  For example, when we call `add` the `$` arm of expects two atoms for the sample, i.e., the two numbers to be added.  When the type check occurs, the [payload](/docs/glossary/payload/) must be of the appropriate type.  If it isn't, the result is a `nest-fail` crash.

```
> (add 22 33)
55

> (add [10 22] [10 33])
nest-fail

> (|=(a=@ [a a]) 15)
[15 15]

> (|=(a=@ [a a]) 22)
[22 22]

> (|=(a=@ [a a]) [22 22])
nest-fail
```

We'll talk in more detail about the various kinds of type-checking that can occur at arm evaluation when we discuss type polymorphism later in Chapter 2.

This isn't a comprehensive list of the type checks in Hoon.  It's only some of the most commonly used kinds.  Two other runes that include a type check are `=.` and `%_`.

## Intro to Hoon Type Inference

It's helpful to know **that** Hoon infers the type of any given expression, but it's important to know **how** such inference works.  Hoon uses various tools for inferring the type of any given expression: literal syntax, cast expressions, gate sample definitions, conditional expressions, and more.

### Literals

[Literals](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29) are expressions that represent fixed values.  Some examples (with the inferred type on the right):

```
123                   @ud
0xabc                 @ux
0b1010                @ub
[12 14]               [@ud @ud]
[0x1f 'hello' %.y]    [@ux @t ?]
```

As you can see there are both atom and cell literals in Hoon.  Hoon infers the type of literals -- including atom auras -- directly from such expressions.

### Casts

Cast runes also shape how Hoon understands an expression type.  The inferred type of a cast expression is just the type being cast for.  It can be inferred that, if the cast didn't result in a `nest-fail`, the value produced must be of the cast type.  Here are some examples of cast expressions with the inferred output type on the right:

```
^-(@ud 123)                       @ud
^-(@ 123)                         @
^-(^ [12 14])                     ^
^-([@ @] [12 14])                 [@ @]
^-(* [12 14])                     *
^+(7 123)                         @ud
^+([7 8] [12 14])                 [@ud @ud]
^+([44 55] [12 14])               [@ud @ud]
^+([0x1b 0b11] [0x123 0b101])     [@ux @ub]
```

You can also use the irregular `` ` `` syntax for casting in the same way as `^-`; e.g., `` `@`123 `` for `^-(@ 123)`.

One thing to note about casts is that they can 'throw away' type information.  The second subexpression of `^-` and `^+` casts may be inferred to have a very specific type.  If the cast type is more general, then the more specific type information is lost.  Consider the literal `[12 14]`.  The inferred type of this expression is `[@ @]`, i.e., a cell of two atoms.  If we cast over `[12 14]` with `^-(^ [12 14])` then the inferred type is just `^`, the set of all cells.  The information about what kind of cell it is has been thrown away.  If we cast over `[12 14]` with `^-(* [12 14])` then the inferred type is `*`, the set of all nouns.  All interesting type information is thrown away on the latter cast.

It's important to remember to include a cast rune with each gate expression.  That way it's clear what the inferred product type will be for calls to that gate.

### (Dry) Gate Sample Definitions

By now you've used the `|=` rune to define several gates.  This rune is used to produce a 'dry' gate, which has different type-checking and type-inference properties than a 'wet' gate does.  We won't explain the wet/dry distinction until later in Chapter 2 -- for now, just keep in mind that we're only dealing with one kind of gate (albeit the more common kind).

The first subexpression after the `|=` defines the sample type.  Any faces used in this definition have the type declared for it in this definition.  Consider again the addition function:

```hoon
|=  [a=@ b=@]                                           ::  take two @
^-  @                                                   ::  output is one @
?:  =(b 0)                                              ::  if b is 0
  a                                                     ::    return a, else
$(a +(a), b (dec b))                                    ::  add a+1 and b-1
```

We run it in the dojo using a cell to pass the two arguments:

```
> +add 12 14
26

> +add 22
nest-fail
-want.{a/@ b/@}
-have.@ud
```

If you try to call this gate with the wrong kind of argument, you get a `nest-fail`.  If the call succeeds, then the argument takes on the type of the sample definition: `[a=@ b=@]`.  Accordingly, the inferred type of `a` is `@`, and the inferred type of `b` is `@`.  In this case some type information has been thrown away; the inferred type of `[12 14]` is `[@ud @ud]`, but the addition program takes all atoms, regardless of aura.

### Using Conditionals for Inference by Branch

You learned about a few conditional runes earlier in the chapter (e.g., `?:`, `?.`), but other runes of the `?` family are used for branch-specialized type inference.  The `?@`, `?^`, and `?~` conditionals each take three subexpressions, which play the same basic role as the corresponding subexpressions of `?:` -- the first is the test condition, which evaluates to a flag `?`.  If the test condition is true, the second subexpression is evaluated; otherwise the third.  These second and third subexpressions are the 'branches' of the conditional.

There is also a `?=` rune for matching expressions with certain types, returning `%.y` for a match and `%.n` otherwise.

#### `?=` Non-recursive Type Match Test

The `?=` rune takes two subexpressions.  The first subexpression should be a type.  The second subexpression is evaluated and the resulting value is compared to the first type.  If the value is an instance of the type, `%.y` is produced.  Otherwise, `%.n`.  Examples:

```
> ?=(@ 12)
%.y

> ?=(@ [12 14])
%.n

> ?=(^ [12 14])
%.y

> ?=(^ 12)
%.n

> ?=([@ @] [12 14])
%.y

> ?=([@ @] [[12 12] 14])
%.n
```

`?=` expressions ignore aura information:

```
> ?=(@ud 0x12)
%.y

> ?=(@ux 'hello')
%.y
```

We haven't talked much about types that are made with a type constructor yet.  We'll discuss these more soon, but it's worth pointing out that every list type qualifies as such, and hence should not be used with `?=`:

```
> ?=((list @) ~[1 2 3 4])
fish-loop
```

Using these non-basic constructed types with the `?=` rune results in a `fish-loop` error.

##### Using `?=` for Type Inference

The `?=` rune is particularly useful when used with the `?:` rune, because in these cases Hoon uses the result of the `?=` evaluation to infer type information.  To see how this works lets use `=/` to define a face, `b`, as a generic noun:

```
> =/(b=* 12 b)
12
```

The inferred type of the final `b` is just `*`, because that's how `b` was defined earlier.  We can see this by using `?` in the dojo to see the product type:

```
> ? =/(b=* 12 b)
  *
12
```
(Remember that `?` isn't part of Hoon -- it's a dojo-specific instruction.)

Let's replace that last `b` with a `?:` expression whose condition subexpression is a `?=` test.  If `b` is an `@`, it'll produce `[& b]`; otherwise `[| b]`:

```
> =/(b=* 12 ?:(?=(@ b) [& b] [| b]))
[%.y 12]
```

You can't see it here, but the inferred type of `b` in `[& b]` is `@`.  That subexpression is only evaluated if `?=(@ b)` evaluates as true; hence, Hoon can safely infer that `b` must be an atom in that subexpression.  Let's set `b` to a different initial value but leave everything else the same:

```
> =/(b=* [12 14] ?:(?=(@ b) [& b] [| b]))
[%.n 12 14]
```

You can't see it here either, but the inferred type of `b` in `[| b]` is `^`.  That subexpression is only evaluated if `?=(@ b)` evaluates as false, so `b` can't be an atom there.  It follows that it must be a cell.

##### The Type Spear

We think we're trustworthy, but perhaps you don't want to take our word for it.  What if you want to see the inferred type of `b` for yourself for each conditional branch?  One way to do this is with a 'type spear'.  But you need to understand the `!>` rune before using this mighty weapon of war.  `!>` takes one subexpression and constructs a cell from it.  The subexpression is evaluated and becomes the tail of the product cell, with a `q` face attached.  The head of the product cell is the inferred type of the subexpression.  Examples:

```
> !>(15)
[#t/@ud q=15]

> !>([12 14])
[#t/{@ud @ud} q=[12 14]]

> !>((add 22 55))
[#t/@ q=77]
```

The `#t/` is just the pretty-printer's way of indicating a type.

To get just the inferred type of a expression, we only want the head of the `!>` product, `-`.  Thus we should use the type spear, `-:!>`.

```
> -:!>(15)
#t/@ud

> -:!>([12 14])
#t/{@ud @ud}

> -:!>((add 22 55))
#t/@
```

Now let's try using `?=` with `?:` again.  But this time we'll replace `[& b]` with `[& -:!>(b)]` and `[& b]` with `[| -:!>(b)]`.  With `b` as `12`:

```
> =/(b=* 12 ?:(?=(@ b) [& -:!>(b)] [| -:!>(b)]))
[%.y #t/@]
```

...and with `b` as `[12 14]`:

```
> =/(b=* [12 14] ?:(?=(@ b) [& -:!>(b)] [| -:!>(b)]))
[%.n #t/{* *}]
```

In both cases, `b` is defined initially as a generic noun, `*`.  But when using `?:` with `?=(@ b)` as the test condition, `b` is inferred to be an atom, `@`, when the condition is true; otherwise `b` is inferred to be a cell, `^` (identical to `{* *}`).

##### `mint-vain`

Expressions of the form `?:(?=(a b) c d)` should only be used when the previously inferred type of `b` isn't specific enough to determine whether it nests under `a`.  This kind of expression is only to be used when `?=` can reveal new type information about `b`, not to confirm information Hoon already has.

For example, if you have a wing expression (e.g., `b`) that is already known to be an atom, `@`, and you use `?=(@ b)` to test whether `b` is an atom, you'll get a `mint-vain` crash.  The same thing happens if `b` is initially defined to be a cell `^`:

```
> =/(b=@ 12 ?:(?=(@ b) [& b] [| b]))
mint-vain

> =/(b=^ [12 14] ?:(?=(@ b) [& b] [| b]))
mint-vain
```

In the first case it's already known that `b` is an atom.  In the second case it's already known that `b` isn't an atom.  Either way, the check is superfluous and thus one of the `?:` branches will never be taken.  The `mint-vain` crash indicates that it's provably the case one of the branches will never be taken.

#### `?@` Atom Match Tests

The `?@` rune takes three subexpressions.  The first is evaluated, and if its value is an instance of `@`, the second subexpression is evaluated.  Otherwise, the third subexpression is evaluated.

```
> =/(b=* 12 ?@(b %atom %cell))
%atom

> =/(b=* [12 14] ?@(b %atom %cell))
%cell
```

If the second `?@` subexpression is evaluated, Hoon correctly infers that `b` is an atom.  if the third subexpression is evaluated, Hoon correctly infers that `b` is a cell.

```
> =/(b=* 12 ?@(b [%atom -:!>(b)] [%cell -:!>(b)]))
[%atom #t/@]

> =/(b=* [12 14] ?@(b [%atom -:!>(b)] [%cell -:!>(b)]))
[%cell #t/{* *}]
```

If the inferred type of the first `?@` subexpression nests under `@` then one of the conditional branches provably never runs.  Attempting to evaluate the expression results in a `mint-vain`:

```
> ?@(12 %an-atom %not-an-atom)
mint-vain

> ?@([12 14] %an-atom %not-an-atom)
mint-vain

> =/(b=@ 12 ?@(b %an-atom %not-an-atom))
mint-vain

> =/(b=^ [12 14] ?@(b %an-atom %not-an-atom))
mint-vain
```

`?@` should only be used when it allows for Hoon to infer new type information; it shouldn't be used to confirm type information Hoon already knows.

#### `?^` Cell Match Tests

The `?^` rune is just like `?@` except it's a test for a cell match instead of an atom match.  The first subexpression is evaluated, and if the resulting value is an instance of `^` the second subexpression is evaluated.  Otherwise, the third is.

```
> =/(b=* 12 ?^(b %cell %atom))
%atom

> =/(b=* [12 14] ?^(b %cell %atom))
%cell
```

Again, if the second subexpression is evaluated Hoon infers that `b` is a cell; if the third, Hoon infers that `b` is an atom.  If one of the conditional branches is provably never evaluated, the expression crashes with a `mint-vain`:

```
> =/(b=@ 12 ?^(b %cell %atom))
mint-vain

> =/(b=^ 12 ?^(b %cell %atom))
nest-fail
```

#### Leaf Counting

Nouns can be understood as binary trees in which each 'leaf' of the tree is an atom.  Let's look at a program that takes a noun and returns the number of leaves in it, i.e., the number of atoms.

```hoon
|=  a=*                                                 ::  1
^-  @                                                   ::  2
?@  a                                                   ::  3
  1                                                     ::  4
(add $(a -.a) $(a +.a))                                 ::  5
```

Save this as `leafcount.hoon` in your urbit's pier and run it from the dojo:

```
> +leafcount 12
1

> +leafcount [12 14]
2

> +leafcount [12 [63 [829 12] 23] 13]
6
```

This program is pretty simple.  If the noun `a` is an atom, then it's a tree of one leaf; return `1`.  Otherwise, the number of leaves in `a` is the sum of the leaves in the head, `-.a`, and the tail, `+.a`.

We have been careful to use `-.a` and `+.a` only on a branch for which `a` is proved to be a cell -- then it's safe to treat `a` as having a head and a tail.

#### Cell Counting

Here's a program that counts the number of cells in a noun:

```hoon
|=  a=*                                                 ::  1
=|  c=@                                                 ::  2
|-  ^-  @                                               ::  3
?@  a                                                   ::  4
  c                                                     ::  5
%=  $                                                   ::  6
  c  $(c +(c), a -.a)                                   ::  7
  a  +.a                                                ::  8
==                                                      ::  9
```

Save this as `cellcount.hoon` and run it from the dojo:

```
> +cellcount 12
0

> +cellcount [12 14]
1

> +cellcount [12 14 15]
2

> +cellcount [[12 [14 15]] 15]
3

> +cellcount [[12 [14 15]] [15 14]]
4

> +cellcount [[12 [14 15]] [15 [14 22]]]
5
```

This code is a little more tricky.  The basic idea, however, is simple.  We have a counter value, `c`, whose initial value is `0`.  We trace through the noun `a`, adding `1` to `c` every time we come across a cell.  For any part of the noun that is just an atom, `c` is returned unchanged.

What makes this program is little harder to follow is that it has a recursion call within a recursion call.  The first recursion expression on line 6 makes changes to two face values: `c`, the counter, and `a`, the input noun.  The new value for `c` defined in line 7 is another recursion call (this time in irregular syntax).  The new value for `c` is to be: the result of running the same function on the the head of `a`, `-.a`, and with `1` added to `c`.  We add `1` because we know that `a` must be a cell.  Otherwise, we're asking for the number of cells in the rest of `-.a`.

Once that new value for `c` is computed from the head of `a`, we're ready to check the tail of `a`, `+.a`.  We've already got everything we want from `-.a`, so we throw that away and replace `a` with `+.a`.

#### Lists

You learned about lists earlier in the chapter, but we left out a little bit of information about the way Hoon understands list types.

A non-null list is a cell.  If `b` is a non-null list then the head of `b` is the first item of `b` _with an `i` face on it_.  The tail of `b` is the rest of the list.  The 'rest of the list' is itself another list _with a `t` face on it_.  We can (and should) use these `i` and `t` faces in list functions.

To illustrate: let's say that `b` is the list of the atoms `11`, `22`, and `33`.  Let's construct this in stages:

```
[i=11 t=[rest-of-list-b]]

[i=11 t=[i=22 t=[rest-of-list-b]]]

[i=11 t=[i=22 t=[i=33 t=~]]]
```

(There are lists of every type.  Lists of `@ud`, `@ux`, `@` in general, `^`, `[^ [@ @]]`, etc.  We can even have lists of lists of `@`, `^`, or `?`, etc.)

Here's a program that takes atoms `a` and `b` and returns a list of all atoms from `a` to `b`:

```hoon
|=  [a=@ b=@]                                           ::  1
^-  (list @)                                            ::  2
?:  (gth a b)                                           ::  3
  ~                                                     ::  4
[i=a t=$(a +(a))]                                       ::  5
```

This program is very simple.  It takes two `@` as input, `a` and `b`, and returns a `(list @)`, i.e., a list of `@`.  If `a` is greater than `b` the list is finished: return the null list `~`.  Otherwise, return a non-null list: a pair in which the head is `a` with an `i` face on it, and in which the tail is another list with the `t` face on it.  This embedded list is the product of a recursion call: add `1` to `a` and run the function again.

Save this code as `gulf.hoon` in your urbit's pier and run it from the dojo:

```
> +gulf [1 10]
~[1 2 3 4 5 6 7 8 9 10]

> +gulf [10 20]
~[10 11 12 13 14 15 16 17 18 19 20]

> +gulf [20 10]
~
```

Where are all the `i`s and `t`s???  For the sake of neatness the Hoon pretty-printer doesn't show the `i` and `t` faces of lists, just the items.

In fact, we could have left out the `i` and `t` faces in the program itself:

```hoon
|=  [a=@ b=@]                                           ::  1
^-  (list @)                                            ::  2
?:  (gth a b)                                           ::  3
  ~                                                     ::  4
[a $(a +(a))]                                           ::  5
```

Because there is a cast to a `(list @)` on line 2, Hoon will silently include `i` and `t` faces for the appropriate places of the noun.  Remember that faces are recorded in the type information of the noun in question, not as part of the noun itself.

We called this program `gulf.hoon` because it replicates the `gulf` function in the Hoon standard library:

```
> (gulf 1 10)
~[1 2 3 4 5 6 7 8 9 10]

> (gulf 10 20)
~[10 11 12 13 14 15 16 17 18 19 20]
```

#### `?~` Null Match Test

The `?~` rune is a lot like `?@` and `?^`.  It takes three subexpressions, the first of which is evaluated to see whether the result is null, `~`.  If so, the second subexpression is evaluated.  Otherwise, the third one is evaluated.

```
> =/(b=* ~ ?~(b %null %not-null))
%null

> =/(b=* [12 13] ?~(b %null %not-null))
%not-null
```

The inferred type of `b` must not already be known to be null or non-null; otherwise, the expression will crash with a `mint-vain`:

```
> =/(b=~ ~ ?~(b %null %not-null))
mint-vain

> =/(b=^ [10 12] ?~(b %null %not-null))
mint-vain

> ?~(~ %null %not-null)
mint-vain
```

Hoon will infer that `b` either is or isn't null based on which `?~` branch is evaluated after the test.

#### Using `?~` With Lists

The `?~` is especially useful for working with lists.  Is a list null, or not?  You probably want to do different things based on the answer to that question.  Here's a program using `?~` to calculate the number of items in a list of atoms:

```hoon
|=  a=(list @)                                          ::  1
=|  c=@                                                 ::  2
|-  ^-  @                                               ::  3
?~  a                                                   ::  4
  c                                                     ::  5
$(c +(c), a t.a)                                        ::  6
```

This function takes a list of `@` and returns an `@`.  It uses `c` as a counter value, initially set at `0` on line 2.  If `a` is `~` (i.e., a null list) then the computation is finished; return `c`.  Otherwise `a` must be a non-null list, in which case there is a recursion to the `|-` on line 3, but with `c` incremented, and with the head of the list `a` thrown away.

It's important to note that if `a` is a list, you can only use `i.a` and `t.a` after Hoon has inferred that `a` is non-null.  A null list has no `i` or `t` in it!  You'll often use `?~` to distinguish the two kinds of list (null and non-null).  If you use `i.a` or `t.a` without showing that `a` is non-null you'll get a `find-fork-d` crash.

Save the above code as `lent.hoon` in your urbit's pier and run it from the dojo:

```
> +lent ~[11 22 33]
3

> +lent ~[11 22 33 44 55 77]
6

> +lent ~[0xff 0b11 'howdy' %hello]
4
```

#### Converting a Noun to a List of its Leaves

Here's a program that takes a noun and returns a list of its 'leaves' (atoms) in order of their appearance:

```hoon
|=  a=*                                                           ::  1
=/  lis=(list @)  ~                                               ::  2
|-  ^-  (list @)                                                  ::  3
?@  a                                                             ::  4
  [i=a t=lis]                                                     ::  5
$(lis $(a +.a), a -.a)                                            ::  6
```

The input noun is `a`.  The list of atoms to be output is `lis`, which is given an initial value of `~`.  If `a` is just an atom, return a non-null list whose head is `a` and whose tail is `lis`.  Otherwise, the somewhat complicated recursion in line 6 is evaluated, in effect looping back to the `|-` with modifications made to `lis` and `a`.

The modification to `lis` in line 6 is to `$(a +.a)`.  The latter is a recursion to `|-` but with `a` replaced by its tail.  This evaluates to the list of `@` in the tail of `a`.  So `lis` becomes the list of atoms in the tail of `a`, and `a` becomes the head of `a`, `-.a`.

Save the above code as `listleaf.hoon` and run it from the dojo:

```
> +listleaf [[[[12 13] [33 22] 12] 11] 33]
~[12 13 33 22 12 11 33]
```

### Other Kinds of Type Inference

So far you've learned about four kinds of type inference, using: (1) literals, (2) explicit casts, (3) gate sample definitions, and (4) branch specialization using runes in the `?` family.

In fact, there are several other ways that Hoon infers type.  Any rune expression that evaluates to a flag, `?`, e.g., `.=`, will be inferred from accordingly.  The `.+` rune always evaluates to an `@`, and Hoon knows that too.  The cell constructor runes, `:-`, `:+`, `:^`, and `:*` are all known to produce cells.

More subtly, the `=+`, `=/`, and `=|` runes modify the subject by pinning values to the head. Hoon infers from this that the subject has a new type: a cell whose head is the type of the pinned value and whose tail is the type of the (old) subject.

In general, anything that modifies the subject modifies the type of the subject.  Type inference can work in subtle ways for various expressions.  However, we have covered enough that it should be relatively clear how to anticipate how type inference works for the vast majority of ordinary use cases.

