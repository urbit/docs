+++
title = "2.9.1 Walkthrough: Landscape Tile"
weight = 40
template = "doc.html"
+++

Tiles are one way to build apps in Landscape, the Urbit web interface. This document will guide you through the process of creating a tile using Hoon and some pre-built tools.

> Note that Tiles use the [React](https://reactjs.org/) framework, which will not be covered in this walkthrough; instead of writing the React ourselves, we will use the tools from the repo mentioned above. We encourage you to use react to build a Tile yourself, though.

![](https://media.urbit.org/docs/landscape-tile/default-tiles.png)

## Getting Started

It's recommended to always use this process in this section when creating a tile, even when your knowledge becomes more advanced. It makes development much easier.

First and foremost, you'll need to have a [mounted fakezod](/docs/using/creating-development-ship) of Urbit version 0.8.0 or higher.

Then you'll need to get the pre-built tools that were mentioned. Navigate to  [urbit/create-landscape-app](https://github.com/urbit/create-landscape-app) and click the green `Use this template` button on to copy the repo to your own account. After that, you will need to clone that new repository locally, using either the `git clone <repo-url>` terminal command, or by clicking the `Clone or download` button on the GitHub.
Once you've cloned the repo, `cd` into the newly downloaded folder and run `npm install` to install dependencies. After that, run `npm start` to start the setup wizard.

![](https://media.urbit.org/docs/landscape-tile/npm-setup.png)

The wizard prompts you with three questions.
- For the purposes of this walkthrough, choose `testing` as the name of your file; your answer determines the name of a Hoon file and the name of directory containing the `tile.js` file that the Hoon file references.
- When prompted to choose between a title and a full application, answer `tile`.
- For the final question, simply give the full path to your ship's pier and the desired desk (such as `/home`). This links your ship to this repo.

### Testing the Default App

With the questions answered, you now have two halves of a default app:

- `urbit/app/testing.hoon`, which contains your Hoon code
- `tile/tile.js`, which is the source file React uses to build `urbit/app/testing/js/tile.js`

Let's test that the default app is set up correctly, so that we make an app of our own.

Run `npm run build`. This copies files into the pier that you linked into the `/app` directory of your desk. Your Hoon file will be `/app/testing.hoon`, and your js file will be `/app/testing/js/tile.js`.

![](https://media.urbit.org/docs/landscape-tile/npm-run-build.png)

Starting with Urbit version 0.8.0, files are no longer automatically synced from your Unix pier to your ship, so after running the build command, you'll need to run the `|commit %home` command in your ship's Dojo.

![](https://media.urbit.org/docs/landscape-tile/commithome.png)

Once this is done, you can start the application by running `|start %testing` in your ship's Dojo. Then navigate to  `http://localhost:80` (or the appropriate port), and log in with the password you get from running `+code` in the Dojo. Then you should see where you should see your new tile.

Any time you make changes to the Hoon file or the js file, you will need to run the `npm run build` command in the repo as well as `|commit %home` in the Dojo. Ford will then automatically rebuild your application with the new changes.

## Our Own Tile

Let's examine a sample tile that has different Hoon code from the default, to explore how the tile system works. This program, composed of the `testing.hoon` and `tile.js` files, creates a tile which can be used to send `hi` messages to ships, just the way you can with `|hi ~zod` from the dojo. Keep in mind that unless you boot other fakeships you won't get responses from ships other than `~zod`.

`tile.js` does the actual front-end rendering using React. The details of React are left for the reader to learn on their own, but you can see here how to store data in the state. That tile will be rendered every time the state gets updated. Calling `api.action` will send a JSON poke to our gall app. We have attached the function where we use that to the button on the tile, so it will get run when the button is clicked.

In your pier, replace the code in `urbit/app/testing.hoon` with the Hoon code below.

``` hoon
/+  *server
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/testing/js/tile
  /|  /js/
      /~  ~
  ==
=,  format
|%
+$  move  (pair bone card)
+$  poke
  $%  [%launch-action [@tas path @t]]
      [%helm-hi @t]
  ==
+$  card
  $%  [%poke wire dock poke]
      [%http-response =http-event:http]
      [%connect wire binding:eyre term]
      [%diff %json json]
  ==
--
|_  [bol=bowl:gall ~]
+*  this  .
++  bound
  |=  [wir=wire success=? binding=binding:eyre]
  ^-  (quip move _this)
  [~ this]
++  prep
  |=  old=(unit ~)
  ~&  'it built'
  ^-  (quip move _this)
  =/  launcha
    [%launch-action [%testing /testingtile '/~testing/js/tile.js']]
  :_  this
  :~
    [ost.bol %connect / [~ /'~testing'] %testing]
    [ost.bol %poke /testing [our.bol %launch] launcha]
  ==
++  peer-testingtile
  |=  pax=path
  ^-  (quip move _this)
  =/  jon=json
    %-  pairs:enjs:format
    :~
      [%status `json`s+'First starting']
    ==
  [[ost.bol %diff %json jon]~ this]
++  send-tile-diff
  |=  jon=json
  ^-  (list move)
  %+  turn  (prey:pubsub:userlib /testingtile bol)
  |=  [=bone ^]
  [bone %diff %json jon]
++  send-status-diff
  |=  msg=tape
  %-  send-tile-diff
  %-  pairs:enjs:format  :~
    [%status `json`s+(crip msg)]
  ==
++  poke-json
  |=  jon=json
  ^-  (quip move _this)
  ~&  'poke-json in testing called'
  ~&  jon
  =/  json-map    ((om:dejs:format same) jon)
  =/  ship-to-hi  (so:dejs:format (~(got by json-map) %ship))
  ~&  ship-to-hi
  =/  sthu  (need (slaw %p ship-to-hi))
  :_  this
  %+  weld
    (send-status-diff "looking")
  ^-  (list move)
  :~
    :-  ost.bol
    :^  %poke
        /helm/hi/[ship-to-hi]
      [sthu %hood]
    [%helm-hi '']
  ==
++  coup-helm-hi
  |=  [pax=path cop=(unit tang)]
  ~&  ["Coup recieved" pax]
  :_  this
  ?~  cop
    (send-status-diff "successfully found {<pax>}")
  (send-status-diff "failure")
++  poke-handle-http-request
  %-  (require-authorization:app ost.bol move .)
  |=  =inbound-request:eyre
  ^-  (quip move _this)
  =/  request-line  (parse-request-line url.request.inbound-request)
  =/  back-path  (flop site.request-line)
  =/  name=@t
    =/  back-path  (flop site.request-line)
    ?~  back-path
      ''
    i.back-path
  ?~  back-path
    [[ost.bol %http-response not-found:app]~ this]
  ?:  =(name 'tile')
    [[ost.bol %http-response (js-response:app tile-js)]~ this]
  [[ost.bol %http-response not-found:app]~ this]
::
--
```

Now, place the code below into `tile/tile.js`. (`npm` should automatically update `urbit/app/testing/js/tile.js` if you have run `npm run serve`; else, you'll need to `npm run build` again.) Once you've replaced the code in both files, run `|commit %home` in the Dojo.

``` javascript
import React, { Component } from 'react';
import classnames from 'classnames';
import _ from 'lodash';


export default class testingTile extends Component {

    constructor(props) {
        super(props);
        console.log("og props");
        console.log(this.props);
        this.state = { ship: "~zod" };
    }

    sub() {
        api.action('testing', 'json', {ship: this.state.ship});
    }

    handleChange(event) {
        this.setState({ship: event.target.value});
    }

    render() {
    return (
      <div className="w-100 h-100 relative" style={{ background: '#1a1a1a' }}>
          <p className="gray label-regular b absolute" style={{ left: 8, top: 4 }}>Testing</p>
            <p className="white absolute" style={{ top: 25, left: 8 }}>Hi a ship {this.props.data.status}</p>
            <p className="white absolute" style={{ top: 100, left: 8 }}>
            <button onClick={this.sub.bind(this)}>stuff</button></p>
            <p className="white absolute" style={{ top: 150, left: 15 }}>
            <input type="text" value={this.state.ship}
             onChange={this.handleChange.bind(this)}/></p>
      </div>
    );
  }

}

window.testingTile = testingTile;
```

### Default Code Components

Parts of the `testing.hoon` code shown above is the "scaffolding" that was automatically built for us by the default Hoon file from the `create-landscape-app` repo. We'll give a general overview of those arms here.

As with other gall apps, `card` and `move` define the types that can be produced by the app, `card` specifically defines which type of requests can be made to other parts of the system.

`++prep` is called when the application first starts, and when its code gets updated. It will get a `unit` of the old state and `++prep` needs to update the state. You might notice the use of `~&`. This is useful to give us feedback to make sure our changes have been loaded.

The `++peer-testingtile` arm is called when the tile first subscribes to the app. The subscription logic is mostly handled for us by the `launch` app here it simply produces some data to send back to the tile, indicating its initial state.

The two arms that are the most important for our application are `++poke-json` which receives any JSON sent by the tile and `++coup-helm-hi`, which we'll cover in a bit.

### Interesting Code

Now that we've glanced at the default components of the program, lets take a close look at the interesting parts of the code.

``` hoon
++  poke-json
  |=  jon=json
  ^-  (quip move _this)
  ~&  'poke-json in testing called'
  ~&  jon
  =/  json-map    ((om:dejs:format same) jon)
  =/  ship-to-hi  (so:dejs:format (~(got by json-map) %ship))
  ~&  ship-to-hi
  =/  sthu  (need (slaw %p ship-to-hi))
  :_  this
  %+  weld
  (send-status-diff "looking")
  ^-  (list move)
  :~
    :-  ost.bol
    :^  %poke
        /helm/hi/[ship-to-hi]
      [sthu %hood]
    [%helm-hi '']
  ==
```

`++poke-json` is going to accept a `json` and produce a `quip`. A `quip` is a pair of: a list of `moves` (in this case), and some state which is the same type as the core we are building. To be clear, a `json` in Hoon is not the same thing as something in the more general JSON format. It is rather a parsed data structure.

There are several uses of the `~&` rune. These are simply debugging printfs that we can skip over.

`(om:dejs:format same)` builds a gate that converts a `json` into a `map`.

`++so:dejs:format` formats some piece of data out of the `json` map, in this case the value of `%ship`. `sthu` is transformed by [`slaw`](@/docs/reference/library/4m.md#slaw) into an actual `@p` to verify that we didn't get sent nonsense. If we did, `need` will cause the gate to crash.

Finally, we produce the list of `move`s and the new state that is the data. This starts with the `:_` rune, which is the inverted form of `:-`, the [cons](https://en.wikipedia.org/wiki/Cons) rune. The state of our application will not actually change, so we can just use `this` for the existing core.

``` hoon
++  send-status-diff
  |=  msg=tape
  %-  send-tile-diff
  %-  pairs:enjs:format  :~
    [%status `json`s+(crip msg)]
  ==
```

`++send-status-diff` takes a `tape` and produces a `list` of `moves`, one to each subscriber to our application, to update them with a JSON structure made from the `tape`.

We weld the result of this gate with one more `move` we've built here: the list starting with `:-  ost.bol`. This `move` is a `%poke` to `%hood`. Specifically, it's a `%helm-hi` poke, the poke used by the `hi.hoon` generator to send `|hi` messages to other ships. In this case, we're sending it to the ship whose name was given to us in the JSON.

When we get a response from `%helm` to our `poke`, we'll receive a `coup`, which is the `move` always sent in response to a `poke`. Specifically, we'll get a `coup` for `helm-hi`, which is why we want an arm named `coup-helm-hi` to handle that.

``` hoon
++  coup-helm-hi
  |=  [pax=path cop=(unit tang)]
  ~&  ["Coup recieved" pax]
  :_  this
  ?~  cop
    (send-status-diff "successfully found {<pax>}")
  (send-status-diff "failure")
```

The code above should be easy to understand. `cop` is `unit` that will have an error in it if the request failed and be `~` otherwise. If it's `~`, we use `send-status-diff` to send the tile a success message; otherwise we send a failure message.
