+++
title = "%gall and %file-server"
weight = 5
template = "doc.html"
+++

You now know how to host Earth web content from your Urbit and you've explored some of the limitations of that ability. In this lesson, you'll learn how to develop a %gall agent to support the back-end of an Earth web app. We call this agent `%tudumvc` because it's TodoMVC but on Urbit so it needs to have a funny name.

## Learning Checklist {#learning-checklist}
* What is the basic structure of a %gall agent?
* How is state added to an agent?
* What is `+dbug`?
* What is a scry?
* What does `=^` (tisket) do?
* What is airlock and how does it work, generally?
* How does incoming JSON look to our Urbit?

## Goals {#goals}
* Install a %gall app.
* Examine the structure of %gall apps.
* Scry our state.
* Use `+dbug` to examine our state.
* Link our Earth web app with our urbit.
* Print out, but do not yet interpret, JSON coming from our Earth web app.

## Prerequisites {#prerequisites}
* An empty Fake Ship (wipe out the one you made last lesson and start anew)
* The [Lesson 3 files](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson3) cloned to your development environment.
  *  **NOTE:** The `/src-lesson3/react-hooks` folder packaged for this lesson has been pre-modified for this lesson. While we will go over these modifications and off-screen changes, you have been pre-warned that the default files will not work for this lesson.

## The Lesson {#the-lesson}
Start by syncing the files from in the /src-lesson3/app, /src-lesson3/mar and /src-lesson4/sur to your ship. We'll examine these files in detail below, but we need them there to start. Additionally, once they've sync'd and you've `|commit %home`-ed, use `|start %tudumvc` to start the app we've just added. You should see:
```
gall: loading %tudumvc
>   '%tudumvc app is online'
> |start %tudumvc
>=
activated app home/tudumvc
[unlinked from [p=~nus q=%tudumvc]]
```
You've just installed your first %gall app and it's working! Let's check out some of the features:
* It serves a placeholder site at (modify for your ship's URL) [http://localhost:8080/~tudumvc](http://localhost:8080/~tudumvc).
* It has a state of just some [cord (or a UTF-8 string)](https://urbit.org/docs/hoon/reference/stdlib/2q/#cord), which you can view by running `:tudumvc +dbug %state` in dojo.
* It has a poke action called `%add-task` that changes the state, which you can test by running `:tudumvc &tudumvc-action [%add-task 'new task']`.

Over the course of this lesson, you'll see how this %gall app works, update the state to handle the type of data TodoMVC uses, add poke actions to mirror those events that TodoMVC can cause and, lastly, examine the JSON data TodoMVC can send us and begin learning about how to parse that data on the Urbit side.  Let's start with what you already know:

### `/sur/tudumvc.hoon` {#lesson-sur-file}
In the last lesson, you learned that a %gall agent often has pokes that are defined in the `/sur` file associated with that app. Taking a look at `/sur/tudumvc.hoon`, you should see one poke type, `action`, with a sub-type consisting of one tagged-union cell, `%add-task`, that takes a cord and gives that argument a face (variable name) of `task`:
```
+$  action
  $%
  [%add-task task=@tU]
  ==
```
To poke this app, again, you need to:
* Specify the %gall app:
    * `:todomvc`
* Specify the appropraite /mar file:
    * `&tudumvc-action` (which specifies /mar/tudumvc/action.hoon)
    * **NOTE:** You could get away without using /mar files if the expectation was to only ever poke the app with raw nouns
* Specify the appropriate poke, and include that poke's arguments
    * `[%add-task 'an updated task']`

Let's take a look at the /mar file next to see how that works in conjunction with this poke:

### `/mar/tudumvc/action.hoon` {#lesson-mar-file}
Our /mar file does a few things of import:

It imports the `/sur/tudumvc.hoon` file to make available the mold called action from that file:
```hoon
/-  tudumvc
```

It imports and reveals dejs:format from [zuse.hoon](https://github.com/urbit/urbit/blob/a87562c7a546c2fdf4e5c7f2a0a4655fef991763/pkg/arvo/sys/zuse.hoon#L3317) which will help us "de-JSON-ify" incoming JSON data:
```hoon
=,  dejs:format
```

It creates a [door](https://urbit.org/docs/glossary/door/) that has an implicit sample of an action from /sur/tudumvc.hoon: 
```hoon
|_  act=action:firststep
```

Then, the /mar file's door has a `+grab` arm which helps us shove incoming data into an acceptable type. Any general noun coming in (like, what you might send through the dojo) will be cast as an action as defined in our /sur/tudumvc.hoon file (`+noun`). Incoming JSON, however, will be parsed using the gate in the `+json` arm. 
```hoon
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
```
This guide will cover how JSON parsing works later. For now, you only need to know that this, upon receiving _any_ JSON, is going to print the JSON in a Hoon type in our dojo and then change our app's state to 'We did it, reddit!' using a poke of our `action` poke type.

Now, some new material:

### /app/tudumvc.hoon {#lesson-app-file}
While %gall agents can use files from across the filesystem of your urbit (some use /lib and /gen files, etc), and while some %gall agents require nothing more than the /app file to function, the most common pattern you'll see is an /app, a /mar and a /sur file working in conjunction to provide the basic service, data type interpretation, and interaction models (respectively).

Again, the /sur file defines structures or types for our application and the /mar file defines methods for converting various types of input our application might receive into types it expects (like those defined in /sur).

The /app file is the meat of the %gall agent, and it has a strict structure you'll see in almost all %gall apps:

#### Importing Files
They almost always start with importing some /sur (`/-`) and /lib (`/+`) files:
```hoon
/-  tudumvc
/+  *server, default-agent, dbug
```
#### Defining State
They then always define some app state (or several states, if the app has been upgraded - you'll learn about this later) in a core:
```hoon
|%
+$  versioned-state
    $%  state-zero
    ==
+$  state-zero
    $:  [%0 task=@tU]
    ==
+$  card  card:agent:gall
--
```

  * **NOTE:** In plainest English, cards are instructions/request sent to some vane - think of these as the bag at a Which 'Wich sandwich shop, where you pick your ingredients and give them to an employee who then executes the instructions.
  * **NOTE:** `versioned-state` is a type defined by a series of tagged unions where the head of a cell is a tag that identifies the type (sort of like a poke). Currently, this app only has one state (`state-zero`) that is tagged by its head atom of `%0`.  Other apps will have multiple states, almost always tagged with incrementing integers (e.g. `%0`, `%1`, and so on).
  * **NOTE** `%0` and `%1` as the head aren't actually functional in showing the progression of state - these are arbitrary. The current version of the state is prescribed directly above the casting of `^-  agent:gall` with `=| state-<whatever>`.
  * **NOTE:** `state-zero` could be written (and will, in fact, later in this guide be re-written) as follows, but you may see states in other applications defined in the format above:
```hoon
+$  state-zero  [%0 task=@tU]
```

#### Forming a Gall Agent
They will then always cast the result of the rest of the code as a `agent:gall`, which will always be either a door or a door and a helper door created using [`=<`](https://urbit.org/docs/reference/hoon-expressions/rune/tis/#tisgal) (compose two expressions, inverted - i.e. the main core of our %gall agent will be up top, and the helper core underneath, but the helper core will be computed and stored in memory first such that it can be accessed and used by the main core). For reference, a door is just a core with an implicit sample, which, in this case, is always a `bowl:gall`.
```hoon
^-  agent:gall
|_  =bowl:gall
```
  * **NOTE:** an `agent:gall` is defined in [lull.hoon](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1656) also and is, roughly, a door ([`form:agent:gall`](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1684)) with 10 arms with some other type definitions included (`step`, `card`, `note`, `task`, `gift`, `sign`).
  * **NOTE:** a [`bowl:gall`](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1623) is just a series of things that will be available to _every_ %gall agent, including `our` (the host ship), `now` (the current time), `dap` (the name of our app, as a `term` (`@tas`) - this will be used to start the app), and several other items.

#### Creating Aliases
They will often proceed with a series of aliases using [`+*`](https://urbit.org/docs/reference/hoon-expressions/rune/lus/#lustar):
```hoon
+*  this  .
    def   ~(. (default-agent this %|) bowl)
 ```
_this_ refers to the whole, primary door of our agent. If you need to refer to our agent's main door, you can use _this_.

In the [breakout lesson on the `(quip card _this)`](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md) we discussed using '\_this' to mean "something in the form of _this_." Now you should see that _this_ is just the agent itself. When the arms of our agent cast their output using `^-  (quip card _this)`, the expectation is that they will return a list of cards, or actions, and the structure of the app again (potentially with state changes).

The `def` shorthand works similarly to `this`, letting us refer to our agent wrapped in the `default-agent` /lib which basically just gives us the ability to create default behaviors for some of the arms of our door that are not currently in use (see `+on-arvo` in our code, for instance).

#### 10 Functional Arms {#lesson-app-file-gall-arms}
Internal to an agent's main door, there will _always_ be **10 arms** (unless it's a `%shoe` agent (a CLI supporting agent), but this case should be considered separately - also some of the 10 expected arms may be defined as cores with sub-arms to do additional work, and some may reach out to our helper core's arms to do additional work). The 10 arms of %gall are exquisitely covered in [~timluc-miptev's Gall Guide](https://github.com/timlucmiptev/gall-guide/blob/master/arms), but we'll review a few of them below:
```hoon
++  on-init
++  on-save
++  on-load
++  on-poke
++  on-arvo
++  on-watch
++  on-leave
++  on-peek
++  on-agent
++  on-fail
```

Your current version of `%tudumvc` only uses 5 out of the _10_ available arms. Let's take a look at those:

##### `++  on-init`
```hoon
^-  (quip card _this)
~&  >  '%tudumvc app is online'
=/  tudumvc-serve  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
=.  state  [%0 'example task']
:_  this
:~  [%pass /srv %agent [our.bowl %file-server] %poke todomvc-serve]
==
```
`+on-init` is run _only once_, at first launch of the application (which you did when you ran `|start %tudumvc` in the dojo). `+on-init` produces a `(quip card _this)`. In this case, you are producing a single card and a mold of the type of our agent.

Specifically, your card here `%pass`es a `%poke` to the `%file-server` app which strongly resembles the poke you made in dojo in the last lesson to serve files. The only real difference here is that part of the poke has been assigned a face (`tudumvc-serve`) and defined above the actual structure of the card which is just a convention used to make the card's code shorter:
```hoon
=/  tudumvc-serve  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
<...>
:~  [%pass /srv %agent [our.bowl %file-server] %poke todomvc-serve]
==
```
Compare this to `:file-server &file-server-action [%serve-dir /'~tudumvc' /app/tudumvc %.n %.n]` which would have been the dojo poke.

Also, note that the line `=.  state  [%0 'example task']` sets the starting state of the app, on first load, to a cell of `[%0 task='example task']`.

Each arm of an agent that produces a `(quip card _this)` (many of them) will return a list of actions (cards) to perform/request, and a version of the agent, potentially with a changed state. This is really useful for a deterministic computer. You can use the arms of our agent to say "on this event, request these actions of other vanes (or other agents by requesting an action through %gall) and also update our state to indicate these changes." Further, you can use the `+on-arvo` arm to say "in the event of receiving these cards from other vanes, take these actions and update the state in these ways." Finally, `+on-agent` does the same things as the above, but for other agents `%give`ing instructions. It makes interaction really, really easy and unified throughout the vane/agent complex of our urbit!

##### `++  on-save`
```hoon
^-  vase 
!>(state)
```
`+on-save` is run every time the agent shuts down or is upgraded. It produces a [vase](https://urbit.org/docs/reference/library/4o/#vase) which is a noun wrapped in its type (as a cell). For instance `[#t/@ud q=1]` would be the vase produced by `!>(1)`. [`!>`](https://urbit.org/docs/hoon/reference/rune/zap/#zapgar) wraps a noun in its type. 

As an aside, you can use what's called a type spear to identify the type of some noun `-:!>(my-noun)` like that (it's called a type spear because it looks like a cute lil' spear).

In our express example, `+on-save` produces the current state of the application wrapped in the type of the state (version). In other words, `+on-save` _saves_ your agent and state for use in:

##### `++  on-load`
```hoon
|=  incoming-state=vase
^-  (quip card _this)
~&  >  '%tudumvc has recompiled'
`this(state !<(versioned-state incoming-state))
```
`+on-load` is run on startup of our agent (on re-load). It, as with `+on-init`, produces a `(quip card _this)` - a list of cards to be sent to the vanes/agents of our urbit and a %gall agent in the structure of our current agent (potentially with changed state). It takes, as an argument, the `incoming-state` vase, which will be the version of the state saved on last close (from `+on-save`). This `+on-load` section of our current app basically does nothing (it simply returns what it was given, unpacked using [!<](https://urbit.org/docs/hoon/reference/rune/zap/#zapgal)). Later, you'll see how it can be used to _upgrade the state between versions of the agent's development_.

##### `++  on-poke`
```hoon
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
`+on-poke` is the most involved portion of our code (so far). It returns a `(quip card _this)`, but in contrast to `+on-load`, this arm takes both a mark and a vase as the sample. The mark vase argument combo should be mildly familiar, as you've taken advantage of this already to poke our app. In the dojo, pokes are communicated using the following format: `:app-name &app-mark-file [%sur-action noun]` - in this case, `:tudumvc &tudumvc-action [%add-task 'new value']`. The cask (mark vase combo), then, is `[%tudumvc-action [%add-task 'new value']]`.

Note the use of [`|^` barket](https://urbit.org/docs/hoon/reference/rune/bar/#barket) in conjunction with [`=^` tisket](https://urbit.org/docs/hoon/reference/rune/tis/#tisket) to create a sub-arm, `+poke-actions` within the `+on-poke` arm to handle all of our expected incoming pokes.

The role of `=^` is critical but also complicated. All you really need to know is that it is a terse way of producting card and state changes from non-in-line hoons (it uses other arms so the code doesn't get wide). If you want to know more about how `=^` works, you can check out this [breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/tisket.md).

##### `++  on-peek`
```hoon
|=  =path
^-  (unit (unit cage))
?+  path  (on-peek:def path)
  [%x %task ~]  ``noun+!>(task)
==
```
`+on-peek` is where scrying is managed. All programs in Urbit can be treated as data, as can (naturally) all data. The effect of this is that everything, including the internal state of a program or app, can be seen as part of the file system. scrying is just the method of using the filesystem to tell us about the state of a program. And here, you must make a choice:
* Take the red pill and [learn how scrying works](@/docs/userspace/tudumvc/breakout-lessons/a-brief-primer-on-clay.md).
* Take the blue pill and only learn `+dbug` (continue reading).

Both of these functions allow us to see in to the state of our app. 
* scrying relies on the `+on-peek` functionality to tell it how to return data, and our specific scry can be completed in dojo like this - `.^(@tU %gx /=tudumvc=/task/noun)` (if you didn't read the breakout above, just try it and nod knowingly).
* `+dbug` relies on the use of the dbug library that is imported at the beginning of the /app/tudumvc.hoon file (`/+  *server, default-agent, dbug`), and can be completed in dojo like this - `:tudumvc +dbug %state`.

That's about it then for the /app, /mar, and /sur files, and the `%tudumvc` app generally.  Let's finish with a discussion of the changes made to the TodoMVC Earth web app.

### TodoMVC Earth App {#lesson-todomvc}
I've set up a modified copy of TodoMVC for you in the [/src-lesson3 folder](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson3/react-hooks). The current TodoMVC app is not ready to be minified, as there's still more work to do, which is why our /app/tudumvc folder has a placeholder index.html file that the agent is serving with the `%file-server` poke sent in `+on-init`. Nonetheless, remember that you can run the non-minified version using `yarn run dev`.

This version of the TodoMVC app has been updated to communicate with your Urbit. You may need to do some additional customization, but we'll point this out to you when we get there.

#### Preliminary Setup
The setup process mirrors the setup you went through earlier to `run dev` the app, but with a few changes:
* Confirm you're on a recent version of Node.js (v14.16.1 at the time of writing):
    * `yarn add n`
    * `n stable`
* Add the Urbit API package:
    * `yarn add @urbit/http-api`
* `yarn install`

With that, you're ready to make the following changes/additions:

#### Create `useApi.js` Hook
Note - your setup may vary from mine, so you'll need to change the object elements 'ship', 'url' and 'code' as are appropriate for your setup. Remember that you can get your code from your ship at any time by running `+code` in the dojo.
```
import Urbit from "@urbit/http-api";
import { memoize } from 'lodash';

const useApi = memoize(async () => {
    const urb = await Urbit.authenticate({ ship: 'nus', url: 'localhost:8080', code: 'bortem-pinwyl-macnyx-topdeg', verbose: true});
    return urb;
});

export default useApi;
```
Urbit has a pre-built JavaScript package called airlock. airlock has several super-helpful methods, including `authenticate`, `poke` and `subscribe`.
* `authenticate` uses the same login functionality as seen in Landscape (using the `+code`, generated from the dojo).
* `poke` sends a poke in JSON to a specified app, of a specified mark and vase.
* `subscribe` opens up a path on which our Urbit can communicate data to the Earth app, and on which our Earth app listens.

The useApi.js hook is grabbing an API token using `authenticate` and exporting the resulting token (`urb`) that will inform our use of the other two methods, later.
* **NOTE:** This description of how this works is generalized and targeted towards this specific project - if you want to know more ways you can work with airlock works, we recommend checking out [~witfyl-ravped's Urbit React Cookbook](https://github.com/witfyl-ravped/urbit-react-cookbook).

#### Change `index.js`
```
// We're adding airlock's useApi functionality here:
import useApi from "@/docs/userspace/tudumvc/hooks/useApi";

const root = document.getElementById("root");

(async () => {
    const api = await useApi();
    ReactDOM.render(<App api={api} />, root);
})();
```
In `index.js`, import `useApi` from the `/hooks` folder, and then make the `ReactDOM.render` method asynchronous, and pass the `api` to `App.js`.

`React.DOM` will be asynchronous so that it await the completion of the promise generated by `useApi`. This ensures that the Earth app is logged in to your Urbit before rendering the DOM.

#### Change `App.js`
```
export default function App(props) {
  const {api} = props;
  return (
    <HashRouter>
      <React.Fragment>
        <div className="todoapp">
        <Route key="my-route" path="/:filter?" render={(props) => {
            return <TodoList api={api} {...props} />
```
In `App.js`, modify the default function to accept the `props` passed by `index.js`. Then, unpack the `props` into the `{api}` object and return `TodoList.js` as a function of having passed `props` to it. This, again, passes the `poke` and `subscribe` methods over to the TodoList container. And remember, it's already authenticated as a result of making `index.js` asynchronous.

#### Change `TodoList.js`
```
export default function TodoList(props) {
  const router = useRouter();

  const [todos, { addTodo, deleteTodo, setDone }] = useTodos();

  const urb = props.api;

  const poker = () => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': 'from Earth to Mars'}});
  };
<... following line is line 121>
          <li>
            <button className="clear-completed" onClick={poker}>
              Test Button
            </button>
          </li>
```
Here's where some real work gets done. `TodoList.js` is now modified to take the `props` passed to it, and `urb` is defined as the `api` attribute of `props`. We can then create a function called `poker` that forms a poke that should be familiar to us. The function `poker`, seen here...
```
  const poker = () => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': 'from Earth to Mars'}});
  };
```
...should remind us of the dojo poke used earlier in this guide (`:tudumvc &tudumvc-action [%add-task 'from Earth to Mars']`, or similar). And that's because it is - the only difference here is that our actual vase (the `action` typed, or `[%add-task 'task']`, part) is a JSON object now.

Also, a taskbar button has been added to the app. It triggers the `poker` function, written above.

Access landscape for your fake ship (possibly at [https://localhost:8080/](https://localhost:8080/) or wherever you expect it to be) and log in using the code you get from running `+code` in your fake ship's dojo.

Next, start the modified Earth web app using `yarn run dev`. Open the console once it's loaded in the browser. You're almost certainly seeing the following error:
```
Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at http://localhost:8080/~/channel/1614149322-3066e9. (Reason: CORS header ‘Access-Control-Allow-Origin’ missing).
```

#### `+cors-registry` and `|cors-approve` {#lesson-cors-registry}
In your dojo, punch in `+cors-registry`. You'll see something like this:
```hoon
> +cors-registry
[ requests={~~http~3a.~2f.~2f.localhost~3a.8080}
  approved={}
  rejected={}
]
```
You're going to have to approve the CORS registration for your Earth app. You can do this with `|cors-approve ~~http~3a.~2f.~2f.localhost~3a.8080` (replace the address with what ever request you see in your dojo on the prior step). Refresh the page.

Now you'll see some new messages in the console, importantly:
```
Received authentication response 
Response { type: "cors", url: "http://localhost:8080/~/login", redirected: false, status: 204, ok: true, statusText: "ok", headers: Headers, body: ReadableStream, bodyUsed: false }
index.js:165
```
You'll also see `< ~nus: opening airlock` in the dojo.

You're now logged in - your Earth web app is connected to our urbit. Push the "Test Button" and let's take a look at what can be sent from Earth to Mars.

#### Looking at the JSON poke
```hoon
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='from Earth to Mars']]}]"
```
This printout highlights the JSON that you received from the "Test Button". If you check the state now (using scrying or `+dbug`, like `:tudumvc +dbug %state`), you'll see that your state's `task` value is now `[%0 task='We did it, reddit!']`. 

We should note that it is sorta weird that our JSON doesn't equal our state value here. Remember that, above, we set up the mar file to simply output the incoming JSON in the dojo and provide a completely separate and distinct poke `action` type to our agent. In the next part of this guide, you'll work on JSON parsing and get it set up to rightly interpret the incoming data from the Earth web app.

The next few parts of this guide finish the conversion of TodoMVC into `%tudumvc` and demonstrate how to interpret JSON into pokes an urbit can actually understand. It will also cover also updating an app's state and available poke `action`s.

## Homework {#homework}
* Read this [airlock reference doc](https://urbit.org/docs/reference/vane-apis/airlock/).
* Check out the state of `%picky` defined [here](https://github.com/timlucmiptev/gall-guide/blob/c95140b2c3c62e45c346a25efe027d55dfdd5bd6/example-code/app/picky-backend.hoon#L7), as well as the [`+on-load`](https://github.com/timlucmiptev/gall-guide/blob/master/example-code/app/picky-backend.hoon#L40) arm.

## Exercises {#exercises}
* Attempt to upgrade our `%gall` agent's state to a `(map id=@ud [label=@tU done=?])`.
    * You'll need to change (1) the state definition, (2) `+on-init`, (3) `+on-load`. 
* Attempt to add a different poke action to our `%gall` app that modifies the state (either the existing state or the one you produced in the above exercise, if you were successful).
**NOTE:** Do not worry about failing at either of these exercises - you will go through guided versions of these activities in upcoming parts of this guide, but it would be good for you to try, first. You can even cheat at look at [/src-lesson4](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson4)'s code - so long as you can comment it and explain what it does as you do the upgrade.

## Summary and Addenda {#summary}
You're almost done with basic integration and, hopefully, you've found the experience so far relatively painless. You might want to take the time now to review `=^` and how it works, in our breakout lesson:
* [`=^`](@/docs/userspace/tudumvc/breakout-lessons/tisket.md)

That's generally optional, though if you go on to develop your own apps, you'll probably want a firmer understanding. Nonetheless, at this point you should:
* Know the basic, 10 arm structure of a `%gall` agent.
* Know where state is defined in an agent.
* Be able to query the current state of an agent, either through `+dbug` or a scry.
* Generally describe the use of `=^`.
* Know what airlock is, and how it's been implemented here.
* Know what JSON looks like when displayed in Urbit.