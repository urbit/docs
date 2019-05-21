+++
title = "Hoon Style Guide"
weight = 3
template = "doc.html"
+++
Welcome to the Hoon style guide. It's important to familiarize yourself with our way of writing Hoon code.

## Layout

Hoon's position on layout is: so long as your code is (a) correctly commented,
(b) free from blank or overlong lines, (c) parses, and (d) looks good, it's good
layout.

When a layout standard or other fundamental coding convention is
not perfectly rigid, code can develop some individual flavor.
But Hoon's layout rules, though not rigid, are still strict.  The
flavor should never overwhelm the content.

### General outline of Hoon syntax

There are two forms of syntax in Hoon: wide and tall.  Wide forms
fit on a single line, use single spaces to separate syntax, and
generally use enclosing terminators (like parentheses to close an
expression).  Tall forms can use multiple lines, separate syntax
with two spaces at minimum and arbitrary whitespace at maximum,
and avoid terminators when the content has a fixed structure.

For example, the wide form `=+(a b)` could be written in tall form
as

```
    =+  a
    b
```

or

```
    =+  a  b
```

These are regular forms -- every rune can be written this way.
Hoon also has a variety of wide [irregular forms](./docs/reference/hoon-expressions/irregular.md).  All tall
forms are regular.  All code within a wide form is wide.
Almost all code has both wide and tall forms, the exception
being named cores.

The goal of wide/tall forms is to resemble the look of
procedural code, with its statement/expression distinction,
in a purely functional language.  In particular, complex code in
functional languages tends to develop a diagonal shape, since
child nodes in the syntax tree are indented right.

### Tall layout conventions

In wide form, the parser allows no freedom of layout (and no
comments, either).  In tall form, there is too much freedom, and so we need
conventions. These conventions aren't absolute, but
you shouldn't defy them unless you have a good reason to do so.

Syntactically, there are three kinds of runes: fixed sequences,
variable sequences, and cores/engines.  Let's talk about each.

#### Fixed sequences and backstep indentation

A fixed sequence is a rune with a fixed number of children.  Most
runes are fixed sequences.  In wide mode we terminate a fixed
sequence with a right-parenthesis (rit).  In tall mode there is
no terminator.

With a fixed sequence, we typically use "backstep indentation."
The goal of a backstep is for the largest child node of the rune
to end up on the same left margin as the rune itself.  This
design ensures that the body of the code flows down the page, not
across the page.

With one child:

```
  !:
  a
```

With two:

```
  =+  a
  b
```

With three:

```
  ?:  a
    b
  c
```

With four (the maximum rune fanout):

```
  :^    a
      b
    c
  d
```

It is sometimes acceptable to not backstep -- especially in tuple
runes: `:-,` `:_`, `:+` and `+^`.  But you should have a specific reason:
for example: emphasizing symmetry in a tuple.

#### Variable sequences

Variable sequences can have an arbitrary number of elements, so
they can't self-terminate.  They are terminated by a `==` marker.
The sequence, or its variable part, is indented and vertical:

```
  :*  a
      b
      c
  ==
```

Another representation wastes a line, but saves an indent.  Use
this only for very long sequences:

```
  :*
    a
    b
    c
  ==
```

Some variable sequences are sequences of pairs; some of these
start with fixed sequences of nodes.  Pair sequences are in
either "kingside" or "queenside" convention, depending on what
looks better for this particular code.

Kingside format:

```
  ?+  x      default
    %foo     99
    %foobar  ?:  y
               42
             (add 2 2)
    37       36
  ==
```

Queenside format:

```
  ?+    x
    default
  ::
      %foo
    99
  ::
      %foobar
    ?:  y
      42
    (add 2 2)
  ==
```

The queenside format is more useful when the tails are bigger.
It is also usually hard to read without linebreak comments,
as demonstrated above.

We sometimes end up with multiple terminators on separate lines,
two or more spaces apart.  These lines can be collapsed:

```
  ?+  x      default
    %foo     99
    37       36
    %foobar  ?-  y
               %moo  9
               %bar  10
  ==         ==
```

## General naming style

Modern Hoon naming is **verbose**.

**Never**: abbreviate a label; pack characters (try to reduce the
length of labels, or make lengths match up between parallel
labels); use intentionally vague and meaningless words; or use
nonsense text that isn't a word.

It can't be repeated too often: **do not abbreviate words, unless
you would use the same abbreviations in written English**.  To
save a trivial, one-time amount of work in typing, you are adding
a nontrivial amount of work and ambiguity in reading.

### Comments and unparsed bytes

Hoon comments are 8-column lines which contain whitespace, then
`::`, then optional text.

Blank lines are lines containing no characters, or only whitespace.
There must never be blank lines in a Hoon file.

Empty lines are lines containing `::` only.  There must never be
two empty lines in a row in a Hoon file.

Whitespace is semi-significant.  The difference between a
space and a gap (more than one space) is significant.  But two or
more spaces, newlines, or comments are one gap.

#### Comment conventions

Hoon suggests "breathing comments."  There should always be an
empty comment line between a comment and the line **below** it:

```
    ::  look, code
    ::
    this.is.code
    ::  we are going to need more code
    ::
    this.is.more.code
```

Sometimes dense code does need air on both sides.  Also
legitimate:

```
    ::  look, code
    ::
    this.is.code
    ::
    ::  we are going to need more code
    ::
    this.is.more.code
```

But air on both sides is needed less often than you may think.

Crowded comments are comments on lines which also contain code.
Older code has a lot of these, especially the "column 56"
standard.

Crowded comments are considered harmful -- don't use them.  Hoon,
like any higher-order functional language, can be very dense and
powerful.  We almost never want it to be **more** dense.

#### Megalithic comments

In older code you'll also see attempts to produce large, visually
salient geometries as separators, like:

```
  ::
  ::::
  ::
```

or

```
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
```

Please don't do this in new code.  Normal conventions should be
legible.  Use more deeply qualified positions if your code is
hard to navigate.

### Structure of all comments, formal and informal

If any comment cannot be parsed as a formal comment, we treat it
as an informal comment and ignore it.

There are four types of formal comments: feature comments (which
annotate named features), product comments (which describe what
the expression below makes), flow comments (which describe the
computation flow), and development comments (which describe the
development process).

All kinds of formal comments have the same structure: simple or
complex.

A simple formal comment is a one-line headline.  A headline is
optional whitespace; then `::`; then two spaces; then a parsed
line of **lowercase** ASCII whose syntax depends on the comment
type.  Like this:

```
  ::  $foo: the definition of a foo
```

A complex formal comment is the headline; then an empty line;
then an udon body with paragraphs broken by empty lines, indented
four spaces, in ASCII mixed case:

```
  ::  $foo: the definition of a foo
  ::
  ::    The source of the word "foo" is lost in history.  Some
  ::    think it comes from the WWII military term "FUBAR,"
  ::    in which "UBAR" stands for "up beyond all retrieval."
  ::
  ::    Somehow "FUBAR" became "foobar."  The rest is history.
  ::
```

The point is: sometimes we want to see a deep explanation;
sometimes we just want a summary.  So we require you to either
(a) provide a line-length explanation, or (b) a long screed
but with a line-length summary/headline.

### Feature comments

A feature headline is `::`, then two spaces, then a qualified
location, then `:`, then a freeform string.  Like:

```
  ::  $foo: a the definition of a foo
  ::
  +$  foo  [head=@ tail=^]
```

We find the feature `$foo` relative to the current location and
move the comment there, as described above.  In most cases it
becomes a product comment.  For a `|chapter` (which does not
resolve to any data value) it becomes the chapter description.

### Product comments

Product comments describe the product of the expression below.
The headline is a string in parentheses:

```
  ::  (a very strange $foo indeed)
  ::
  make:a:strange:foo
```

### Flow comments and legends

Flow comments use a new commenting concept called **legends**.

#### Legends

One of the problems with Hoon as a language is that it takes some
time to learn to look at a tree of runes and "see the function."
Seeing the function is beautiful and pleasant.  But until the new
Hoon student has put in a lot of practice, this experience is
inaccessible.  And tracing runes with a manual is hard.

Canonical flow comments are one way to ease this burden.
them, we first need to write descriptive names (not necessarily
unique) for every leg of every rune case.  Then, we introduce a
narration of the code with these descriptions.

For example, let's fix `[%wtcl p=hoon q=hoon r=hoon]`.  Let's
make it... `[%wtcl if=hoon then=hoon else=hoon]`.  Then we
could write flow comments as follows:

```
    ?:  ::  if, it's it winter
        ::
        is-winter
      ::  then, why not rome?
      ::
      visit-italy
    ::  else, amsterdam is nice in the summer
    ::
    visit-holland
```

The headline of a flow comment uses a **legend**: the name of
this leg in the parent rune, then a message,

For someone who doesn't know Hoon, these pseudo-keywords are
a lifesaver.  For someone who does, they are not too annoying
and may still be helpful.

Of course, to use this we need to write useful "leg ends" for all
appropriate legs of all appropriate runes.  But that will
probably help us document them, anyway.

#### Flow promotion

Sometimes, just for cosmetic reasons, we like to raise the
comment on the first leg of a rune up above the parent:

```
    ::  if, it's it winter
    ::
    ?:  is-winter
      ::  then, why not rome?
      ::
      visit-italy
    ::  else, amsterdam is nice in the summer
    ::
    visit-holland
```

This can make flow comments collide, as in "else, if," below:

```
    ::  if, it's winter
    ::
    ?:  is-winter
      ::  then, why not rome?
      ::
      visit-italy
    ::  else, if, sprechen sie deutsch?
    ::
    ?:  speak-german
      ::  then, maybe berlin?
      ::
      visit-berlin
    ::  else, everyone in amsterdam speaks english
    ::
    visit-holland
```

#### Flow comments, traces, and interpolation

Flow comments, because they describe what your code is doing, are
embedded in the stack trace, using the same hint mechanism as
`~|`.  A trace is an explanation of everything your code was
doing when it crashed.

And data interpolation, in `{}`, also works in flow comments.
Your flow comments just describe what your code is doing, in
English, including data.

## Grading

How do we define the superficial quality of Hoon code?  (Setting
aside, of course, the question of whether the code is computing
the right thing in the right way.)

There are five grades of Hoon: incomplete (F), compiling (D),
correct (C), complete (B), and annotated (A).

Any file that looks like code and opens in an editor gets an F.
If it compiles, and it is Hoon, it gets a D.

A Hoon file that follows the layout, structure, and naming
conventions in this document has earned a C.  Weird indents,
cryptic or abbreviated names, etc, etc, preclude an A or B
grade -- regardless of documentation.

A Hoon file gets a B if and only if **every symbol in the file is
defined, where introduced, by a formal comment**.  You do not get
to make up a name without writing a one-line definition.

For an A, there are two criteria.

One: every symbol that needs an explanation (a multiline comment
after the definition) has an explanation.  This is obviously a
judgment call, as a grade of A should always be.  If a definition
doesn't call for any explanation, it must be dead obvious.

Two: every `%constant` we use must be defined where it is used,
not just where it's declared.

The advantage of a `%constant` over a classic `typedef`: there is no
need to search formally for a symbol.  The disadvantage: there is
no trivial way to find out what the symbol actually means.  So
when I send some `%foobar` move, I should define what I think
`%foobar` means.  Just copy and paste the original definition.

Code shouldn't even try for an A until it is quite stable.  The worst
thing in the world is code that changes without updating the documentation.
Any **incorrect** comment in a file drops it all the way back to a D.
