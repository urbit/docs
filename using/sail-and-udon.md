+++
title = "Sail and Udon"
weight = 7
template = "doc.html"
+++

Sail is Hoon markup that’s used to render a web page with XML. But what makes it special is that you can run arbitrary Hoon code within such a web page without using a separate markup language.

Udon is a way to write content for the web. It's a minimalist markup language for creating and rendering text documents, with a Markdown-inspired syntax. It's integrated with our Hoon programming language, allowing it to be used as standalone prose in its own file or embedded inside a Hoon source file, in which case it will be parsed into a tree of HTML nodes using Sail.

This document will be divided into two main sections: the Sail guide and the Udon guide. The Udon guide has two sub-sections that each walk you through a practical example. Also, you're encouraged to read the Getting Started section below, which applies to both Udon and Sail.

## Table of Contents

- #### [Sail: A Guide](#sail)

- #### [Udon: A Guide](#udon)

- #### [Udon: A Simple  Blog](#blog)

- #### [Udon: A Static Site](#static)

## Getting Started

Before starting with either Sail or Udon, make sure that your ship is
[mounted to Unix](https://urbit.org/docs/using/setup/)

To host that output, your ship also has a web-server, called
[Eyre](https://urbit.org/docs/using/web/), that can be found at
`http://localhost:8080/` if it’s your first ship that’s running on the a
machine, `http://localhost:8081/` if it’s the second ship on that same machine,
and so on. In the startup messages, a ship will tell you which HTTP port it's
using.

The `/web` directory of the `%home` desk is served by default. You can change
which desk you're serving by using the command `|serve` in the Dojo. If you
have already created and mounted a desk named `%sandbox`, for example, you can
switch to serving it with this command:

```
|serve %sandbox
```

The first time you serve a desk, `/web` will be included as default. After that,
you will need to explicitly append `/web` to the desk you're switching to --
otherwise, you'll need to write `http://localhost:8080/web` every time you
navigate to your web-server. Newly served desks not automatically having `/web`
as their root directory is a bug.

To switch back to your `%home` desk and set `/web` as your root directory, run:

```
|serve %/web
```

We'll be serving the `%home` desk for the examples in this tutorial.

### Rendering

That server has access to source files located in `/<your-urbit>/home/web` and
any sub-folders thereof. For the purposes of this tutorial, we will only be
using files that are located in the `/<your-urbit>/home/web/pages` path.

There is an important distinction between these two paths. According to
`/ren/urb.hoon`, any file inside of `/web` or any of its sub-directories
is put through a tree of renderers specified at `/ren/urb/tree.hoon`
-- _except_ for files inside of `/web/pages`. All of the files in `/web` and
its non-`/pages` children directories have various operations on files, such as
wrapping your Sail the `html`, `head`, and `body` nodes. This rendering tool,
called simply **Tree**, also adds certain formatting polish, such as a sidebar
that lists sibling files in the same directory.

The `/web/pages` sub-directory is a unique case with its own rendering rules.
The Tree is not used when rendering files in this path. The existence of no tag
is inferred, and no special formatting is applied. Such simplicity is ideal for
introducing the basics of Sail. Any source file located in `/web/pages` must
produce a complete HTML node with "head" and "body" nodes as children.

Understanding the details of the rendering pipeline is not necessary to complete
this tutorial. But, if you are curious, you might find it illuminating to
explore the contents of the `/ren` directory.

So, if a Sail source file named `sailtest.hoon` is saved in your `/web/pages`
folder on your only running urbit process, you can view that source rendered
into a web-page at `localhost:8080/pages/sailtest/`.

## <a name="sail"></a>Sail: A Guide

It’s easy to see how Sail can directly translate to HTML:

### Sail code

```
;html
  ;head
    ;title: My first webpage
  ==
  ;body
    ;h1: Welcome!
    ; Hello, world!
    ; We're on the web.
    ;div;
    ;script@"http://unsafely.tracking.you/cookiemonster.js";
  ==
==
```

### HTML code

```
<html>
  <head>
    <title>My first webpage</title>
  </head>
  <body>
    <h1>Welcome!</h1>
    Hello, world!
    We’re on the web.
    <div></div>
    <script src="http://unsafely.tracking.you/cookiemonster.js"></script>
  </body>
</html>
```

Save the above Sail code in `/home/web/pages/firstsail.hoon`, and the above
HTML code in `/home/web/pages/firsth.html`. Access the resulting pages by
navigating to `http://localhost:8080/pages/firstsail` and
`http://localhost:8080/pages/firsth.html`, respectively, in your browser. The
resulting pages should be identical!

It shouldn't be hard to see the similarities here. So let's go into more
detail about what the differences are.

### Tags and Closing

In Sail, tag heads are written with the tag name prepended by `;`. Unlike in
HTML, there are different ways on closing tags, depending on the needs of the
tag. One of the nice things about Hoon is that you don’t have to be constantly
closing expressions; Sail inherits this convenience.

#### Empty

Empty tags are closed with a `;` following the tag. Example:

```
;div;
```

Equals:

```
<div></div>
```

#### Filled

Filled tags are closed via line-break. To fill text inside, add `:` after the
tag name, then insert your plain text following a space. Example:

```
;h1: The title
```

Equals:

```
<h1>The title</h1>
```

#### Nested

To nest tags, simply create a new line. Nested tags need to be closed
with `==`, because they expect a list of sub-tags. If we nest a line of plain
text with no tag, a `<p>` is prepended.

Sail, like Hoon, is white-space sensitive. Unlike in Hoon, however, two spaces
(called a "gap") is not necessarily equivalent to a line-break in Sail.

```
;body
  ;h1: Blog title
  This is some good content.
==
```

Equals:

```
<body>
    <h1>Blog title</h1>
    <p>This is some good content.</p>
</body>
```


Conversely, if we want to write a string with no tag at all, then we can prepend
those untagged lines with `;`.

```
;body
  ;h1: Welcome!
  ; Hello, world!
  ; We’re on the web.
==
```

Equals:

```
<body>
    <h1>Welcome!</h1>
    Hello, world!
    We’re on the web.
</body>
```


#### Attributes

Attributes are key-value pairs that go into an HTML node.

Adding attributes is simple: just add the desired attribute between parentheses,
right after the tag name without a space.  We separate different attributes of
the same node by using `,`.

Attributes can be used in two forms: flat, which uses one line; and tall, which
uses multiple lines, when a single line would not be practical. Flat forms and
flat forms are two syntaxes of semantically equivalent expressions.


#### Generic

The code below produces a “Submit” button on the page.

Wide-form Sail:

```
;input(type "submit", value "Submit");
```

Tall-form Sail:

```
;input
  =type  "submit"
  =value  "Submit";
==
```

Equals:

```
<input type="submit" value="Submit">`
```

#### IDs

```
;nav#header: Menu
```

Equals:

```
<nav id="header">Menu</nav>
```

Add `#` after tag name to add an ID.

#### Classes

`;h1.text-blue: Title` equals `<h1 class="text-blue">Title</h1>`

Add `.` after tag name to add a class. However, if you want a class name that
contains a space, you will need to use use the syntax of a generic attribute:

`;div(class "logo inverse");` equals `<div class="logo inverse"></div>`


#### Image

`;img@"example.png";`

Equals

`<img src="example.png"/>`

Add `@` after the tag name to link your source.

To add attributes to the image, like size specifications, add the
desired attribute after the `"` of the image name and before the final `;` of
the `img` tag.

For example:

`;img@"https://urbit.org/example.png"(width "100%");`

#### Linking

`;a/"urbit.org": A link to Urbit.org`

Equals

`<a href="urbit.org">A link to Urbit.org</a>`

Add `/` after tag name to start an href.

### Hoon in Sail

Our first example is useful to understand how Sail syntax translates to HTML
syntax, but Sail finds its usefulness in the fact that it can be used seamlessly
with Hoon code.

One place where Sail diverges from HTML is that it supports string
interpolation. In Sail, the contents of all tags are a string type called `tape`
unless otherwise designated. Tapes are delineated by the double quotes `""`.
That’s important, because tapes can be interpolated with Hoon expressions,
provided that those expressions produce something a tape as well. Interpolation
is done by wrapping the code to be inserted in `{}`. In your Dojo prompt, try
the command below (without the `>`):

```
> "I am a l{(mul 3 11)}t Urbit user."
! exit
```

Oh no! That command produced a nest-fail error, which indicates that there was
a problem related to Hoon type-system. We used the proper `{}` syntax for
interpolation, and we used the proper function-call syntax inside of it. So
what happened?

Trying the `mul` function on its own will help answer this question. Try the
following command in your Dojo:

```
> (mul 3 11)
33
```

This should work, producing `33`, an atom. That’s our problem. The
interpolation expression expects a tape, but our first command tried to
interpolate with something that results in an atom. Try this now:

```
> <(mul 3 11)>
"33"
```

We get a similar result, but we know that it’s a tape because it’s wrapped in
`""`. Bingo!  With this knowledge, let’s perform a successful interpolation:

```
> "I am a l{<(mul 3 11)>}t Urbit user."
"I am a l33t Urbit user."
```

Great!

### The Subject

The default subject of a Sail file is different from the subject that
expressions in the Dojo or a Hoon generator are evaluated against.

To see this difference, first save the code below to a file at
`home/web/pages/sub.hoon` and view the rendering at
`http://localhost:8080/pages/sub`.

```
;html
  ;head;
  ;body
    {<.>}
  ==
==
```

Then enter the following command in the Dojo:

```
> .
```

You'll notice that the Sail subject is like a stripped-down version of the Dojo
subject. Its final line should match the Dojo subject.

Now swap the code below into your Sail file.

```
/=  gas  /$  fuel:html
;html
  ;head;
  ;body
    {<.>}
  ==
==
```

You'll find that the resulting Sail subject is much larger. If you look closely,
you'll see that there's some new similarities with the Dojo subject, such as
containing the name of your ship. There's also some new differences, since
`fuel:html` contains things that are specifically useful for performing
web-related operations.

### A More Interesting Example

Now let’s apply knowledge of string interpolation and the Sail subject in a Sail
source file. The following code produces more interesting things than the
example we saw before.

```
/=  gas  /$  fuel:html
=/  show-list  &
=+  wid=(met 3 p.bem.gas)
=/  what-kind
?:  (lte wid 1)   "galaxy"
?:  =(2 wid)      "star"
?:  (lte wid 4)   "planet"
?:  (lte wid 8)   "moon"
  "comet"
;html
  ;head
    ;meta(charset "utf-8");
    ;title: A more advanced page
  ==
  ;body
  ;h1: This is the Title
    ; This is a
      ;a/"http://urbit.org": link to Urbit.org.
    ;span:  Check it out!
    ;+  ?:  show-list
        ;ol
          ;li(style "color: green"): We're doing interesting stuff now.
          ;li: We're pretty-printing this sum with Hoon: {<(add 50 50)>}.
          ;li: The code above is shorthand for {(scow %ud (add 50 50))}.
          ;li: I am {(trip '~lodleb-ritrul')}.
          ;li: Actually, my name is {<p.bem.gas>}. I'm a {what-kind}.
        ==
        ;div: My name is {<p.bem.gas>}. I'm a {what-kind}.
  ==
==
```

Save the above Sail code in to `home/web/pages/secondsail.hoon` and access the
resulting page by navigating to `http://localhost:8080/pages/secondsail` in
your browser.

There are some interesting things here. Let’s go through this code piece by
piece.

```
/=  gas  /$  fuel:html
```

Later in this code we want produce the name of the ship is hosting it, something
that looks like ~lodleb-ritrul. In a generator, we could produce our ship name
by writing `our` -- try it in the Dojo. But remember that Sail is rendered
against its own subject, `our` is not part of the default subject. To augment
our subject with the information that we need, we use  `/=  gas  /$  fuel:html`.

The above expression uses two Ford runes, `/=` and `/$`, to add the relevant
information to the current subject. We can pull the ship’s name out of this
augmented subject later. It's important to note that these runes are not part of
Hoon. They are part of Ford, our build system.

`/$` is used to get data from the environment, and `/=` adds that data to
subject in the face `gas`. The
[Ford user manual](https://urbit.org/docs/arvo/internals/ford/runes/) has
details on these and other Ford runes, but understanding these runes isn’t
necessary for the purposes of this tutorial.

`fuel:html` gets extra data from your ship’s Eyre module, which handles all
things HTTP, and sticks it in the subject when Eyre renders a page. This
includes the name of the ship, which is what we look for in the next line, but
it includes much more.

`p.bem.gas` is an expression that looks for `p` within `bem` within `gas`, the
face that we stored the above `fuel:html` expression in. That wing happens to
resolve to the name of the ship that is hosting the web-server. If we wanted to
access the current desk, we would use the wing expression `q.bem.gas`.

You can take a look at what you can access by typing `fuel:html` in the Dojo,
and then explore it by modifying your wing expression in your Sail file
accordingly.

```
=/  show-list  &
```

The above line of code stores a variable used later for a conditional. `&` means
`true`, meaning that any evaluation of `show-list` will be true until changed in
the source code.

```
=+  wid=(met 3 p.bem.gas)
=/  what-kind
  ?:  (lte wid 1)   "galaxy"
  ?:  =(2 wid)      "star"
  ?:  (lte wid 4)   "planet"
  ?:  (lte wid 8)   "moon"
  "comet"
```

This code chunk is a series of conditionals that checks the host ship’s name to
see what its value is.

The first line, `=+  wid=(met 3 p.bem.gas)`, combines a new noun with the
subject and gives it the face `wid`. This noun is produced by the the
standard-library function [`met`](/docs/reference/library/2c), which measures the number of
[blocks](/docs/reference/library/1c/) of size `a` within `b`. Blocks are units that have a
bitwidth of `2^a`. So, in this case, it measures how many bytes (blocks of size
3 are bitwidths of 8; `2^3 = 8`) are fully contained in your ship's address.

Galaxies contain zero to one 3-blocks; stars contain two 3-blocks; planets
contain three to four 3-blocks; moons contain five to eight 3-blocks; comets
contain nine to sixteen 3-blocks. Each test uses `lte`, the
less-than-or-equal-to function, to determine if `wid` is of a given size. The
result of this series of tests is added to the subject and given the face
`what-kind`.

Ship names are simply another representation of atoms, and ship
categories are different ranges of possible atomic values. Because of this, we
perform less-than tests to see what kind of ship is running the web-server.

```
;html
  ;head
    ;meta(charset "utf-8");
    ;title: A more advanced page
  ==
```

Sail proper begins here. These four lines are four nodes. The `;html` node
indicates that the contained code should be rendered as HTML; this tag is closed
on the final line. The `;head` node contains metadata, and is closed three lines
later.  The `;meta` node sets the character set to UTF-8, and the `;title` node
sets the title of the page that shows up in the browser tab.

```
  ;body
  ;h1: This is the Title
    ; This is a
      ;a/"http://urbit.org": link to Urbit.org.
    ;span:  Check it out!
```

The first line here opens, of course, the body node. The second line creates
header text.

The third, fourth, and fifth lines of code here construct a single line with an
inline link.
`; This is a` begins the rendered line with plain text.

`;a/"http://urbit.org": link to Urbit.org.` continues that same rendered line,
and creates hyperlinked text out of `link to Urbit.org.`

`;span:  Check it out!` continues that same rendered line further. `;span:`
has the same use as `<span>` in HTML, and by following it with just a `:` and no
attributes, it continues the line without formatting. Following `;span:` with
**two** spaces causes there to be single space following the produced `<span>`
element, because one of those spaces is syntactically necessary.

In the following lines, we beginning to use some Hoon expressions again.

```
  ;+  ?:  show-list
          ;ol
```

In the top line in the chunk above, we use the `;+` Sail rune, which
resolves an expression to a single node. That expression, in this case, is
`?:`, which tests the truth value of `show-list`, which we assigned the value
`&` (meaning “true”) at the beginning of the program. It’s closed by the `==` on
the last line.

Thus, this program resolves to the first child of `show-list`, the node `;ol`.
That node creates an ordered list, and the items contained within that node.

```
            ;li(style "color: green"): We're doing more interesting stuff now.
```

The line above  is the only element of this list that does not use
Hoon proper. The line renders as green, as interpreted by the browser,
because of the Sail attribute.

The next items in the list use `{}`. Recall that these braces, pronounced “lob”
and “rob” in Hoon-speak, allow for the interpolation of code within a string.

```
            ;li: We're pretty-printing this sum with Hoon: {<(add 50 50)>}.
```

The line above is interpolated with Hoon code that produces the sum of 50 plus
50, which is wrapped in `<>` to put the product in double quotes to make it a
tape, like the rest of the line.


```
            ;li: The code above is shorthand for {(scow %ud (add 50 50))}.
```

The `{(scow %ud (add 50 50)}` on this line is just a different way
writing the `{<(add 50 50)>}` expression. `scow` is a Hoon function that turns a
noun into a `tape`, Hoon’s string type. `%ud` tells `scow` that its argument
should be displayed in the form of an unsigned decimal.


```
            ;li: I am {(trip '~lodleb-ritrul')}.
```

`trip` is a function that takes a `cord` and produces a `tape`. A piece of
data of the cord type is one big atom formed from adjacent unicode bytes and
delineated by `''`. Remember that all text rendered in Sail  is treated as a
tape. So, by converting `~lodleb-ritrul` to a tape, it can be included in the
tape that we are trying to insert it into without getting a type error.

```
            ;li: Actually, my name is {<p.bem.gas>}. I'm a {what-kind}.
          ==
```

The line above has interpolated code that uses a wing expression to access the
name of the host ship, and then accesses the face `what-kind` contains a string
describing what type of ship it is. We declared `gas` on the very first line so
that we could add that sort of information to the subject that our Sail is
rendered against. The wing expression `p.bem.gas` looks for `p` within `bem`
within `gas`, which happens to be where the name of the ship is located.

Note that `{what-kind}` does not have a `<>` wrapper. Why do you think this is?

```
        ;div; My name is {<p.bem.gas>}. I'm a {ship}.
  ==
==
```

The `;div;` node above is only rendered, as an alternative to the above list,
if `show-list` is evaluated as true. This means it won’t be shown with your
default code. To show this line, change the `&` on line 2 to `|` (“false”).

### Sail Runes

In the previous example, we used a few special runes that aren’t used in typical
Hoon code. But there are others that are worth learning about at this point.

`;+` is an expression that resolves to a single node. We saw this on line 20
in our Sail example above: `;+  ?:  show-list` resolves to the node `;ol` and
all of that node’s children.

`;*` is an expression that resolves to a list of nodes. If we want to render
multiple nodes side-by-side, and not just the children of a single node, this
is the expression that we use.

`;=` turns a tuple of nodes into a list of nodes.


To see how these runes work, let’s take a chunk of our previous code starting at
line 20 and modify it a bit:

```
  ;*  ?:  show-list
        ;=
        ;li: I am {(trip '~lodleb-ritrul')}.
        ;li: Actually, my name is {<p.bem.gas>}.
        ==
      ;=
    ;div: My name is {<p.bem.gas>}. I'm a {what-kind}.
    ;div: No list here!
      ==
  ==
```

We changed the conditional branches so that each contains two Sail nodes,
side-by-side -- notice that the `;ol` is absent from the first branch.

We begin with the `;*` rune, which resolves to a list of nodes, instead of the
`;+` rune, which only resolves to a single node.

But that’s not enough on its own. `;*` needs to resolve to a list, and a few
Sail nodes aren’t lists until they are explicitly made into lists. Until we wrap
those nodes in `;=`, the nodes treated as mere tuples. All branches must be
valid lists for the `;*  ?:  show-list` expression to resolve.

### Further Reading

You should now have foundational knowledge for making web pages with Sail. There
is, of course, more to learn.

The [Ford manual](https://urbit.org/docs/arvo/internals/ford/runes/)
can show you how to access various ship resources for user in your pages. To
learn more about how the renderer works, take a look at the
`/home/ren/urb.hoon` file inside your urbit.

## <a name="udon"></a>Udon: A Guide

Udon is a way to write content for the web. It's a minimalist
markup language for creating and rendering text documents, with a
Markdown-inspired syntax. It's integrated with our Hoon programming language,
allowing it to be used as standalone prose in its own file or embedded inside a
Hoon source file, in which case it will be parsed into a tree of HTML nodes
using Hoon's XML-templating syntax, Sail.

This document is itself written in Udon, and its source file is of the
Udon `.udon` extension. As such, we use some `formatted text` to make
it clear what is and isn't code, and to display that code to you instead of
actually using its semantics for formatting.

There are quite a few similarities between Udon and the
CommonMark standard, but there are enough differences that you shouldn't rely on
existing knowledge of the latter. Udon generally supports only one
syntax for each type of HTML node it emits. Udon is also stricter than
Markdown: some syntax errors will prevent the file from being parsed at all.

We provide a few simple examples [here](#examples) of how to publish
Udon files using our web interface.

## Udon Syntax

### Front Matter

The first thing on your file is a chunk of code called the front matter. It
contains metadata about your page, such as date, title, and position relative
to sibling pages.

As an example, let's look at the front matter of this very page:

```
:-  :~  navhome/'/docs/'
        sort/'11'
        title/'Udon'
    ==
;>
```

What's going on here?

`:-`, the Hoon rune for creating a cell, creates a cell composed of
the `:~` Hoon rune for creating a list, and `;>`, which is a Sail rune
for Udon.

`:~` creates a list out of the three elements: `navhome/'/docs/'`, which
indicates that navigating "home" will bring you to the urbit.org/docs section
of the website; `sort/'28',` which assigns it the 28th position of the
immediate section that contains it, the one you see in the sidebar;
and `title/'Udon'`, which gives the page its title. The `==` digraph
terminates the list.

`;>` is a Sail rune that creates a node that contains everything that follows
it, telling the parser that that text should be interpreted as Udon.
It's not technically front matter, but you'll always find it following the
front matter, since all Udon must come after this rune.

The categories listed in the example above -- `navhome`, `sort`, and `title` --
make sense to Eyre by default, but any arbitrary category can be used. The code
below is valid front matter.

```
:-  :~  date/~2018.9.12
        author/~lodleb-ritrul
        music/'rad'
    ==
```

Note that `~2018.9.12`, `~lodleb-ritrul`, and `'rad'` are all of of atom
types: `@da`(date), `@p` (ship name), and `@t` (cord), respectively. Only atom
types work here. Having `music/"rad"` would prevent the source file from
parsing.

### Headers

Headers in Udon begin the line with one or more `#` characters,
'followed by a single space. After that space comes the actual text to be
displayed. The number of leading `#`s corresponds to the resulting HTML
header-size element: `#` yields an `<h1>`, `##` yields an `<h2>`, and so on,
through `<h6>`. The header for this section is `### Headers`.

**Example:**
```
#### Header (h4)

##### Header (h5)
```
**Produces:**

#### Header (h4)

##### Header (h5)

### Italics and Bold

Enclosing text with `_` will cause that text to appear italicized, using an `<i>`
element.

Enclosing text with `*` will cause that text to appear bolded, using a `<b>`
element.


**Example:**

```
To get their *attention*, you need that _je ne sais quoi_.
```

**Produces:**

To get their **attention**, you need that _je ne sais quoi_.

### Line Break

A blank line is interpreted as a line break, creating a distinct
paragraph. However, a newline on its own is merely interpreted as a space on
the _same line_.

**Example:**

```
Here's the first line.

This second line is separated by two newlines, so it's a separate paragraph.

This line looks like a distinct paragraph, but...
It's only separated by a single newline, so it's included in the same paragraph.
```
**Produces:**


Here's the first line.

This second line is separated by two newlines, so it's a separate paragraph.

This line looks like a distinct paragraph, but...
It's only separated by a single newline, so it's included in the same paragraph.

#### Backslash Line Break

A backslash at the end of a line inserts a line break (`<br>`)
after that line. This contrasts with the normal udon behavior of
converting newlines to spaces.

**Example:**
```
I wonder how long each line
will be if I put backslashes\
at the ends of the lines.
```
**Produces:**

I wonder how long each line
will be if I put backslashes\
at the ends of the lines.

### Escape

A backslash directly _before_ a word (with no spaces) will be interpreted
as an escape character, causing it to be rendered raw.

**Example:**

```
Here is some *bold* text.
Here is some \*not bold* text.
```

**Produces:**

Here is some **bold** text.
Here is some \*not bold* text.


### List

A line beginning with a `-` followed by a space is interpreted as an
element of an **unordered list** (`<ul>`). Each line in an unordered list is
prepended with a bullet point.

A line beginning with a `+` followed by a space is interpreted as an element
of an **ordered list** (`<ol>`). Each line in an ordered list is prepended with
a number corresponding to its position in that list.

New list elements are delineated by newlines beginning with list symbols of
the appropriate type (`-` or `+`).

Just as with non-list text, text on a bare newline will appear on line before,
separated by a space. A `\\` is used to create a line-break that isn't the list
itself and isn't a list. Both of these kinds of newlines must be indented by two
spaces, or else the page will not parse.

Indentation is also used for creating nested sub-lists. Sub-lists of one kind
can be used with parent lists of the other kind. Sub-lists can't be nested
directly after either kind of aforementioned newline that isn't a list element;
only lines that are themselves list elements can nest sub-lists.

A newline after a blank line is interpreted as a new paragraph in normal text.
Between to list elements, however, a blank line is semantically equivalent to
a bare newline. To separate two lists with blank space, create a blank line
followed by a `\\` on its own line.

**Example:**

```
- Eggs
  (cage-free)
- Milk
- Butter
- Chicken\
  Make sure that you get enough for the barbecue
- Bread
  + Ask the baker what's fresh
  + Buy the second-freshest batch
- Cereal

\
+ First, separate eggs into a bowl.
+ Then, add a splash of cream.
  - If you don't have cream, you can use milk, but cream is preferred.
    + If you don't have milk or cream, melt an eighth of a stick of butter on
      a skillet
    + Scrambled the eggs in the bowl.
    + Pour the eggs onto the skillet before the butter browns
+ Heat the skillet

+ Scramble eggs and put them into skillet

\
+ Cool
+ Alright
```

Produces

- Eggs
  (cage-free)
- Milk
- Butter
- Chicken\
  Make sure that you get enough for the barbecue
- Bread
  + Ask the baker what's fresh
  + Buy the second-freshest batch
- Cereal

\
+ First, separate eggs into a bowl.
+ Then, add a splash of cream.
  - If you don't have cream, you can use milk, but cream is preferred.
    + If you don't have milk or cream, melt an eighth of a stick of butter on
      a skillet
    + Scrambled the eggs in the bowl.
    + Pour the eggs onto the skillet before the butter browns
+ Heat the skillet

+ Scramble eggs and put them into skillet

\
+ Cool
+ Alright

### Link

There are two ways to create links, but both contain the text be hyperlinked
in `[]` followed by the destination in `()`.

The first type is an inline-style link, which simply uses the full URL as its
destination.

**Example:**

```
[I'm an inline-style link](https://www.urbit.org/docs/reference/shell)
```

**Produces:**

[I'm an inline-style link](https://www.urbit.org/docs/reference/shell)

The second type is a reference-style link, which uses a relative path, based on
the current page's location. Instead of the full url, we use `..` to fill in
the all of the URL that the destination has in common with the origin page.

**Example:**

```
[I'm a reference-style link](../shell)
```

**Produces:**

[I'm a reference-style link](../shell)

If this page is located at `https://www.urbit.org/docs/reference/`, then these two
examples should have the same destination.

#### Anchor Link

A link to a section of the same page is in the style of
`[text to be linked](#the-destination)`.

The destination for the anchor link is designated with the HTML element `id`,
so we need to use some [Sail](#sail). If there are two or more anchors with
the same `id` on the page, you will arrive at the earliest instance of the the
anchor.

**Example:**

```
Check out this [section](#the-destination) that we want to jump to.

Four score and seven years ago....

It was the best of times, it was the worst of times...

## Here we are!
```

**Produces:**

Check out this [section](#the-destination) that we want to jump to.

Four score and seven years ago....

It was the best of times, it was the worst of times...

## Here we are!

### Double Quote

Text enclosed in double quotes (`"`) will be rendered with
opening and closing quotes -- that is, `“` and `”`.

**Example:**
```
"Yes," he said. "That is the way with him."
```

**Produces:**

"Yes," he said. "That is the way with him."


### Code Literal

There are two ways to show the literal text of code without running it: inline
and block. Both highlight the contained text in another color.

Note that the backslash, due to its role as the escape character, can only be
displayed in a code block literal and not as inline code literal. This is a
bug.

```
\
```

#### Inline Code Literal

Enclosing some text in
```
`
```
characters will cause it to be displayed as code,
inside a `<code>` HTML element with monospace font and highlighted with a
different background color.

Using `` ` \`` is useful when you want to designated only part of a line as code.
Since this page is written in Udon, we've been using this operation
throughout this guide to `format text` to distinguish code from prose.

**Example:**
```
`*[a 2 b c] -> *[*[a b] *[a c]]` is like lisp's `apply`.
```
**Produces:**

`*[a 2 b c] -> *[*[a b] *[a c]]` is like lisp's `apply`.

Also, using the `++` prefix before a word will cause the word to be rendered as
code with the `++` displayed, since that's the standard notation for an arm in
Hoon.

**Example:**

```
The ++add arm is used to sum two numbers.
```

**Produces:**

The ++add arm is used to sum two numbers.

#### Block Code Literal

By enclosing a block of text in a tick on their own lines
before and after the contained text, the text will be treated as a code block.

Most of our examples so far have used.

**Example:**


```
  ```
  (def Y (fn [f]
         ((fn [x]
            (x x))
          (fn [x]
            (f (fn [y]
                 ((x x) y)))))))
  ```
```

**Produces:**

```
(def Y (fn [f]
       ((fn [x]
          (x x))
        (fn [x]
          (f (fn [y]
               ((x x) y)))))))
```

### Hoon Constants

Hoon has several syntactic forms for literals (numbers, strings, dates, etc.)
that can be used in udon as well. Udon detects such code, and so these
forms will automatically appear inside a `<code>` element like inline code.

Example:

```
~2017.8.29 \
0xdead.beef \
%term
```

produces:\

~2017.8.29 \
0xdead.beef \
%term


### Horizontal Rule

Three or more hyphens, such as `---`, on their own line produce an `<hr>`
element, the 'horizontal rule'. This is rendered as a horizontal line the
width of its containing paragraph.

**Example:**

```
Above the line
---
Below the line
-----
And below this line, too
```

**Produces:**


Above the line
---
Below the line
-----
And below this line, too

### Block Quote

A section of text with the first line beginning with `>` and a space,
and each successive newline indented by two spaces yields a
`<blockquote>` HTML element. This block quote can itself contain more Udon,
including more block quotes to render nested levels of quotation.
Inline italicization with `_` does not work, however.

Blank newlines do not end the block quote, but a blank newline followed by an
unindented line of text _will_ end the quote.

**Example:**

```
> As Gregor Samsa awoke one morning from uneasy dreams, he
  found himself transformed in his bed into a *monstrous* vermin.

Quote break.

> _See_ the child.

  He is pale and thin, he wears a thin and ragged linen shirt.
```

**Produces:**

> As Gregor Samsa awoke one morning from uneasy dreams
  he found himself transformed in his bed into a **monstrous** vermin.

Quote break.

> _See_ the child.

  He is pale and thin, he wears a thin and ragged linen shirt.


### Poem

A poem is a section of text with meaningful newlines.  Recall that,
normally in Udon, newlines are treated as spaces and do not create a
new line of text. If you want to embed text where newlines are retained, then
indent the text in question with **eight spaces**.

**Example:**

```
        A shape with lion body and the head of a man,
        A gaze blank and pitiless as the sun,
        Is moving its slow thighs, while all about it
        Reel shadows of the indignant desert birds.
```
**Produces:**

        A shape with lion body and the head of a man,
        A gaze blank and pitiless as the sun,
        Is moving its slow thighs, while all about it
        Reel shadows of the indignant desert birds.


## Sail Expressions

It's possible to use Udon as an HTML templating language akin to
PHP, ERB, JSP, or Handlebars templates. This facility derives
in part from the support for embedding Hoon code inside the markup.


Sail is a domain-specific language within Hoon for creating XML nodes,
including HTML. It can be used directly within Udon to provide
scripting capability with Hoon and also to provide more precise control over the
resulting HTML. The [Sail guide](../sail) is a good place to learn the
specifics.

Example:

```
;=
  ;p
    ;strong: Don't panic!
    <br>
    ;small: [reactive publishing intensifies]
  ==
==
```

Produces:


<p>
    <strong>Don't panic!</strong>
    <br>
    <small>[reactive publishing intensifies]</small>
</p>


## <a name="blog"></a>A Simple Udon Blog

Publishing using Udon is really easy. It uses the file extension `.udon`. Here we'll create a very simple blog and publish our first posts.

First, let's setup a desk to serve our posts from:

```
|merge %site ~your-urbit %home
```

Then let's mount that desk to unix:

```
|mount /=site=
```

You should now be able to find a `/site` folder inside of your pier
directory (either `comet/` or `your-urbit/`).

To begin serving files from this new desk use `|serve`:

```
|serve %site
```

First let's create the landing page for our blog.  Create the file
`site/web/blog.udon`:

```
:-  :~  anchor/'none'
    ==
;>

# Hello

This is a simple blog I built on Urbit.

;list(dataType "post");
```

Try viewing this file at `http://localhost:8080`. Note that `8080` might be
`8081`, `8082`, and so on, depending if those ports were being used when you
started your urbit.

The only special thing about this page is the `anchor/'none'` front-matter
which simply turns off the Tree navigation.  Normally Tree gives navigation
controls for walking around the filesystem, but taking them away makes
the page seem more like a landing page.

The page looks pretty boring now.  Let's add our first post.  From
unix run `mkdir your-urbit/site/web/blog; touch
your-urbit/site/web/blog/post-1.udon`. (Currently [there's a
bug](https://github.com/urbit/urbit/issues/321) that prevents empty
directories from getting created, so we have to `touch` a file inside
them first.)  In `blog/post-1.udon` let's add some filler content:

```
:-  :~  navhome/'/blog'
        type/'post'
        date/'~2016.6.20'
        title/'My first post!'
    ==
;>

Is this a decentralized Medium?  Let's find out.

But first, how about a long quote from Paramenides:

> True, he said; and therefore when ideas are what they are in
  relation to one another, their essence is determined by a relation
  among themselves, and has nothing to do with the resemblances, or
  whatever they are to be termed, which are in our sphere, and from
  which we receive this or that name when we partake of them. And
  the things which are within our sphere and have the same names
  with them, are likewise only relative to one another, and not to
  the ideas which have the same names with them, but belong to
  themselves and not to them.

Good to get that out of the way.
```

You should be able to view this file at:
`http://localhost:8080/blog/post-1.udon`.

You'll also notice that
now the list of posts here: `http://localhost:8080/blog` has
updated.

Here we use two pieces of front-matter worth noting: `type` and `navhome`.

- `type` implies that the page has some special handling by Tree. When `type` is
  `post` we automatically put in the `date`, `title` and `author` when they're
  specified and add some styles.

- `navhome` sets the path used by the home button (the circle in the top left).
  Since we want to send people back to the root of our blog, we set this to `/blog`

Adding posts is as easy as dropping Udon files into the `blog/`
directory.  Pretty easy!

### Blog comments

Now let's enable comments on a blog post.

First, turn comments on by editing the frontmatter in `post-1.udon`.  Your
frontmatter should look like this:

```
:-  :~  navhome/'/blog'
        type/'post'
        date/'~2018.6.20'
        title/'Blog comments'
        comments/'true'
    ==
;>
```

Now try loading your post here: `your-urbit.urbit.org/blog/post-1`.
You should see a comments box at the bottom of the page.

Try posting a comment!  When you do you should see the following in
your console:

```
+ /~your-urbit/home/55/web/blog/post-1/comments/~2016.6.20..23.20.54..0b88/md
------------[0]
~your-urbit[tree]: receiving comments, ;join %comments for details
```

Comments are written into the filesystem in the `comments/` folder
relative to the page they're enabled on.  When a new comment is posted
a notification is also posted to the `/comments` `:talk` channel.

Use `;join` to keep up with comments as they get posted:

```
;join ~your-urbit/comments
```

That's it!  Easy.

## <a name="static"></a>A Static Site

Hosting a static tree of content is easy.  Let's put together a really
simple site for an imaginary Urbit meetup group.

We assume you have at least followed the beginning of [our first
examples](#blog) and created a desk called `site` and mounted it to
unix.

Note: below we use Urbit's implementation of Markdown, [Udon](#udon).
This markup language allows you to use snippets of Hoon code but not HTML.
In particular, we use Sail, a subset of Hoon.  This Sail is rendered as HTML
when the file is served to a client.  To learn about Sail, head over to
the [Sail](/docs/learn/arvo/arvo-internals/sail) section of the docs.

In `site/web/meet.udon` put:

```
:-  :~  navhome/'/meet'
        navdpad/'false'
        navpath/'/meet'
        navmode/'navbar'
    ==
;>

# Neo-Tokyo Urbit meetup

![](https://ofheroesandcliches.files.wordpress.com/2014/06/neo-tokyo.png)

Hi there! We meet once a week at The Chat to work on Urbit projects
together.

You can find out more about the group on the [about](about) page and
follow our projects in [projects](projects).
```

This is our landing page.  Here we're using a few new bits of frontmatter:
`navdpad`, `navmode` and `navpath`.  `navdpad` just turns off the nav
arrows. `navmode` can be set to 'navbar' to switch to a horizontal top
nav instead of a left bar. `navpath` sets the path to load the nav
items from.

Let's create `about.udon` and `projects.udon`.  From Unix use the
technique from before to create a new directory: `mkdir
your-urbit/site/web/meet/; touch your-urbit/site/web/meet/about.udon`.
Then put the following in `site/web/about.udon`:

```
:-  :~  navhome/'/meet'
        navdpad/'false'
        navpath/'/meet'
        navmode/'navbar'
        title/'About'
    ==
;>

# About

## Mission statement

The existing framework cannot subdue the new human force that is increasing day
by day alongside the irresistible development of technology and the
dissatisfaction of its possible uses in our senseless social life.

## Members

Membership is open to anyone.  Just send a message to `~talsur-todres`.

- Shōtarō Kaneda
- Motoko Kusanagi
- Ishikawa
- Faye Valentine
- Spike Spiegel
```

And `site/web/projects.udon`:

```
:-  :~  navhome/'/meet'
        navdpad/'false'
        navpath/'/meet'
        navmode/'navbar'
        title/'Projects'
    ==
;>

# Projects

## Active

;list;

## Discussion

;div(class "mini-module")
    ;script(src "/~/at/lib/js/urb.js");
    ;script(src "https://cdn.rawgit.com/seatgeek/react-infinite/0.8.0/dist/react-infinite.js");
    ;script(src "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment-with-locales.js");
    ;script(src "https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.1/moment-timezone.js");
    ;script(src "/talk/main.js");
    ;link(href "/talk/main.css", rel "stylesheet");
    ;talk(readonly "", chrono="reverse", station="comments");
==
```

This page introduces a new thing: the `:talk` module.  Inside of the
`mini-module` div we load the scripts needed by the `;talk`
component.  The `;talk` component is a static component for
displaying a feed from a talk channel inline.  Here we're going to
display the discussion from our active projects inline.

We'll need a few active projects though.  From unix: `mkdir
your-urbit/site/web/meet/projects; touch
your-urbit/site/web/meet/projects/bike.udon`.

In `site/web/meet/projects/bike.udon`:

```
:-  :~  navhome/'/meet'
        navdpad/'false'
        navpath/'/meet'
        navmode/'navbar'
        title/'Kaneda's Bike'
        comments/'true'
    ==
;>

# Urbit on a Motorcycle

Discussion on getting urbit to power Kaneda's motorcycle.
```

Here we just use the `comments` frontmatter to enable comments on the page.
Adding other imaginary projects is left to the reader.

Building a static site takes only a few minutes and a few Udon files.  Have fun!
