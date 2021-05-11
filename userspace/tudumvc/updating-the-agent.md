+++
title = "Updating the Agent"
weight = 6
template = "doc.html"
+++

## Introduction {#introduction}
At this point, we have a `%gall` agent that can:
* Host a default Earth web page.
* Contain a limited data structure.
* Print out incoming JSON.
We also have a version of TodoMVC that can:
* Authenticate with an Urbit (Fake Ship or otherwise, but we've been using a Fake Ship).
* poke `%tudumvc` using a new button, resulting in some state changes and a dojo printout.

In this chapter of the tutorial, we'll integrate all of the existing functionality of TodoMVC into the %gall agent and preparing your `%tudumvc`'s state to accommodate tasks in the format in which they exist on TodoMVC.

## Required Files {#required-files}
* The /src-lesson4/react-hooks folder copied to your local environment.
* The /src-lesson4/app /mar/tudumvc and /sur files copied into the respectively similar versions on an Urbit running on your local environment (using the sync functionality).

## Learning Checklist {#learning-checklist}
* How to upgrade the state database of our %gall agent.
* How to add new poke `action`s.

## Goals {#goals}
* Investigate the expected state of "todos" in the Earth app.
* Upgrade the %gall agent's state to accommodate the Earth app state.
* Upgrade the %gall agent's `action`s to accommodate all possible Earth app actions.

## Prerequisites {#prerequisites}
* A Fake Ship as prepared in [Chapter 3 - Configuring a %gall agent to interact with TodoMVC](@/docs/userspace/tudumvc/agent-supported-hosting.md).
* **NOTE:** We've included a copy of all the files you need for this chapter _in their completed form_ in the folder [src-lesson4](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson4).

## Chapter Text {#chapter-text}
To prepare `%tudumvc` as a back-end for TodoMVC, we'll take a look at how TodoMVC stores data in the localStorage presently.Let's take a look at how the data in TodoMVC is being stored. 

We'll start by launching our Urbit (recall that we previously made the Earth app dependent on our ship being online due to the asynchronous call to authenticate with our ship), then opening the app (`yarn run dev` in the /react-hooks folder).

If we add some todos and mark at least one of them as complete, then open the browser's console (`F12` in most browsers) and examine localStorage, we can see the storage looks something like this:
```
>> localStorage
<- >Storage { todos: "[{\"done\":false,\"id\":\"d160cc1a-02dc-4ea3-f89c-43b482da5fc4\",\"label\":\"two\"},{\"done\":false,\"id\":\"f555c8b9-ca31-b25e-d71e-f473c5de38f6\",\"label\":\"one\"},{\"done\":false,\"id\":\"a8297d73-3359-7829-cdc4-c545642f9a35\",\"label\":\"test\"}]", length: 1 }
```
`localStorage` is storing an object with a key of "todos" whose value is an array of data from the TodoMVC todo list. 

This general object could be parsed using the `parse` method of JSON to turn the "todos" item from `localStorage` into its JSON form:
```
>> JSON.parse(localStorage.getItem("todos"))
<- (3) […]
0: Object { done: false, id: "d160cc1a-02dc-4ea3-f89c-43b482da5fc4", label: "two" }
1: Object { done: false, id: "f555c8b9-ca31-b25e-d71e-f473c5de38f6", label: "one" }
2: Object { done: true, id: "a8297d73-3359-7829-cdc4-c545642f9a35", label: "test" }
length: 3
```
Each object contains three key-value pairs: 
1. "done" - the completion status.
2. "id" - a random ID used to differentiate tasks.
3. "label" - the task text. 

This structure should inform `%tudumvc`'s required state upgrades. The agent will need to acccommodate storing tasks in a way that includes the same information points provided by the app natively.

Thinking proactively here, on the Urbit side, we'll further structure the original design of the Earth app's data, turning this array into a `map`. A `map` will enable to indexing a given task quickly by it's "id" to make changes to it (mark it as complete, edit the "label", etc.). This `map` structure will also help, later, when we add networking (between Urbits) to the Earth app - but more on that later.

### Upgrading the state {#state-upgrades}
We'll start by updating the `/sur/tudumvc.hoon` file to define the _new_ state as a type so that it can be easily referenced in the /app file (not necessary, but idiomatic - one could define the state structures in /app, as well). Recall that we import `/sur/tudumvc.hoon` using `/-` in our /app file.

#### `/sur/tudumvc.hoon`
Currently, /sur defines _only_ the `action` type. For `%tudumvc` to communicate well with TodoMVC (Earth app), we've added a new type called `tasks` that is structured to accommodate a `map` with a key of a task's "id" and a value for that key of the task's "label" and "done"-ness (completion state). Using this structure will allow `%tudumvc` to index a given task by its "id" (a unique key) to modify the "label" or "done"ness (which can be non-unique - we can enter "Call Mom" 100 times and not have an indexing conflict - btw, you should call your mother - it's almost Mother's Day).

As with `action`, this type will be defined using [`+$`](https://urbit.org/docs/reference/hoon-expressions/rune/lus/#lusbuc). The resulting /sur file looks like this:

<div id="state-type">
  <input type="radio" id="prior" name="state-type">
  <label for="prior">Prior Version</label>
  <div class="tab">

```hoon
|%

+$  action
  $%
  [%add-task task=@tU]
  ==
--
```
  </div>

  <input type="radio" id="current" name="state-type" checked>
  <label for="current">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>
<style>
  #state-type {
    display: flex;
    flex-wrap: wrap;
  }
  #state-type label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #state-type label[for=current] {
    border-right-width: 1px;
  }
  #state-type .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #state-type input[type="radio"] {
    display: none;
  }
  #state-type input[type='radio']:checked + label {
    font-weight: bold;
  }
  #state-type input[type='radio']:checked + label + .tab {
    display: block;
  }
    #state-definition {
    display: flex;
    flex-wrap: wrap;
  }
  #state-definition label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #state-definition label[for=current2] {
    border-right-width: 1px;
  }
  #state-definition .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #state-definition input[type="radio"] {
    display: none;
  }
  #state-definition input[type='radio']:checked + label {
    font-weight: bold;
  }
  #state-definition input[type='radio']:checked + label + .tab {
    display: block;
  }
  #door-sample {
    display: flex;
    flex-wrap: wrap;
  }
  #door-sample label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #door-sample label[for=current3] {
    border-right-width: 1px;
  }
  #door-sample .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #door-sample input[type="radio"] {
    display: none;
  }
  #door-sample input[type='radio']:checked + label {
    font-weight: bold;
  }
  #door-sample input[type='radio']:checked + label + .tab {
    display: block;
  }
  #on-init {
    display: flex;
    flex-wrap: wrap;
  }
  #on-init label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #on-init label[for=current4] {
    border-right-width: 1px;
  }
  #on-init .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #on-init input[type="radio"] {
    display: none;
  }
  #on-init input[type='radio']:checked + label {
    font-weight: bold;
  }
  #on-init input[type='radio']:checked + label + .tab {
    display: block;
  }
  #on-load {
    display: flex;
    flex-wrap: wrap;
  }
  #on-load label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #on-load label[for=current5] {
    border-right-width: 1px;
  }
  #on-load .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #on-load input[type="radio"] {
    display: none;
  }
  #on-load input[type='radio']:checked + label {
    font-weight: bold;
  }
  #on-load input[type='radio']:checked + label + .tab {
    display: block;
  }
  #action-update {
    display: flex;
    flex-wrap: wrap;
  }
  #action-update label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #action-update label[for=current6] {
    border-right-width: 1px;
  }
  #action-update .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #action-update input[type="radio"] {
    display: none;
  }
  #action-update input[type='radio']:checked + label {
    font-weight: bold;
  }
  #action-update input[type='radio']:checked + label + .tab {
    display: block;
  }
  #on-poke {
    display: flex;
    flex-wrap: wrap;
  }
  #on-poke label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #on-poke label[for=current7] {
    border-right-width: 1px;
  }
  #on-poke .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    width: 100%;
  }
  #on-poke input[type="radio"] {
    display: none;
  }
  #on-poke input[type='radio']:checked + label {
    font-weight: bold;
  }
  #on-poke input[type='radio']:checked + label + .tab {
    display: block;
  }
</style>

Next, the /app file needs to be updated to utilize this new type.

#### `/app/tudumvc.hoon`
There are four specific areas of `%tudumvc`'s /app file that need to be updated to accept the new state:
* The definition of the state.
* The `+on-init` arm.
* The `+on-load` arm.
* The `+on-poke` arm (though we'll actually handle this in a second as we upgrade our `action` definitions).

The order of update operations should be:
* Update the state definition to include the `tasks` type from /sur.
* Update the `+on-init` arm to start the agent with the newest state definition.
* Update the `+on-load` arm to provide an upgrade path for existing users to the new state.

Incidentally, if you're following along on your own, don't `|commit %home` any of these changes until all of the changes in this chapter have been made - they work in conjunction and need to be implemented simultaneously.

##### state definition
`versioned-state` is a type defined as a [tagged union](https://en.wikipedia.org/wiki/Tagged_union) of all available states. The state versions are almost always ennumerated, couting up from a tag of `%0` (to `%1`, `%2` and so on).

To add the new version, then, we'll do something like this:

<div id="state-definition">
  <input type="radio" id="prior2" name="state-definition">
  <label for="prior2">Prior Version</label>
  <div class="tab">

```hoon
+$  versioned-state
    $%  state-zero
    ==
+$  state-zero
    $:  [%0 task=@tU]
    ==
```
  </div>

  <input type="radio" id="current2" name="state-definition" checked>
  <label for="current2">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>

The above adds a new available state definition, but without updating the door's sample, the `+on-init` and `+on-load` arms, this won't work properly.

##### The door's sample
While `versioned-state` has been updated with the new state definition, the door of `%tudumvc` needs to be updated to tell the agent to expect (its state) as the newly defined version (if you've read our breakout lesson on [(quip card _this)](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md) you may see what's happening here). All of `%tudumvc`'s users (existing users by `+on-load` and new ones by `+on-init`) will have their state updated to the new state type after upgrading their app to this new version. With the new state being produced (either by, again, `+on-load` or `+on-init`), the door of the agent needs to expect that resultant state as the sample. To do this, we need to make sure that the expected sample of our agent is the new state version:

<div id="door-sample">
  <input type="radio" id="prior3" name="door-sample">
  <label for="prior3">Prior Version</label>
  <div class="tab">

```hoon
=|  state-zero
```
  </div>

  <input type="radio" id="current3" name="door-sample" checked>
  <label for="current3">Current Hoon</label>
  <div class="tab"> 

```hoon
=|  state-one
```
  </div>
</div>

With that change in place, any references to state in the existing code will be pointed to `state-one`, because of the immediately following line:

```hoon
=*  state  -
```

##### `+on-init`
New users don't have to worry about upgrading their state, but they will need to be immediately set up with the new state on first load. To do this, we change `+on-init`:
<div id="on-init">
  <input type="radio" id="prior4" name="on-init">
  <label for="prior4">Prior Version</label>
  <div class="tab">

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
  </div>

  <input type="radio" id="current4" name="on-init" checked>
  <label for="current4">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>

This change sets up `+on-init` to start _new_ users with the newly defined state (`tasks`). Using [`+put:by`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/hoon.hoon#L1632) (described further [`here`](https://urbit.org/docs/reference/library/2i/#put-by)), `+on-init` now adds a starting key-value pair to the `tasks` map of an `id=@ud` key of `1` and a `[label=@tu done=?]` value of `['example task' %.n]`.

This is sufficient for new users, but existing users will need `+on-load` to provide an upgrade path from their existing state to the new state (theoretically, this could be as simple as "throw away the old state, and start them with this new state and these new values for that state").

##### `+on-load`
Existing users will have a state of `[%0 task=@tU]`. For those users to successfully upgrade, that prior state needs to be converted into something compliant with `[%1 tasks=tasks:tudumvc]` where `tasks`, again, is the map defined in the /sur file modified above. Using `+put:by` here, as well, the app will take the existing task (of the old state) and put it in the first `id` position of our map (`id=1`), and mark it as incomplete.

However, we don't want to apply the upgrade path to users _already_ on the new state. As such, we want the agent to parse what state a user is in when they load so that we don't attempt to apply the upgrades to someone already in the `state-one` configuration:
<div id="on-load">
  <input type="radio" id="prior5" name="on-load">
  <label for="prior5">Prior Version</label>
  <div class="tab">

```hoon
++  on-load
  |=  incoming-state=vase
  ^-  (quip card _this)
  ~&  >  '%tudumvc has recompiled'
  `this(state [%1 (~(put by) 1 [task.incoming-state %.n])])
```
  </div>

  <input type="radio" id="current5" name="on-load" checked>
  <label for="current5">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>

Reviewing the changes made above:
* [!<](https://urbit.org/docs/reference/hoon-expressions/rune/zap/#zapgal) dynamically checks a vase to make sure it matches a mold.
    * Here, this checks the vase to make sure that it matches the mold of `versioned-state` which you updated to include both `state-zero` and `state-one`.
    * Once confirmed, this gives a face of `state-ver` to the typed vase.
* [`?-`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wuthep) switches without a default.
    * Here, this checks the head of the state-ver (the tag of the tagged union) to determine if the user's saved state is state `%0` or state `%1`.
    * For state `%1`, it returns the `incoming-state`, as is.
    * For state `%0`, it takes the current `task` value, which is just a `@tU` and turns it into a value in the `tasks` map using [`+put:by`](https://urbit.org/docs/reference/library/2i/#put-by).

### Upgrading the `action`s {#upgrading-pokes}
TodoMVC is capable of more than just `%add-task`ing a new item to the same text field, as was possible in the first version of `%tudumvc`. To make `%tudumvc` capable of handling all of the expected UI interactions, the /sur and /app files also need to be changed to accommodate additional poke actions. At minimum, `%tudumvc` needs to allow for:
* Adding a Task
* Removing a Task
* Marking a Task as Complete
* Editing a Task

Starting in the `/sur/tudumvc.hoon` file, the `action` type can be upgraded to implement these features.

#### `/sur/tudumvc.hoon`
The previously constructed map data structure (the state's element `tasks`) allows `%tudumvc` to communicate a minimal amount of data between our Earth web app and Urbit to accomplish these tasks:
<div id="action-update">
  <input type="radio" id="prior6" name="action-update">
  <label for="prior6">Prior Version</label>
  <div class="tab">

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
  </div>

  <input type="radio" id="current6" name="action-update" checked>
  <label for="current6">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>

Since tasks are indexed by their unique `id`, `action` only needs to pass the `id` key to mark something as complete or remove it. To edit a task, it must to pass both the `id` and the new `label` (to make sure we're editing the right task, even if many tasks exist with the exact same starting `label`). And, as in `+on-load`, it only needs the `label` of a task to add it as a key-value pair to the `tasks` map.

#### `/app/tudumvc.hoon` - `+on-poke` Changes
Next, you should update `+on-poke` to accommodate the new `action`s that just added to our /sur file. If you're not sure why this is our next step, you might want to look back at [the Hosting on Urbit](@/docs/userspace/tudumvc/hosting-on-urbit.md) part of this tutorial, or the breakout lesson on [pokes](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md). We'll show the changes and then go through each poke to discuss how it works.
<div id="on-poke">
  <input type="radio" id="prior7" name="on-poke">
  <label for="prior7">Prior Version</label>
  <div class="tab">

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
  </div>

  <input type="radio" id="current7" name="on-poke" checked>
  <label for="current7">Current Hoon</label>
  <div class="tab"> 

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
  </div>
</div>

If you're following along, before proceeding, sync your changed files and `|commit %home`. Next, check your state using `:tudumvc +dbug %state`. We should have something like this:
```
>   [%1 tasks={[p=id=1 q=[label='example task' done=%.n]]}]
```

Again, the existing state's `task` value has been updatedby turning it into a map of `[id=@ud [label=@tu done=?]]`s where the existing `task` is now the `label` of the first key-value pair in the `map`. 

The _new_ `tasks` `map` can be modified using the pokes previously defined in /sur.

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
`%add-task` adds a task to the map. It takes an argument of a `task=@tu`; a new task, as a cord.
* First, it creates a face called `new-id` who's value is determined by a conditional statement.
* If the `tasks` face of the user's state is empty, it will start at task `id` 1 when adding a task.
* Otherwise it will look to find the greatest current `id` value and increment it by one (in other words the agent always creates new tasks at the next positive integer `id` position).
    * This ordering function is a little complex, so we've made a [breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/ordering-tasks.md) to explain it; if you don't want to read that, just trust me that that's what it does here ``+(-:(sort `(list @ud)`~(tap in ~(key by `(map id=@ud [task=@tU complete=?])`tasks)) gth))``.
* In either event, next, it uses [`+put:by`](https://urbit.org/docs/reference/library/2i/#put-by) to store the incoming task (`task.action`) at the `key`-position of `new-id`, with an incomplete state (`%.n`).
This can be entered in dojo by entering `:tudumvc &tudumvc-action [%add-task 'test']`:
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
* If the `id.action` is not `0`, then it checks (using [+`has:by`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1583), further described [here](https://urbit.org/docs/reference/library/2i/#has-by)) if that `id` is a valid key in our map.
    * If it is not a valid `id`, it returns the state unchanged but messages the user in dojo indicating that there is `"No such task at ID {<id.action>}`.
    * If it _is_ valid, it uses [`+del:by`](https://urbit.org/docs/reference/library/2i/#del-by) to remove that key-value pair from `tasks` in the state.

If you're following along, you can try this in dojo by entering `:tudumvc &tudumvc-action [%remove-task 2]`. You should see something like this (assuming you have a task at that key `id`):
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
`%mark-complete` marks an existing task from the state `tasks` `map` as complete. It takes an argument of an `id=@ud` which should be one of the existing tasks `id`s in the `map`.

This is practically similar to `%remove-task`, except it only changes the `done`ness of a given task using `+put:by` to replace the existing `done` value with the _opposite_ of the current `done` value. In the TodoMVC app, the user clicsk the done button to mark an incomplete task as complete, and also clicks the done button of a _complete_ task to mark it _incomplete_. Programming the %gall agent to automatically alternate between those solves for this functionality.

`%tudumvc` performs this alternation of completeness function by creating a face of `done-state` and setting it equal to the _opposite_ of the current `done` state, using [`?!`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wutzap) only _after_ confirming that the `id` key actually exists.

In dojo, the command `:tudumvc &tudumvc-action [%mark-complete 1]` results in the following behavior:
```hoon
>   "Task 'example task' marked %.y"
> :tudumvc &tudumvc-action [%mark-complete 1]
>=
>   "Task 'example task' marked %.n"
> :tudumvc &tudumvc-action [%mark-complete 1]
>=
```

##### `%edit-task`
Rather than explain how `%edit-task` works - take a look and see if you can read it.
```hoon
  %edit-task
~&  >  "Receiving facts {<id.action>} and {<label.action>}"
=/  done-state=?  done.+>:(~(get by tasks) id.action)
`state(tasks (~(put by tasks) id.action [label.action done-state]))
```

We can tell you it works rather similarly to the ones above, and that it takes two arguments:
* An `id`.
* An updated `label`.

## Additional Materials {#additional-materials}
* Examine the available structures of [JSON in Hoon](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/lull.hoon#L40), found in `lull.hoon`.
* Read through [`+enjs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3263) in `zuse.hoon`.
* Read through [`+dejs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) in `zuse.hoon`.

## Exercises {#exercises}
* Write a description of how `%edit-task` works, referencing the code in the [src-lesson4](https://github.com/rabsef-bicrym/tudumvc/blob/95dd6aef0551db7123c085fe7efa7cdf8c889ee2/src-lesson4/app/tudumvc.hoon#L86) folder.
    * Also, make sure you can write a successful `poke` in dojo using this type.
* Attempt to create a few JSON objects (or other structures/types of JSON) in dojo.
    * Use [`dejs:format`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) to parse those into regular Hoon types.

## Summary and Addenda {#summary}
The Urbit side of a single-player `%tudumvc` implementation is complete - the next chapter will focus on updating the Earth web app to connect directly to Urbit (and ditch localStorage entirely) and parsing JSON in Urbit.

For now, we hope you are able to:
* Describe how state upgrading is managed in %gall.
* Add your own poke `action`s by defining them in your agent's /sur file and adding handling to `+on-poke`.

Also, check out the breakout lesson for this chapter on:
* [Ordering Tasks Using `sort`](@/docs/userspace/tudumvc/breakout-lessons/ordering-tasks.md)