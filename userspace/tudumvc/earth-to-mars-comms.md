+++
title = "Mars to Earth Uplink"
weight = 7
template = "doc.html"
+++

# Introduction {#introduction}
This part of the tutorial will cover connecting TodoMVC with `%tudumvc` and will end with a fully functioning, single-player version of `%tudumvc` complete with web app.

This chapter involves a significant number of JavaScript changes and we don't explain every single change. If you're not familiar with React.js at all, this chapter may be difficult to follow. Just remember, there are a lot of resources available online that describe how React.js works.

## Required Files {#required-files}
* The /src-lesson5/app /mar/tudumvc and /sur files copied into the respectively similar versions on an Urbit running on your local environment (using the sync functionality).

## Learning Checklist {#learning-checklist}
* How to use airlock to `subscribe` an Earth web app on a path to Urbit data.
* How to parse JSON data effectively in hoon.

## Goals {#goals}
* Upgrade the Earth app to send poke data for all actions.
* Parse incoming poke data into a structure the %gall agent can understand.
* Subscribe the Earth app to Urbit data for all data changes.
* Code the %gall agent to send updated state information to the Earth web.
* Minify the Earth app and host it from your Urbit.

## Prerequisites {#prerequisites}
* The TodoMVC Earth web app as modified in [the Updating the Agent part of this tutorial](@/docs/userspace/tudumvc/updating-the-agent.md).
    * A copy of the modified Earth web app can be found in [/src-lesson5/todomvc-start](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson5/todomvc-start).
* **NOTE:** We've included a copy of all the files you need for this chapter _in their completed form_ in the folder [src-lesson5](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson5).
    * In /src-lesson5/todomvc-start, we've included the files for the Earth web app as modified in the prior section of this tutorial, so you'll start with those.
    * In /src-lesson5/todomvc-end, you'll find the files for the Earth web app as they should appear after this section of the tutorial; if you're having any trouble with your modifications you can try using these instead, at the end.

## Chapter Text {#chapter-text}
This chapter follows the following order of operations:
* Add some `poke` functions to `TodoList.js` to create JSON outputs in Urbit that can be interpreted (using `+dejs:format`) into Hoon types.
* Write parsing Hoon to accept those inputs, and update the formatting of state to accommodate the new `tasks` type, when sending to the Earth app.
* Update `TodoList.js` to fully implement all possible actions and subscribe to the state from Urbit.

This could be done in a more efficient order if you knew what you were doing, but we're assuming you don't. Hopefully, this more circuitous path shows a deductive pattern one might apply to reasoning out that intercommunication.

### `poke`s Replete with Parsing
In addition to the Test Button functionality that was previously added, there are now several poke actions available in `TodoList.js`:
<style>
  #java {
    display: flex;
    flex-wrap: wrap;
  }
  #java label {
    order: -1;
    padding: .5rem;
    border-width: 1px 0px 0px 1px;
    border-style: solid;
    cursor: pointer;
  }
  #java label[for=current] {
    border-right-width: 1px;
  }
  #java label[for=current2] {
    border-right-width: 1px;
  }
  #java input[type="radio"] {
    display: none;
  }
  #java .tab {
    display: none;
    border: 1px solid;
    padding: 1rem;
    max-width: 100%;
  }
  #java input[type='radio']:checked + label {
    font-weight: bold;
  }
  #java input[type='radio']:checked + label + .tab {
    display: block;
}
</style>
<div id="on-poke">
  <input type="radio" id="prior" name="java">
  <label for="prior">Prior Version</label>
  <div class="tab">

```
  const [todos, { addTodo, deleteTodo, setDone }] = useTodos();

  // Here we're importing the Urbit API from useApi which was passed as a prop
  // to this component/container
  const urb = props.api;

  // Here we're creating a poke action to send some JSON to our ship
  const poker = () => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': 'from Earth to Mars'}});
  };
```
  </div>

  <input type="radio" id="current" name="java" checked>
  <label for="current">Current TodoList.js</label>
  <div class="tab"> 

```
  // Note that we've removed "addTodo" and "deleteTodo" from those functions
  // that are lazily defined here, to avoid name conflict
  const [todos, { setDone }] = useTodos();

  // Here we're importing the Urbit API from useApi which was passed as a prop
  // to this component/container
  const urb = props.api;

  // We've added "deleteTodo" and "addTodo"
  const poker = () => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': 'from Earth to Mars'}});
  };

  const deleteTodo = (num) => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'remove-task': num}})
  };

  const addTodo = (task) => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': task}})
  };

  const setDone = (num) => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'mark-complete': num}})
  };
```
  </div>
</div>

**NOTE:** setDone doesn't _yet_ mirror all its expected functionality - maybe you can fix that as part of the homework.

If you're following along, save these changes, let the app recompile and attempt adding a task. If you're having trouble there, make sure you check `+cors-registry`.

Doing so and attempting to add a task will produce output like this in `dojo`:
```
< ~nus: opening airlock
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='test']]}]"
>   "Added task 'We did it, reddit!' at 2"
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='test']]}]"
>   "Added task 'We did it, reddit!' at 3"
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='test']]}]"
>   "Added task 'We did it, reddit!' at 4"
~nus:dojo> 
```
This is not good - you are not a Redditor. We have yet to write code to parse these incoming pokes and add tasks according to input from the user in TodoMVC, and not just some default value. Tthe Reddit default behavior in /mar way back in [the chapter on agent supported hosting](@/docs/userspace/tudumvc/agent-supported-hosting.md).

JSON interpretation can be added in the /mar file:

#### `/mar/tudumvc/action.hoon` and JSON Parsing Introduction {#JSON-parsing}
Before reading this section, if you haven't yet, we suggest reviewing forming [JSON in Hoon](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/lull.hoon#L40), found in `lull.hoon`, as well as the JSON parser [`++  dejs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) in `zuse.hoon`.

##### Available JSON Structures
You might want to have a more in-depth lesson on JSON parsing, which you can find [here](@/docs/userspace/tudumvc/breakout-lessons/more-on-JSON-parsing.md). This part of the tutorial will give you just what you need for this purpose.
```hoon
+$  json                                                ::  normal json value
  $@  ~                                                 ::  null
  $%  [%a p=(list json)]                                ::  array
      [%b p=?]                                          ::  boolean
      [%o p=(map @t json)]                              ::  object
      [%n p=@ta]                                        ::  number
      [%s p=@t]                                         ::  string
  ==                                                    ::
```
A JSON in Hoon is defined as either ([$@](https://urbit.org/docs/reference/hoon-expressions/rune/buc/#bucpat) a null atom or a tagged union [$%](https://urbit.org/docs/reference/hoon-expressions/rune/buc/#buccen) with a few different options, some of which are recursive (`%a` and `%o`, specifically).

Looking at the incoming poke from the web, we can see that `"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='test']]}]"`. The incoming JSON is an `%o` object that contains a `(map @t json)`. The map has one key (`add-task`) and one value (`[%s p='test']`). To learn how to handle this, we'll work our way out from the inside (the value).

You could try doing this in the dojo by creating an object in the dojo that mirrors the incoming value:
```hoon
> =a `json`[%s 'this is a string']
> a
[%s p='this is a string']
~nus:dojo> 
```
The JSON parser [`+dejs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3317) includes [`+so:dejs:format`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3472) (**NOTE:** `+so:dejs:format` is just a long way of referencing the `++  so` arm of `++  dejs` which is, itself in `++  format` found in `zuse.hoon`) which is designed to parse `%s` type JSON specifically - try this in `dojo`:
```hoon
> (so:dejs:format a)
'this is a string'
~nus:dojo> 
```
Now this must be expanded to work with an object (`[%o p=\{[p='add-task' q=[%s p='test']]`). This won't be as obvious (if you haven't read [the breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/more-on-JSON-parsing.md)), but the function `+of:dejs:format` gives a list of parsing functions as, itself, a tagged union that will check the key in an object and apply one specific parser to each value of the incoming object based on a matching of the key from the object to the tag in the tagged union provided to `+of`. If this doesn't make sense yet, it will with examples over the course of this chapter.

In dojo, construct a parser using `+of:dejs:format`, like this:
```hoon
> =a (of:dejs:format :~([%add-task so:dejs:format]))
```
and store the expected Earth-formed poke JSON as another face:
```hoon
> =b [%o `(map @t json)`(my :~(['add-task' [%s 'test']]))]
```
then try parsing it:
```hoon
> (a b)
[%'add-task' 'test']
~nus:dojo> 
```
The parsed result is just like the expected vase in the dojo pokes we've used previously to modify the state of `%tudumvc`.

##### `/mar/tudumvc/action.hoon`
/mar can be modified to incorporate the parser. This will allow the pokes from TodoMVC to be correctly interpreted back into the `action` poke types that can be used on the Urbit side, and sent to `%tudumvc` in a native format:
<div id="on-poke">
  <input type="radio" id="prior2" name="java">
  <label for="prior2">Prior Version</label>
  <div class="tab">

```hoon
/-  tudumvc
=,  dejs:format
|_  act=action:tudumvc
++  grab
  |%
  ++  noun  action:tudumvc
  ++  json
  |=  jon=^json
  ~&  "Your JSON object looks like {<jon>}"
  %-  action:tudumvc
  =<
  action
  |%
  ++  action
    [%add-task 'We did it, reddit!']
  --
  --
--
```
  </div>

  <input type="radio" id="current2" name="java" checked>
  <label for="current2">Current `/mar/tudumvc/action.hoon`</label>
  <div class="tab"> 

```hoon
  ++  json
    |=  jon=^json
    %-  action:tudumvc
    =<
    (action jon)
    |%
    ++  action
      %-  of
      :~  [%add-task so]
          [%remove-task ni]
          [%mark-complete ni]
          [%edit-task (ot :~(['id' ni] ['label' so]))]
      ==
    --
  --
```
  </div>
</div>

`+action` employs a call to `+of:dejs:format`. The parser `+of` is fed a tagged union of parsers, including:
* Parsing `%add-task` with `+so:dejs:format`.
* Parsing `%remove-task` with `+ni:dejs:format`.
* Parsing `%mark-complete` with `+ni:dejs:format`.
* Parsing `%edit-task` with `(ot :~['id' ni] ['label' so])`.

To clarify, `+ni` parses a number as an integer, `+so` parses a string as a cord, and `+ot` parses an object as a tuple and takes a list of `fist`s for the expected keys in that object to further interpret them.
.

If you're following along on your own, you can clear your Urbit app's state (`:tudumvc &tudumvc-action [%remove-task 0]`), `|commit %home` the changes to the /mar file, and finally try adding a task in TodoMVC again. You should see something like this:
```hoon
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='We actually did it, Urbit!']]}]"
>   "Added task 'We actually did it, Urbit!' at 1"
~nus:dojo> 
```

With that done, we need to get the Earth web app to receive Urbit's state in the format it expected from localStorage, and the basic integration will be complete.

### `subscribe` Method of airlock and Sending cards {#airlock-subscriptions}
If you're not super familiar with JavaScript or React.js, this portion of the tutorial may be difficult to follow. There are several required changes to `containers/TodoList.js` and `/app/tudumvc.hoon` to implement state sharing between Mars and Earth. In very simple terms, we must tell TodoMVC to listen on a `path` for information and tell Urbit to send state data on that same `path` each time the state changes. Start with the (arguably) less involved TodoMVC changes:

#### `subscribe`-ing on a `path`
TodoMVC needs to `subscribe` to an Urbit path to receive data from the Urbit. It will then use React.js's useState and useEffect functions to incorporate the incoming data into TodoMVC.

The imports are updated:
<div id="import-changes">
  <input type="radio" id="prior3" name="java">
  <label for="prior3">Prior Version</label>
  <div class="tab">

```
import React, { useCallback, useMemo } from "react";
import { NavLink } from "react-router-dom";
```
  </div>

  <input type="radio" id="current3" name="java" checked>
  <label for="current3">Current Imports</label>
  <div class="tab"> 

```
import React, { useCallback, useMemo, useState, useEffect } from "react";
import { NavLink, Route } from "react-router-dom";
```
  </div>
</div>

As is state management:
<div id="import-changes">
  <input type="radio" id="prior4" name="java">
  <label for="prior4">Prior Version</label>
  <div class="tab">

```
  const [todos, { setDone }] = useTodos();

  // Here we're importing the Urbit API from useApi which was passed as a prop
  // to this component/container
  const urb = props.api;
```
  </div>

  <input type="radio" id="current4" name="java" checked>
  <label for="current4">Current State Management</label>
  <div class="tab"> 

```
  const [todos, setLocalTodos] = useState([]);

  // Here we're importing the Urbit API from useApi which was passed as a prop
  // to this component/container
  const urb = props.api

  // And here we're subscribing to our Urbit app and setting our listening
  // path to '/mytasks'
  useEffect(() => { const sub = urb.subscribe({ app: 'tudumvc', path: '/mytasks', event: data => {
    setLocalTodos(data);
  }}, [todos, setLocalTodos])
  }, []);
```
  </div>
</div>

<table>
<tr>
<td colspan="2">

And, with that, Earth is listening for data from Mars - we should send some back.

#### `/app/tudumvc.hoon` {#using-a-helper-core}
We're going to add a "helper core" ([as described earlier](@/docs/userspace/tudumvc/agent-supported-hosting.md)) to make this more legible. Basically, all this does is offboard some code to beneath the main, 10 arms of the %gall agent. This helper core will serve two purposes:
  1. Converting the `map` of `tasks` from the state back into the TodoMVC expected array.
  2. Converting from hoon types to JSON for TodoMVC, using [`+enjs`](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3263) from `zuse.hoon` to encode from hoon to JSON things.

There are a few changes required to `/app/tudumvc.hoon`, here, including:

Instructing the %gall agent to parse a helper core before the main core
<div id="adding-helper-core">
  <input type="radio" id="prior5" name="java">
  <label for="prior5">Prior Version</label>
  <div class="tab">

```hoon
^-  agent:gall
|_  =bowl:gall
+*  this   .
    def    ~(. (default-agent this %|) bowl)
```
  </div>

  <input type="radio" id="current5" name="java" checked>
  <label for="current5">Current door Code</label>
  <div class="tab"> 

```hoon
^-  agent:gall
=<
|_  =bowl:gall
+*  this   .
    def    ~(. (default-agent this %|) bowl)
    hc  ~(. +> bowl)
```
  </div>
</div>


Adding the helper core to the bottom of the `/app/tudumvc.hoon` file

```hoon
|_  bol=bowl:gall
++  tasks-json
  |=  stat=tasks:tudumvc
  |^
  ^-  json
  =/  tasklist=(list [id=@ud label=@tU done=?])  ~(tap by stat)
  =/  objs=(list json)  (roll tasklist object-maker)
  [%a objs]
  ++  object-maker
  |=  [in=[id=@ud label=@tU done=?] out=(list json)]
  ^-  (list json)
  :-
  %-  pairs:enjs:format
    :~  ['done' [%b done.in]]
        ['id' [%s (scot %ud id.in)]]
        ['label' [%s label.in]]
    ==
  out
  --
--
```

Passing a card on each possible poke action:
**NOTE:** The use of cards is better defined in [a previous breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md).
<div id="poke-changes">
  <input type="radio" id="prior6" name="java">
  <label for="prior6">Prior Version</label>
  <div class="tab">

```hoon
  %add-task
=/  new-id=@ud
?~  tasks
  1
+(-:(sort `(list @ud)`~(tap in ~(key by `(map id=@ud [task=@tU complete=?])`tasks)) gth))
~&  >  "Added task {<task.action>} at {<new-id>}"
`state(tasks (~(put by tasks) new-id [task.action %.n]))
```

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

```hoon
  %edit-task
~&  >  "Receiving facts {<id.action>} and {<label.action>}"
=/  done-state=?  done.+>:(~(get by tasks) id.action)
`state(tasks (~(put by tasks) id.action [label.action done-state]))
==
```
  </div>

  <input type="radio" id="current6" name="java" checked>
  <label for="current6">Current pokes</label>
  <div class="tab"> 

```hoon
  %add-task
=/  new-id=@ud
?~  tasks
  1
+(-:(sort `(list @ud)`~(tap in ~(key by `(map id=@ud [task=@tU complete=?])`tasks)) gth))
~&  >  "Added task {<task.action>} at {<new-id>}"
=.  state  state(tasks (~(put by tasks) new-id [+.action %.n]))
:_  state
~[[%give %fact ~[/mytasks] [%json !>((json (tasks-json:hc tasks)))]]]
```

```hoon
  %remove-task
?:  =(id.action 0)
  =.  state  state(tasks ~)
  :_  state
  ~[[%give %fact ~[/mytasks] [%json !>((json (tasks-json:hc tasks)))]]]
?.  (~(has by tasks) id.action)
  ~&  >>>  "No such task at ID {<id.action>}"
  `state
=.  state  state(tasks (~(del by tasks) id.action))
:_  state
~[[%give %fact ~[/mytasks] [%json !>((json (tasks-json:hc tasks)))]]]
```

```hoon
  %mark-complete
?.  (~(has by tasks) id.action)
  ~&  >>>  "No such task at ID {<id.action>}"
  `state
=/  task-text=@tU  label.+<:(~(get by tasks) id.action)
=/  done-state=?  ?!  done.+>:(~(get by tasks) id.action)
~&  >  "Task {<task-text>} marked {<done-state>}"
=.  state  state(tasks (~(put by tasks) id.action [task-text done-state]))
:_  state
~[[%give %fact ~[/mytasks] [%json !>((json (tasks-json:hc tasks)))]]]
```

```hoon
  %edit-task
~&  >  "Receiving facts {<id.action>} and {<label.action>}"
=/  done-state=?  done.+>:(~(get by tasks) id.action)
=.  state  state(tasks (~(put by tasks) id.action [label.action done-state]))
:_  state
~[[%give %fact ~[/mytasks] [%json !>((json (tasks-json:hc tasks)))]]]
```
  </div>
</div>


Lastly, updating `+on-watch` to send data on a path when a subscription occurs. All this does is send the current `tasks` map, converted to JSON, back along the path as, currently, the only subscriber will be the TodoMVC Earth web app. In future, we can create different paths that send the data in different formats to allow for inter-%gall subscriptions that don't need the JSON conversion.

**NOTE:** This implementation of `+on-watch` is very simple; deceptively so. As stated, more will be done with `+on-watch` in a later chapter of this tutorial, but this is good for a start.
<div id="on-watch">
  <input type="radio" id="prior7" name="java">
  <label for="prior7">Prior Version</label>
  <div class="tab">

```hoon
++  on-watch  on-watch:def
```
  </div>

  <input type="radio" id="current7" name="java" checked>
  <label for="current7">Current pokes</label>
  <div class="tab"> 

```hoon
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%mytasks ~]
  :_  this
  ~[[%give %fact ~[path] [%json !>((json (tasks-json:hc tasks)))]]]
  ==
```
  </div>
</div>

If you're following along, you can `|commit %home` the changes in Urbit and save the changes to TodoList.js. If you add a task thereafter (either by the front end or the back-end), you should see it automatically appear in the Earth web version.

#### Final changes to TodoMVC {#updating-earth-app}
TodoMVC performs edits and other activities using TodoItem.js, so to finish this chapter off, we need to change TodoItem.js. Incidentally, we've avoided doing this but you could also remove reference to useTodos.js anywhere you find it in either file - it is deprecated by these changes.

Incorporating the Urbit API in TodoItem.js:

<div id="TodoItem-API">
  <input type="radio" id="prior8" name="java">
  <label for="prior8">Prior Version</label>
  <div class="tab">

```
  return (
    <React.Fragment>
```
  </div>

  <input type="radio" id="current8" name="java" checked>
  <label for="current8">Current Fragment Return</label>
  <div class="tab"> 

```
  const {api} = props;
  return (
    <React.Fragment>
```
  </div>
</div>

Passing the API to TodoItem.js:
<div id="API-passing">
  <input type="radio" id="prior9" name="java">
  <label for="prior9">Prior Version</label>
  <div class="tab">

```
          {visibleTodos.map(todo => (
            <TodoItem key={todo.id} todo={todo} />
          ))}
```
  </div>

  <input type="radio" id="current9" name="java" checked>
  <label for="current9">Current Route Instantiation</label>
  <div class="tab"> 

```
          {visibleTodos && visibleTodos.map(todo => (
            // Each item is an instance of Route and wants
            // a key
            <Route key={`todoItem-${todo.id}`} render={(props) => {
              console.log(`todoItem-${todo.id}`);
              return <TodoItem todo={todo} api={api} {...props}/>
            }} />
          ))}
```
  </div>
</div>

And, updating TodoItem.js to use Urbit for its work:
<div id="TodoItem-Urbit">
  <input type="radio" id="prior10" name="java">
  <label for="prior10">Prior Version</label>
  <div class="tab">

```
export default function TodoItem({ todo }) {
  const [, { deleteTodo, setLabel, toggleDone }] = useTodos(() => null);

  const [editing, setEditing] = useState(false);
```

```
  const onDelete = useCallback(() => deleteTodo(todo.id), [todo.id]);
  const onDone = useCallback(() => toggleDone(todo.id), [todo.id]);
  const onChange = useCallback(event => setLabel(todo.id, event.target.value), [
    todo.id
  ]);
```

```
  const handleViewClick = useDoubleClick(null, () => setEditing(true));
  const finishedCallback = useCallback(
    () => {
      setEditing(false);
      setLabel(todo.id, todo.label.trim());
    },
    [todo]
  );

  const onEnter = useOnEnter(finishedCallback, [todo]);
  const ref = useRef();
  useOnClickOutside(ref, finishedCallback);
```

```
  return (
    <li
      onClick={handleViewClick}
      className={`${editing ? "editing" : ""} ${todo.done ? "completed" : ""}`}
    >
      <div className="view">
        <input
          type="checkbox"
          className="toggle"
          checked={todo.done}
          onChange={onDone}
          autoFocus={true}
        />
        <label>{todo.label}</label>
        <button className="destroy" onClick={onDelete} />
      </div>
      {editing && (
        <input
          ref={ref}
          className="edit"
          value={todo.label}
          onChange={onChange}
          onKeyPress={onEnter}
        />
      )}
    </li>
  );
```
  </div>

  <input type="radio" id="current10" name="java" checked>
  <label for="current10">Current TodoItem.js</label>
  <div class="tab"> 

```
export default function TodoItem(props) {
  const [label, setLabel] = useState(props.todo.label);

  const [id, setID] = useState(props.todo.id);
  
  const [editing, setEditing] = useState(false);

  const urb = props.api;

  const deleteTodo = (num) => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'remove-task': parseInt(num)}})
  };

  const toggleDone = (num) => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'mark-complete': parseInt(num)}})
  };

  const onBlur = () => {
    console.log(`setting urbit state to ${label} for task ${id}`);
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'edit-task': {'id': parseInt(id), 'label': label}}})
  };
```

```
  const onDelete = useCallback(() => deleteTodo(id), [id]);
  const onDone = useCallback(() => toggleDone(id), [id]);
  const onChange = event => {
    setLabel(event.target.value);
  }
```

```
  const handleViewClick = useDoubleClick(null, () => setEditing(true));
  const finishedCallback = useCallback(
    () => {
      onBlur();
      setEditing(false);
    },
    [label]
  );

  const onEnter = useOnEnter(finishedCallback, [label]);
  const ref = useRef();
  useOnClickOutside(ref, finishedCallback);
```

```
  return (
    <li
      onClick={handleViewClick}
      className={`${editing ? "editing" : ""} ${props.todo.done ? "completed" : ""}`}
    >
      <div className="view">
        <input
          type="checkbox"
          className="toggle"
          checked={props.todo.done}
          onChange={onDone}
          autoFocus={true}
        />
        <label>{label}</label>
        <button className="destroy" onClick={onDelete} />
      </div>
      {editing && (
        <input
          ref={ref}
          className="edit"
          value={label}
          id={id}
          // On change needs to happen component local
          // on blur needs to send to urbit
          onChange={onChange}
          onKeyPress={onEnter}
        />
      )}
    </li>
  );
```
  </div>
</div>

### Wrapping Up
If you're following along, you should be able to save all these changes, reload the app (from the `yarn run dev` interface) and start using it at this point. We still need to minify the JavaScript and store it in the `/app/tudumvc` folder to serve it _from_ your Urbit rather than running it on a dev server.

#### Minifying
1. Modify the homepage setting in `package.json` to read `http://localhost:8080/~tudumvc` or similar (already done in the [files for this chapter](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson5/todomvc-end)).
1. Minify the app (by producing a `build` folder) using `yarn build`.
2. Delete the old `index.html` file from `/app/tudumvc`.
3. Copy and paste the contents of `build` to `/app/tudumvc`.
4. Delete `favicon.ico`.

And, with that, `%tudumvc` is live on the Earth web at http://localhost:8080/~tudumvc (or your relative version).

## Homework {#homework}
* Try moving all of your poke handling work in `+on-poke`'s sub-arm `poke-action` to the helper core.
* Read about subscriptions and inter-%gall communications [here](https://github.com/timlucmiptev/gall-guide/blob/master/poke).

## Exercises {#exercises}
* Describe what's going on in our Helper Core - you'll need the following information:
    * [=<](https://urbit.org/docs/reference/hoon-expressions/rune/tis/#tisgal)
    * [pairs:enjs:format](https://github.com/urbit/urbit/blob/6bcbbf8f1a4756c195a324efcf9515b6f288f700/pkg/arvo/sys/zuse.hoon#L3271)
    * [tap:by](https://urbit.org/docs/reference/library/2i/#tap-by)
    * [roll](https://urbit.org/docs/reference/library/2b/#roll)
    * [scot](https://urbit.org/docs/reference/library/4m/#scot)
* Fix setDone in `/containers/TodoList.js` to work properly - you'll need to:
    * Add a secret function to `%mark-complete` (perhaps at `id=0` like we did with `%remove-task`) that automatically marks all tasks as complete, regardless of their current state.
    * Change `/containers/TodoList.js` to send just the secret function identifier rather than cycling through all available `id`s
    * Change our "Test Button" to be the "Mark All as Complete" button.

## Summary and Addenda {#summary}
That was a lot of work. Congratulations on making it this far. We hope you picked up on the big beats and we encourage you to pore through the changes we made in the JavaScript to better understand what we did. It's a shame we couldn't cover every line change here, but we expect that's better covered in other forums, anyway.

By now, you should:
* Generally understand JSON parsing.
    * Additional information [here](@/docs/userspace/tudumvc/breakout-lessons/more-on-JSON-parsing.md).
* Generally understand `airlock` subscriptions and how data is passed using a card along a `path`.

In the next and final part of this tutorial, we'll discuss how to add features to `%tudumvc` to allow networked task-management between urbits, now that all the data is stored in Urbit.