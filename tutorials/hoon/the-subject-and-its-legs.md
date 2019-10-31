+++
title = "1.6 The Subject and Its Legs"
weight = 13
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/the-subject-and-its-legs/"]
+++

Hoon isn't an object-oriented programming language; it's a "subject-oriented" programming language.  But what's this "subject"?

## A Start

For now we can say three things about the subject: (1) every Hoon expression is evaluated relative to some subject; (2) roughly, the subject defines the environment in which a Hoon expression is evaluated; and (3) the subject is a noun.

In fact, you already learned about the noun address system in [Lesson 1.2](../nouns.md) when you used `+` to return a fragment of a noun:

```
> +1:[[11 22] 33]
[[11 22] 33]

> +2:[[11 22] 33]
[11 22]

> +3:[[11 22] 33]
33
```

The `:` operator does two things.  First, it evaluates the expression on the right-hand side; and second, it evaluates the expression on the left-hand side, using the product of the right-hand side as its subject.

In the examples above, the expression on the right-hand, `[[11 22] 33]`, evaluates to itself:

```
> [[11 22] 33]
[[11 22] 33]
```

...so the subject for the left-hand expression, `+1`, is simply `[[11 22] 33]`.  The `+` operator is used to produce some fragment of the subject at a given address.  E.g., `+2`, returns whatever is at address `2` of the subject.  Hence, we may read `+2:[[11 22] 33]` as "address `2` of the subject produced by `[[11 22] 33]`".

Let's create a subject with some computations:

```
> [[(add 22 33) (mul 2 6)] 23]
[[55 12] 23]

> +1:[[(add 22 33) (mul 2 6)] 23]
[[55 12] 23]

> +2:[[(add 22 33) (mul 2 6)] 23]
[55 12]

> +3:[[(add 22 33) (mul 2 6)] 23]
23

> +4:[[(add 22 33) (mul 2 6)] 23]
55
```

`add` and `mul` are functions of the Hoon standard library.  `add` is used to add two atoms, and `mul` is used to multiply them.

## Limbs of the Subject

The subject is a noun, just like any other piece of Hoon data.  In Lesson 1.2 we discussed how any noun can be understood as a binary tree.  E.g., `[[4 5] [6 [14 15]]]`:

```
     [[4 5] [6 [14 15]]]
             .
            / \
          .     .
         / \   / \
        4   5 6    .
                  / \
                 14 15
```

Each fragment of a noun is itself a noun, and hence can be understood as a binary tree as well.  Each fragment or 'subtree' sticks out of the original tree, like a **limb**.  A 'limb' is a subtree of the subject.

Sometimes a programmer simply wants to produce a value from the subject.  In other cases more is desired -- programmers often want to carry out substantive computations on data in the subject.  There are two kinds of limbs to accommodate these two cases: arms and legs.

**Arms** are limbs of the subject that are used for carrying out substantive computations.  We'll talk about arms in the next lesson.  **Legs** are limbs that store data.  Any limb that isn't an arm is a leg.  In this lesson we'll talk about various ways to access legs of the subject.

### Address-based Limb Expressions

A limb expression is an expression of Hoon that resolves to a limb of the subject.  An address-based limb expression evaluates to a limb of the subject based on its noun address.

In the following you'll learn the various limb expressions available in Hoon, as well as how they work when they resolve to legs.  First we'll explain the limb expressions that return a leg according to subject address.

#### `+` operator

You've already used this.  For any unsigned integer `n`, `+n` returns the limb of the subject at address `n`.  If there is no such limb, the result is a crash.

```
> +2:[111 222 333]
111

> +3:[111 222 333]
[222 333]

> +6:[111 222 333]
222
```

#### `.` expression

Using `.` as an expression returns the entire subject.  It's equivalent to `+1`.

```
> .:[[4 5] [6 [14 15]]]
[[4 5] 6 14 15]

> .:[4 5]
[4 5]

> .:'The whole subject!'
'The whole subject!'
```

#### 'lark' expressions (`+`, `-`, `+>`, `+<`, `->`, `-<`, etc.)

Using `-` by itself returns the head of the subject, and using `+` by itself returns the tail:

```
> -:[[4 5] [6 [14 15]]]
[4 5]

> +:[[4 5] [6 [14 15]]]
[6 14 15]
```

To think of it another way, `-` is for the left and `+` is for the right.  You can remember this by thinking of a number line -- the negative numbers are to the left, the positive numbers to the right.

`-` and `+` only work if the subject is a cell, naturally.  An atom doesn't have a head or a tail.

```
> +:12
ford: %ride failed to execute:
```

What if you want the tail of the tail of the subject?  You might expect that you can double up on `+` for this: `++`.  Not so.  Instead, combine `+` with `>`: `+>`.  `>` means the same thing as `+`, but is used with `+` to make for easier reading.

And the analogous point also holds for `-` and `<`.  You can combine `+` or `-` with either of `>` or `<` to get a more specific limb of the subject.  `-<` returns the head of the head; `->` returns the tail of the head; and `+<` returns the head of the tail.

```
> -<:[[4 5] [6 [14 15]]]
4

> ->:[[4 5] [6 [14 15]]]
5

> +<:[[4 5] [6 [14 15]]]
6

> +>:[[4 5] [6 [14 15]]]
[14 15]
```

By alternating the `+`/`-` symbols with `<`/`>` symbols, you can grab an even more specific limb of the subject:

```
> +>-:[[4 5] [6 [14 15]]]
14

> +>+:[[4 5] [6 [14 15]]]
15
```

You can think of this sort of lark series -- e.g., `+>-<` -- as indicating a binary tree path to a limb of the subject, starting from the root node of the tree.  In the case of `+>-<` this path is: tail, tail, head, head.

```
        *Root*
        /    \
     Head   *Tail*
            /    \
         Head   *Tail*
                /    \
            *Head*   Tail
            /    \
        *Head*   Tail
```

#### Exercise 1.6a
1. Use a lark expression to obtain the value 6 in the following noun represented by a binary tree:
```
         .
         /\
        /  \
       /    \
      .      .
     / \    / \
    /   .  10  .
   /   / \    / \
  .   8   9  11  .
 / \            / \
5   .          12  13
   / \
  6   7
```
2. Use a lark expression to obtain the value 9 in the following noun: `[[5 6] 7 [[8 9 10] 3] 2] 1]`.

Solutions to these exercises may be found at the bottom of this lesson.

#### `&` and `|` operators

`&n` returns the `n`th item of a list that has at least `n + 1` items.  `|n` returns everything after `&n`.

But what's a list?  There are two kinds of lists: empty and non-empty.  The empty list is null, `~`.  A non-empty list is a cell whose head is the first item and whose tail is the rest of the list.  'The rest of the list' is itself a list.  Hoon lists are null-terminated; that is, the null symbol `~` indicates the end of the list.  Consider the following cell of nouns:

```
> ['first' 'second' 'third' 'fourth' ~]
['first' 'second' 'third' 'fourth' ~]
```

The `'first'` noun is at `+2`, `'second'` is at `+6`, `'third'` is at `+14`, and so on.  (Try it!)  That's because the above noun is really the following:

```
> ['first' ['second' ['third' ['fourth' ~]]]]
['first' 'second' 'third' 'fourth' ~]
```

...with the superfluous brackets removed.  Rather than using `+2` to produce `'first'` and `+6` to produce `'second'`, you can use `&1` and `&2` to produce the first and second items in the list, respectively:

```
> &1:['first' 'second' 'third' 'fourth' ~]
'first'

> &2:['first' 'second' 'third' 'fourth' ~]
'second'

> &3:['first' 'second' 'third' 'fourth' ~]
'third'

> &4:['first' 'second' 'third' 'fourth' ~]
'fourth'
```

The list items can themselves be cells:

```
> &1:[['first' %pair] ['second' %pair] ['third' %pair] ~]
['first' %pair]

> &2:[['first' %pair] ['second' %pair] ['third' %pair] ~]
['second' %pair]

> &3:[['first' %pair] ['second' %pair] ['third' %pair] ~]
['third' %pair]
```

We can give an alternate, recursive definition of `&n` for all positive integers `n`.  In the base case, `&1` is equivalent to `+2`.  For the generating case, assume that `&(n - 1)` is equivalent to `+k`.  Then `&n` is equivalent to `+((k × 2) + 2)`.

For example, let `n` be 4.  What is `&4`?  `&3` is equivalent to `+14`.  `(14 × 2) + 2` is `30`, so `&4` is equivalent to `+30`.

`|n` returns the rest of the list after `&n`:

```
> |1:['first' 'second' 'third' 'fourth' ~]
['second' 'third' 'fourth' ~]

> |2:['first' 'second' 'third' 'fourth' ~]
['third' 'fourth' ~]

> |3:['first' 'second' 'third' 'fourth' ~]
['fourth' ~]

> |4:['first' 'second' 'third' 'fourth' ~]
~
```

As with `&n`, we can characterize `|n` recursively.  In the base case, `|1` is `+3`.  In the generating case, assume that `|(n - 1)` is equivalent to `+k`.  Then `|n` is equivalent to `+((k × 2) + 1)`.

### Other Limb Expressions: Names

Working with specific addresses of the subject can be cumbersome even when the subject is small.  When the subject is a really large noun -- as is often the case -- it's downright impractical.  Thankfully there's a more convenient method for resolving to a limb of the subject: using names.

A name can resolve either an arm or a leg of the subject.  Recall that arms are for computations and legs are for data.  When a name resolves to an arm, the relevant computation is run and the product of the computation is produced.  When a limb name resolves to a leg, the value of that leg is produced.  We aren't yet ready to talk about arm resolution; for now let's focus on leg names.

#### Faces

Hoon doesn't have variables like other programming languages do; it has 'faces'.  Faces are like variables in certain respects, but not in others.  Faces play various roles in Hoon, but most frequently faces are used simply as labels for legs.

A face is a limb expression that consists of a series of alphanumeric characters.  A face has a combination of lowercase letters, numbers, and the `-` character.  Some example faces: `b`, `c3`, `var`, `this-is-kebab-case123`.  Faces must begin with a letter.

There are various ways to affix a face to a limb of the subject, but for now we'll use the simplest method: `face=value`.  An expression of this form is equivalent in value to simply `value`.  Hoon registers the given `face` as metadata about where the value is stored in the subject, so that when that face is invoked later its data is produced.

```
> b=5
b=5

> [b=5 cat=6]
[b=5 cat=6]

> -:[b=5 cat=6]
b=5

> b:[b=5 cat=6]
5

> b2:[[4 b2=5] [cat=6 d=[14 15]]]
5

> d:[[4 b2=5] [cat=6 d=[14 15]]]
[14 15]
```

To be clear, `b=5` is equivalent in value to `5`, and `[[4 b2=5] [cat=6 d=[14 15]]]` is equivalent in value to `[[4 5] 6 14 15]`.  The faces are not part of the underlying noun; they're stored as metadata about address values in the subject.

If you use a face that isn't in the subject you'll get a `find.[face]` crash:

```
> a:[b=12 c=14]
-find.a
[crash message]
```

You can give your faces faces:

```
> b:[b=c=123 d=456]
c=123
```

#### Duplicate Faces

There is no restriction against using the same face name for multiple limbs of the subject.  This is one way in which faces aren't like ordinary variables:

```
> [[4 b=5] [b=6 b=[14 15]]]
[[4 b=5] b=6 b=[14 15]]

> b:[[4 b=5] [b=6 b=[14 15]]]
5
```

Why does this return `5` rather than `6` or `[14 15]`?  When a face is evaluated on a subject, a head-first binary tree search occurs starting at address `1` of the subject.  If there is no matching face for address `n` of the subject, first the head of `n` is searched and then `n`'s tail.  The complete search path for `[[4 b=5] [b=6 b=[14 15]]]` is:


+ `[[4 b=5] [b=6 b=[14 15]]]`
+ `[4 b=5]`
+ `4`
+ `b=5`
+ `[b=6 b=[14 15]]`
+ `b=6`
+ `b=[14 15]`

There are matches at steps 4, 6, and 7 of the total search path, but the search ends when the first match is found at step 4.

The children of legs bearing names aren't included in the search path.  For example, the search path of `[[4 a=5] b=[c=14 15]]` is:

+ `[[4 a=5] b=[c=14 15]]`
+ `[4 a=5]`
+ `4`
+ `a=5`
+ `b=[c=14 15]`

Neither of the legs `c=14` or `15` is checked.  Accordingly, a search for `c` of `[[4 a=5] b=[c=14 15]]` fails:

```
> c:[[4 b=5] [b=6 b=[c=14 15]]]
-find.c [crash message]
```

There are cases when you don't want the limb of the first matching face.  You can 'skip' the first match by prepending `^` to the face.  Upon discovery of the first match at address `n`, the search skips `n` (as well as its children) and continues the search elsewhere:

```
> ^b:[[4 b=5] [b=6 b=[14 15]]]
6
```

Recall that the search path for this noun is:

+ `[[4 b=5] [b=6 b=[14 15]]]`
+ `[4 b=5]`
+ `4`
+ `b=5`
+ `[b=6 b=[14 15]]`
+ `b=6`
+ `b=[14 15]`

The second match in the search path is step 6, `b=6`, so the value at that leg is produced.  You can stack `^` characters to skip more than one matching face:

```
> a:[[[a=1 a=2] a=3] a=4]
1

> ^a:[[[a=1 a=2] a=3] a=4]
2

> ^^a:[[[a=1 a=2] a=3] a=4]
3

> ^^^a:[[[a=1 a=2] a=3] a=4]
4
```

When a face is skipped at some address `n`, neither the head nor the tail of `n` is searched:

```
> b:[b=[a=1 b=2 c=3] a=11]
[a=1 b=2 c=3]

> ^b:[b=[a=1 b=2 c=3] a=11]
-find.^b
```

The first `b`, `b=[a=1 b=2 c=3]`, is skipped; so the entire head of the subject is skipped.  The tail has no `b`; so `^b` doesn't resolve to a limb when the subject is `[b=[a=1 b=2 c=3] a=11]`.

How do you get to that `b=2`?  And how do you get to the `c` in `[[4 a=5] b=[c=14 15]]`?  In each case you should use a wing.

## Wings

A **wing** is a limb resolution path into the subject.  A wing expression indicates the path as a series of limb expressions separated by the `.` character.  E.g.,

```
limb1.limb2.limb3
```

You can read this as `limb1` in `limb2` in `limb3`, etc.  You can use a wing to get the value of `c` in `[[4 a=5] b=[c=14 15]]`: `c.b`

```
> c.b:[[4 a=5] b=[c=14 15]]
14
```

And to get the `b` inside the head of `[b=[a=1 b=2 c=3] a=11]`: `b.b`.

```
> b.b:[b=[a=1 b=2 c=3] a=11]
2

> a.b:[b=[a=1 b=2 c=3] a=11]
1

> c.b:[b=[a=1 b=2 c=3] a=11]
3

> a:[b=[a=1 b=2 c=3] a=11]
11

> b.a:[b=[a=1 b=2 c=3] a=11]
-find.b.a
```

Here are some other wing examples:

```
> g.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
[h=0xff i=0b11]

> c.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
[d=12 e='hello']

> e.c.s:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
'hello'

> +3:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
r='howdy'

> r.+3:[s=[c=[d=12 e='hello'] g=[h=0xff i=0b11]] r='howdy']
'howdy'
```

### Limbs are Trivial Wings

As stated before, a wing is a limb resolution path into the subject.  This definition includes as a trivial case a path of just one limb.  Thus, all limbs are wings, and all limb expressions are wing expressions.

We mention this because it is convenient to refer to all limbs and non-trivial wings as simply 'wings'.  This will be our usual practice for the rest of this series.

## Exploring the Subject

Earlier we said that every Hoon expression is evaluated relative to a subject.  We then showed how the `:` operator uses a Hoon expression on the right-hand side to set the subject for the expression on the left.

```
> b:[b='Hello world!' c='This is the tail of the subject for the LHS']
'Hello world!'
```

The left, `b`, uses the product of the right as its subject.  But what about the right-hand expression?  What's _its_ subject?  Until now we've included an explicit subject in all the examples, but it's time to remove the training wheels.  Usually the subject of a Hoon expression isn't shown explicitly.

Consider the expression `(add 2 2)`:

```
> (add 2 2)
4
```

What's the subject of this expression?

In fact, you may already know how to find the answer.  The subject is a noun and as such its limbs have addresses.  To see that noun, use `+1`.  You'll see something like the following:

```
> +1
[ [ our=~zod
    now=~2018.12.10..22.10.44..09d7
      eny
    \/0v2dv.6gdve.pp0br.rh1sq.bq4ok.p9dqn.5r44u.7tqrl.qdrmo.i223s.472gv.hrb44\/
      .g2h3h.p1dih.3v7ju.58eei.i51es.akbie.290r8.2vt29.qv54q
    \/                                                                       \/
  ]
  <19.anu 24.tmo 6.ipz 38.ard 119.spd 241.plj 51.zox 93.pqh 74.dbd 1.qct $141>
]
```

This noun (or a modified version of it) is the subject used for Hoon expressions entered into the dojo.

We can't explain every part of the subject just yet, but you should be able to recognize some of it.  There is a face, `our`, serving as a label for the urbit's name.  Another face, `now`, is a label for an absolute date.  `eny` is a face for an atom serving as [entropy](https://en.wikipedia.org/wiki/Entropy_%28computing%29).  The value for `eny` is different every time it's checked.

```
> our
~zod

> now
~2018.12.10..22.13.25..18ef

> eny
\/0v3qd.9lnj9.0up6k.dn4tp.ue9cs.mgsii.5fdqm.p12d6.104o1.6knrb.mkft3.pihte.vdt\/
  bo.io77f.5uq5a.hrish.va34d.jv2b7.3bn3o.ol9ii.fg9i5
\/                                                                           \/

> eny
\/0v10n.4lqle.q66jp.rr3uv.3q4nc.dj7pl.t1df4.4a2fe.qh2l5.up998.sj7mp.on646.881\/
  0g.nfcfj.gempp.tehbd.087g4.cpi7l.2mr25.477mb.mj2va
\/                                                                           \/
```

Also embedded in that subject is the Hoon 'standard library', a library of commonly-used functions.  We've already used two of them: `add` and `mul`.  Have you noticed that these function names look like faces?  They aren't actually faces, but Hoon searches for them like it searches for faces.  When we call `add`,

```
> (add 22 33)
55
```

...it only works because Hoon finds `add` somewhere in the subject.  We can make a subject that doesn't have `add` in it and try to use it:

```
> (add 22 33):[123 456]
-find.add

> (add 22 33):['This subject' 'is austere.']
-find.add
```

It doesn't work because, as far as Hoon is concerned, `add` doesn't exist for the expression on the left.  We can put `add` back into the subject manually, however:

```
> (add 22 33):[123 456 add]
55
```

And it works!

The subject of the right-hand side expression of the `:` is the same implicit subject we have in the dojo.

## Dojo Faces

We're playing in the Urbit `dojo`.  The dojo is like a cross between a Lisp REPL and the Unix shell.  (If you know the Unix shell, the Urbit command line has the same history model and Emacs editing commands.)

It's worth taking a moment to learn about certain features of the dojo that aren't part of Hoon, but which can be handy to experiment with when learning Hoon.

You can use the dojo to add a noun with a face to the subject.  Type:

```
> =a 37
```

You've added `37` to the dojo subject with the face `a`.  Hoon expressions entered into the dojo can now use `a` and it will resolve to this value. So you can write:

```
> a
37

> [4 a]
[4 37]

> (add a a)
74

> (mul a a)
1.369
```

To unbind `a` and remove its value from the subject, enter `=a` and omit the value:

```
> =a
```

You removed `a` from the subject.  (We can bind it again later, or bind over it without removing it.)

```
> [4 a]
-find.a
```

### Dojo Fun

We can use dojo faces to get used to how wings work.

```
> =a [g=37 b=[%hi c=.6.28] h=0xdead.beef]

> a
[g=37 b=[%hi c=.6.28] h=0xdead.beef]

> g.a
37

> b.a
[%hi c=.6.28]

> c.b.a
.6.28

> +2.a
g=37

> +3.a
[b=[%hi c=.6.28] h=0xdead.beef]
```

Here are a few more examples:

```
> c:[c=[d=15 e=20] f=[g=45 h=50]]
[d=15 e=20]

> -.c:[c=[d=15 e=20] f=[g=45 h=50]]
d=15

> +.c:[c=[d=15 e=20] f=[g=45 h=50]]
e=20

> +1.c:[c=[d=15 e=20] f=[g=45 h=50]]
[d=15 e=20]

> ..c:[c=[d=15 e=20] f=[g=45 h=50]]
[d=15 e=20]
```

## Creating a Modified Leg

Often a leg of the subject is produced with its value unchanged.  But there is a way to produce a modified version of the leg as well.  To do so, we use an expression of the form:

```
wing-of-subject(wing-1 new-value-1, wing-2 new-value 2, ...)
```

The `wing-of-subject` resolves to some limb in the subject.  This is followed by a set of parentheses.  `wing-1` and `wing-2` pick out which parts of that limb we want to change.  Their values are replaced with `new-value-1` and `new-value-2`, respectively.  Commas separate each of the `wing` `new-value` pairs.

Let's create a mutant version of the noun we have stored in `a`.  To do this, type in the face `a` followed by the desired modifications in parentheses:

```
> a
[g=37 b=[%hi c=.6.28] h=0xdead.beef]

> a(g 44)
[g=44 b=[%hi c=.6.28] h=0xdead.beef]

> a(b 'hello world!')
[g=37 b='hello world!' h=0xdead.beef]

> a(b 'hello world!', h 0xfeed.beef)
[g=37 b='hello world!' h=0xfeed.beef]

> a(b 'hello world!', h 0xfeed.beef, g 123)
[g=123 b='hello world!' h=0xfeed.beef]

> a(+2 r=457.842)
[r=457.842 b=[%hi c=.6.28] h=0xdead.beef]
```

You can also use more complex wings and modify their values as well:

```
> b.a(c .3.14)
[%hi c=.3.14]
```

At this point you should have at least a rough idea of what the subject is, and a fair understanding of how to get legs of the subject using wings.  But legs are only one kind of limb -- we'll talk about arms in the next lesson.

#### Exercise 1.6b
Enter the following into dojo:
```
=a [[[b=%bweh a=%.y c=8] b="no" c="false"] 9]
```
Test your knowledge from this lesson by evaluating the following expressions and then checking your answer in the dojo or see the solutions below.

1. `> b:a(a [b=%skrt a="four"])`
2. `> ^b:a(a [b=%skrt a="four"])`
3. `> ^^b:a(a [b=%skrt a="four"])`
4. `> b.a:a(a [b=%skrt a="four"])`
5. `> a.a:a(a [b=%skrt a="four"])`
6. `+.a:a(a [b=%skrt a="four"])`
7. `a:+.a:a(a [b=%skrt a="four"])`
8. `a(a a)`
9. `b:-<.a(a a)`
10. How many times does the atom `9` appear in `a(a a(a a))`?

## Exercise Solutions

### Exercise 1.6a
1.
```
> =b [[[5 6 7] 8 9] 10 11 12 13]
> ->-:b
8
```
2.
```
> =c [[5 6] 7 [[8 9 10] 3] 2]
> +>-<+<:c
9
```

### Exercise 1.6b
1. `%bweh`
2. `"no"`
3. Error: `ford: %slim failed:`
4. `%skrt`
5. `"four"`
6. `a="four"` - Note that this is different from the above!
7. `"four"`
8. `[[[b=%bweh a=[[[b=%bweh a=%.y c=8] b="no" c="false"] 9] c=8] b="no" c="false"]9]`
9. `%bweh`
10. `9` appears 3 times:
```
> a(a a(a a))
[[[ b=%bweh a [[[b=%bweh a=[[[b=%bweh a=%.y c=8] b="no" c="false"] 9] c=8] b="no" c="false"] 9] c=8] b="no" c="false"] 9]
```