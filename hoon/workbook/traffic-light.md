+++
title = "Traffic Light"
weight = 6
template = "doc.html"
+++
Let's create a state machine in Hoon that models the functionality of a traffic
light. Save the code below as `traffic.hoon` in your `/gen` directory.

```hoon
:-  %say
|=  *
:-  %noun
=+  |%
    ++  state  ?(%red %yellow %green)
    --
=/  current-state=state  %red
=+  ^=  traffic-light
    |%
    ++  look  current-state
    ++  set
      |=  s=state
      +>.$(current-state s)
    --
=+  a=traffic-light
=+  b=traffic-light
=.  a  (set.a %yellow)
[current-state.a current-state.b]
```

Let's look at the code piece-by-piece.

```hoon
:-  %say
|=  *
:-  %noun
```

Here's the boilerplate code to designate our generator as being a
[`%say` generator](@/docs/hoon/hoon-tutorial/generators.md). We're using this variant because
it allows us to run the generator without any arguments. It's otherwise not
relevant to the functionality of our program.

```hoon
=+  |%
    ++  state  ?(%red %yellow %green)
    --
```

`=+` adds a noun to the subject. In our case, the noun in question is the core
that is opened with `|%` and closed with `--`. This core is used to store types,
and does that with the arm that it contains.

`++  state` creates an arm called `state`, which will be used as the name of the
new type that is created in the code that follows, `?(%red %yellow %green)`.
That following code creates a new type from the union of its elements. In this
case, the state can be one of three values: `%red`, `%yellow`, or `%green`
corresponding to the three colors of a standard traffic light.

Having new types in a separate core is a common idiom in Hoon programs that allows
the compiler to do [constant folding](https://en.wikipedia.org/wiki/Constant_folding),
which improves performance.

```hoon
=/  current-state=state  %red
```

The line above creates a noun of type `state` - the type that we created with
the arm in previous code chunk - and gives it a default value. Because we are
putting this noun into the subject, it will be available for use in the
`traffic-light` core we are about to create.

```hoon
=+  ^=  traffic-light
    |%
    ++  look  current-state
    ++  set
      |=  s=state
      +>.$(current-state s)
    --
```

`=+  ^=  traffic-light` does two things. The `^=` rune assigns a face to that
noun so it's easier to reference. The `=+` rune adds a noun to the subject, in
this case the core that we just assigned a name and start to build on the next
line and assigned the name.

With `|%`, we are finally at the meat of the program. This core that we just
named has two arms: `look`, which gives us the current state, defined later; and
`set`, which gives us a simple way to modify the value of `current-state`.

The gate we are producing with `|=` may look a bit strange, so let's break it
down.

`s=state` allows for an argument of type `state` and gives it a face `s`.

We first produce a core with one arm named `$`. That `$` arm will produce a new
core with `current-state` changed to match the `s` provided when it was called.
How does this work?

Remember that `.` is [wing syntax](@/docs/hoon/hoon-expressions/limb/wing.md) that
applies the wing expression on the left of it to the noun to the right of it.
`$` is the arm of the core. Then by using the wing expression `+>`, which means
"return the head of the tail", we traverse the subject to the core to latch onto
its parent core. where we defined the arms `look` and `set`. The `( )` then
lists changes to the core we would like to make as we produce a new one. You
will often see `+>.$` used in this way.

```hoon
=+  a=traffic-light
=+  b=traffic-light
```

Now we have the last parts of our program. Remember that `=+` allows us to add a
noun to the head of the subject. In this case, we are adding two nouns, one with
the face `a` and a second with the face `b`. These two nouns will be copies of
the `traffic-light` core, with all the bits we previously created.

```hoon
=.  a  (set.a %yellow)
```

`=.` changes a leg in the subject. We use the `set` arm on `a` to produce a gate
and give that the argument of `%yellow`. Remember that we are actually producing
a new core in the gate, so we have to then assign that back to the face `a`.

```hoon
[current-state.a current-state.b]
```

Here we simply are creating a new cell that has the `current-state` from `a` as
it's head and the `current-state` from `b` as it's tail.

Let's run it in the Dojo to get our product:

```
> +traffic
[%yellow %red]
```

### Exercises

1. Modify the generator to include a way to cycle the light without
explicitly having to select the next color. That is, if the light is currently
`%green` then the next color would be `%yellow`. If `%yellow` then the next
color should be `%red`.

2. Using what you have learned about creating state machines in Hoon,
produce a state machine that can act as a vending-machine emulator. It should
keep track of the amount of items it has, as well as the amount of money that an
item costs. To keep it simple, assume this vending machine only has one item for
sale.

3. Modify your vending machine from exercise 2 to support holding multiple items
with different prices.
