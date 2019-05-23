+++
title = "Hoon Syntax"
weight = 13
template = "doc.html"
+++
# 1.3 Hoon Syntax

The study of Hoon can be divided into two parts: syntax and semantics.

The [syntax](https://en.wikipedia.org/wiki/Syntax_(programming_languages%29) of a programming language is the set of rules that determine what counts as admissible code in that language.  It determines which characters may be used in the source, and also how these characters may be assembled to constitute a program.  Attempting to run a program that doesn't follow these rules will result in a syntax error.

The [semantics](https://en.wikipedia.org/wiki/Semantics_(computer_science%29) of a programming language concerns the meaning of the various parts of that language's code.

In this lesson we will give a general overview of Hoon's syntax. By the end of it, you should be familiar with all the basic elements of Hoon code.

## Hoon Characters

Hoon source files are composed almost entirely of the [printable ASCII characters](https://en.wikipedia.org/wiki/ASCII#Printable_characters).  Hoon does not accept any other characters in source files except for [UTF-8](https://en.wikipedia.org/wiki/UTF-8) in quoted strings.  Hard tab characters are illegal; use two spaces instead.

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

An [expression](https://en.wikipedia.org/wiki/Expression_(computer_science%29) is a combination of characters that the language interprets and evaluates as producing a value.  Hoon programs are made up entirely of expressions.

Hoon expressions can be either basic or complex.  Basic expressions of Hoon are fundamental, meaning that they can't be broken down into smaller expressions.  Complex expressions are made up of smaller expressions (which are called **subexpressions**).

There are many categories of Hoon expressions: noun literals, wing expressions, type expressions, and rune expressions.  Let's go over each.

### Noun Literals

A noun is either an atom or a cell.  An atom is an unsigned integer and a cell is a pair of nouns.

There are [literal](https://en.wikipedia.org/wiki/Literal_(computer_programming%29) expressions for each kind of noun.  A noun literal is just a notation for representing a fixed noun value.

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
```

Recall from [lesson 1.2](./docs/learn/hoon/hoon-tutorial/nouns.md) that even though atoms are unsigned integers, they can be pretty-printed in different ways.  The way an atom is to be represented depends on its aura.  The literal syntax for each of the hard-coded auras will be explained further in [lesson 2.4](./docs/learn/hoon/hoon-tutorial/atoms-auras-and-simple-cell-types.md).

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

A wing expression is a series of limb expressions separated by `.`.  You learned about these in [sections 1.3](./docs/reference/hoon-expressions/limb/wing.md) and [sections 1.4](./docs/reference/hoon-expressions/limb/limb.md).

Let's start with the base case: a single limb.  A limb expression is a trivial wing expression -- there is only one limb in the series.  Some one-limb wings:

- `+2`
- `-`
- `+>`
- `&4`
- `a`
- `b`
- `add`
- `mul`

As a special limb we also have `$`.  This is the name of the arm in special one-armed cores called "gates".  (We covered the role of `$` in [lesson 1.5](./docs/learn/hoon/hoon-tutorial/gates.md).)

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

They may also be put in brackets to indicate compound types, e.g., `[@ ^]`, `[@ud @sb]`, `[[? *] ^]`.  (Technically these expressions don't _always_ indicate compound types.  In certain contexts they're interpreted in a different way.  We'll address this variation of meaning in [lesson 2.6](./docs/learn/hoon/hoon-tutorial/structures-and-complex-types.md).)

### Rune Expressions

A **rune** is just a pair of ASCII characters (a digraph).  You've already seen some runes in Chapter 1: `|=`,`|%`, and `|_`.  We usually pronounce runes by combining their characters' names, e.g.: 'ket-hep' for `^-`, 'bar-tis' for `|=`, and 'bar-cen' for `|%`.  As stated previously, these names are entirely optional.

Expressions with a rune at the beginning are rune expressions.  Most runes are used at the beginning of a complex expression, but there are exceptions.  For example, the runes `--` and `==` are used at the end of certain expressions.

Runes are classified by family (with the exceptions of `--` and `==`).  The first of the two symbols indicates the family -- e.g., the `^-` rune is in the `^` family of runes, and the `|=` and `|%` runes are in the `|` family.  The runes of particular family usually have related meanings.  Two simple examples: the runes in the `|` family are all used to create cores, and the runes in the `:` family are all used to create cells.

Rune expressions are usually complex, which means they usually have one or more subexpressions.  The appropriate syntax varies from rune to rune; after all, they're used for different purposes.  To see the syntax rules for a particular rune, consult the [rune reference](./docs/reference/hoon-expressions/rune/_index.md).  Nevertheless, there are some general principles that hold of all rune expressions.

#### Tall and Flat Forms

There are two rune syntax forms: **tall** and **flat**.  Tall form is usually used for multi-line expressions, and flat form is used for one-line expressions.  Most runes can be used in either of tall or flat forms.  Tall form expressions may contain flat form subexpressions, but flat form expressions may not contain tall form.

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

The `( )` gate-calling syntax can be used for gates with any number of arguments.

You can find other irregular forms in the irregular expression [reference document](./docs/reference/hoon-expressions/irregular.md).

### Expressions That Are Only Irregular

There are certain irregular expressions that aren't syntactic sugar for regular form equivalents -- they're solely irregular.  There isn't much in general that can be said about these because they're all different, but we can look at some examples.

Below we use the `` ` `` symbol to create a cell whose head is null, `~`.

```
> `12
[~ 12]

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
```

To see other irregular expressions, check the irregular expression [reference document](./docs/reference/hoon-expressions/irregular.md).


## The Standard Library

The Hoon standard library is a compilation of generally useful Hoon gates (functions). You've seen these already: in expressions like `(add 11 11)`, `add` is a function from the standard library.

It's important to know about standard library functions, because they make certain tasks much easier, and spare you from having to write the code itself. If you did not use the `add` library function, for example, you would have to write out code like this every time you wanted to find the sum of two numbers:

```
++  add
  ~/  %add
  |=  [a=@ b=@]
  ^-  @
  ?:  =(0 a)  b
  $(a (dec a), b +(b))
```

Standard library functions are often built with other standard library functions, but ultimately those functions used are only built with runes. Notice how in the code above `add` is built with the `dec` function, which decrements a value by `1`.

## Reference Materials

The Hoon syntax can be intimidating for the uninitiated, so it's good to remember where you can look up expressions can be found. The [reference section](/docs/reference/) itself is a good place to find the reference materials that you need. These children sections are likely to be useful:

- The [Runes](/docs/reference/hoon-expressions/) page will show you how to use any Hoon rune.
- The [Cheat sheet](/docs/reference/cheat-sheet/) is a more compact place to look up rune expressions.
- The [Standard library](/docs/reference/library/) section has its sub-pages arranged by category. So arithmetic functions, for example, are all found on the same page.
- The [Hoon Style Guide](/docs/learn/hoon/style/) will show you how to write your Hoon code so that it's idiomatic and easily understood by others.

### Debugging

When you have an error in your Hoon code, one of two things can happen. Either the code does not run at all and you get an error (such as `nest-fail`), or your code _does_ run but produces the wrong results. The [Troubleshooting](/docs/reference/troubleshooting/) page is a good resource for figuring out how to debug your code.

There are a couple useful runes associated with debugging:

`!:` (zapcol), if written at the top of a Hoon file, turns on a full debugging stack-trace. It's good practice to use whenever you're learning.

`~&` (sigpam) is used to print its argument every time that argument executes. So, if you wanted to see how many times your program executed `foo`, you would write `foo bar`. Then, when your program runs, it will print `foo` on a new line of output every time the program comes across it by recursion.

But there are more. Check out the aforementioned [troubleshooting](/docs/reference/troubleshooting/) page to see other handy debugging runes and how to use them.

### [Next Lesson: The Subject and Its Legs](./docs/learn/hoon/hoon-tutorial/simple-one-gate-programs.md)
