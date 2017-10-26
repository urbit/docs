---
navhome: /developer/docs/
next: true
sort: 17
title: Web apps
---

# Backend

We've done purely functional web pages as hook files, and we've done command 
line apps, so now let's interact with an app over the web. The fundamental 
concepts are no different than from the command line-- you send "poke" messages 
to apps and subscribe to data streams. The only difference is that you do it 
with javascript.

Let's create a small web app that counts the number of times you poke it. 
There'll be a button to poke the app, and line of text below it saying how 
many times the app has been poked. We can update this by subscribing our page 
to the relevant path on its app.

Let's first checkout the app `/examples/app/click.hoon`:

```
::  Poke your urbit from the web                        ::  1
::                                                      ::  2
::::  /===/app/click/hoon                               ::  3
  ::                                                    ::  4
/-  click                                               ::  5
[. click]                                               ::  6
!:                                                      ::  7
|%                                                      ::  8
++  move  {bone card}                                   ::  9
++  card  $%  {$diff diff-content}                      ::  10
          ==                                            ::  11
++  diff-content  $%  {$click-clicks clicks}            ::  12
                  ==                                    ::  13
--                                                      ::  14
::                                                      ::  15
|_  {bow/bowl cis/clicks}                               ::  16
::                                                      ::  17
++  poke-click-click                                    ::  18
  |=  cik/^click                                        ::  19
  ^-  {(list move) _+>.$}                               ::  20
  ~&  click+clicked++(cis)                              ::  21
  :_  +>.$(cis +(cis))                                  ::  22
  %+  turn  (prey /click bow)                           ::  23
  |=  {o/bone *}                                        ::  24
  [o %diff %click-clicks +(cis)]                        ::  25
::                                                      ::  26
++  peer-click                                          ::  27
  |=  pax/path                                          ::  28
  ^-  {(list move) _+>.$}                               ::  29
  [~[[ost.bow %diff %click-clicks cis]] +>.$]           ::  30
::                                                      ::  31
++  coup                                                ::  32
  |=  {wir/wire err/(unit tang)}                        ::  33
  ^-  {(list move) _+>.$}                               ::  34
  ?~  err                                               ::  35
    ~&  click+success+'Poke succeeded!'                 ::  36
    [~ +>.$]                                            ::  37
  ~&  click+error+'Poke failed. Error:'                 ::  38
  ~&  click+error+err                                   ::  39
  [~ +>.$]                                              ::  40
::                                                      ::  41
++  reap                                                ::  42
  |=  {wir/wire err/(unit tang)}                        ::  43
  ^-  {(list move) _+>.$}                               ::  44
  ?~  err                                               ::  45
    ~&  click+success+'Peer succeeded!'                 ::  46
    [~ +>.$]                                            ::  47
  ~&  click+error+'Peer failed. Error:'                 ::  48
  ~&  click+error+err                                   ::  49
  [~ +>.$]                                              ::  51
::                                                      ::  52
--                                                      ::  53
```

There's nothing really new here, except that we use a couple of new marks, 
`click` and `clicks`. When we get poked with a `click`, we increment the 
variable `clicks` in our state and tell all our subcribers the new value. 
When someone subscribes to us on the path `/click`, we immediately give them 
the current number of clicks.

Let's take a look at the new marks. Here's `/examples/mar/click/click.hoon`:

```
::  A click                                             ::  1
::                                                      ::  2
::::  /===/mar/click/click/hoon                         ::  3
  ::                                                    ::  4
/-  click                                               ::  5
[. click]                                               ::  6
!:                                                      ::  7
|_  cik/^click                                          ::  8
++  grab                                                ::  9
  |%                                                    ::  10
  ++  noun  |=(* %click)                                ::  11
  ++  json                                              ::  12
    |=  jon/^json                                       ::  13
    ?>  =('click' (need (so:jo jon)))                   ::  14
    %click                                              ::  15
  --                                                    ::  16
--                                                      ::  17
```                                                          
                                                             
The mark `click-click` has hoon type `%click`, which means the only valid 
value is `%click`. We can convert from `noun` by just producing `%click`.

We also convert from json by parsing a json string with `so:jo`, asserting 
the parsing succeeded with `need`, and asserting the result was 'click' with 
`?>`, which asserts that its first child is true.

> Note the argument to `++json`is `jon/^json`.  Why `^json`?
> `++json` shadows the type definition, so if we want to refer to
> the type, we have to prepend a `^`.  This extends to multiple
> levels: `^^^foo` means the fourth innermost instance of `foo`.

> `++jo` in `zuse` is a useful library for parsing complex json
> into hoon structures. In this case, the `:` between `so` and
> `jo` means 'inside of', because `so` is an arm contained within
> the core `jo`.  Our case is actually simple enough that the
> `?>` line could have been `?>  =([%s 'click'] jon)`.

We can test this mark from the command line (don't forget to start your app 
with `|start %click`).

```
~fintud-macrep:dojo/examples> &click-click %click
%click
~fintud-macrep:dojo/examples> &click-click &json [%s 'click']
%click
~fintud-macrep:dojo/examples> &click-click &json &mime [/text/json (taco '"click"')]
%click
~fintud-macrep:dojo/examples> &click-click &json &mime [/text/json (taco '"clickety"')]
/~fintud-macrep/home/0/mar/click:<[7 5].[8 11]>
ford: casting %json to %click
ford: cast %click
```

And `/examples/mar/click/clicks.hoon`:

```
::  Total number of clicks                              ::  1
::                                                      ::  2
::::  /===/mar/click/clicks/hoon                        ::  3
  ::                                                    ::  4
/-  click                                               ::  5
[. click]                                               ::  6
!:                                                      ::  7
|_  cis/clicks                                          ::  8
++  grow                                                ::  9
  |%                                                    ::  10
  ++  json                                              ::  11
    (joba %clicks (jone cis))                           ::  12
  --                                                    ::  13
--                                                      ::  14
```

`clicks-clicks` is just an atom. We convert to json by creating an object with 
a single field "clicks" with our value.

> Be sure to checkout section 3bD, JSON and XML, in zuse.hoon
> `++joba` is just a function that takes a key-value pair and
> produces a JSON object with one element.

```
~fintud-macrep:dojo/examples> &json &click-clicks 6
[%o p={[p='clicks' q=[%n p=~.6]]}]
```

Now that we know the marks involved, take another look at the app above. 
Everything should be pretty straightforward. Let's poke the app from the 
command line.

```
~fintud-macrep:dojo/examples> |start %click
>=
~fintud-macrep:dojo/examples> :click &click-click %click
[%click %clicked 1]
>=
~fintud-macrep:dojo/examples> :click &click-click %click
[%click %clicked 2]
>=
```

**Exercise**:

- Modify `:sink` from the subcriptions chapter to listen to
  `:click` and print out the subscription updates on the command
  line.

# Frontend

That's all that's needed for the backend. The frontend is just some "sail" html 
(Hoon markup for XML) and javascript. Here's `/web/pages/examples/click.hoon`:

```
;html
  ;head
    ;script(type "text/javascript", src "//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js");
    ;script(type "text/javascript", src "/~/at/lib/js/urb.js");
    ;title: Clickety!
  ==
  ;body
    ;div#cont
      ;input#go(type "button", value "Poke!");
      ;div#err(class "disabled");
      ;div#clicks;
    ==
    ;script(type "text/javascript", src "/pages/examples/click/click.js");
  ==
==
```

You should recognize the sail syntax from an earlier chapter. Aside from jquery, 
we also include `urb.js`, which is a framework for interacting with urbit.

To view the frontend, point your browser at `ship-name.urbit.org/~~/pages/click` 
if you're on the live network. If you're running a fake galaxy or a comet 
locally, navigate to whatever port it's running on, which is usually: 
`https://localhost:8443/~~/pages/click`.

We have a button labeled "Poke!" and a div with id `clicks` where we'll put 
the number of clicks. We also include a small javascript file where the 
client-side application logic can be found. It's in 
`/examples/web/pages/click/click.js`:

```
$(function() {
  var clicks, $go, $clicks, $err

  $go     = $('#go')
  $clicks = $('#clicks')
  $err    = $('#err')

  $go.on("click",
    function() {
      window.urb.send(
        "click", {mark: "click-click"}
      ,function(err,res) {
        if(err)
          return $err.text("There was an error. Sorry!")
        if(res.data !== undefined &&
           res.data.ok !== undefined &&
           res.data.ok !== true)
          $err.text(res.data.res)
        else
          console.log("poke succeeded");
      })
  })

  window.urb.appl = "click"
  window.urb.bind('/click',
    function(err,dat) {
      clicks = dat.data.clicks
      $clicks.text(clicks)
    }
  )
})
```

We set up two event handlers. When we click the button, we run 
`window.urb.send`, which sends a poke to the app specified as the first 
argument, in this case our :click app. The arguments are data, parameters, 
and the callback. The data is the specific data we want to send. The parameters 
are all optional, but here's a list of the available ones:

- `ship`:  target urbit.  Defaults to `window.urb.ship`, which
  defaults to the urbit which served the page.
- `appl`:  target app.  Defaults to `window.urb.appl`, which
  defaults to null.
- `mark`:  mark of the data.  Defaults to `window.urb.send.mark`,
  which defaults to "json".
- `wire`:  wire of the poke.  Defaults to `/`.

In our case, we specify only that the mark is "click".

The callback function is called when we receive an acknowledgment. If there 
was an error, we put it in the `err` div that we defined above. Otherwise, we 
print to the console a message saying the poke succeeded. As is common, we gray
out the button when it is clicked. It is only reenabled when positive 
acknowledgement is received.

Our second event handler is `window.urb.bind`, which is called immediately when 
the page is loaded, subscribing the page to the specified data stream on the 
app set with `urb.appl` (which is, in this case, :click). It also takes three 
arguments: path, parameters, and callback. The path is the path on the app to 
subscribe to. The parameters are all optional (indeed, we omit them entirely 
here), but are similar to those for `send`:

- `ship`:  target urbit.  Defaults to `window.urb.ship`, which
  defaults to the urbit which served the page.
- `appl`:  target app.  Defaults to `window.urb.appl`, which
  defaults to null.
- `mark`:  mark of expected data.  Data of other marks is
  converted to this mark on the server before coming to the web
  front end.  Defaults to `window.urb.bind.mark`, which defaults
  to "json".
- `wire`:  wire of the subscription.  Defaults to the given path.

The callback function here just updates the data in the `clicks` div. A truly 
robust app would intelligently handle errors, of course.

Note that the app doesn't have anything web-specific in itself. As far as it 
knows, it's just receiving pokes and subscriptions. The javascript is fairly 
pure as well, sending and receiving json everywhere. The marks are the 
translation layer, and they're the only things that need to know how the hoon 
types map to json.

**Exercise**:

- Open the app in multiple tabs, click the button, and verify
  that all the tabs stay synchronized. Poke it manually from the
  command line and verify the tabs are updated as well.
