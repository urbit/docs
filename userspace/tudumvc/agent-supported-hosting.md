+++
title = "%gall and %file-server"
weight = 5
template = "doc.html"
+++

## Introduction {#introduction}
We've hosted the basic Earth app using `%file-server` from Urbit. Our next step in development will be to create a %gall agent to support hosting the app and, eventually, acting as a back-end for the app's data. We call this agent `%tudumvc` because it's TodoMVC but on Urbit so it needs to have a funny name.

## Required Files {#required-files}
* The /src-lesson3/react-hooks folder copied to your local environment.
* The /src-lesson3/app /mar/tudumvc and /sur files copied into the respectively similar versions on an Urbit running on your local environment (using the sync functionality).

## Learning Checklist {#learning-checklist}
* What basic structure all %gall agents share.
* Where state is defined in an agent.
* What `+dbug` does.
* What a scry is.
* What `=^` (tisket) does.
* What airlock is and how, generally, it works.
* How incoming JSON is represented on Urbit.

## Goals {#goals}
* Install a %gall agent.
* Examine the structure of %gall agents.
* Scry the %gall agent's state.
* Use `+dbug` to examine our state.
* Link the Earth web app with an Urbit.
* Have an Urbit print out JSON coming from the Earth web app.

## Prerequisites {#prerequisites}
* A new Fake Ship (technically, one could complete this on the same ship as the last part of this tutorial, but we're going to work from a clean slate)
* The [Chapter 3 files](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson3).
  * **NOTE:** The `/src-lesson3/react-hooks` folder packaged for this chapter has been pre-modified.
  * We will go over these modifications and off-screen changes.

## Chapter Text {#chapter-text}
%gall agents are rigorously structured and follow a relatively consistent pattern. Prospective hooners can use this structure to their advantage by taking the bones of an existing %gall agent and converting it to their needs. One might start with a very basic app like [~timluc-miptev's `%skeleton` app, found here](https://github.com/timlucmiptev/gall-guide/blob/master/example-code/app/skeleton.hoon). We've created a very basic version of `%tudumvc` that can act as a skeleton for further development and added it to the repository for this chapter. Installing our basic app will require the following steps:
* Sync the folders/files from /src-lesson3/app to Urbit's /home/app folder.
* Sync the file from /src-lesson3/mar to Urbit's /home/mar folder.
* Sync the file from /src-lesson3/sur to Urbit's /home/sur folder.
* Commit the changes using `|commit %home` in dojo.
* Start the app using `|start %tudumvc` in dojo.

We'll examine these files in detail below. Once they're sync'ed, committed and started, the Urbit should produce:
```
gall: loading %tudumvc
>   '%tudumvc app is online'
> |start %tudumvc
>=
activated app home/tudumvc
[unlinked from [p=~nus q=%tudumvc]]
```

This very basic implementation of `%tudumvc` has the following features:
* It serves a placeholder site at [http://localhost:8080/~tudumvc](http://localhost:8080/~tudumvc).
* It has a state of just some [cord (or a UTF-8 string)](https://urbit.org/docs/hoon/reference/stdlib/2q/#cord), which can be viewed by running `:tudumvc +dbug %state` in dojo.
* It has a poke action called `%add-task` that changes the state, which can be used by running `:tudumvc &tudumvc-action [%add-task 'new task']` in dojo.

This chapter will cover the following items:
* The structure of %gall agents.
* The use of `airlock` to connect a JavaScript Earth app to an Urbit.
* The use of pokes to mirror Earth app-side events.
* The structure of JSON when interpreted by an Urbit.

In the last chapter, we examined the /sur file for `%file-server`. With that in mind, the /sur file for `%tudumvc` will be fairly familiar:

### `/sur/tudumvc.hoon` {#lesson-sur-file}
%gall agents often have pokes that are defined in a /sur file. `/sur/tudumvc.hoon` contains one such defined structure, `action`, with a sub-type consisting of one tagged-union cell, `%add-task`, that takes a cord and gives that argument a face (variable name) of `task`:
```
+$  action
  $%
  [%add-task task=@tU]
  ==
```
Poking this app would consist of entering the following in dojo:
* Specify the %gall app:
    * `:tudumvc`
* Specify the appropraite /mar file:
    * `&tudumvc-action` (which specifies `/mar/tudumvc/action.hoon`)
* Specify the appropriate poke, and include that poke's arguments
    * `[%add-task 'an updated task']`
* In total, this:
    * `:tudumvc &tudumvc-action [%add-task 'an updated task']`

The `/mar/tudumvc/action.hoon` file works in conjunction with this poke:

### `/mar/tudumvc/action.hoon` {#mar-file}
The /mar file does a few things of import:

It imports the `/sur/tudumvc.hoon` file to make available the mold called action from that file:
```hoon
/-  tudumvc
```

It imports and reveals `+dejs:format` from [zuse.hoon](https://github.com/urbit/urbit/blob/a87562c7a546c2fdf4e5c7f2a0a4655fef991763/pkg/arvo/sys/zuse.hoon#L3317) (**note:** `+arm-name:core` is shorthand for `++  dejs` from the `++  core` specified) which is used to "de-JSON-ify" incoming JSON data:
```hoon
=,  dejs:format
```

It creates a [door](https://urbit.org/docs/glossary/door/) that has an implicit sample of an action from `/sur/tudumvc.hoon`:
```hoon
|_  act=action:firststep
```

The /mar file's door has a `+grab` arm which helps us shove incoming data into an acceptable type. Any general noun coming in will be cast as an action as defined in `/sur/tudumvc.hoon` file (`+noun`). Incoming JSON, however, will be parsed using the gate in the `+json` arm.
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
This tutorial will cover how JSON parsing works later. For now, you only need to know that this, upon receiving _any_ JSON, is going to print the JSON in a Hoon type in our dojo and then change our app's state to 'We did it, reddit!' using a poke of our `action` poke type.

Lastly, `/mar/tudumvc/action.hoon` includes a `+grad` arm which [takes two instances of a mark and produces a diff of them](https://urbit.org/docs/arvo/clay/architecture/#marks). This functionality is outside the scope of the current tutorial, but is covered elsewhere. `/mar/tudumvc/action.hoon` takes the easy way out and offloads the `+grad` arm logic to another mark file (namely, noun).

Now, some new material:

### `/app/tudumvc.hoon` {#app-file}
While %gall agents can use files from across the filesystem of your urbit (some use /lib and /gen files, etc), and while some %gall agents require nothing more than the /app file to function, a very common pattern is to have an /app, a /mar and a /sur file working in conjunction to provide the basic service, data type interpretation, and interaction models (respectively).

The /sur file defines structures or types for the agent and the /mar file defines methods for converting various types of input the agent might receive into types it expects (like those defined in /sur).

The /app file is the meat of the %gall agent, and it has a strict structure, seen in ([almost, and even this almost requires a caveat of "there are stil 10 arms but it won't look like it"](@/docs/hoon/guides/cli-tutorial.md)) all %gall apps:

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
  * **NOTE:** `versioned-state` is a type defined by a series of tagged unions where the head of a cell is a tag that identifies the type (sort of like a poke). Currently, this app only has one state (`state-zero`) that is tagged by its head atom of `%0`. Other apps will have multiple states, almost always tagged with incrementing integers (e.g. `%0`, `%1`, and so on).
  * **NOTE** `%0` and `%1` as the head aren't actually functional in showing the progression of state - these are arbitrary. The current version of the state is prescribed directly above the casting of `^-  agent:gall` with `=| state-<whatever>`.
  * **NOTE:** `state-zero` could be written (and will, in fact, later in this tutorial be re-written) as follows, but you may see states in other applications defined in the format above:
```hoon
+$  state-zero  [%0 task=@tU]
```

#### Forming a Gall Agent
They will then always cast the result of the rest of the code as a `agent:gall`, which will always be either a door or a door and a helper door created using [`=<`](https://urbit.org/docs/reference/hoon-expressions/rune/tis/#tisgal) (compose two expressions, inverted - i.e. the main core of the %gall agent will be up top, and the helper core underneath, but the helper core will be computed and stored in memory first such that it can be accessed and used by the main core). For reference, a door is just a core with an implicit sample, which, in this case, is always a `bowl:gall`.
```hoon
^-  agent:gall
|_  =bowl:gall
```
  * **NOTE:** an `agent:gall` is defined in [lull.hoon](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1656) also and is, roughly, a door ([`form:agent:gall`](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1684)) with 10 arms with some other type definitions included (`step`, `card`, `note`, `task`, `gift`, `sign`).
  * **NOTE:** a [`bowl:gall`](https://github.com/urbit/urbit/blob/0f069a08e83dd0bcb2eea2e91ed611f0074ecbf8/pkg/arvo/sys/lull.hoon#L1623) is just a series of things that will be available to _every_ %gall agent, including `our` (the host ship), `now` (the current time), `dap` (the name of the app, as a `term` (`@tas`) - this will be used to start the app), and several other items.

#### Creating Aliases
They will often proceed with a series of aliases using [`+*`](https://urbit.org/docs/reference/hoon-expressions/rune/lus/#lustar):
```hoon
+*  this  .
    def   ~(. (default-agent this %|) bowl)
 ```
_this_ refers to the whole, primary door of the agent. If you need to refer to the agent's main door, you can use _this_.

In the [breakout lesson on the `(quip card _this)`](@/docs/userspace/tudumvc/breakout-lessons/quip-card-and-poke.md) we discussed using '\_this' to mean "something in the form of _this_." _this_ is just the agent itself. When the arms of the agent cast their output using `^-  (quip card _this)`, the expectation is that they will return a list of cards, or actions, and the structure of the app again (potentially with state changes).

The `def` shorthand works similarly to `this`, letting code refer to the agent wrapped in the `default-agent` /lib which allows for the creation of default behaviors for some of the arms of the door that are not currently in use (see `+on-arvo` in `%tudumvc`'s current code, for instance).

#### 10 Functional Arms {#app-file-gall-arms}
Internal to an agent's main door, there will _always_ be **10 arms** (unless it's a `%shoe` agent (a CLI supporting agent), but this case should be considered separately - also some of the 10 expected arms may be defined as cores with sub-arms to do additional work, and some may reach out to our helper core's arms to do additional work). The expected 10 arms are as follows:
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

The current version of `%tudumvc` only uses 5 out of the _10_ available arms. The 10 arms of %gall are exhaustively (and exquisitely) covered in [~timluc-miptev's Gall Guide](https://github.com/timlucmiptev/gall-guide/blob/master/arms), but this tutorial will review a few of them, below:

##### `+on-init`
```hoon
^-  (quip card _this)
~&  >  '%tudumvc app is online'
=/  tudumvc-serve  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
=.  state  [%0 'example task']
:_  this
:~  [%pass /srv %agent [our.bowl %file-server] %poke todomvc-serve]
==
```
`+on-init` is run _only once_, at first launch of the application (i.e., on running `|start %tudumvc` in the dojo). `+on-init` produces a `(quip card _this)`. In this case, `%tudumvc` produces a single card and a mold of the type of our agent.

Specifically, the card here `%pass`es a `%poke` to the `%file-server` app which strongly resembles the poke made in dojo in the last chapter (to `%file-server`, as well) to serve files. The only real difference here is that part of the poke has been assigned a face (`tudumvc-serve`) and defined above the actual structure of the card which is just a convention used to make the card's code shorter:
```hoon
=/  tudumvc-serve  [%file-server-action !>([%serve-dir /'~tudumvc' /app/tudumvc %.n %.n])]
<...>
:~  [%pass /srv %agent [our.bowl %file-server] %poke todomvc-serve]
==
```
Compare this to `:file-server &file-server-action [%serve-dir /'~tudumvc' /app/tudumvc %.n %.n]` which would have been the dojo poke.

Also, note that the line `=.  state  [%0 'example task']` sets the starting state of the app, on first load, to a cell of `[%0 task='example task']`.

Each arm of an agent that produces a `(quip card _this)` (many of them) will return a list of actions (cards) to perform/request, and a version of the agent, potentially with a changed state. This is really useful for a deterministic computer. With this, the arms of the agent can be used to say "on this event, request these actions of other vanes (or other agents by requesting an action through %gall) and also update the state to indicate these changes." Further, the `+on-arvo` arm can be used to say "in the event of receiving these cards from other vanes, take these actions and update the state in these ways." Finally, `+on-agent` does the same things as the above, but for other agents `%give`ing instructions. It makes interaction really easy and unified (in form) throughout the vane/agent complex on Urbit!

##### `+on-save`
```hoon
^-  vase 
!>(state)
```
`+on-save` is run every time the agent shuts down or is upgraded. It produces a [vase](https://urbit.org/docs/reference/library/4o/#vase) which is a noun wrapped in its type (as a cell). For instance `[#t/@ud q=1]` would be the vase produced by `!>(1)`. [`!>`](https://urbit.org/docs/hoon/reference/rune/zap/#zapgar) wraps a noun in its type. 

As an aside, you can use what's called a type spear to identify the type of some noun `-:!>(my-noun)` like that (it's called a type spear because it looks like a cute lil' spear).

In `%tudumvc`, `+on-save` produces the current state of the application wrapped in the type of the state (version). In other words, `+on-save` _saves_ the agent and state for use in:

##### `+on-load`
```hoon
|=  incoming-state=vase
^-  (quip card _this)
~&  >  '%tudumvc has recompiled'
`this(state !<(versioned-state incoming-state))
```
`+on-load` is run on startup of an agent (on re-load or upgrade). It, as with `+on-init`, produces a `(quip card _this)` - a list of cards to be sent to the vanes/agents of an urbit and a %gall agent in the structure of the current agent (potentially with changed state). It takes, as an argument, the `incoming-state` vase, which will be the version of the state saved on last close (from `+on-save`). This `+on-load` section of `%tudumvc` basically does nothing (it simply returns what it was given, unpacked using [!<](https://urbit.org/docs/hoon/reference/rune/zap/#zapgal)). In a later chapter, we will use `+on-load` to _upgrade the state between versions of the agent's development_.

##### `+on-poke`
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
`+on-poke` is the most involved portion of `%tudumvc`'s code (so far). It returns a `(quip card _this)`, but in contrast to `+on-load`, this arm takes both a mark and a vase as the sample. The mark vase argument combo should be mildly familiar, as this tutorial has already taken advantage of this arm to poke `%file-server` app. In the dojo, pokes are communicated using the following format: `:app-name &app-mark-file [%sur-action noun]` - in this case, `:tudumvc &tudumvc-action [%add-task 'new value']`. The cask (mark vase combo), then, is `[%tudumvc-action [%add-task 'new value']]`.

Note the use of [`|^` barket](https://urbit.org/docs/hoon/reference/rune/bar/#barket) in conjunction with [`=^` tisket](https://urbit.org/docs/hoon/reference/rune/tis/#tisket) to create a sub-arm, `+poke-actions` within the `+on-poke` arm to handle all of the expected incoming pokes.

The role of `=^` is critical but also complicated. All you really need to know is that it is a terse way of producting card and state changes from non-in-line hoons (it uses other arms so the code doesn't get wide). If you want to know more about how `=^` works, you can check out this [breakout lesson](@/docs/userspace/tudumvc/breakout-lessons/tisket.md).

##### `+on-peek`
```hoon
|=  =path
^-  (unit (unit cage))
?+  path  (on-peek:def path)
  [%x %task ~]  ``noun+!>(task)
==
```
`+on-peek` is where scrying is managed. All programs in Urbit can be treated as data, as can (naturally) all data. The effect of this is that everything, including the internal state of a program or app, can be seen as part of the file system. scrying is just a method for examining some part of the filesystem - here, the state of a program. And here, you must make a choice:
* Take the red pill and [learn how scrying works](@/docs/userspace/tudumvc/breakout-lessons/a-brief-primer-on-clay.md).
* Take the blue pill and only learn `+dbug` (continue reading).

Both of these functions peer into the state of the app. 
* scrying relies on the `+on-peek` functionality to tell it how to return data; the specific scry can be completed in dojo like this - `.^(@tU %gx /=tudumvc=/task/noun)` (if you didn't read the breakout above, just try it and nod knowingly).
* `+dbug` relies on the use of the dbug library that is imported at the beginning of the /app/tudumvc.hoon file (`/+  *server, default-agent, dbug`), and can be completed in dojo like this - `:tudumvc +dbug %state`.

That's about it then for the /app, /mar, and /sur files, and the `%tudumvc` app generally. Let's finish with a discussion of the changes made to the TodoMVC Earth web app.

### TodoMVC Earth App {#todomvc}
I've set up a modified copy of TodoMVC for you in the [/src-lesson3 folder](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson3/react-hooks). The current TodoMVC app is not ready to be minified, as there's still more work to do, which is why the `/app/tudumvc` folder has a placeholder index.html file that the agent is serving with the `%file-server` poke sent in `+on-init`.

The version of the TodoMVC app included in the source files for this chapter has been updated to communicate with a Fake Ship (`~nus`) found at `localhost:8080`. If you're following along, and want this to work for you (and have a different configuration than the aformentioned, you may need to do some additional customization, but we'll point this out to you when we get there.

#### Preliminary Setup
The app is largely the same as it was in the prior chapter, but it has a new package added. The Urbit API package has been added using `yarn add @urbit/http-api`.

Additionally, some of the code has been changed to utilize the functionality of the Urbit API package:

#### Creating the `useApi.js` Hook
If you're following along, your setup may vary, so you'll need to change the object elements 'ship', 'url' and 'code' as are appropriate for your setup. Remember that you can get your code from your ship at any time by running `+code` in the dojo.
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

The `useApi.js` hook is grabbing an API token using `authenticate` and exporting the resulting token (`urb`) that will inform our use of the other two methods, later.
* **NOTE:** This description of how this works is generalized and targeted towards this specific project - if you want to know more ways you can work with airlock works, we recommend checking out [~witfyl-ravped's Urbit React Cookbook](https://github.com/witfyl-ravped/urbit-react-cookbook).

#### Changes to `index.js`
```
// We're adding airlock's useApi functionality here:
import useApi from "@/docs/userspace/tudumvc/hooks/useApi";

const root = document.getElementById("root");

(async () => {
    const api = await useApi();
    ReactDOM.render(<App api={api} />, root);
})();
```
In `index.js`, `useApi` is imported from the `/hooks` folder, and the `ReactDOM.render` method is made asynchronous, and `App.js` is passed the `api`.

`React.DOM` will be asynchronous so that it awaits the completion of the promise generated by `useApi`. This ensures that the Earth app is logged in to Urbit before rendering the DOM.

#### Changes to `App.js`
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
In `App.js`, the default function was modified to accept the `props` passed by `index.js`. Then, `props` is unpacked into the `{api}` object and `TodoList.js` is returned as a function with `props` being passed to it. This, again, passes the `poke` and `subscribe` methods over to the TodoList container. And remember, it's already authenticated as a result of making `index.js` asynchronous.

#### Changes to `TodoList.js`
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
Here's where some real work gets done. `TodoList.js` is now modified to take the `props` passed to it, and `urb` is defined as the `api` attribute of `props`. A function called `poker` is added that forms a poke that should be familiar. The function `poker`, seen here...
```
  const poker = () => {
    urb.poke({app: 'tudumvc', mark: 'tudumvc-action', json: {'add-task': 'from Earth to Mars'}});
  };
```
...should appear similar to the dojo poke used earlier in this tutorial (`:tudumvc &tudumvc-action [%add-task 'from Earth to Mars']`, or similar). The only difference here is that the vase (the `action` type, or `[%add-task 'task']`, part) is a JSON object now.

Also, a taskbar button has been added to the app. It triggers the `poker` function, written above.

All of these changes can be used by first accessing landscape for the fake ship (possibly at [https://localhost:8080/](https://localhost:8080/) or wherever you expect it to be) and logging in using the `+code`.

Once logged in, the modified Earth web app can be started using `yarn run dev`. If you're following along, at this point you should open the console once it's loaded in the browser. You're almost certainly seeing the following error:
```
Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at http://localhost:8080/~/channel/1614149322-3066e9. (Reason: CORS header ‘Access-Control-Allow-Origin’ missing).
```

#### `+cors-registry` and `|cors-approve` {#lesson-cors-registry}
The `+cors-registry` maintains a `set` of URLs attempting to connect to an Urbit. In the dojo, running `+cors-registry` will display something like this:
```hoon
> +cors-registry
[ requests={~~http~3a.~2f.~2f.localhost~3a.8080}
  approved={}
  rejected={}
]
```
To allow a URL to connect to a ship, _i.e._ to enable airlock, the URL must be approved in the CORS registration. This is done with `|cors-approve ~~http~3a.~2f.~2f.localhost~3a.8080` (replacing the address with whatever request one wants to approve). If you're following along, do this and then refresh the page.

With the CORS registration for the Earth app approved, the in-browser console will now show something like this:
```
Received authentication response 
Response { type: "cors", url: "http://localhost:8080/~/login", redirected: false, status: 204, ok: true, statusText: "ok", headers: Headers, body: ReadableStream, bodyUsed: false }
index.js:165
```
The connected Urbit will also print `< ~nus: opening airlock` in the dojo.

The Earth web app is connected to the urbit. If one were to push the "Test Button", some interesting things would happen. We suggest you push that button now.

#### A JSON poke
```hoon
"Your JSON object looks like [%o p=\{[p='add-task' q=[%s p='from Earth to Mars']]}]"
```
The "Test Button" will produce a dojo print as above. The agent's `task` state object (checked using scrying or `+dbug`, like `:tudumvc +dbug %state`), will also be updated to `[%0 task='We did it, reddit!']`. 

We should note that it is sorta weird that our JSON doesn't equal our state value here. Remember that, above, we set up the mar file to simply output the incoming JSON in the dojo and provide a completely separate and distinct poke `action` type to `%tudumvc`. In the next part of this tutorial, we'll work on JSON parsing and get it set up to rightly interpret the incoming data from the Earth web app - here we're just demonstrating the functionality.

## Additional Materials {#additional-materials}
* Read the [airlock reference doc](https://urbit.org/docs/reference/vane-apis/airlock/).
* Check out the state of `%picky` defined [here](https://github.com/timlucmiptev/gall-guide/blob/c95140b2c3c62e45c346a25efe027d55dfdd5bd6/example-code/app/picky-backend.hoon#L7), as well as the [`+on-load`](https://github.com/timlucmiptev/gall-guide/blob/master/example-code/app/picky-backend.hoon#L40) arm.

## Exercises {#exercises}
* Attempt to upgrade `%tudumvc`'s state to a `(map id=@ud [label=@tU done=?])`.
    * You'll need to change (1) the state definition, (2) `+on-init`, (3) `+on-load`. 
* Attempt to add a different poke action to our `%gall` app that modifies the state in some new way (either the existing state or the one you produced in the above exercise, if you were successful).
**NOTE:** Do not worry about failing at either of these exercises - they're covered in upcoming parts of this tutorial, but it would be good for you to try, first. You can even cheat at look at [/src-lesson4](https://github.com/rabsef-bicrym/tudumvc/tree/main/src-lesson4)'s code - but if you do, try to comment it and explain what it does as you do the upgrade.

## Summary and Addenda {#summary}
You might want to take the time now to review `=^` and how it works, in our breakout lesson:
* [`=^`](@/docs/userspace/tudumvc/breakout-lessons/tisket.md)

That's generally optional, though if you go on to develop your own apps, you'll probably want a firmer understanding. Nonetheless, at this point you should:
* Know the basic, 10 arm structure of a `%gall` agent.
* Know where state is defined in an agent.
* Be able to query the current state of an agent, either through `+dbug` or a scry.
* Generally describe the use of `=^`.
* Know what airlock is, and how it's been implemented here.
* Know what JSON looks like when displayed in Urbit.