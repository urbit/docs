+++
title = "4. Updating the Agent"
weight = 2
template = "doc.html"
+++

At this point, you should have a `%gall` agent that can:
* Host a default Earth web page
* Contain a limited data structure
* Print out incoming JSON
You also have a version of TodoMVC that can:
* Authenticate with your Fake Ship
* poke your `%gall` agent using a new button

In this part of the guide, you're going to work on integrating all of the existing functionality of TodoMVC into our %gall agent and hooking up the TodoMVC Earth web app to your agent. You'll also learn to return an updated state (of the task list) to our Earth web app for display. Lastly, you'll move a minified version of our new `%tudumvc` to the folder you're hosting through our app.

## Learning Checklist
* How to upgrade the state database of our %gall agent.
* How to add new poke `action`s.

## Goals
* Investigate the expected state of "todos" in the Earth app.
* Upgrade the %gall agent's state to accommodate the Earth app state.
* Upgrade the %gall agent's `action`s to accommodate all possible Earth app actions.

## Prerequisites
* A Fake Ship as prepared in [Lesson 3 - The `%gall` of that `agent`](./agent-supported-hosting.md).
* **NOTE:** We've included a copy of all the files you need for this lesson _in their completed form_ in the folder [src-lesson4](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson4), but you should try doing this on your own instead of just copying our files in.

## The Lesson
Let's take a look at how the data in TodoMVC is being stored. First, launch your Urbit (recall that you previously made the Earth app dependent on our ship being online due to the asynchronous call to authenticate with our ship), then open the app (`yarn run dev` in the /react-hooks folder).

Add some todos and mark at least one of them as complete, then open the browser's console (`F12` in most browsers).

In the console, let's examine localStorage, as that's what TodoMVC is currently using to store data:
```
>> localStorage
<- >Storage { todos: "[{\"done\":false,\"id\":\"d160cc1a-02dc-4ea3-f89c-43b482da5fc4\",\"label\":\"two\"},{\"done\":false,\"id\":\"f555c8b9-ca31-b25e-d71e-f473c5de38f6\",\"label\":\"one\"},{\"done\":false,\"id\":\"a8297d73-3359-7829-cdc4-c545642f9a35\",\"label\":\"test\"}]", length: 1 }
```
`localStorage` is storing an object with a key of "todos" whose value is an array of data from our TodoMVC todo list. Take a closer look using:
```
>> JSON.parse(localStorage.getItem("todos"))
<- (3) […]
0: Object { done: false, id: "d160cc1a-02dc-4ea3-f89c-43b482da5fc4", label: "two" }
1: Object { done: false, id: "f555c8b9-ca31-b25e-d71e-f473c5de38f6", label: "one" }
2: Object { done: true, id: "a8297d73-3359-7829-cdc4-c545642f9a35", label: "test" }
length: 3
```
Using the `parse` method of JSON to turn the "todos" item from `localStorage` into its JSON form, you should an array of objects each with three key-value pairs: (1) "done" - the completion status, (2) "id" - a random ID used to differentiate tasks, (3) "label" - the task text. This structure should inform our Urbit's required state upgrades. `%tudumvc` will need to acccommodate storing tasks in a way that includes the same information points provided by the app natively.

On the Urbit side, you'll further structure the original design of the Earth app's data, turning this array into a `map`. A `map` will enable to indexing a given task quickly by it's "id" to make changes to it (mark it as complete, edit the "label", etc.).

### Upgrading the state
First, you'll need to open the `/sur/tudumvc.hoon` file and define our state as a type so that we can reference it easily in our /app file (not necessary, but idiomatic - one could define the state structures in /app, as well). Recall that we import `/sur/tudumvc.hoon` using `/-` in our /app file.

#### `/sur/tudumvc.hoon`
Our current file only defines our `action` type. For `%tudumvc` to communicate well with TodoMVC (Earth app), you'll want to add a new type called `tasks` that is structured to accommodate a `map` with a key of a task's "id" and a value for that key of the task's "label" and "done"-ness (completion state). Using this structure will allow us to index a given task by its "id" (a unique key) to modify the "label" or "done"ness (which can be non-unique - we can enter "Call Mom" 100 times and not have an indexing conflict - btw, you should call your mother - it's almost Mother's Day).

Just as with `action`, we're going to use [`+$`](https://urbit.org/docs/reference/hoon-expressions/rune/lus/#lusbuc):
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version
</td>
</tr>
<tr>
<td>

```hoon
|%

+$  action
  $%
  [%add-task task=@tU]
  ==
--
```
</td>
<td>

```hoon
+$  action
  $%
  [%add-task task=@tU]
  ==

:: Creates a structure called tasks that is a (map id=@ud [label=@tU done=?])
:: In other words a map of unique IDs to a cell of `cord` labels and boolean done-ness
::
+$  tasks  (map id=@ud [label=@tU done=?])
--
```
</td>
</tr>
</table>

Now, to turn your attention to our /app file and upgrade the state there.

#### `/app/tudumvc.hoon`
You're going to need to change four specific areas of our /app file:
* The definition of our state.
* The `+on-init` arm.
* The `+on-load` arm.
* The `+on-poke` arm (though we'll actually handle this in a second as we upgrade our `action` definitions).

Our order of operations will be:
* Update the state definition to include the `tasks` type we just created in the `/sur` file.
* Update the `+on-init` arm (which controls new installs of the agent) to start people off with the newest state definition, so they don't have to upgrade to our new version.
* Update the `+on-load` arm to provide an upgrade path for existing users to the new state.

Incidentally, don't `commit` any of these changes until the end of this part of the guide - you can have your sync-ing routine off for nearly all of this lesson.

##### state definition
Recall that `versioned-state` is a type defined as a [tagged union](https://en.wikipedia.org/wiki/Tagged_union) of our available states and that almost always our states are ennumerated, couting up from a tag of `%0` (to `%1`, `%2` and so on). Let's add our new state:
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
+$  versioned-state
    $%  state-zero
    ==
+$  state-zero
    $:  [%0 task=@tU]
    ==
```
</td>
<td>

```hoon
+$  versioned-state
    $%  state-one
        state-zero
    ==
+$  state-zero
    $:  [%0 task=@tU]
    ==
+$  state-one
    $:  [%1 tasks=tasks:tudumvc]
    ==
```
</td>
</tr>
</table>

The above adds a new available state definition, but until we update the door's sample, the `+on-init` and `+on-load` arms, nobody will actually be using this new state.

##### The door's sample
Next, you'll need to change what the door's sample is. This is sort of hard to explain, but basically (if you've read our breakout lesson on [(quip card _this)](./breakout-lessons/quip-card-and-poke.md) you may see what's happening here) you need to tell our agent that the data it should expect (its state) will be the new state definition. All of `%tudumvc`'s users (existing users by `+on-load` and new ones by `+on-init`) will have their state updated to the new state type after upgrading their app. With the new state being produced (either by, again, `+on-load` or `+on-init`), the door of the agent needs to expect that resultant state as the sample. To do this, we need to make sure that the expected sample of our agent is the new state version:
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
=|  state-zero
```
</td>
<td>

```hoon
=|  state-one
```
</td>
</tr>
</table>

With that change in place, any references to state in the existing code will be pointed to `state-one`, because of the immediately following line:

```hoon
=*  state  -
```

##### `++  on-init`
New users don't have to worry about upgrading their state, but they will need to be immediately set up with the new state on first load. To do this, you'll want to change `+on-init`:
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
++  on-init
  ^-  (quip card _this)
  ~&  >  '%tudumvc app is online'
  =/  todo-react  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
  =.  state  [%0 'example task']
  :_  this
  :~  [%pass /srv %agent [our.bowl %file-server] %poke todo-react]
  ==
```
</td>
<td>

```hoon
++  on-init
  ^-  (quip card _this)
  ~&  >  '%tudumvc app is online'
  =/  todo-react  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
  =.  state  [%1 `tasks:tudumvc`(~(put by tasks) 1 ['example task' %.n]]
  :_  this
  :~  [%pass /srv %agent [our.bowl %file-server] %poke todo-react]
  ==
```
</td>
</tr>
</table>

Note that the only real change here is how state is initialized. Using [`++  put:by`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/hoon.hoon#L1632) (described further [`here`](https://urbit.org/docs/reference/library/2i/#put-by)), `+on-init` now add a starting key-value pair to the `tasks` map of an `id=@ud` key of `1` and a `[label=@tu done=?]` value of `['example task' %.n]`.

This will work for new users, but you're going to need to do a little more work to get your existing users upgraded to this new state.

##### `++  on-load`
Existing users will have a state of `[%0 task=@tU]`. For everyone to successfully upgrade, that prior state needs to be converted into something compliant with `[%1 tasks=tasks:tudumvc]` where `tasks`, again, is the map we defined in the /sur file modified above. Using `++  put:by` here, as well, the app will nowy take the existing task (of the old state) and put it in the first `id` position of our map (`id=1`), and mark it as incomplete. Additionally, you'll want the agent to parse what state a user is in when they load so that we don't attempt to apply the upgrades to someone already in the `state-one` configuration:
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
++  on-load
  |=  incoming-state=vase
  ^-  (quip card _this)
  ~&  >  '%tudumvc has recompiled'
  `this(state [%1 (~(put by) 1 [task.incoming-state %.n])])
```
</td>
<td>

```hoon
++  on-load
  |=  incoming-state=vase
  ^-  (quip card _this)
  ~&  >  '%tudumvc has recompiled'
  =/  state-ver  !<(versioned-state incoming-state)
  ?-  -.state-ver
    %1
  `this(state state-ver)
    %0
  `this(state [%1 `tasks:tudumvc`(~(put by tasks) 1 [task.state-ver %.n])])
  ==
```
</td>
</tr>
</table>

Reviewing the changes made above:
* [!<](https://urbit.org/docs/reference/hoon-expressions/rune/zap/#zapgal) dynamically checks a vase to make sure it matches a mold.
    * Here, you're checking the vase to make sure that it matches your mold of `versioned-state` which you updated to include both `state-zero` and `state-one`.
    * Once confirmed, you're giving a face of `state-ver` to the typed vase.
* [`?-`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wuthep) switches without a default.
    * Specifically, your checking the head of the state-ver (the tag of the tagged union) to determine if the user's saved state is state `%0` or state `%1`.
    * For state `%1`, just return the `incoming-state` as is.
    * For state `%0`, take the current `task` value, which is just a `@tU` and turn it into a value in our map using [`++  put:by`](https://urbit.org/docs/reference/library/2i/#put-by).

### Upgrading the `action`s
Now, you need to upgrade the /sur and /app files again to accommodate additional poke actions that satisfy for all of our possible TodoMVC events. You can take some time to explore TodoMVC and try and determine what those behaviors are, but we'll tell you they should include (at minimum):
* Adding a Task
* Removing a Task
* Marking a Task as Complete
* Editing a Task

Let's start in the `/sur/tudumvc.hoon` file again and create those `action`s.

#### `/sur/tudumvc.hoon`
The previously constructed map data structure (the state's element `tasks`) allows `%tudumvc` to communicate a minimal amount of data between our Earth web app and Urbit to accomplish these tasks:
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
|%

+$  action
  $%
  [%add-task task=@tU]
  ==

:: Creates a structure called tasks that is a (map id=@ud [label=@tU done=?])
:: In other words a map of unique IDs to a cell of `cord` labels and boolean done-ness
::
+$  tasks  (map id=@ud [label=@tU done=?])
--
```
</td>
<td>

```hoon
|%
:: We've added %remove-task, %mark-complete, %edit-task as new actions
::
+$  action
  $%
  [%add-task task=@tU]
  [%remove-task id=@ud]
  [%mark-complete id=@ud]
  [%edit-task id=@ud label=@tU]
  ==

:: Creates a structure called tasks that is a (map id=@ud [label=@tU done=?])
:: In other words a map of unique IDs to a cell of `cord` labels and boolean done-ness
::
+$  tasks  (map id=@ud [label=@tU done=?])
--
```
</td>
</tr>
</table>

Since tasks are indexed by their unique `id`, you only need to pass the `id` key to mark something as complete or remove it. To edit a task, you have to pass both the `id` and the new `label` (to make sure you're editing the right task, even if many tasks exist with the exact same starting `label`). And, as with `+on-load` you'll only need the `label` of a task to add it as a key-value pair to the `tasks` map.

#### `/app/tudumvc.hoon` - `++  on-poke` Changes
Next, you should update `+on-poke` to accommodate the new `action`s that just added to our /sur file. If you're not sure why this is our next step, you might want to look back at [the Hosting on Urbit](./hosting-on-urbit.md) part of this guide, or the breakout lesson on [pokes](./breakout-lesson/quip-card-and-poke.md). We'll show the changes and then go through each poke to discuss how it works.
<table>
<tr>
<td>
:: initial version
</td>
<td>
:: new version 
</td>
</tr>
<tr>
<td>
   
```hoon
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+  mark  (on-poke:def mark vase)
      %tudumvc-action  (poke-actions !<(action:tudumvc vase))
  ==
  [cards this]
  ::
  ++  poke-actions
    |=  =action:tudumvc
    ^-  (quip card _state)
    ?-  -.action
      %add-task
    `state(task task:action)
    ==
  --
```
</td>
<td>

```hoon
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+  mark  (on-poke:def mark vase)
      %tudumvc-action  (poke-actions !<(action:tudumvc vase))
  ==
  [cards this]
  ::
  ++  poke-actions
    |=  =action:tudumvc
    ^-  (quip card _state)
    ?-  -.action
      %add-task
    =/  new-id=@ud
    ?~  tasks
      1
    +(-:(sort `(list @ud)`~(tap in ~(key by `(map id=@ud [task=@tU complete=?])`tasks)) gth))
    ~&  >  "Added task {<task.action>} at {<new-id>}"
    `state(tasks (~(put by tasks) new-id [+.action %.n]))
     ::
      %remove-task
    ?:  =(id.action 0)
      `state(tasks ~)
    ?.  (~(has by tasks) id.action)
      ~&  >>>  "No such task at ID {<id.action>}"
      `state
    `state(tasks (~(del by tasks) id.action))
    ::
      %mark-complete
    ?.  (~(has by tasks) id.action)
      ~&  >>>  "No such task at ID {<id.action>}"
      `state
    =/  task-text=@tU  label.+<:(~(get by tasks) id.action)
    =/  done-state=?  ?!  done.+>:(~(get by tasks) id.action)
    ~&  >  "Task {<task-text>} marked {<done-state>}"
    `state(tasks (~(put by tasks) id.action [task-text done-state]))
    ::
      %edit-task
    ~&  >  "Receiving facts {<id.action>} and {<label.action>}"
    =/  done-state=?  done.+>:(~(get by tasks) id.action)
    `state(tasks (~(put by tasks) id.action [label.action done-state]))
    ==
  --
```
</td>
</tr>
</table>

Before proceeding, sync your changed files and `|commit %home`. Next, check your state using `:tudumvc +dbug %state`. You should have something like this:
```
>   [%1 tasks={[p=id=1 q=[label='example task' done=%.n]]}]
```
Hopefully, you can see how you've updated the existing state's `task` value by turning it into a map of `[id=@ud [label=@tu done=?]]`s where your existing `task` is now the `label` of the first key-value pair in our map. Now, let's look at the `poke-action` changes.

##### `%add-task`
```hoon
  %add-task
=/  new-id=@ud
?~  tasks
  1
+(-:(sort `(list @ud)`~(tap in ~(key by `(map id=@ud [task=@tU complete=?])`tasks)) gth))
~&  >  "Added task {<task.action>} at {<new-id>}"
`state(tasks (~(put by tasks) new-id [task.action %.n]))
```
`%add-task` adds a task to our map. It takes an argument of a `task=@tu` or just a task as a cord.
* First, it creates a face called `new-id` who's value is determined by a conditional statement.
* If the `tasks` face of the user's state is empty, it will start at task `id` 1 when adding a task.
* Otherwise it will look to find the greatest current `id` value and increment it by one (in other words the agent always creates new tasks at the next positive integer `id` position).
    * This ordering function is a little complex, so we've made a [breakout lesson](./lesson4-1-ordering-our-tasks.md) to explain it; if you don't want to read that, just trust me that that's what it does.
* In either event, what it does next is again use [`put:by`](https://urbit.org/docs/reference/library/2i/#put-by) to store the incoming task (`task:action`) at the `key`-position of `new-id`, with an incomplete state (`%.n`).
Try it in dojo by entering `:tudumvc &tudumvc-action [%add-task 'test']`. You should see something like this:
```hoon
>   "Added task 'test' at 2"
> :tudumvc &tudumvc-action [%add-task 'test']
>=
```

##### `%remove-task`
```hoon
  %remove-task
?:  =(id.action 0)
  `state(tasks ~)
?.  (~(has by tasks) id.action)
  ~&  >>>  "No such task at ID {<id.action>}"
  `state
~&  >  "Removed task {<(~(get by tasks) id.action)>}"
`state(tasks (~(del by tasks) id.action))
```
`%remove-task` removes an existing task from the `tasks` map or clears everything out of `tasks` with a special all-clear function. It takes an argument of an `id=@ud` which should either be `0` or one of the existing tasks `id`s in our map.
* First, it checks to see if the `id.action` is `0`, using [`?:`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wutcol).
    * If `id.action` is `0`, then it set `tasks` equal to `~`, or null.
* If the `id.action` is not `0`, then it checks (using [`has:by`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1583), also [here](https://urbit.org/docs/reference/library/2i/#has-by)) if that `id` is a valid key in our map.
    * If it is not a valid `id`, it returns the state unchanged but mesasges the user in dojo indicating that there is `"No such task at ID {<id.action>}`.
    * If it _is_ valid, it uses [`del:by`](https://urbit.org/docs/reference/library/2i/#del-by) to remove that key-value pair from `tasks` in the state.

Try it in dojo by entering `:tudumvc &tudumvc-action [%remove-task 2]`. You should see something like this (assuming you have a task at that key `id`):
```hoon
>   "Removed task [~ [label='test' done=%.n]]"
> :tudumvc &tudumvc-action [%remove-task 2]
>=
```

##### `%mark-complete`
```hoon
  %mark-complete
?.  (~(has by tasks) id.action)
  ~&  >>>  "No such task at ID {<id.action>}"
  `state
=/  task-text=@tU  label.+<:(~(get by tasks) id.action)
=/  done-state=?  ?!  done.+>:(~(get by tasks) id.action)
~&  >  "Task {<task-text>} marked {<done-state>}"
`state(tasks (~(put by tasks) id.action [task-text done-state]))
```
`%mark-complete` marks an existing task from the state `tasks` map as complete. It takes an argument of an `id=@ud` which should be one of the existing tasks `id`s in the map.

This works almost identically to `%remove-task`, except that it only changes the `done`ness of a given task using `put:by` to replace the existing `done` value with the _opposite_ of the current `done` value. In the TodoMVC app, you can click the done button to mark an incomplete task as complete, and also click the done button of a _complete_ task to mark it _incomplete_. Allowing our app to automatically alternate between those solves for this functionality.

`%tudumvc` performs this alternation of completeness function by creating a face of `done-state` and setting it equal to the _opposite_ of the current `done` state, using [`?!`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wutzap) only _after_ we've confirmed that the `id` key actually exists.

Try it in dojo a few times, using something like `:tudumvc &tudumvc-action [%mark-complete 1]`:
```hoon
>   "Task 'example task' marked %.y"
> :tudumvc &tudumvc-action [%mark-complete 1]
>=
>   "Task 'example task' marked %.n"
> :tudumvc &tudumvc-action [%mark-complete 1]
>=
```

##### `%edit-task`
We're not going to tell you how `%edit-task` works - in fact, that's one of your exercises this part of the guide. We can tell you it works rather similarly to the ones above, and that it takes two arguments:
* An `id`.
* An updated `label`.

## Homework
* Examine the available structures of [JSON in Hoon](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/lull.hoon#L40), found in `lull.hoon`.
* Read through [`++  enjs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3263) in `zuse.hoon`.
* Read through [`++  dejs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) in `zuse.hoon`.

## Exercises
* Write a description of how `%edit-task` works, referencing the code in the [src-lesson4](https://github.com/rabsef-bicrym/tudumvc/blob/95dd6aef0551db7123c085fe7efa7cdf8c889ee2/src-lesson4/app/tudumvc.hoon#L86) folder.
    * Include a successful `dojo` `poke` command and show your output.
* Attempt to create a few JSON objects (or other structures/types of JSON) in dojo and then use [`dejs:format`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) to parse them into regular Hoon types.

## Summary and Addenda
You're just about complete with a single-player `%tudumvc` implementaiton - the next lesson will focus on updating the Earth web app to connect directly to Urbit (and ditch localStorage entirely) and parsing JSON in Urbit.

For now, we hope you are able to:
* Describe how state upgrading is managed in %gall.
* Add your own poke `action`s by defining them in your agent's /sur file and adding handling to `+on-poke`.

Also, check out the breakout lesson for this lesson on:
* [Ordering Tasks Using `sort`](./breakout-lessons/ordering-tasks.md)