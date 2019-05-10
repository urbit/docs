+++
title = "Hoon Syntax"
weight = 22
template = "doc.html"
+++
The study of Hoon can be divided into two parts: syntax and semantics.

The [syntax](https://en.wikipedia.org/wiki/Syntax_%28programming_languages%29) of a programming language is the set of rules that determine what counts as admissible code in that language.  It determines which characters may be used in the source, and also how these characters may be assembled to constitute a program.  Attempting to run a program that doesn't follow these rules will result in a syntax error.

The [semantics](https://en.wikipedia.org/wiki/Semantics_%28computer_science%29) of a programming language concerns the meaning of the various parts of that language's code.

In this lesson we cover Hoon's syntax.  A strict account of Hoon's syntax would refrain from making any reference at all to semantics, but for ease of exposition we won't be quite so fastidious.

## Hoon Characters

Hoon source files are composed almost entirely of the [printable ASCII characters](https://en.wikipedia.org/wiki/ASCII#Printable_characters).  Hoon does not accept any other characters in source files except for [UTF-8](https://en.wikipedia.org/wiki/UTF-8) in quoted strings.  Hard tab characters are illegal.

```
> "You can put ½ in quotes, but not elsewhere!"
"You can put ½ in quotes, but not elsewhere!"

> 'You can put ½ in single quotes too.'
'You can put ½ in single quotes too.'

> "Some UTF-8: ἄλφα"
"Some UTF-8: ἄλφα"
```

### Reading Hoon Aloud

Hoon code makes heavy use of non-alphanumeric symbols.  Reading off code aloud using the proper names of ASCII symbols is tedious, so we've mapped syllables to symbols:

```
ace [1 space]   gal <               pal (
bar |           gap [>1 space, nl]  par )
bas \           gar >               sel [
buc $           hax #               mic ;
cab _           hep -               ser ]
cen %           kel {               sig ~
col :           ker }               soq '
com ,           ket ^               tar *
doq "           lus +               tic `
dot .           pam &               tis =
fas /           pat @               wut ?
zap !
```

Learning and using these names of non-alphanumeric symbols is entirely optional; you can become an expert Hoon programmer without them.  Many Hoon programmers find them helpful, however, particularly when talking to someone else who knows them.

Note that the list includes two separate whitespace forms: `ace` for a single space; `gap` is either 2+ spaces or a newline.  In Hoon, the only whitespace significance is the distinction between `ace` and `gap` -- i.e., the distinction between one space and more than one.

## Expressions of Hoon

An [expression](https://en.wikipedia.org/wiki/Expression_%28computer_science%29) is a combination of characters that the language interprets and evaluates as producing a value.  Hoon programs are made up entirely of expressions.

Hoon expressions can be either basic or complex.  Basic expressions of Hoon are fundamental, meaning that they can't be broken down into smaller expressions.  Complex expressions are made up of smaller expressions (which are called *subexpressions*).

There are many categories of Hoon expressions: noun literals, wing expressions, type expressions, and rune expressions.  Let's go over each.

### Noun Literals

A noun is either an atom or a cell.  An atom is an unsigned integer and a cell is a pair of nouns.

There are [literal](https://en.wikipedia.org/wiki/Literal_%28computer_programming%29) expressions for each kind of noun.  A noun literal is just a notation for representing a fixed noun value.

We start with atom literals.  Each of these is a basic expression of Hoon that evaluates to itself.  Examples:

```
> 1
1

> 123
123

> 123.456
123.456

> 'hello'
'hello'

> ~zod
~zod

> 0xdead.beef
0xdead.beef

> 0b1101.1001
0b1101.1001
```

Recall from [lesson 1.2](../nouns) that even though atoms are unsigned integers, they can be pretty-printed in different ways.  The way an atom is to be represented depends on its aura.  The literal syntax for each of the hard-coded auras will be explained further in [lesson 2.4](../atoms-auras-and-simple-cell-types).

Cell literals can be written in Hoon using `[ ]`.  Cell literals are complex, because other expressions are put inside the square brackets.  Examples:

```
> [6 7]
[6 7]

> [[12 14] [654 123.456 980]]
[[12 14] 654 123.456 980]

> ['hello' 0xdad]
['hello' 0xdad]

> [123 [~zod ~ten] .1.2837]
[123 [~zod ~ten] .1.2837]
```

You can also put complex expressions inside square brackets to make a cell.  These are valid expressions but they aren't cell literals, naturally:

```
> [(add 22 33) (mul 22 33)]
[55 726]
```

### Wings

A wing expression is a series of limb expressions separated by `.`.  You learned about these in [sections 1.3](../hoon-ch1-3) and [sections 1.4](../hoon-ch1-4).

Let's start with the base case: a single limb.  A limb expression is a trivial wing expression -- there is only one limb in the series.  Some one-limb wings:

- `+2`
- `-`
- `+>`
- `&4`
- `a`
- `b`
- `add`
- `mul`
- `kebab-case-123`

As a special limb we also have `$`.  This is the name of the arm in special one-armed cores called "gates".  (We covered the role of `$` in [lesson 1.5](../hoon-ch1-5).)

Wing expressions with multiple limbs are complex expressions.  Examples:

- `+2.+3.+4`
- `-.+.+`
- `resolution.path.into.subject`
- `+>.$`
- `a.b.c`
- `-.b.+2`
- `-.add`

### Type Expressions

Hoon is a statically typed language.  You'll learn more about the type system later in the chapter.  For now, just know that Hoon's type system uses special symbols to indicate certain fundamental types: `~` (null), `*` (noun), `@` (atom), `^` (cell), and `?` (flag).  Each of these symbols can be used as a stand-alone expression of Hoon.  In the case of `@` there may be a series of letters following it, to indicate an atom aura; e.g., `@s`, `@rs`, `@tas`, and `@tD`.

They may also be put in brackets to indicate compound types, e.g., `[@ ^]`, `[@ud @sb]`, `[[? *] ^]`.  (Technically these expressions don't _always_ indicate compound types.  In certain contexts they're interpreted in a different way.  We'll address this variation of meaning in [lesson 2.6](../hoon-ch2-6).)

### Rune Expressions

A *rune* is just a pair of ASCII characters (a digraph).  You've already seen some runes in Chapter 1: `|=`,`|%`, and `|_`.  We usually pronounce runes by combining their characters' names, e.g.: 'ket-hep' for `^-`, 'bar-tis' for `|=`, and 'bar-cen' for `|%`.  As stated previously, these names are entirely optional.

Expressions with a rune at the beginning are rune expressions.  Most runes are used at the beginning of a complex expression, but there are exceptions.  For example, the runes `--` and `==` are used at the end of certain expressions.

Runes are classified by family (with the exceptions of `--` and `==`).  The first of the two symbols indicates the family -- e.g., the `^-` rune is in the `^` family of runes, and the `|=` and `|%` runes are in the `|` family.  The runes of particular family usually have related meanings.  Two simple examples: the runes in the `|` family are all used to create cores, and the runes in the `:` family are all used to create cells.

Rune expressions are usually complex, which means they usually have one or more subexpressions.  The appropriate syntax varies from rune to rune; after all, they're used for different purposes.  To see the syntax rules for a particular rune, consult the [rune reference](/docs/reference/hoon-expressions/rune).  Nevertheless, there are some general principles that hold of all rune expressions.

#### Tall and Flat Forms

There are two rune syntax forms: *tall* and *flat*.  Tall form is usually used for multi-line expressions, and flat form is used for one-line expressions.  Most runes can be used in either of tall or flat forms.  Tall form expressions may contain flat form subexpressions, but flat form expressions may not contain tall form.

The spacing rules differ in the two forms.  In tall form, each rune and subexpression must be separated from the others by a `gap` -- that is, by two or more spaces, or a line break.  In flat form the rune is immediately followed by parentheses `( )`, and the various subexpressions inside the parentheses must be separated from the others by an `ace` -- that is, by a single space.

Seeing an example will help you understand the difference.  The `:-` rune is used to produce a cell.  Accordingly, it is followed by two subexpressions: the first defines the head of the cell, and the second defines the tail.  Here are three different ways to write a `:-` expression in tall form:

```
> :-  11  22
[11 22]

> :-  11
  22
[11 22]

> :-
  11
  22
[11 22]
```

These all do the same thing.  The first example shows that, if you want to, you can write 'tall' form code on a single line.  Notice that there are two spaces between the `:-` rune and `11`, and also between `11` and `22`.  This is the minimum spacing necessary between the various parts of a tall form expression -- any fewer will result in a syntax error.

Usually one or more line breaks are used to break up a tall form expression.  This is especially useful when the subexpressions are themselves long stretches of code.  The same `:-` expression in flat-form is:

```
> :-(11 22)
[11 22]
```

This is the preferred way to write an expression on a single line.  The rune itself is followed by a set of parentheses, and the subexpressions inside are separated by a single space.  Any more spacing than that results in a syntax error.

Nearly all rune expressions can be written in either form, but there are exceptions.  `|%` and `|_` expressions, for example, can only be written in tall form.  (Those are a bit too complicated to fit comfortably on one line anyway.)

#### Irregular Forms

Some runes are used so frequently that they have irregular counterparts that are easier to write and which mean precisely the same thing.  Irregular rune syntax is hence a form of [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar).  All irregular rune syntax is flat.  (It follows from this that all tall form expressions are regular.)

Let's look at another example.  The `.=` rune takes two subexpressions, evaluates them, and tests the results for equality.  If they're equal it produces `%.y` for 'yes'; otherwise `%.n` for 'no'.  In tall form:

```
> .=  22  11
%.n

> .=  22  (add 11 11)
%.y

> .=  22
  11
%.n

> .=  22
  (add 11 11)
%.y
```

And in flat form:

```
> .=(22 11)
%.n

> .=(22 (add 11 11))
%.y
```

The irregular form of the `.=` rune is just `=( )`:

```
> =(22 11)
%.n

> =(22 (add 11 11))
%.y
```

The examples above have another irregular form: `(add 11 11)`.  This is the irregular form of `%+`, which calls a gate (i.e., a Hoon function) with two arguments for the sample.

```
> %+  add  11  11
22

> %+(add 11 11)
22
```

The irregular `( )` gate-calling syntax is versatile -- it is also a shortcut for calling a gate with one argument, which is what the `%-` rune is for:

```
> (dec 11)
10

> %-  dec  11
10

> %-(dec 11)
10
```

The `( )` gate-calling syntax can be used for gates of any other [arity](https://en.wikipedia.org/wiki/Arity) as well.

You've already seen two other irregular forms.  In [lesson 1.5](../gates), you made a gate that takes an atom `a` for its sample and returns `a + 1`: `|=(a=@ (add 1 a))`.  This expression uses the `|=` rune in flat form.

```
> =inc |=(a=@ (add 1 a))

> (inc 10)
11

> (inc 15)
16
```

The `a=@` subexpression -- used to define the face and the type of the gate's sample -- is the irregular form of `$=(a @)`:

```
> =inc |=($=(a @) (add 1 a))

> (inc 10)
11

> (inc 15)
16
```

In the previous chapter you also defined faces in nouns as in the following examples:

```
> b:[a=15 b=25 c=35]
25

> c:[a=15 b=25 c=35]
35
```

The `a=15` expression is the irregular form of `^=(a 15)`:

```
> b:[^=(a 15) ^=(b 25) ^=(c 35)]
25

> c:[^=(a 15) ^=(b 25) ^=(c 35)]
35
```

You can find other irregular forms in the irregular expression [reference document](/docs/reference/irregular).

### Expressions That Are Only Irregular

There are certain irregular expressions that aren't syntactic sugar for regular form equivalents -- they're solely irregular.  There isn't much in general that can be said about these because they're all different, but we can look at some examples.

Below we use the `` ` `` symbol to create a cell whose head is null, `~`.

```
> `12
[~ 12]

> `[12 14]
[~ 12 14]

> `[[12 14] 16]
[~ [12 14] 16]
```

Putting `,.` in front of a wing expression removes a face, if there is one.

```
> -:[a=[12 14] b=[16 18]]
a=[12 14]

> ,.-:[a=[12 14] b=[16 18]]
[12 14]

> ,.-:[[12 14] b=[16 18]]
[12 14]

> +:[a=[12 14] b=[16 18]]
b=[16 18]

> ,.+:[a=[12 14] b=[16 18]]
[16 18]

> ,.+:[a=[12 14] [16 18]]
[16 18]
```

To see other irregular expressions, check the irregular expression [reference document](docs/reference/irregular).

## Hoon Style

See [Hoon Style Guide](https://urbit.org/docs/learn/hoon/style/).

### Rune Expression Body Types

Let's call everything in the expression after the initial rune the expression *body*. There are four kinds of body: *fixed*, *running*, *jogging*, and *battery*.  There is a preferred manner of styling for each body.

#### Fixed

Some runes have a *fixed* number of subexpressions.  For example, the `:-` and `.=` runes each have exactly two.

Fixed bodies often use "backstep" indentation in tall form.  In backstep indentation the code slopes backward and to the right by two spaces per line.  The last subexpression isn't indented at all, and the first subexpression is on the same line as the rune.  The indentation of the first subexpression therefore depends upon the total number of subexpressions.

We'll use the `:` family of runes to illustrate.  The `:-` rune creates a cell from two subexpressions, `:+` creates a cell from three, and `:^` creates a cell from four.  In flat form:

```
> :-(11 22)
[11 22]

> :+(11 22 33)
[11 22 33]

> :^(11 22 33 44)
[11 22 33 44]
```

Let's look at these in tall form, using backstep indentation:

```
> :-  11
  22
[11 22]

> :+  11
    22
  33
[11 22 33]

> :^    11
      22
    33
  44
[11 22 33 44]
```


Some other *1-fixed*, *2-fixed*, *3-fixed* and *4-fixed* examples, using `p`, `q`, `r`, and `s` for the subexpressions:

```
|.
p

=|  p
q

?:  p
  q
r

%^    p
    q
  r
s
```

In optimal usage of backstep indentation the most complicated subexpressions are at the bottom.  This helps keep code flow vertical rather than diagonal.

#### Running

A *running* body doesn't have a fixed number of subexpressions; expressions with running bodies can be arbitrarily long.

To indicate the end of such expressions in tall form, use the `==` rune.  The first subexpression is two spaces after the initial rune, and all others are indented to line up with the first.  The terminating `==` should align vertically with the initial rune.  In flat form, parentheses are used around the expression body, so the terminating `==` is unnecessary.

The `:*` rune is used to create a cell of arbitrary length:

```
> :*(11 22 33)
[11 22 33]

> :*(11 22 33 44)
[11 22 33 44]

> :*(11 22 33 44 55)
[11 22 33 44 55]
```

We'll use `:*` to illustrate proper tall form running body style:

```
> :*  11
      22
      33
      44
      55
  ==
[11 22 33 44 55]
```

More generally:

```
:*  p
    q
    r
    s
    t
==
```

#### Jogging

A *jogging* body is an arbitrarily long series of subexpression pairs.  Most jogging bodies are preceded by a fixed sequence of subexpressions.  The first jogging pair is one line after the last fixed subexpression, and indented two spaces behind it.  There are two jogging conventions: *flat* (each pair on one line) and *tall* (each pair split across lines).  In either case the expression is terminated with a `==`.

The `?-` rune is `1-fixed` followed by a jogging body.  The fixed subexpression is evaluated and then compared against the left subexpression of each of the jogging pairs.  When a match is found, the subexpression to the right of the match is evaluated.

For example:

```
> ?-  `?(%2 %3 %4)`%2
    %2  %yes
    %3  %no
    %4  %no
  ==
%yes
```

More generally, the *flat jogging* style (preceded by *1-fixed* `p`):

```
?-  p
  q  r
  s  t
  u  v
==
```

A *tall jogging* example (preceded by *1-fixed* `p`):

```
?-    p
    q
  r
    s
  t
    u
  v
==
```

In flat form for *jogging* bodies, subexpression pairs are separated by commas:

```
$(a +(a), b (dec b), c (add 2 c))
```

#### Battery

Certain runes are used to create a core.  Cores with multiple arms have a special syntax for defining each of the arms in the battery.  A core has no fixed limit on the number of arms contained in its battery, so you must terminate core expressions with the `--` rune.  Each arm in the battery is defined with three things: (1) a rune in the `+` family (e.g., `++`, `+*`, and `+$`), (2) an arm name, and (3) a subexpression defining the content of that arm.  Runes in the `+` family may only go in core subexpressions.  Putting them anywhere else results in a syntax error.

Here's an example of a *battery* body:

```
|%
++  arm-1
  %p
++  arm-2
  %q
++  arm-3
  %r
--
```

## Motivation

There's no denying that Hoon's syntax is a bit strange, especially for those used to working in other programming languages.  Hoon makes heavy use of ASCII characters, and this can be intimidating to newcomers.  However, we believe that anyone who learns Hoon syntax will find that it has a number of advantages.

Hoon's syntax is designed to address three serious problems in functional syntax design.  These problems are: (1) *terminator piles*, (2) *indentation creep*, and (3) *feature/label confusion*.

### Terminator piles

A *terminator pile* is a series of termination characters required to end some expression in a language.  Think of Lisp's stacks of right parentheses.  For a trivial example, let's say you want to add 22 five times in Lisp using `+`:

```
(+ 22 (+ 22 (+ 22 (+ 22 22))))
```

In a sufficiently complicated expression it's tedious to keep track of all the parentheses in the terminator pile.  You can write terminator piles in Hoon code if you really want to:

```
> (add 22 (add 22 (add 22 (add 22 22))))
110
```

...but you are never forced to do so.  There is always a semantically equivalent alternative syntax without them:

```
> %+  add  22
  %+  add  22
  %+  add  22
  %+  add  22  22
110
```

### Indentation creep

In some programming languages there is an indentation convention according to which an expression embedded within a parent expression is indented more to the right.  In a sufficiently long and complicated function with many embedded subexpressions, the tendency is for the code to shift more and more to the right.  This tendency is called *indentation creep*, and it can become an irritating problem when working with long functions.  It's true that short functions are better, but long ones sometimes need to be written.

Ordinary indentation conventions give long functions a _diagonal_ shape, which is a poor fit for most editor windows.  Because Hoon is designed to be written with 'backstep' indentation, the code flows _down_, not down and across.

### Feature/label confusion

A language lends itself to *feature/label confusion* (FLC) when it's difficult to distinguish general features of the language from labels in a particular program.  This can be a serious problem other functional programming languages.  In Lisp, for example, a user-defined macro has the same syntax as a function call.

The worst-case result of FLC is "DSL cancer".  Every source file with this malady is effectively written in its own domain-specific language (DSL).  Learning to read such a file is like learning a language.  One can also describe the result as "write-only code".  User-level macros, operator overloading, and even excessive use of higher-order programming, can all lead quickly to the tragedy of write-only code.

Hoon largely avoids FLC by its use of runes.  Hoon has no user-level macros or operator overloading. It does support higher-order programming; write-only Hoon can certainly be (and has been) written.  However, with a little discipline one can write Hoon without inventing a DSL.

### [Next Lesson: Simple One-Gate Programs](../simple-one-gate-programs)
