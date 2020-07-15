+++
title = "Command line interface apps"
weight = 13
template = "doc.html"
+++

# Command line interface apps

## Introduction

In this tutorial we will go in-depth on how to build command line interface (CLI)
applications in Urbit, in the course of which we will encounter a number of
libraries and applications used to facilitate this. Even if you have no interest
in writing CLI applications, this tutorial should be useful exposure to
the guts of a number of internal systems, including:

* Dill (the console vane)
* Gall (the userspace vane)
* dojo (the shell)
* `%hood` (for Gall apps interacting with Dill)
* `drum` (`%hood` library that tracks console display and input state for apps)
* `shoe` (library for CLI Gall apps that handles boilerplate code)
* `sole` (library for working with user input and console output)

There are three CLI apps that currently ship with urbit - `%dojo`, `%chat-cli`,
and `%shoe`. You should be familiar with the former two, the latter is an example
app that shows off how the `shoe` library works. These are all Gall apps, and as
such their source can be found in the `app/` folder of your `%home` desk.

In [Seven components](#seven-components) we summarize what role each of the
above bulleted items plays in a CLI app. We then show how this is reflected
with a [move trace](#move-trace-for-shoe-app)

We will investigate how to write CLI apps by walking through the code of the 
example app `%shoe` and then extending it. This tutorial can be
considered to be a continuation of the [Hoon school
lesson](@/docs/tutorials/hoon/generators.md#ask) on `sole` and `%ask`
generators, which only covers the bare minimum necessary to write generators
that take user input.

CLI apps will someday include text user interfaces (TUIs) and so if you are
interested in creating those, this tutorial is also for you.

## Seven components

In this section we briefly summarize each of the seven components mentioned
above and what purpose they perform in a CLI app. Then we look at a move trace
showing how a command send to a CLI app navigates through these components.

#### Dill

Dill is the Arvo vane that handles keyboard input from the user as well as
drawing the text in the console. You can learn more about what `task`s Dill is
responsible for in its [API documentation](@/docs/reference/vane-apis/dill.md).

#### Gall

Gall is the vane that handles userspace apps.

#### dojo

dojo is the first CLI app you encounter when you boot your ship and one you
should already be quite familiar with if you are reading this tutorial.

#### `%hood`

`%hood` is a Gall app that mediates interactions between other Gall apps and
Dill. This is an important functionality since we don't want multiple CLI apps
attempting to draw to the console at the same time. Thus all traffic between
Gall apps and Dill ultimately routes through `%hood` at some point.

#### `drum`

`drum` is Hood library that is used for handling `|command`s that you may have
used before, such as `|sync`, `|verb`, or `|hi`. (i think? this is based on a
comment in hood.hoon but I haven't looked into it further)

#### `shoe`

`shoe` is a library used to build CLI Gall apps. This is the focus of the
tutorial. We review the structure of the library [here](#the-shoe-library) and
an example app built using the `shoe` library [here](#shoe-example-app-walkthrough).

### `sole`

`sole` is a library for handling user input and console output, but less abstracted from
Dill than `shoe` and not specifically focused on Gall apps. It is still appropriate to use for writing generators
that handle user input, but anything more complex should use `shoe`, which does
the messier low-level work with `sole` on your behalf.

### Move trace 

In this section we will track how our input commands propagate through Arvo,
hitting each of the above components along the way.

We will generate a move trace of when a single character is
pressed on the keyboard when running the `%shoe` app. For a more in-depth
explanation of how to interpret move traces, check out
the [move trace tutorial](@/docs/tutorials/arvo/move-trace.md).

Starting from dojo, we enable verbose mode by entering `|verb` and then
switch to `%shoe` with `Ctrl-X` (you may need to press `Ctrl-X` multiple times). Then we press a
single character, say `d`, as if we are beginning to input the only command
`%shoe` accepts, `demo`. The following move trace shows how that `d` ends up
being displayed on the screen and passed to `%shoe` for further handling.

```
["" %unix %belt //term/1 ~2020.7.9..20.24.51..81e5]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] ~[//term/1]]
["||" %give %g [%unto %fact] i=/d t=~[//term/1]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %shoe %poke] /use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe] ~[/d //term/1]]
```

We've omitted two `%poke-ack`s for clarity here, as they are a distraction from our discussion.

In English, this represents the following sequence of `move`s:

1. Unix sends `%belt` `card` to Arvo, which then triggers the `%belt` `task` in
   Dill. This is the `task` that Dill uses to receive input from the keyboard.
2. Dill `%pass`es the input to Gall, which `%poke`s the `%hood` app, telling
   `%hood` that the `d` key was pressed.
3. Gall `%give`s back to Dill a `%fact`, telling it to display the key that was
   pressed, `d`, in the terminal.
4. Gall `%pass`es a `%deal` `card`  to itself, which says to `%poke` `%shoe` to inform it that `d` has been
   pressed. This `%poke` to `%shoe` is along the `wire`
   `/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe` which tells us that
   `%hood`, `drum`, and `phat` (another part of `%hood`) are all involved in some way. However this `wire`
   is generally thought of as being a unique identifier for an opaque cause and
   so exactly what it says doesn't actually tell us very much.
   
This exercise has shown us how keyboard input goes from Unix to Dill to
Gall to `%hood` to `%shoe`. Let's input the rest of the characters so that
`demo` is displayed in the command line, then press Enter.

```
["" %unix %belt //term/1 ~2020.7.9..20.24.31..7117]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] ~[//term/1]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %shoe %poke] /use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe] ~[/d //term/1]]
["|||" %give %g [%unto %fact] i=/g/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe t=~[/d //term/1]]
["||||" %give %g [%unto %fact] i=/d t=~[//term/1]]
["|||" %give %g [%unto %fact] i=/g/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe t=~[/d //term/1]]
["||||" %give %g [%unto %fact] i=/d t=~[//term/1]]
~zod ran the command
```
Again, we omit the `%poke-ack`s. The first two `move`s are doing the same as
before. Things start to diverge at the third `move`. Here, we no longer return
to Dill to instruct it to display a character since Enter is not a visible
character. Instead we go straight to `%poke`ing `%shoe`, telling it that Enter
has been pressed.

My guess for remaining moves:

4. `%shoe` parses the poke and recognizes it as a valid command. It then
   tells Gall to tell Dill the start a new line.
5. Gall tells Dill to display a new line.
6. `%shoe` processes the validated command and tells Gall to tell Dill to
   display `~zod ran the command`.
7. Gall tells Dill to display `~zod ran the command`.



## The `shoe` library

Here we describe the different cores of `/lib/shoe.hoon` and their purpose.

An app using the `shoe` library will have `sole-ids=(list @ta)` as part of its
state. These are typically called session ids, and they are identifiers not only
for ships, but for multiple sessions on a given ship. An app using the `shoe`
library may be connected to by a local or remote ship in order to send commands,
and each of these connections is assigned a unique `@ta` that identifies the
ship and which session on that ship if there are multiple.

### `shoe` core

An iron (contravariant) door that defines an interface for Gall agents utilized
the `shoe` library. Use this
core whenever you want to receive input from the user and run a command. The input will get
put through the parser (`+command-parser`) and results in a noun of
`command-type` that the underlying application specifies, then the app calls
that command.

In addition to the ten arms that all Gall core apps possess, `+shoe` has a few
more specific to making use of the `shoe` library. Thus you will often find it
convenient to wrap the `shoe` core with the `agent` core to obain a standard
10-arm Gall agent core. See the [shoe example app
walkthrough](#shoe-example-app-walkthrough) for how to do this.

#### `+command-parser`

Input parser for a specific session. If the head of the result is true,
instantly run the command. We give a brief tutorial on parsing in SECTION??

#### `+tab-list`

Autocomplete options for the sessions (to match `+command-parser`).

#### `+on-command`

Called when a valid command is run.

#### `+can-connect`

Called to determine whether the session can be connected to. For example, you
may only want the local ship to be able to connect to the session.

#### `+on-connect`

Called when a connection to the session is made.

#### `+on-disconnect`

Called when a session is disconnected.

### `default` core

This core contains the bare minimum implementation of the additional `shoe` arms
beyond the 10 standard Gall app ams. It is used
analogously to how the `default-agent` core is used for Gall apps.

### `agent` core

This is a wrapper core designed to take in the `shoe` core that has too many
arms to be a Gall agent core, and turns it into a standard Gall agent core by
moving the additional arms into the context. It endows the agent with additonal
arms in its context used for managing `sole` events and for calling `shoe`-specific arms.


## The `sole` library

In order to display text, `shoe` creates `$shoe-effect`s which for now are just ` [%sole effect=sole-effect]`s which are eventually broken down into Dill
calls.

From `sur/sole.hoon`:
```hoon
++  sole-effect                                         ::  app to sole
  $%  {$bel ~}                                          ::  beep
      {$blk p/@ud q/@c}                                 ::  blink+match char at
      {$clr ~}                                          ::  clear screen
      {$det sole-change}                                ::  edit command
      {$err p/@ud}                                      ::  error point
      {$klr p/styx}                                     ::  styled text line
      {$mor p/(list sole-effect)}                       ::  multiple effects
      {$nex ~}                                          ::  save clear command
      {$pro sole-prompt}                                ::  set prompt
      {$sag p/path q/*}                                 ::  save to jamfile
      {$sav p/path q/@}                                 ::  save to file
      {$tab p/(list {=cord =tank})}                     ::  tab-complete list
      {$tan p/(list tank)}                              ::  classic tank
  ::  {$taq p/tanq}                                     ::  modern tank
      {$txt p/tape}                                     ::  text line
      {$url p/@t}                                       ::  activate url
  ==

### `shoe` app walkthrough

Here we go through the code in the `shoe` example app, explaining what each line
does. This is in preparation for the next chapter of the tutorial in which we
modify the app.

```hoon
::  shoe: example usage of /lib/shoe
::
::    the app supports one command: "demo".
::    running this command renders some text on all sole clients.
::
/+  shoe, verb, dbug, default-agent
```

`/+` is the Ford rune which imports libraries from the `/lib` directory into
the subject.
 * `shoe` is the `shoe` library.
 * `verb` is a library used to print what a Gall agent is doing.
 * `dbug` is a library of debugging tools. Why do we need this?
 * `default-agent` contains a Gall agent core with minimal implementations of
   required Gall arms.

```hoon
|%
+$  state-0  [%0 ~]
+$  command  ~
::
+$  card  card:shoe
--
```
The types used by the app.

`$state-0` stores the state of the app, which is null as there is no state to
keep track of. It is good practice (required?) to have a type for state anyways
in case the app is made stateful at a later time, and indeed we will do this
when we modify this app later in the tutorial.

`$command` is typically a set of tagged union types that are possible
commands that can be entered by the user. Since this app only supports one
command, it is unnecessary for it to have any associated data, thus the command
is represented by `~`.

In a non-trivial context, a `$command` is given by `[%name
data]`, where `%name` is the identifier for the type of command and `data` is
a type or list of types that contain data needed to execute the command. See
`app/chat-cli.hoon` for examples of commands, such as `[%say letter:store]` and
`[%delete path]`.

`$card` is either an ordinary Gall agent `card` or a `%shoe` `card`, which takes
the form `[%shoe sole-ids=(list @ta) effect=shoe-effect]`. A `%shoe` `card` is
sent to all `sole`s listed in `sole-ids`, instructing them to implement the
action specified by `effect`. Here we can
reference `card:shoe` because of `/+  shoe` at the beginning of the app.

```hoon
=|  state-0
=*  state  -
::
```
Pin the bunt value of `state-0` to the head of the subject, then give it the
macro `state`. The `-` here is a lark expression referring to the head of the
subject. This allows us to use `state` to refer to the state elsewhere in the
code no matter what version we're using.

```hoon
%+  verb  |
%-  agent:dbug
^-  agent:gall
%-  (agent:shoe command)
^-  (shoe:shoe command)
```
This sequence of commands forges a `agent:gall` core that
possess may arms of the sort defined in `verb,` `agent:dbug`, and `agent:shoe`.
This sequence of commands tells the compiler that the following core is a Gall
agent core that may possess arms of the sort defined in `verb`, `agent:dbug`,
and `agent:shoe`. These cores tell the compiler what sort of form these arms
must have, and ensure that the arms that are not standard Gall arms are put into
the context so that the resulting core nests within `agent:gall`.

To be more precise, going from bottom to top, we cast what follows to a
`(shoe:shoe command)` app core,
pass that into a gate that transforms it into a `(agent:shoe command)` core, which is then cast
as an `agent:gall` and passed into the `agent:dbug` gate, which
endows the resulting core (stil a valid Gall agent core) with additional arms
useful for debugging purposes. Finally, the `verb` gate (imported with `/+
verb`) is called, which allows the agent to print what it is doing.

```hoon
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    des   ~(. (default:shoe this command) bowl)
::
```
This is boilerplate Gall agent core code. We set `def` to be an alias for the part of the
context where the `default-agent` lives, and set `des`  to be an alias for the part of the
context where `shoe` library commands live.

Next we begin implementing all of the arms 

```hoon
++  on-init   on-init:def
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  [~ this]
::
++  on-poke   on-poke:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
```
Boilerplate Gall app arms using the minimum implementation found in `def`.

Here begins the implementations of the additional arms required by the
`(shoe:shoe command)` interface.
```hoon
++  command-parser
  |=  sole-id=@ta
  ^+  |~(nail *(like [? command]))
  (cold [& ~] (jest 'demo'))
```
`+command-parser` is of central importance - it is what is used to parse user
input and transform it into `$command`s for the app to execute. Writing a proper
command parser requires understanding of the Hoon parsing functions found in the
standard library, but we will cover some of the basics here.

`+command-parser` is a gate which takes in a `sole-id=@ta` identifying a sole
session and produces a particular sort of gate which takes in a `nail` (parse
input) and returns an `edge` (parse output) that we call a parser.

 `nail` is the remainder of a parse given by `[p=hair q=tape]` where the
`hair=[p=@ud q=@ud]` represent line and column of the current position of the parse and the
`tape` is the parsing input. An `edge` is a given by `[p=hair q=(unit
[p=* q=nail])]` which continues tracking the current parsing position and may
return a `~` signifying that nothing has been matched, or a
noun (like a parsed command) and a `nail` representing the parse input. Here the
`edge` is given by the product of `*(like [? command])`. `like [? command]` produces a
generic `edge` which returns a result that is a cell of values of the `?` and
`command` types.

So by the time we get to `+command-parser` we already have a nail. Where do the
nails come from?

Anyways, the gate is

```hoon
(cold [& ~] (jest 'demo'))
```
`cold` is a parser modifier that accepts a constant noun (here `[& ~]`) and a
`rule` (`(jest 'demo')`), yielding a parser that
produces `[& ~]` whenever the `rule` `(jest 'demo')` triggers. `(jest 'demo')`
is a `rule` which matches whenever the `tape` in the input `nail` exactly
matches `demo`.

In the (section on modifying `%shoe`) we will go into more depth on parsing
commands.

```hoon
++  tab-list
  |=  sole-id=@ta
  ^-  (list [@t tank])
  :~  ['demo' leaf+"run example command"]
  ==
```
`+tab-list` is pretty much plug-n-play. For each command you want to be tab
completed, add an entry to the `list` begun by `:~` of the form `[%command
leaf+"description"]`. Now whenever the user types a partial command and presses
tab, the console will display the list of commmands that match the partial
command as well as the descriptions given here.

Thus here we have that starting to type `demo` and pressing tab will result in
the following output in the console:
```
demo  run example command
~zod:shoe> demo
```
with the remainder of `demo` now displayed in the input line.

```hoon
++  on-command
  |=  [sole-id=@ta =command]
  ^-  (quip card _this)
  =-  [[%shoe ~ %sole -]~ this]
  =/  =tape  "{(scow %p src.bowl)} ran the command"
  ?.  =(src our):bowl
    [%txt tape]
  [%klr [[`%br ~ `%g] [(crip tape)]~]~]
```
Ask Mark.

The remainder of the code should be easy to digest for a Hoon initiate.
```hoon
++  can-connect
  |=  sole-id=@ta
  ^-  ?
  ?|  =(~zod src.bowl)
      (team:title [our src]:bowl)
  ==
++  on-connect      on-connect:des
++  on-disconnect   on-disconnect:des
--
```

#### Move trace on example app

In this section we will track how our input commands propagate through Arvo.

Let's first look at a move trace of what happens when a single character is
pressed on the keyboard when running the `%shoe` app. For a more in-depth
explanation of how to interpret move traces, check out
the [move trace tutorial](@/docs/tutorials/arvo/move-trace.md).

Starting from dojo, we enable verbose mode by entering `|verb` and then
switch to `%shoe` with `Ctrl-X` (you may need to press `Ctrl-X` multiple times). Then we press a
single character, say `d`, as if we are beginning to input the only command
`%shoe` accepts, `demo`. The following move trace shows how that `d` ends up
being displayed on the screen and passed to `%shoe` for further handling.

```
["" %unix %belt //term/1 ~2020.7.9..20.24.51..81e5]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] ~[//term/1]]
["||" %give %g [%unto %fact] i=/d t=~[//term/1]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %shoe %poke] /use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe] ~[/d //term/1]]
```

We've omitted two `%poke-ack`s for clarity here, as they are a distraction from our discussion.

In English, this represents the following sequence of `move`s:

1. Unix sends `%belt` `card` to Arvo, which then triggers the `%belt` `task` in
   Dill. This is the `task` that Dill uses to receive input from the keyboard.
2. Dill `%pass`es the input to Gall, which `%poke`s the `%hood` app, telling
   `%hood` that the `d` key was pressed.
3. Gall `%give`s back to Dill a `%fact`, telling it to display the key that was
   pressed, `d`, in the terminal.
4. Gall `%pass`es a `%deal` `card`  to itself, which says to `%poke` `%shoe` to inform it that `d` has been
   pressed. This `%poke` to `%shoe` is along the `wire`
   `/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe` which tells us that
   `%hood`, `drum`, and `phat` (another part of `%hood`) are all involved in some way. However this `wire`
   is generally thought of as being a unique identifier for an opaque cause and
   so exactly what it says doesn't actually tell us very much.
   
This exercise has shown us how keyboard input goes from Unix to Dill to
Gall to `%hood` to `%shoe`. Let's input the rest of the characters so that
`demo` is displayed in the command line, then press Enter.

```
["" %unix %belt //term/1 ~2020.7.9..20.24.31..7117]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] ~[//term/1]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %shoe %poke] /use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe] ~[/d //term/1]]
["|||" %give %g [%unto %fact] i=/g/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe t=~[/d //term/1]]
["||||" %give %g [%unto %fact] i=/d t=~[//term/1]]
["|||" %give %g [%unto %fact] i=/g/use/hood/~zod/out/~zod/shoe/drum/phat/~zod/shoe t=~[/d //term/1]]
["||||" %give %g [%unto %fact] i=/d t=~[//term/1]]
~zod ran the command
```
Again, we omit the `%poke-ack`s. The first two `move`s are doing the same as
before. Things start to diverge at the third `move`. Here, we no longer return
to Dill to instruct it to display a character since Enter is not a visible
character. Instead we go straight to `%poke`ing `%shoe`, telling it that Enter
has been pressed.

My guess for remaining moves:

4. `%shoe` parses the poke and recognizes it as a valid command. It then
   tells Gall to tell Dill the start a new line.
5. Gall tells Dill to display a new line.
6. `%shoe` processes the validated command and tells Gall to tell Dill to
   display `~zod ran the command`.
7. Gall tells Dill to display `~zod ran the command`.

### Example app idea

Able to be connected to from multiple ships and sessions. Each can run one
command, which displays the name of the ship and its session id to all ships. So
basically it should just be a modification of the demo app to allow for multiple
sessions... Maybe this is what it already does though? How do I connect to the
app from a remote ship?
