+++
title = "Generators"
weight = 9
template = "doc.html"
+++
Generators are the most straightforward way to write programs for Urbit. They
are used for doing computations that do not require persistence: they take an
input and produce an output, then disappear. Generators might make sense for
listing directory contents, or running unit tests, or fetching the contents of a
URL.

There are four kinds of generators: naked, `%say`, `%get`, and `%ask`.

### Naked Generators

A naked generator is simply a `gate`; that is, it is an anonymous function that
takes a `sample` (argument) and produces a noun. All you need to do is write a
`gate` and put it into a file in the `/gen` directory. Let's take a look at a
very simple one:

```
|=  a=*
a
```

This generator takes one argument of any noun and produces it without any
changes. If we put this into a file named `echo.hoon` in the `/gen` directory,
we can run it from the [Dojo](./docs/using/shell.md):

```
> +echo 42
42
```

This command just passes in 42 and gets 42 back. But what about when we pass in
`"asdf"`?

```
> +echo "asdf"
[97 115 100 102 0]
```

We just get a pile of numbers back in the form of a raw `noun`. The numbers that
compose that noun are called `atoms`, and how they are interpreted is a matter
of what `aura` is being applied to them. For the purposes of this lesson, an
`aura` tells the pretty-printer how to display an `atom`, but keep in mind that
an `aura` is type metadata and does other things, too.

In the example above, we didn't specify an `aura`, leaving the printer to fend
for itself. `"asdf"` is a `tape`, a type that is simply a `list` of `cords`. A
`cord` is itself an atom represented as a string of UTF-8 characters. When used
as part of a `tape`, the `cord` is only a single character. So each atom in the
`[97 115 100 102 0]` output corresponds to a component of the `tape`: 97 is
`a`, 115 is `s`, 100 is `d`, 102 is `f`, and `0` is the "null" that every list
is terminated with.

We can tell the Dojo to cast -- apply a specific type to -- the output of our
generator to see something more familiar:

```
> _tape +echo "asdf"
"asdf"
```

Now let's create a generator with two arguments instead of one. Save the code
below as `add.hoon` in the `/gen` directory.

```
|=  [a=@ud b=@ud]
(add a b)
```

Now, run the generator:

```
> +add [3 4]
7
```

You may notice our generator takes a cell containing two `@ud`. This is
actually one of the limitations of naked generators. We can only pass one
argument. We can get around this, of course, by passing a cell, but it's less
than ideal. Also, a naked generator cannot be called without an argument.
This brings us to `%say` generators.

### `%say` Generators

We use `%say` generators when we want to provide something else in Arvo, the
Urbit operating system, with metadata about the generator's output. This is
useful when a generator is needed to pipe data to another program, a frequent
occurrence.

To that end, `%say` generators use `mark`s to make it clear, to other Arvo
computations, exactly what kind of data their output is. A `mark` is akin
to a MIME type on the Arvo level. A `mark` describes the data in
some way, indicating that it's an `%atom`, or that it's a standard such as
`%json`, or even that it's an application-specific data structure like
`%talk-command`. `mark`s are not specific to `%say` generators; whenever data
moves between programs in Arvo, that data is marked.

So, more formally, a `%say` generator is a `cell`. The head of that cell is the
`%say` tag, and the tail is a `gate` that produces a `cask` -- a pair of the
output data and the `mark` describing that data.

Below is an example of a `%say` generator. Save it to `add.hoon` in the `/gen`
directory.

```
:-  %say
|=  *
:-  %noun
(add 40 2)
```

Now run the generator as below:

```
> +add
42
```

Notice that we used no argument, something that is possible with `%say`
generators but impossible with naked generators. We'll explain that in a moment.
For now, let's focus on the code that is necessary to make something a `%say`
generator.

```
:-  %say
```

Recall that the rune `:-` produces a cell, with the first following expression
as its head and the second following expression as its tail.

The expression above creates a cell with `%say` as the head. The tail is
the `|=  *` expression on the line that follows.

```
|=  *
:-  %noun
(add 40 2)
```

`|=  *` constructs a gate that takes a noun. This gate will itself produce a
`cask`, which is cell formed by the prepending `:-`. The head of that `cask` is
`%noun` and the tail is the rest of the program, `(add 40 2)`. The tail of the
`cask`  will be our actual data produced by the body of the program: in this
case, just adding 40 and 2 together.

#### `%say` generators with arguments

We can modify the boilerplate code to allow arguments to be passed into a `%say`
generator, but in a way that gives us more power than we would have if we just
used a naked generator.

Naked generators are limited because they have no way of accessing data that
exists in Arvo, such as the date and time or pieces of fresh entropy. In `%say`
generators, however, we can access that kind of subject by identifying them
in the gate's sample, which we only specified as `*` in the previous few
examples. But we can do more with `%say` generators if we do more with that
sample. Any valid sample will follow this 3-tuple scheme:

`[[now, eny, beak] [list of unnamed arguments] [list of named arguments]]`

This entire structure is a noun, which is why `*` is a valid sample if we
wish to not use any of the information here in a generator. But let's look at
each of these three elements, piece by piece.

The **first part** of the above 3-tuple is a noun that is composed of three
atoms:

`now` is the current time.
`eny` is 512 bits of entropy for seeding random number generators.
`beak` contains the current ship, desk, and case.

You can access each of those pieces of data by typing their names into the Dojo.
But in a generator, we need to put faces (variable names) onto that data so we
can easily use it in the program. We can do so like this:

```
|=  [[now=@da eny=@uvJ bec=beak] ~ ~]
```

Any of those pieces of data could be omitted by replacing part of the noun with
`*` rather than giving them faces. For example, `[now=@da * bec=beak]` if we
didn't want `eny`, or `[* * bec=beak]` if we only wanted `beak`.

The **second part** of the sample is a `list` of arguments that _must_ be passed
to the generator as it is run. Because it's a `list`, this element needs to be
terminated with a `~`. In the example above, we used `~`, the empty list, to
represent this second part. But that would mean we don't want to use any new
faces for our generator. So a sample where we want to declare a single required
argument would look like this:

```
|=  [* [n=@ud ~] ~]
```

In the above code, we use a `*` to ignore any of the information that would go
in the first part of the sample, somewhat similar to how we use a `~` to say
"nothing here" for the second or third parts of the sample.

But to use both parts together, our gate and sample would look like this:

```
|=  [[now=@da eny=@uvJ bec=beak] [n=@ud ~] ~]
```

The **third part** of the sample is a list of _optional_ arguments. These
arguments may be passed to the program as it's being run, but the program doesn't
require them. The syntax for the third part is just like the syntax for the
second part, besides its position:

```
|=  [* ~ [bet=@ud ~]]
```

Let's look at an example that uses all three parts. Save the code below in a
file called `dice.hoon` in your `/gen` directory.

```
:-  %say
|=  [[now=@da eny=@uvJ bec=beak] [n=@ud ~] [bet=@ud ~]]
:-  %noun
[(~(rad og eny) n) bet]
```

This is a very simple dice program with an optional betting functionality.
In the code, our sample specifies faces on all of the Arvo data, meaning that we
can easily access them. We also require the argument `[n=@ud ~]`, and allow the
_optional_ argument `[bet=@ud ~]`.

But there's something new: `(~(rad og eny) n)`. This code pulls the `rad` arm
out of the `og` core with the subject of `eny`. Recall that `eny` is our entropy
value, so this is used to seed the generator. The `rad` arm will give us a
pseudorandom number between 0 and `n`. Then we form a cell with the result and
`bet`, the optional named argument specified previously.

We can run this generator like so:

```
> +dice 6, =bet 2
[4 2]

> +dice 6
[5 0]

> +dice 6
[2 0]

> +dice 6, =bet 200
[0 200]

> +dice
nest-fail
```

We get a different value from the same generator between runs, something that
isn't possible with a naked generator. Another novelty is the ability to choose
to not use the second argument.

##### Arguments without a cell

Also unlike a naked generator, we don't need to put our arguments together into
a cell. Swap the code below into your `add.hoon` file.

```
:-  %say
|=  [* [a=@ud b=@ud ~] ~]
:-  %noun
(add a b)
```

In the above code we're again creating a `%say` generator, but the sample of our
gate is a little different than before. We are using `*` for the first part of
the sample, because we don't use any Arvo data in this program. We are using a
`~` for the third part, because we aren't allowing optional arguments -- the
list of optional arguments is _empty_.

Run a command like the one below in the Dojo. Notice that you can use two
arguments that aren't in the cells.

```
> +add 40 2
42
```

### `%ask` generators

We use the `%ask` generator when we want to create an interactive program
that prompts for inputs as it runs, rather than expecting arguments to be passed
in at the time of initiation.

Code-wise, two things are needed to create a useful `%ask` generator.

The first is **`sole-result`**, which lives in `/sur/sole.hoon`. It's a
mold-builder that's required by any part of Arvo, such as the Dojo, that wants
to understand the output of the `%ask` generator. Because it's the only type of
`%ask` data that is intelligible to the system, the ultimate output of an `%ask`
generator must be `sole-result`. You can think of it as a function that takes
molds and digests them into a type for the operating system. The simplest way to
use `sole-result` is by calling the `produce` gate from `/lib/generators.hoon`.

The second is **`prompt`**, a gate that lives in `lib/generators.hoon`. `prompt`
allows you to get information back from the user, which is essential to the
typical desired operation of an `%ask` generator.

Since this isn't easy to digest in the abstract, we'll use an example generator
to explain how this kind of generator works.

##### `%ask` example

The code below is an `%ask` generator that checks if the user inputs "blue" when
prompted. Save it as `axe.hoon` in `/gen`.

```
/-  sole
/+  generators
=,  [sole generators]
:-  %ask
|=  *
^-  (sole-result (cask tang))
%+  print    leaf+"What is your favorite color?"
%+  prompt   [%& %prompt "color: "]
|=  t=tape
%+  produce  %tang
?:  =(t "blue")
  :~  leaf+"Oh. Thank you very much."
      leaf+"Right. Off you go then."
  ==
:~  leaf+"Aaaaagh!"
    leaf+"Into the Gorge of Eternal Peril with you!"
==
```

Run the generator from the Dojo:

```
> +axe
What is your favorite color?
: color:
```

Something new happened. Instead of simply returning something, your Dojo's
prompt changed from `~your-urbit:dojo>` to `~your-urbit:dojo: color:`, and
now expects additional input. Let's give it an input:

```
: color: red
Into the Gorge of Eternal Peril with you!
Aaaaagh!
```

Let's go over what exactly is happening in this code.

```
/-  sole
/+  generators
=,  [sole generators]
```

Here we bring in some of the types we are going to need from `/sur/sole` and
gates we will use from `/lib/generators`. We use some special runes for this.

`/-` is a Ford rune used to import types from `sur`.

`/+` is a Ford rune used to import libraries from `lib`.

`=,` is a rune that allows us to expose a namespace. We do this to avoid having
to write `sole-result:sole` instead of `sole-result` or `print:generators`
instead of `print`.

```
:-  %ask
|=  *
```

This code might be familiar. Just as with their `%say` cousins, `%ask`
generators need to produce a `cell`, the head of which specifies what kind of
generator we are running.

With `|=  *`, we create a gate and ignore the standard arguments we are given,
because we're not using them.

```
^-  (sole-result (cask tang))
```

`%ask` generators need to have the second half of the cell be a gate that
produces a `sole-result`, one that in this case contains a `cask` of `tang`.
We use the `^-` rune to constrain the generator's output to such a
`sole-result`.

A `cask` is a pair of a `mark` name and a noun. Recall that a `mark` can be
thought of as an Arvo-level MIME type for data.

A `tang` is a `list` of `tank`, and a `tank` is a structure for printing data.
There are three types of `tank`: `leaf`, `palm`, and `rose`. A `leaf` is for
printing a single noun, a `rose` is for printing rows of data, and a `palm` is
for printing backstep-indented lists.

```
%+  print    leaf+"What is your favorite color?"
%+  prompt   [%& %prompt "color: "]
|=  t=tape
%+  produce  %tang
```

Because we imported `generators`, we can access its contained gates, three of
which we use in `axe.hoon`: `print`, `prompt`, and `produce`.

**`print`** is used for printing a `tank` to the console.

In our example, `%+` is the rune to call a gate, and our gate `print` takes one
argument which is a `tank` to print. The `+` here is syntactic sugar for
`[leaf "What is your favorite color?"]` that just makes it easier to write.

**`prompt`** is used to construct a prompt for the user to provide input.
It takes a single argument that is a tuple. Most `%ask` generators will want to
use the `prompt` gate.

The first element of the `prompt` sample is a flag that indicates whether what
the user typed should be echoed out to them or hidden. `%&` will produce echoed
output and `%|` will hide the output (for use in passwords or other secret
text).

The second element of the `prompt` sample is intended to be information for use
in creating autocomplete options for the prompt. This functionality is not yet
implemented.

The third element of the `prompt` sample is the `tape` that we would like to
use to prompt the user. In the case of our example, we use `"color: "`.

**`produce`** is used to construct the output of the generator. In our example,
we produce a `tang`.


```
|=  t=tape
```

Our gate here takes a `tape` that was produced by `prompt`. If we needed
another type of data we could use `parse` to obtain it.

The rest of this generator should be intelligible to those with Hoon knowledge
at this point.

One quirk that you should be aware of, though, is that `tang` prints in reverse
order from how it is created. The reason for this is that `tang` was originally
created to display stack trace information, which should be produced in reverse
order. This leads to an annoyance: we either have to specify our messages
backwards or construct them in the order we want and then `flop` the `list`.
This is a [known issue](https://github.com/urbit/arvo/issues/840) to be resolved.

### `%get` generators

`%get` generators are used for making HTTP requests through `eyre`. For this
section we'll assume knowledge of generators covered in previous sections, so
we can jump in with an example:

```
/-  sole
/+  generators
=,  generators
:-  %get
|=  [* [url=tape ~] ~]
^-  (sole-request:sole (cask json))
%+  curl  (scan url auri:de-purl:html)
|=  hit/httr:eyre
?~  r.hit  !!
=/  my-json  (de-json:html q.u.r.hit)
?~  my-json  !!
=,  dejs:format
%+  produce  %json
%.  %title
%~  got  by
%-  (om same)
u.my-json
```

The above generator was written with the
[Studio Ghibli API](https://ghibliapi.herokuapp.com/). It uses this API to
print the title of a Studio Ghibli film.

```
/-  sole
/+  generators
=,  generators
```

Here we import types from `/sur/sole.hoon` and gates from
`/lib/generators.hoon`. We also use `=,` to expose the namespace of
`generators` that we just imported.

```
:-  %get
|=  [* [url=tape ~] ~]
```

Like with `%say` and `%ask` generators, we must include the  "boilerplate":
code that produces a generator-specific `cell`. The head of that cell is `%get`,
and the tail is a gate that takes a `tape` of the URL that we are trying
to access.

```
^-  (sole-request:sole (cask json))
```

Here we make sure our gate is producing a `sole-request` which contains a `cask`
of the type `json`.


```
%+  curl  (scan url auri:de-purl:html)
|=  hit/httr:eyre
```

Here we can see the call to `curl`, the sample of which will parse our url and
make sure it's in the proper format.

The second part of the `curl` call is the `gate` that will get called with the
result provided by the actual HTTP request.

```
?~  r.hit  !!
```

Here we verify that the `r` face of our response is not null before
continuing. If it is null, the generator will crash, as there is nothing left to
do.

```
=/  my-json  (de-json:html q.u.r.hit)
```

Here we verify that data was returned to us in the `json` Hoon type.
`q.u.r.hit` is the actual data we care about as a `cord`. `hit` is actually an
entire response object, including headers, which we don't care about for this
example. `de-json` out of `html` will parse the `cord` and produce a `json` type
for us that we can then use to inspect the data.

```
?~  my-json  !!
=,  dejs:format
```

After parsing the JSON structure we want to make sure we got back a valid `json`
type. To do that, we test for null and crash if that test passes. If it doesn't
pass, we use `=,` on the `dejs:format` core so that we can more easily pull arms
out of it.

```
%+  produce  %json
%.  %title
%~  got  by
```

Now we come to our `produce` call. Recall that `produce` is used in all the
non-naked generators to output the final result. Here we want to produce a
`cask` of `json`, so we use the mark `%json` to indicate that.

Next we have what may be an unfamiliar rune: `%.`. This rune is simply `%-` with
the argument order reversed. `%title` is the argument passed to the next gate
that is called. `by` is the core that is the `map` engine. A Hoon `map` is a
key-value pair structure, sometimes referred to as a dictionary in other
languages. `got` is the arm in `by` that will produce a gate that we can call to
access members of a given `map`.

> The idiomatic way to write Hoon is to have the
  "heaviest" code paths lowest in the program, which is why `%.`
  is preferred in this case over `%-`. Use of this style is recommended, as it
  results in code that is much easier to read.

At the moment, however, we do not have a `map`, but instead have a `json` type.

```
%-  (om same)
u.my-json
```

Here we use `om`, which is an arm in `dejs:format` that will take a `json` and
return a `map`. `same` is a wet gate from the standard library that takes an
argument of any type and returns it as that type. We could use any other gate to
modify the data if that were useful for the particular data we are going to be
processing, but here we want the data exactly as it is.

Since `my-json` is a `unit` of `json`, the actual data we are looking for is in
`u.my-json`. We take this and give it to the gate produced by the call to `om`.
This gate is going to transform our data by taking in the `json` structure and
producing a `map`. Then we can look up keys in this map using `got` from
the `by` core.

`%.` performs the same function as `%-`, the rune used to call a function,
except with the arguments reversed so that the function is last and
the arguments of that function come first. It's used here to keep with the
principle that heaviest, or most complex, expressions should go to the bottom.

The key we are looking up in our new `map` we've created from `my-json` is
`%title`, which is an element in the original source, to produce the final
result of the generator.
