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
* `%hood` (for Gall apps interacting with Dill)
* `drum` (`%hood` library that tracks console display and input state for apps)
* `shoe` (library for CLI Gall apps that handles boilerplate code)
* `sole` (library for working with user input and console output)

There are three CLI apps that currently ship with urbit - `%dojo`, `%chat-cli`,
and `%shoe`. You should be familiar with the former two, the latter is an example
app that shows off how the `shoe` library works that we will be looking at closely. These are all Gall apps, and as
such their source can be found in the `app/` folder of your `%home` desk.

In [six components](#six-components) we summarize what role each of the
above bulleted items plays in a CLI app. Then we go into further depth on two of
them: `shoe` and `sole`. In [the `shoe`
library](#the-shoe-library) we take a closer look at the `shoe` library and its
cores and how they are utilized in CLI apps. Then in [the `sole`
library](#the-sole-library) we look at what `shoe` effects ultimately break down
into. Finally in [`%shoe` app walkthrough](#shoe-app-walkthrough) we explore
the functionality of the `%shoe` app and then go through the code line-by-line.

This tutorial can be
considered to be a continuation of the [Hoon school
lesson](@/docs/tutorials/hoon/generators.md#ask) on `sole` and `%ask`
generators, which only covers the bare minimum necessary to write generators
that take user input.

## Six components

In this section we briefly summarize each of the seven components mentioned
above and what purpose they perform in a CLI app. Then we look at a move trace
showing how a command send to a CLI app navigates through these components.

#### Dill

Dill is the Arvo vane that handles keyboard input from the user as well as
drawing the text in the console. You can learn more about what `task`s Dill is
responsible for in its [API documentation](@/docs/reference/vane-apis/dill.md).

#### Gall

Gall is the vane that handles userspace apps.

#### `%hood`

`%hood` is a Gall app that mediates interactions between other Gall apps and
Dill. This is an important functionality since we don't want multiple CLI apps
attempting to draw to the console at the same time. Thus all traffic between
Gall apps and Dill ultimately routes through `%hood` at some point.

#### `drum`

`drum` is a Hood library that is used for handling `|command`s, e.g. `|ota`, `|start`, or `|hi`.

#### `shoe`

`shoe` is a library used to build CLI Gall apps. This is the focus of the
tutorial. We review the structure of the library [here](#the-shoe-library) and
an example app built using the `shoe` library [here](#shoe-example-app-walkthrough).

#### `sole`

`sole` is a library for handling user input and console output, but less abstracted from
Dill than `shoe` and not specifically focused on Gall apps. It is still appropriate to use for writing generators
that handle user input, but anything more complex should use `shoe`, which does
the messier low-level work with `sole` on your behalf.


## The `shoe` library {#the-shoe-library}

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


## The `sole` library {#the-sole-library}

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
```

## `%shoe` app walkthrough {#shoe-app-walkthrough}

Here we explore the capabilities of the `%shoe` example app and then go through
the code, explaining what each line does. 

### Playing with `%shoe`

First let's test the functionality of `%shoe` so we know what we're getting into.

Start two fake ships, one named `~zod` and the other can have any name - we will
go with `~nus`. Fake ships run locally are able to see each other, and our
intention is to connect their `%shoe` apps.

On each fake ship start `%shoe` by entering `|start %shoe` into dojo. You may
then switch to `%shoe` by pressing `Ctrl-X`, possibly multiple times, which will
change the prompt to `~zod:shoe>` and `~nus:shoe>`. Enter `demo` from `~zod` and press Enter:
```
~zod ran the command
~zod:shoe> 
```
`~zod ran the command` should be displayed in bold green text, signifying that
the command originated locally.

Now we will connect the sessions. Switch `~zod` back to dojo and enter `|link
~nus %shoe`. If this succeeds you will see the following.
```
>=
; ~nus is your neighbor
[linked to [p=~nus q=%shoe]]
```
Now `~zod` will have two `%shoe` sessions running - one local one on `~zod` and
one remote one on `~nus`, which you can access by pressing `Ctrl-X` until you see
`~nus:shoe>` from `~zod`'s console. On the other hand, you should not see
`~zod:shoe>` on `~nus`'s side, since you have not connected `~nus` to `~zod`'s
`%shoe` app. When you enter `demo` from `~nus:shoe>` on
`~zod`'s console you will again see `~zod ran the command`, but this time it
should be in the ordinary font used by the console, signifying that the command
is originating from a remote session. Contrast this with entering `demo` from
`~nus:shoe>` in `~nus`'s console, which will display `~nus ran the command` in
bold green text.

Now try to link to `~zod`'s `%shoe` session from `~nus` by switching to the dojo
on `~nus` and entering `|link ~zod %shoe`. You should see
```
>=
[unlinked from [p=~zod q=%shoe]]
```
and if you press `Ctrl-X` you will not get a `~zod:shoe>` prompt. This is
because the example app is set up to always allow `~zod` to connect (as well as
subject moons if the ship happens to be a planet) but not `~nus`, so this
message means that `~nus` failed to connect to `~zod`'s `%shoe` session.

### `%shoe`'s code

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
standard library, but we will cover the bare essentials of parsing here.

`+command-parser` is a gate which takes in a `sole-id=@ta` identifying a `sole`
session and produces a particular sort of gate which takes in a `nail` (parse
input) and returns an `edge` (parse output) that we call a parser or `$rule`.
`+command-parser` produces a specific type of `$rule` whose result is of the
type `[? command]`. Let us elaborate.

 `nail` is the remainder of a parse given by `[p=hair q=tape]` where the
`hair=[p=@ud q=@ud]` represent line and column of the current position of the parse and the
`tape` is the parsing input. An `edge` is a given by `[p=hair q=(unit
[p=* q=nail])]`. `p` says what we have parsed up to this point. `q` is the
result of the parse, which is `~` if nothing valid has yet been parsed or a noun
`p.q` that here will be a value of the `$command` type and `q.q` a `nail` that
contains results that may still be unparsed. Here the
`edge` is cast with `*(like [? command])`. `like [? command]`
produces a generic `edge` which returns a result that is a cell of values of the
`?` and `command` types - this is what forces `+command-parser` to produce a
`$rule` that returns a value of type `[? command]`.

Anyways, the gate is
```hoon
(cold [& ~] (jest 'demo'))
```
`cold` is a parser modifier that accepts a constant noun (here `[& ~]`) and a
`rule` (`(jest 'demo')`) to produce another `rule`. This `rule` is then a parser that
produces `[& ~]` whenever the `rule` `(jest 'demo')` triggers. `(jest 'demo')`
triggers whenever the `tape` in the input `nail` exactly
matches `demo`.

The reason we use a `cord` `demo` as the argument for `jest` rather than a
`tape` is not too important for this discussion, but the short version is that
`cord`s are used to represent data that is passed around while `tape`s are for
when you're ready to start doing string manipulation.

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

Next we have `+on-command`, which is called whenever `+command-parser`
recognizes that `demo` has be entered by a user on a connected session.
```hoon
++  on-command
  |=  [sole-id=@ta =command]
  ^-  (quip card _this)
```
This is a gate that takes in the `sole-id` corresponding to the session and the
`command` noun parsed by `+command-parser` and returns a `list` of `card`s and
`_this`, which is Gall agent core including its state.
```hoon
  =-  [[%shoe ~ %sole -]~ this]
```
This creates a cell of a `%shoe` card that triggers a `sole-effect` given by the head of
the subject `-`, then the Gall agent core `this` - i.e. the return result of
this gate. The use of the `=-` rune means that what follows this
expression is actually run first, which puts the desired `sole-effect` into the
head of the subject.
```hoon
  =/  =tape  "{(scow %p src.bowl)} ran the command"
```
We pin the `tape` that we want to be printed to the head of the subject.
```hoon
  ?.  =(src our):bowl
    [%txt tape]
  [%klr [[`%br ~ `%g] [(crip tape)]~]~]
```
We cannot just put a bare `tape` at the head of the subject to be added to the
card - it needs to be wrapped as a `sole-effect`. This tells us that if the
origin of the command is not our ship to just print it normally with the `%txt`
`sole-effect`. Otherwise we use `%klr`, which prints it stylistically (here it
makes the text green and bold).

The following allows either `~zod` or the current ship or its moons to connect to `%shoe`.
```hoon
++  can-connect
  |=  sole-id=@ta
  ^-  ?
  ?|  =(~zod src.bowl)
      (team:title [our src]:bowl)
  ==
```

We use the minimal implementations for the final two `shoe` arms.
```hoon
++  on-connect      on-connect:des
++  on-disconnect   on-disconnect:des
--
```

This concludes our review of the code of the `%shoe` app. To continue learning
how to build your own CLI app, we recommend checking out `/app/chat-cli.hoon`.
