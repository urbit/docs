+++
title = "Gall Apps"
weight = 6
template = "doc.html"
+++
This is documentation about how to write Gall apps.  Some knowledge of Hoon is assumed.

> Note: the last major revision of these lessons was in 2016.  They need to be
  rewritten; in some ways they are outdated, and in other ways they were not
  always accessible enough to beginners.  We are planning to rewrite these in the
  near future.  There is still useful information to be found in the meantime.

## API Connectors

> Note: This lesson depends on some code that needs to be updated before the examples will work correctly.  This will be addressed in the near future.  We apologize!

Most people have lots of data stored in online services, many of
which have APIs.  API connectors allow the user to access this
data from within their Urbit.

A security driver allows the user to make authenticated requests
to the service's API, but the user still needs to know the API
and send and receive JSON.  An API connector puts a layer of
porcelain over this to allow the user easier control over their
data.

Each connector should perform two basic functions.  First, it
should expose a tree of the data in the service that's accessible
through `.^` and FUSE.  Second, it should expose event streams as
actions occur in the service.  Let's take a look at how the `%gh`
app accomplishes both for Github.

After starting `%gh` (`|start %gh`), let's look at the root of
the tree that `%gh` exposes:

```
~your-urbit:dojo> .^(arch %gy /=gh=)
[fil=~ dir={[p=~.issues q=~]}]
```

`%gh` is currently a skeleton -- it contains examples of all the
functionality necessary for a connector, but many endpoints
aren't implemented.  As we can see here, only issues are
implemented.  We can explore this tree:

```
~your-urbit:dojo> .^(arch %gy /=gh=/issues)
[fil=~ dir={[p=~.by-repo q=~] [p=~.mine q=~]}]
```

And eventually:

```
/-  gh
.^(issue:gh %gx /=gh=/issues/by-repo/philipcmonktest/testing/7)
<issue...>
login.user:.^(issue:gh %gx /=gh=/issues/by-repo/philipcmonktest/testing/7)
'philipcmonktest'
```

The other thing an API connector needs to do is expose event
streams.  One straightforward way to use this capacity is with
the `:pipe` app:

```
:pipe|connect %gh /listen/philipcmonktest/testing/issues/'issue_comment' %public
```

Now creating an issue results in the following message in your
`%public` `:talk` channel:

```
~your-urbit[philipcmonktest@github]: opened issue ##11: i found a bug!
```

You'll also get notifications of issue status changes and
comments.

As is often the case, the best way to write an API connector is
to copy an existing one and modify it.  We'll dissect the Github
connector here.  This code is in `/=home=/app/gh/hoon`, and it's
also reproduced at the bottom of this page (in case the code
drifts out of sync with this doc).

We'll go over the two parts to an API connector (one-time reading vs listening
for events) separately.

#### Reading

A connector exposes a tree of data.  Every read request has a
`care`, which is generally either `%x` or `%y.  `%x` is a request
for a particular piece of data, while `%y` is a request for a
directory listing.  Roughly, `%x` means Unix `cat` and `%y` means
Unix `ls`.

> Sometimes you wish to expose a tree where a part of the path can't be enumerated.  For example, a `%y` of `/issues/by-repo` "should" produce a list of all Github users, but we don't do that because it's too long.  Instead, we just produce our own username (from the `web.plan` file).  You can still access repos from other users, you just don't see them in the directory listing.

The usual flow for implementing this tree of data makes heavy use
of the `connector` library.  This library is well documented in
the source, so check out `/=home=/lib/connector/hoon`.

The `connector` library needs to be initialized with definitions
of `move` and `sub-result` (all the types of data that can be
returned by a place).  This can just be a line at the top of the
main core:

```
=+  connector=(connector move sub-result)  ::  Set up connector library
```

Most of the Github-specific logic is in `++places`, which is a
list of all the places we can request.  A place consists of:

```
++  place
  $:  guard/mold
      read-x/$-(path move)
      read-y/$-(path move)
      sigh-x/$-(jon/json (unit sub-result))
      sigh-y/$-(jon/json (unit arch))
  ==
```

- `guard`, the type of the paths we should match.  For example, to match `/issues/<user>/<repo>` use `{$issues @t @t $~}`.

- `read-x`, called when someone tries to read the place with `care` `%x`.  Should produce a single move, usually either a `%diff` response if we can immediately answer or a `%hiss` http request if we need to make a request to the api.  See the `++read-*` functions in `++helpers` for some common handlers.

- `read-y`, same as `read-x` except with care `%y`.

- `sigh-x`, called when an http response comes back on this place.  You're given the json of the result, and you should produce either a result or null.  Null represents an error. If you didn't create an http request in `read-x`, then this should never be called.  Use `++sigh-strange` from `++helpers` to unconditionally signal an error.

- `sigh-y`, same as `sigh-x` except with care `%y`.  Note that a `%y` request must produce an arch, unlike a `%x` request, which may produce data of any mark.

Filling out the list of places is a lot of grunt work, but most
places are fairly straightforward, and the `++read-*` helper
functions are useful.  Check out the library source for more
information on those.

Besides the list of places, we just need to handle the flow of
control.  `++peek` and `++peer-scry` are the interface we expose
to the rest of the system while `++sigh-httr` and `++sigh-tang`
are used to handle responses when we make HTTP requests.

- `++peek` should usually just produce `~`.  If there are cases where we can respond directly to a `.^` request without blocking on anything, we could do it here, but it's generally not worth the hassle since the same logic should be duplicated in `++peer-scry`.

- `++peer-scry` is where the actual handling for a read request goes.  In general, we just need to call `++read` from the `connector` library with the bone, list of places, care, and path.  This will match the path to the appropriate place and run either `++read-x` or `++read-y`, depending on the care.

- If `++read-x` or `++read-y` made a successful API request, then the response will come back on `++sigh-httr`.  Here, we just need to parse out the wire and call `++sigh` from the `connector` library with the list of places, care, path, and HTTP result.  This will match the path to the appropriate place and run either `++sigh-x` or `++sigh-y`, depending on the care.

- If `++read-x` or `++read-y` made an API request that failed, then we'll get a stack trace in `++sigh-tang`.  Here, we just print it out and move on.

That's really all there is to the reading portion of API
connectors.

One of the most accessible ways to jump into Arvo programming is
to just add more places to an existing API connector.  It's
useful, small in scope, and comes in bite-sized chunks since most
places are less than ten lines of code.

#### Listening

Listening for events is fairly service-specific.  In some
services, we poll for changes.  The Twitter connector has an
example of this, but note that it predates the `connector`
library and is thus more complicated than it needs to be, and the
interface it exposes isn't standard.  In Github, we power our
event streams with webhooks.

For Github, when someone subscribes to
`/listen/<user>/<repo>/<events...>`, we want to produce
well-typed results when they occur.

We only want to create one webhook per event, so in our state we
have `hook`, which is a map of event names to the set of bones
which are subscribed to that event.  We must always keep this
up-to-date.

Flow of control starts in `++peer-listen`, where we just call
`++listen`.  In `++listen`, for each event in the list of events,
we check to see if we have that hook set up (by checking whether
it exists in `hook`).  If so, we call `++update-hook` to add the
current bone to the set of listeners.  Otherwise, we call
`++create-hook`, which sends a request to Github to set up the
new webhook.  We also create an entry in `hook` with the current
bone.

When we created the webhook, we told Github to send the event to
`/~/to/gh/gh-<event>.json?anon&wire=/`.  This turns into a poke.
Let's parse out this url.  The first `gh` is the app name to
poke.  The next portion, `gh-<event>` is the mark to convert the
JSON to.  For example, when the "issues" event fires, it'll get
converted to mark `gh-issues`.  This mark has a conversion
routine from `json` to the `issues` type, which is defined in the
`gh` structure (`/=home=/sur/gh/hoon`).  Once this conversion
happens, the `gh` app will get poked with the correctly marked
data in `++poke`.

In `++poke`, we check `hook` to find the subscribers to the event
that was fired, and we update them.

That's really all there is to it.  Webhook flow isn't well
standardized, so even if your chosen service is powered by
webhooks, your listening code might look rather different.  The
point is to expose the correct interface.


#### Github API Connector Code

In case the code in `/=home=/app/gh/hoon` drifts out of sync with
this doc:

```
::  This is a connector for the Github API v3.
::
::  You can interact with this in a few different ways:
::
::    - .^({type} %gx /=gh={/endpoint}) to read data or
::      .^(arch %gy /=gh={/endpoint}) to explore the possible
::      endpoints.
::
::    - subscribe to /listen/{owner}/{repo}/{events...} for
::      webhook-powered event notifications.  For event list, see
::      https://developer.github.com/webhooks/.
::
::  This is written with the standard structure for api
::  connectors, as described in lib/connector.hoon.
::
/?  314
/-  gh, plan-acct
/+  gh-parse, connector
::
!:
=>  |%
    +$  move  (pair bone card)
    +$  card
      $%  [%diff sub-result]
          [%them wire (unit hiss:eyre)]
          [%hiss wire [%~ %~] %httr [%hiss hiss:eyre]]
      ==
    ::
    ::  Types of results we produce to subscribers.
    ::
    +$  sub-result
      $%  [%arch arch]
          [%gh-issue issue:gh]
          [%gh-list-issues (list issue:gh)]
          [%gh-issues issues:gh]
          [%gh-issue-comment issue-comment:gh]
          [%json json]
          [%null %~]
      ==
    ::
    ::  Types of webhooks we expect.
    ::
    +$  hook-response
      $%  [%gh-issues issues:gh]
          [%gh-issue-comment issue-comment:gh]
      ==
    --
=+  connector=(connector move sub-result)  ::  Set up connector library
::
|_  $:  hid=bowl:gall
        hook=(map @t [id=@t listeners=(set bone)])  ::  map events to listeners
    ==
::  ++  prep  _`.  ::  Clear state when code changes
::
::  List of endpoints
::
++  places
  |=  wir=wire
  ^-  (list place:connector)
  =+  (helpers:connector ost.hid wir "https://api.github.com")
  =>  |%                              ::  gh-specific helpers
      ++  sigh-list-issues-x
        |=  jon=json
        %+  bind  ((ar:jo issue:gh-parse) jon)
        |=  issues=(list issue:gh)
        gh-list-issues+issues
      ::
      ++  sigh-list-issues-y
        |=  jon=json
        %+  bind  ((ar:jo issue:gh-parse) jon)
        |=  issues=(list issue:gh)
        :-  `(shax (jam issues))
        (malt (turn issues |=(issue:gh [(rsh 3 2 (scot %ui number)) ~])))
      --
  :~  ^-  place                       ::  /
      :*  guard=,%~
          read-x=read-null
          read-y=(read-static %issues ~)
          sigh-x=sigh-strange
          sigh-y=sigh-strange
      ==
      ^-  place                       ::  /issues
      :*  guard=,[%issues %~]
          read-x=read-null
          read-y=(read-static %mine %by-repo ~)
          sigh-x=sigh-strange
          sigh-y=sigh-strange
      ==
      ^-  place                       ::  /issues/mine
      :*  guard=,[%issues %mine %~]
          read-x=(read-get /issues)
          read-y=(read-get /issues)
          sigh-x=sigh-list-issues-x
          sigh-y=sigh-list-issues-y
      ==
      ^-  place                       ::  /issues/by-repo
      :*  guard=,[%issues %by-repo %~]
          read-x=read-null
          ^=  read-y
          |=  pax=path
          =+  /(scot %p our.hid)/home/(scot %da now.hid)/web/plan
          =+  .^([* acc=(map knot plan-acct)] %cx -)
        ::
          ((read-static usr:(~(got by acc) %github) ~) pax)
          sigh-x=sigh-strange
          sigh-y=sigh-strange
      ==
      ^-  place                       ::  /issues/by-repo/<user>
      :*  guard=,[%issues %by-repo @t %~]
          read-x=read-null
          read-y=|=(pax=path (get /users/[-.+>.pax]/repos))
          sigh-x=sigh-strange
          ^=  sigh-y
          |=  jon=json
          %+  bind  ((ar:jo repository:gh-parse) jon)
          |=  repos=(list repository:gh)
          [~ (malt (turn repos |=(repository:gh [name ~])))]
      ==
      ^-  place                       ::  /issues/by-repo/<user>/<repo>
      :*  guard=,[%issues %by-repo @t @t %~]
          read-x=|=(pax=path (get /repos/[-.+>.pax]/[-.+>+.pax]/issues))
          read-y=|=(pax=path (get /repos/[-.+>.pax]/[-.+>+.pax]/issues))
          sigh-x=sigh-list-issues-x
          sigh-y=sigh-list-issues-y
      ==
      ^-  place                       ::  /issues/by-repo/<user>/<repo>
      :*  guard=,[%issues %by-repo @t @t @t %~]
          ^=  read-x
          |=(pax=path (get /repos/[-.+>.pax]/[-.+>+.pax]/issues/[-.+>+>.pax]))
        ::
          read-y=(read-static ~)
          ^=  sigh-x
          |=  jon=json
          %+  bind  (issue:gh-parse jon)
          |=  issue=issue:gh
          gh-issue+issue
        ::
          sigh-y=sigh-strange
      ==
  ==
::
::  When a peek on a path blocks, ford turns it into a peer on
::  /scry/{care}/{path}.  You can also just peer to this
::  directly.
::
::  We hand control to ++scry.
::
++  peer-scry
  |=  pax=path
  ^-  [(list move) _+>.$]
  ?>  ?=([care:clay *] pax)
  :_  +>.$  :_  ~
  (read:connector ost.hid (places %read pax) i.pax t.pax)
::
::  HTTP response.  We make sure the response is good, then
::  produce the result (as JSON) to whoever sent the request.
::
++  sigh-httr
  |=  [way=wire res=httr:eyre]
  ^-  [(list move) _+>.$]
  ?.  ?=([%read care:clay @ *] way)
    ~&  res=res
    [~ +>.$]
  =*  style  i.way
  =*  ren  i.t.way
  =*  pax  t.t.way
  :_  +>.$  :_  ~
  :+  ost.hid  %diff
  (sigh:connector (places ren style pax) ren pax res)
::
::  HTTP error.  We just print it out, though maybe we should
::  also produce a result so that the request doesn't hang?
::
++  sigh-tang
  |=  [way=wire tan=tang]
  ^-  [(list move) _+>.$]
  %-  (slog >%gh-sigh-tang< tan)
  [[ost.hid %diff null+~]~ +>.$]
::
::  We can't actually give the response to pretty much anything
::  without blocking, so we just block unconditionally.
::
++  peek
  |=  [ren=@tas tyl=path]
  ^-  (unit (unit (pair mark *)))
  ~ ::``noun=[ren tyl]
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::         Webhook-powered event streams (/listen)            ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::  To listen to a webhook-powered stream of events, subscribe
::  to /listen/<user>/<repo>/<events...>
::
::  We hand control to ++listen.
::
++  peer-listen
  |=  pax=path
  ^-  [(list move) _+>.$]
  ?.  ?=([@ @ *] pax)
    ~&  [%bad-listen-path pax]
    [~ +>.$]
  (listen pax)
::
::  This core handles event subscription requests by starting or
::  updating the webhook flow for each event.
::
++  listen
  |=  pax=path
  =|  mow=(list move)
  =<  abet:listen
  |%
  ++  abet                                              ::  Resolve core.
    ^-  [(list move) _+>.$]
    [(flop mow) +>.$]
  ::
  ++  send-hiss                                         ::  Send a hiss
    |=  hiz=hiss:eyre
    ^+  +>
    =+  wir=`wire`[%x %listen pax]
    +>.$(mow [[ost.hid %hiss wir `~ %httr [%hiss hiz]] mow])
  ::
  ::  Create or update a webhook to listen for a set of events.
  ::
  ++  listen
    ^+  .
    =+  pax=pax  ::  TMI-proofing
    ?>  ?=([@ @ *] pax)
    =+  events=t.t.pax
    |-  ^+  +>+.$
    ?~  events
      +>+.$
    ?:  (~(has by hook) i.events)
      $(+>+ (update-hook i.events), events t.events)
    $(+>+ (create-hook i.events), events t.events)
  ::
  ::  Set up a webhook.
  ::
  ++  create-hook
    |=  event=@t
    ^+  +>
    ?>  ?=([@ @ *] pax)
    =+  clean-event=`tape`(turn (trip event) |=(a=@tD ?:(=('_' a) '-' a)))
    =.  hook
      %+  ~(put by hook)  (crip clean-event)
      =+  %+  fall
            (~(get by hook) (crip clean-event))
          *[id=@t listeners=(set bone)]
      [id (~(put in listeners) ost.hid)]
    %-  send-hiss
    :*  %+  scan
          =+  [(trip i.pax) (trip i.t.pax)]
          "https://api.github.com/repos/{-<}/{->}/hooks"
        auri:de-purl:html
        %post  ~  ~
        %-  as-octs:mimes:html  %-  crip  %-  en-json:html  %-  pairs:enjs:format  :~
          name+s+%web
          active+b+&
          events+a+~[s+event] ::(turn `(list ,@t)`t.t.pax |=(a=@t s=a))
          :-  %config
          %-  pairs:enjs:format  :~
            =+  =+  clean-event
                "http://107.170.195.5:8443/~/to/gh/gh-{-}.json?anon&wire=/"
            [%url s+(crip -)]
            [%'content_type' s+%json]
          ==
        ==
    ==
  ::
  ::  Add current bone to the list of subscribers for this event.
  ::
  ++  update-hook
    |=  event=@t
    ^+  +>
    =+  hok=(~(got by hook) event)
    %_    +>.$
        hook
      %+  ~(put by hook)  event
      hok(listeners (~(put in listeners.hok) ost.hid))
    ==
  --
::
::  Pokes that aren't caught in more specific arms are handled
::  here.  These should be only from webhooks firing, so if we
::  get any mark that we shouldn't get from a webhook, we reject
::  it.  Otherwise, we spam out the event to everyone who's
::  listening for that event.
::
++  poke
  |=  response=hook-response
  ^-  [(list move) _+>.$]
  =+  hook-data=(~(get by hook) (rsh 3 3 -.response))
  ?~  hook-data
    ~&  [%strange-hook hook response]
    [~ +>.$]
  ::  ~&  response=response
  :_  +>.$
  %+  turn  ~(tap in listeners.u.hook-data)
  |=  ost=bone
  [ost %diff response]
--
```

## Generators

Up until now we've poked apps directly. This requires the user to
specify the mark, and it requires the app to accept the arguments in a
way that's convenient for users to input. This is the "plumbing" way to
interact with apps. Generators are the "porcelain" layer. This is why
when you run a command like `+ls` or `|merge`, there are no marks in
sight.

We've used generators before, back in [Basic
Operation](/docs/learn/arvo/arvo-internals/admin). At that point, we just used the
generators to produce values -- we didn't pipe their results into apps.
In the dojo cast, the role of a generator is to take a list of arguments
and produce a value, which is often, though not always, piped into an
app. Generators are pure, stateless functions, and they cannot send
moves.

`+ls` and `+cat` are commonly-used generators that produce a directory
listing and print out a file, respectively. These are useful in
themselves, so we generally don't pipe the results into an app.

Another generator is `+hood/merge`. Try running `+hood/merge` with the
normal arguments for `|merge`:

```
> +hood/merge %home our %they
[syd=%home her=~zod sud=%they cas=[%da p=~2018.10.4..21.11.49..901c] gem=%auto]

> +hood/merge %home our %they, =gem %this
[syd=%home her=~zod sud=%they cas=[%da p=~2018.10.4..21.12.11..ee32] gem=%this]
```

This didn't run any merge, it just constructed the command that, if sent
to `:hood`, would run it. Note first that, even though it's not printed,
this value has mark `kiln-merge`. Also, the merge strategy `gem=%auto`
was added automatically. Optional arguments are straightforward with
generators.

In general, generators are prepended by either `+` or `|`. The general
form is `+generator`, but often generators are created specifically to
work with a single app, they're usually placed in a subdirectory of gen
and run with `|`. Thus, if `my-generator` generator is made for use with
`:my-app`, then `my-generator` is put in
`/gen/my-app/my-generator.hoon`, and can be run directly with
`+my-app/my-generator <args>`. If you want to pipe the result into
`:my-app`, then run `:my-app +my-app/my-generator <args>`. Because this
pattern is so common, this can be abbreviated to
`:my-app|my-generator <args>`. Because most built-in commands are
generators for the `:hood` app, `:hood|generator <args>` can be
shortened to `|generator <args>`.

Let's write a generator called `:pong` that takes an urbit address, which is of
mark `urbit`, and sends that urbit the message `'howdy'`. First--without a
generator--let's make `:ping` that does the same, except that
it lets the user optionally specify the message as well.

We'll need a new mark for our arguments. Let's call it
`ping-message`.

> For app-specific marks, it's good style to prefix the name of the mark with the name of the app. Since many apps have several such marks, subdirectories in `/mar` are rendered as `-`, so that `ping-message` is written in (/mar/ping/message.hoon).

```
::
::::  /mar/ping/message/hoon
  ::
/?    314
|_  [to=@p message=@t]
++  grab
  |%
  +$  noun  [@p @t]
  --
--
```

The app can easily be modified to use this (`/app/ping.hoon`):

```
::  Allows one ship to ping another with a string of text
::
::::  /app/ping/hoon
  ::
/?    314
|%
  +$  move  [bone term wire *]
--
!:
|_  [bowl:gall state=%~]
::
++  poke-ping-message
  |=  [to=@p message=@t]
  ~&  'sent'
  ^-  [(list move) _+>.$]
  :-  ^-  (list move)
      :~  `move`[ost %poke /sending [to dap] %atom message]
      ==
  +>.$
::
++  poke-atom
  |=  arg=@
  ~&  'received'
  ^-  [(list move) _+>.$]
  ::
  ~&  [%receiving (@t arg)]
  [~ +>.$]
::
++  coup  |=(* `+>)
--
```

Now we can run this with:

```
~fintud-macrep:dojo> |start %ping
>=

~fintud-macrep:dojo> :ping &ping-message [~sampel-sipnym 'heyya']
>=
```

And on `~sampel-sipnym`, assuming it's running `:ping` as well,
we see `[%receiving 'heyya']`.

This is an annoying way to invoke the app, though. The `[]` are
mandatory, and optional arguments are hard. Let's make a generator,
`+send` to make everything nicer. Since it's specific to
`:ping`, let's put it in `/gen/ping/send.hoon`:

```
:-  %say
|=  [^ [to=@p message=?(%~ [text=@t %~])] %~]
[%ping-message to ?~(message 'howdy' text.message)]
```

A couple of new things here. Firstly, `message=?(%~ [text=@t %~])] %~]`
should be read as "the message is either null or a pair of text and
null". Generator argument lists are always null-terminated, which makes
it convenient to accept lists in tail position (which are particularly
annoying without generators). `?(a b)` is the irregular form of
`$?(a b)`, which is a union type. Thus, `?(a b)` means the type of
anything that's in either `a` or `b`. Thus, in our case,
`?(~ [text=@t ~])` is either null or a pair of text and null.

This is run as follows:

```
~fintud-macrep:dojo> :ping|send ~sampel-sipnym
>=

~fintud-macrep:dojo> :ping|send ~sampel-sipnym 'how do you do'
>=
```

Which causes `~sampel-sipnym` to print `[%receiving 'howdy']` and
`[%receiving 'how do you do']`.

(Note: `:ping|send ~sampel-sipnym` is short for `:ping +ping/send ~sampel-sipnym`.)

**Exercises**:

- Create a generator for `:sum` from [State](#state) so that you can run `:sum|add 5` to add numbers to it.

- Create a generator for `:click` from [Web Apps](#backend) so that you can run `:click|poke` to poke it.


## Writing an HTTP Request

There's a variety of arvo services we haven't touched on yet.
Let's figure out how to make HTTP requests and set timers.

Let's build an uptime-monitoring system.  It'll ping a web
service periodically and print out an error when the response
code isn't 2xx.  Save the following as `app/up.hoon`:

```
::  Up-ness monitor. Accepts atom url, 'on', or 'off'
::
::::  /hoon/up/app
  ::
/?    314
|%
+$  move  [bone card]
+$  card
  $%  [%hiss wire unit-iden=$~ mark=%httr cage=[mark=%purl vase=purl:eyre]]
      [%wait wire @da]
  ==
+$  action
  $%  [%on $~]            ::  enable polling('on')
      [%off $~]           ::  disable polling('off)
      [%target p=cord]    ::  set poll target('http://...')
  ==
--
|_  [hid=bowl:gall on=_| in-progress=_| target=@t]
++  poke-atom
  |=  url-or-command=@t  ^-  (quip move _+>)
  =+  ^-  act/action
      ?:  ?=($on url-or-command)  [%on ~]
      ?:  ?=($off url-or-command)  [%off ~]
      [%target url-or-command]
  ?-  -.act
    $target  [~ +>.$(target p.act)]
    $off  [~ +>.$(on |)]
    $on
      :-  ?:  |(on in-progress)  ~
          [ost.hid %hiss /request ~ %httr %purl (need (de-purl:html target))]~
      +>.$(on &, in-progress &)
  ==
++  sigh-httr
  |=  [wir=wire code=@ud headers=mess:eyre body=(unit octs)]
  ~&  'arrive here'
  ^-  [(list move) _+>.$]
  ?:  &((gte code 200) (lth code 300))
    ~&  [%all-is-well code]
    :_  +>.$
    [ost.hid %wait /timer (add ~s10 now.hid)]~
  ~&  [%we-have-a-problem code]
  ~&  [%headers headers]
  ~&  [%body body]
  :_  +>.$
  [ost.hid %wait /timer (add ~s10 now.hid)]~
++  wake-timer
  |=  [wir=wire $~]  ^-  (quip move _+>)
  ?:  on
    :_  +>.$
    [ost.hid %hiss /request ~ %httr %purl (need (de-purl:html target))]~
  [~ +>.$(in-progress |)]
::
++  prep  ~&  target  _`.  :: computed when the source file changes;
--                         :: here it prints target then resets our state
```

There's some fancy stuff going on here.  We'll go through it line by
line, though.

There's two kinds of cards we're sending to arvo. A `%hiss` move tells
`%eyre` to make an HTTP request. It expects a `(unit iden)`, which will
be null here because we aren't doing any authentication; a mark, in this
case the http request mark `&httr`; and some data in the form of a
`cage`, which is a `[mark vase]`. This is confusing, so the mold in the
code quoted above includes a bunch of otherwise unnecessary faces for
the purpose of illustration. Compare: `[%hiss p=(unit user) q=mark
r=cage]` from `zuse`.

> You can grep zuse.hoon and arvo.hoon for most of these definitions. However, beware the ambiguity surrounding "hiss": there's ++hiss in section 3bI of `zuse` ("Arvo structures"), and there's `%hiss` the move that is sent to %eyre to make our HTTP request happen. Here we're talking about the latter. See `++task:able:eyre` in `zuse`.

> Recall that `++unit` means "maybe".  Formally, "`(unit a)` is either null or a pair of null and a value in `a`". Also recall that to pull a value out of a unit (`u.unit`), you must first verify that the unit is not null (for example with `?~`). See `++need`.

A `purl:eyre` is a parsed url structure, which can be created with `de-purl:html`,
which is a function that takes a url as text and parses it into a `(unit
purl:eyre)`.  Thus, the result is null if and only if the url is malformed.
'Purl' is also the mark which will be applied to this result.

When you send this request, you can expect a `%sigh` with the
response, which we handle later on in `++sigh-httr`.

For `%wait`, you just pass a `@da` (absolute date), and arvo will
produce a `%wake` when the time comes.

> A timer is guaranteed to not be triggered before the given time, but it's currently impossible to guarantee the timer will be triggered at exactly the requested time.

Let's take a look at our state:

```
|_  [hid=bowl:gall on=_| in-progress=_| target=@t]
```

We have three pieces of app-specific state.  `target` is the url
we're monitoring.  `on` and `in-progress` are booleans
representing, respectively, whether or not we're supposed to keep
monitoring and whether or not we're in the middle of a request.

The type of booleans is usually written as `?`, which is a union
of `&` (true) and `|` false.  This type defaults to `&` (true).  In our
case, we want both of these to default to `|` (false).  Because
of that, we use `_|` as the type.  `_value` means "take the type
of `value`, but make the default value be `value`".  Thus, our
type is still a boolean, just like `?`, but the default value is
`|` (false).

> This is the same `_` used in `_+>.$`, which means "the same type as the value "+>.$".  In other words, the same type as our current context and state.

Let's take a look at `++poke-atom`.  When we're poked with an atom, we
first check whether the atom is `'off'`.  If so, we set our state
variable `on` to false.

If not, we check whether the atom is `'on'`.  If so, we set `on` and
`in-progress` to true.  If it was already either on or in progress, then
we don't take any other immediate action. If it was both off and not in
progress, then we send an HTTP request.

If the argument is neither 'off' nor 'on', then we assume it's an
actual url, so we save it in `target`.

Here's the move that sends the HTTP request:

```
[ost.hid %hiss /request ~ %httr %purl (need (de-purl:html target))]
```

> Remember, we are expected to produce a **list** of moves. Note the `~` after the move in the full example. This is a convenient shortcut for creating a list of a single element.  It's part of a small family of such shortcuts.  `~[a b c]` is `[a b c ~]`, `[a b c]~` is `[[a b c] ~]` and `\`[a b c]` is `[~ a b c]`. These may be mixed and matched to create various convoluted structures and emojis.

The correspondence between this move and `[bone card]` can be hard to
visualize on one line. Here it is more pedantically:

```
:*  bone=ost.hid                                        :: the move
    term=%hiss
    wire=/request
    unit-iden=~
    mark=%httr
    cage=[%purl (need (de-purl:html target))]
==
```

When the HTTP response comes back, we handle it with
`++sigh-httr`, which, along with the wire the request was sent
on, takes the status code, the response headers, and the response
body.

We check whether the status code is between 200 and 300.  If so,
all is well, and we print a message saying so.  We start the
timer for ten seconds after the present time.

If we got a bad status code, then we print out the entire
response and start the timer again.

After ten seconds, arvo will give us a `%wake` event, which will
be handled in `++wake-timer`.  If we're still supposed to keep
monitoring, we send the same HTTP request as before.  Otherwise,
we set `in-progress` to false.

Let's try it out:

```
~fintud-macrep:dojo> |start %up
>=
~fintud-macrep:dojo> :up &atom 'http://www.google.com'
>=
[%all-is-well 200]
[%all-is-well 200]
~fintud-macrep:dojo> :up &atom 'http://example.com'
>=
[%all-is-well 200]
~fintud-macrep:dojo> :up &atom 'http://google.com'
>=
[%we-have-a-problem 301]
[ %headers
  ~[
    [p='X-Frame-Options' q='SAMEORIGIN']
    [p='X-XSS-Protection' q='1; mode=block']
    [p='Content-Length' q='219']
    [p='Server' q='gws']
    [p='Cache-Control' q='public, max-age=2592000']
    [p='Expires' q='Sun, 10 Jan 2016 23:45:05 GMT']
    [p='Date' q='Fri, 11 Dec 2015 23:45:05 GMT']
    [p='Content-Type' q='text/html; charset=UTF-8']
    [p='Location' q='http://www.google.com/']
  ]
]
[ %body
  [ ~
    [ p=219
        q
      \/'<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">\0a<TITLE>301 Moved</TI\/
        TLE></HEAD><BODY>\0a<H1>301 Moved</H1>\0aThe document has moved\0a<A HREF="http://www.google.com/">her
        e</A>.\0d\0a</BODY></HTML>\0d\0a'
      \/                                                                                                      \/
    ]
  ]
]
~fintud-macrep:dojo> :up &atom 'off'
```

## Marks

We've used predefined marks already, but we haven't yet created
our own marks.  Let's write a sample mark of our own, then chain
it together with some preexisting ones to have fun with type
conversions.

Let's make a small "cord" mark.  "Cord" is a name we use for `@t`
text, but there's no predefined mark for it.  Let's put the following code in:
`/mar/cord.hoon`:

```
/?  314
|_  cod=@t
++  grab
  |%
  ++  atom  |=(arg=@ `@t`(scot %ud arg))
  --
++  grow
  |%
  ++  md  cod
  --
--
```

`/?  314` is the required
version number, just like in apps.  After that everything's in a
`|_`, which is a `|%` core, but with input arguments.  In our
case, the argument is the marked data.

There are three possible top-level arms in the `|_` core,
`++grab`, `++grow`, and `++grad` (which is used for revision
control, covered elsewhere).  `++grab` specifies
functions to convert from another mark to the current mark.
`++grow` specifies how to convert from the current mark to
another one.

In our case, we only define one arm in `++grab`, namely `++atom`.
This allows us to convert any atom to a cord.  `++scot` is a
standard library function in `hoon.hoon` which pretty-prints
atoms of various types.  We want to treat the atom as an
unsigned decimal number, so we give `%ud` and the given argument
to `++scot`.  Thus, the form of an arm in `++grab` is
`|=(other-mark-type this-mark-value)`.

In `++grow`, we just convert to the `md` mark, which is just a
`@t` internally, but it has fancy conversion functions to things
like html.  `++md` isn't a function because the "argument" is
already a `@t`, so we can just produce the new value directly.

Let's play around a bit with this mark.  First, let's take a
marked atom and convert it to our new mark.

```
~fintud-macrep:dojo> &atom 9
9

~fintud-macrep:dojo> &cord &atom 9
'9'

~fintud-macrep:dojo> &cord &atom &cord &atom 9
 '57'
```

ASCII 9 is 57.  There's no requirement, implicit or otherwise,
that conversions back and forth between marks be inverses of each
other.  These are semantic conversions, in that they refer to the
same concept.  They're not isomorphisms.

Let's play around a little more:

```
~fintud-macrep:dojo> &md &cord &atom 17
'17'

~fintud-macrep:dojo> &hymn &md &cord &atom 17
[ [%html ~]
  [[%head ~] ~]
  [[%body ~] [g=[n=%pre a=~] c=~[[g=[n=%$ a=~[[n=%$ v="17"]]] c=~]]] ~]
  ~
]
```

That was exciting.  If you squint at that,  it looks an
awful lot like html.  Our value `17` is still in there, in the
body.  `urb` is the mark we render most web pages to.  It makes
sure you have a complete skeleton of a web page.  Of course, by
the time this gets to the web page, it's plain html.  Let's do
the final step in the conversion.

```
~fintud-macrep:dojo> &mime &hymn &md &cord &atom 17
[[%text %html ~] p=52 q='<html><head></head><body><pre>17</pre></body></html>']
```

This is a mime-typed octet stream with type `/text/html`, length
121 bytes, and our lowly number `17` rendered to a web page.
`cord` was just one step in the chain.

Of course, arvo can infer some parts of this chain:

```
~fintud-macrep:dojo> &cord 17
'17'
```

Likewise, `md` is the only way to get from `cord` to `hymn`, so
that can be omitted.  If we omit the `hymn`, though, we get:

```
~fintud-macrep:dojo> &mime &cord 17
[[%text %x-markdown ~] p=2 q='17']
```

Here, we converted straight from `cord` to `md` to `mime`.  Arvo
decided that was the most straightforward conversion, but it
gives a different result than passing it through the `hymn`
mark.

The minimal correct input, then, is `&mime &hymn &cord &atom 17`.

## Network Messages

In the following we assume that you have some knowledge of Hoon.  If you don't, check out chapters 1 and 2 of the Hoon tutorial and check back when you're ready.

Let's get our planets to talk to each other.  To listen for and receive messages from other planets, we'll need an app. Let's look at a very simple one, `echo.hoon`:

```
::  Accepts any noun from dojo and prints it out
::
::::  /===/app/echo/hoon
  ::
!:                          :: enables debug printfs
|%                          :: forms a core with subject as payload
+$  move  [bone card]       :: defines echo app's arvo move mold
+$  card  $%  $~            :: defines card (data) mold as null tagged union
          ==                :: end of mold definition; see $%
--                          :: end of card arm definition
::                          ::
|_  [bow=bowl:gall $~]      :: forms a core with bowl (app state) as sample
++  poke-noun               :: begin definition of poke-noun arm
  |=  non=*                 :: forms a gate which accepts any noun
  ^-  [(list move) _+>.$]   :: casts product to mold of moves and context
  ~&  echo+noun+non         :: debug printf, i.e. '[%echo %noun *]'
  [~ +>.$]                  :: produce a cell of empty list and our state
--                          :: end of poke-noun arm definition
```

Save this as `echo.hoon` in the `/app` directory of your urbit's pier.

This is a very simple app that does only one thing. If you poke it with
a value, it prints that value out. To try this out, you have to start
the app, then you can poke it from the command line with the following
commands:

```
~fintud-macrep:dojo> |start %echo
>=

~fintud-macrep:dojo> :echo 5
[%echo %noun 5]
>=

~fintud-macrep:dojo> :echo [1 2]
[%echo %noun [1 2]]
>=
```

> There is currently a bug where the `[%echo %noun *]` lines are printed **above** the line you entered, so your output may not look exactly like this. `>=` means that a command was successfully received and executed.

Most of the app code should be simple enough to guess its function. The
important part of this code is the definition of `++poke-noun`.

Once an app starts, it's always running in the background and you interact with
it by sending it messages. The most straightforward way to do that is to poke it
from the command line, which we we did with `:echo 5`
(`:[app-name] [argument(s)]`).

In this case, `++poke-noun` takes an argument (**sample**) `arg` and
prints it to dojo with `~&` ([sigpam](/docs/reference/hoon-expressions/rune/sig#sigpam/)).
This is an unusual rune that formally "does nothing", but the interpreter
detects it and printfs the first child, before executing the second as if the
first didn't exist. This is a slightly hacky way of printing to the console,
but we'll get to the correct way later on.

But what does `++poke-noun` produce? Recall that `^-` casts to a type. In this
case, it's declaring that the end result (**product**) of the function
(`++poke-noun`'s **gate**) will be of type `[(list) _+>.$]`. But what does this
mean?

The phrase to remember is "a list of moves and our state". Urbit is a message
passing system, so whenever we want to do something that interacts with the rest
of the system, we send a message. Thus, a move is Arvo's equivalent of a
syscall. The first thing that `++poke-noun` produces is a list of messages,
called "moves". In this case, we don't actually want the system to do anything,
so we produce the empty list, `~` (in the `[~ +>.$]` line).

The second thing `++poke-noun` produces is our state. `+>.$` refers to a
particular address in our subject where our formal app state is stored.
It'll become clear why this is later on, but for now pretend that `+>.$`
is a magic invocation that means "app state".

Let's look at another example. Say we want to
only accept a number, and then print out the square of that number.

```
::  Accepts an atom from the dojo and squares it.
::
::::  /===/app/square/hoon
  ::
!:
|%                                                  ::  no moves in :square
+$  move  [bone card]                               ::  no cards in :square
+$  card  $%  $~
          ==
--
::                                                  ::  stateless
|_  [bow=bowl:gall $~]
++  poke-atom
  |=  tom=@
  ^-  [(list move) _+>.$]
  ~&  square+(mul tom tom)
  [~ +>.$]
--
```

Save this as `square.hoon` in the `/app` directory of your urbit's pier.

A few things have changed. Firstly, we no longer accept arbitrary nouns because
we can only square atoms (integers, in this case an unsigned one). Thus, our
argument is now `tom=@`. Secondly, it's `++poke-atom` rather than `++poke-noun`.

### Intro to marks

Are there other `++poke`s? Yes. In fact, `noun` and `atom` are just two
of arbitrarily many "marks". A mark is fundamentally a type definition,
but accessible at the Arvo level. Each mark is defined in the `/mar`
directory. Some marks have conversion routines to other marks, and some
have diff, patch, and merge algorithms. None of these are required for a
mark to exist, however.

`noun` and `atom` are two predefined marks. In your `/mar` directory,
there are already many more, and you may add more at will. The type
associated with `noun` is `*`, and the type associated with `atom` is
`@`.

When we poke an app from anywhere, we do so with a mark that searches
for the corresponding (`++poke-[mark]`) arm. Data constructed on the
command line is by default marked with `noun`. In this case, the app is
expecting an atom, so we have to explicitly mark the data with `atom`
using `&[mark]`. Try the following commands:

```
~fintud-macrep:dojo> |start %square
>=

~fintud-macrep:dojo> :square 6
gall: %square: no poke arm for noun

~fintud-macrep:dojo> :square &atom 6
[%square 36]
>=
```

> Recall the bug where `%square` may get printed above the input line.

Marks are powerful, and they're the backbone of Urbit's data pipeline,
so we'll be getting quite used to them.

**Exercise**:

- Write an app that computes fizzbuzz on its input.

#### Sending a message to another urbit

Let's write our first network message! Here's `examples/app/pong.hoon`:

```
::  Allows one urbit to send the string 'Pong' to
::  another urbit.
::
::::  /===/app/pong/hoon
  ::
!:
|%
+$  move  [bone card]
+$  card  $%  [$poke wire dock poke-contents]
          ==
+$  poke-contents  $%  [$atom @]
                   ==
--
|_  [bow=bowl:gall $~]                                    ::  stateless
::
++  poke-urbit
  |=  to=ship
  ^-  [(list move) _+>.$]
  ~&  pong+'Outgoing pong!'
  :_  +>.$
  ~[[ost.bow %poke /sending [to dap.bow] %atom 'Pong']]
::
++  poke-atom
  |=  tom=@
  ^-  [(list move) _+>.$]
  ~&  pong+'Incoming pong!'
  ~&  pong+received+`@t`tom
  [~ +>.$]
::
++  coup  |=(* [~ +>.$])
::
--
```


Run it with these commands:

```
~fintud-macrep:dojo> |start %pong
>=

~fintud-macrep:dojo> :pong &urbit ~sampel-sipnym
>=
```

Replace `~sampel-sipnym` with another urbit. The easiest thing to do is to start
a comet, a free and disposable Urbit identity. If you don't know how to start a
comet, see [the user setup section](/docs/getting-started/). Don't forget to start
the `%pong` app on that urbit, too. You should see, on the foreign
urbit, this output:

```
[%pong 'Incoming pong!']
[%pong %received 'Pong']
```

Most of the code should be straightforward. In `++poke-atom`, the only new thing
is the expression `` `@t`tom ``, which is **casting** the argument `tom` to type
`@t`. As we already know, `@t` is the type of "cord" (text string).

The more interesting part is in `++poke-urbit`. The `urbit` mark is an urbit
identity, and the Hoon type associated with it is `ship` or `@p` (the "p"
stands for "phonetic base").

Recall that in a `++poke` arm we produce "a list of moves and our state". Until
now, we've left the list of moves empty, since we haven't wanted to tell Arvo to
do anything in particular. Now we want to send a message to another urbit. Thus,
we produce a list with one element:

```
~[[ost.bow %poke /sending [to dap.bow] %atom 'Pong]]
```

#### Moves

The general form of a move is `[bone term wire *]`.

Or, in pseudo-code:

`["cause" sys-call/action tack-new-layer-on-cause action-specific information]`

Let's walk through each of these elements step by step.

###### Bones ("cause")

If you look up `++bone` in `hoon.hoon`, you'll see that it's a number (`@ud`),
and that it's an opaque reference to a duct. `++duct` in `hoon.hoon` is a list
of `wire`s, where `++wire` is an alias for `++path`. `++path` is a list of
`++knot`s, which are ASCII text. Thus, a duct is a list of paths, and a bone is
an opaque reference to it (in the same way that a Unix file descriptor is an
opaque reference to a file structure). Thus, to truly understand bones, we must
understand ducts.

A duct is a stack of causes, again, represented as paths, which are called wires.
At the bottom of every duct is a unix event, such as a keystroke, network
packet, file change, or timer event. When Arvo is given this event, it routes
the event to appropriate kernel module for handling.

Sometimes, the module can immediately handle the event and produce any necessary
results. For example, when we poked the `++poke-atom` arm above, we poked %gall,
our application server, which was able to respond to our poke directly. When the
module cannot service the request itself, it sends instructions to another
kernel module or application (through the %gall module) to do a specified
action, and produces the result from that.

Furthermore, when one module sends a message to another kernel module or
application, it also sends along the duct it was given with its new wire tacked
onto the top. Now the duct has two entries, with the unix event on the bottom
and the kernel module that handled it on top. This process can continue
indefinitely, pushing more and more wires onto the top of the duct. When an
entity finally produces a result, a wire is popped off the duct, and the result
is passed all the way back down, repeating the process of wire popping
sequentially until the bottom of the duct is reached.

In effect, a duct is an Arvo-level call stack. It's worth noting that while in
traditional call stacks a function call happens synchronously and returns
exactly once. In Arvo, multiple moves can be sent at once, are evaluated
asynchronously, and each one may be responded to zero or more times.

The point to take home is that whatever caused `++poke-urbit` to be called is
also the root cause for the network message we're trying to send. Thus, we say
to send the network message along the given bone `ost`.

##### Wire (path)

Of course, we have to push a new wire onto our duct before passing it along (or
responding to it directly) anywhere. This wire can have any data we want in it,
but we don't need anything specific here, so we just use the wire `/sending`
(`/elem1/elem2/elemN` is one syntax used to create `++path`s and `++wire`s of N
elements). If we were expecting a response (which we're not), it would come back
along the `/sending` wire, meaning that the path `/sending` will be passed back
to the response handler as an argument. Although it's not required, it's
generally a good idea to make the wire human-readable for bug-handling purposes.

##### Term (sys-call)

Each move also has a `term`, composed of lowercase ASCII and/or `-`. This `term`
has the sign `@tas`. In this case, our `term` is `%poke`, which is the name of
the particular kind of move we're sending. You can always use `%poke` to message
an app. Other common names include `%warp`, to read from the filesystem;
`%wait`, to set a timer; and `%them`, to send an http request.

The move ends with `*` (that is, any noun) since each type of move takes
different data. In our case, a `%poke` move takes a target (urbit and app) and
marked data, then pokes the arm of the corresponding mark on that app on that
urbit with that data. `[to-urbit-address %pong]` is the target urbit and app,
`%atom` is the `mark`, and`'Pong'` is the data.

When Arvo receives a `%poke` move, it calls the appropriate `++poke`.
The same mechanism is used for sending messages between apps on the same
urbit as for sending messages between apps on different urbits.

> We said earlier that we're not expecting a response. This is not entirely true: the `++coup` is called when we receive acknowledgment that the `++poke` was called. We don't do anything with this information right now, but we could.

**Exercises**:

- Extend either of the apps in the first two exercises to accept input over the network in the same way as `pong`.

- Modify `pong.hoon` to print out a message when it receives acknowledgement.

- Write two apps, `even` and `odd`. When you pass an atom to `even`, check whether it's even. If so, divide it by two and recurse; otherwise, poke `odd` with it. When `odd` receives an atom, check whether it's equal to one. If so, terminate, printing "%success". Otherwise, check whether it's odd. If so, multiply it by three, add one, and recurse; otherwise, poke `even` with it. When either app receives a number, print it out along with the name of the app. In the end, you should be able to watch Collatz's conjecture play out between the two apps. Sample output:

```
~fintud-macrep:dojo> :even &atom 18
[%even 18]
[%odd 9]
[%even 28]
[%even 14]
[%odd 7]
[%even 22]
[%odd 11]
[%even 34]
[%odd 17]
[%even 52]
[%even 26]
[%odd 13]
[%even 40]
[%even 20]
[%even 10]
[%odd 5]
[%even 16]
[%even 8]
[%even 4]
[%even 2]
%success
```

- Put `even` and `odd` on two separate urbits and pass the messages over the network. Post a link to a working solution in :talk to receive a cookie.


## Security Drivers

A security driver is a file in `/=home=/sec/<tld>/<domain>/hoon`
that handles the authentication for all HTTP requests to
`https://<domain>.<tld>`.  When anything in Urbit makes an HTTP
request through `%eyre` (our web server), it checks to see if we
have a security driver for the requested domain, and if so
filters the request through the driver.  The security driver will
usually either decorate the request with the needed credentials
if it has them, or else it will guide the user through the
process of authenticating Urbit with the service.

Each web service needs its own security driver, but most of them
are pretty standard.  We recommend starting with an existing
security driver based on your needed authentication method (e.g.
basic auth, OAuth1, OAuth2), and changing whatever is specific to
your service.

The best strategy for building security drivers is to copy a
similar one and tweak it until it works for you.  The best
representatives are Github for Basic Authentication, Twitter for
OAuth1, Slack for OAuth2 when access tokens don't expire, and
Google APIs for OAuth2 when access tokens do expire.  In most
cases you'll need to make very few changes to one of these
models.

Still, it's worth seeing one or two built from the ground up.
Here, we'll build a connector for the Github API v3.  (It's already in `/sec/com/github.hoon` if you want to see it.)

The
simplest way to interact with the Github API is to just fetch
https://api.github.com from the dojo.  First, run this:

```
> |init-auth-basic /com/github
```

Input your Github username and password as directed.  Next:

```
~your-urbit:dojo> +https://api.github.com
```

> Note: the current version of this API is outdated, so you'll get a 403 message at this point.  We need to update this so you can follow along with the examples.  We're sorry!

Github exposes a few endpoints to the general web, and the root
endpoint is one of them.  This gives you a textual representation
of a JSON object that contains a bunch of urls to other parts of
Github's API.  This is exactly the same response you would get
from just running `curl https://api.github.com` on UNIX.

If we don't have a security driver for Github yet, many of the
endpoints won't be accessible, or they will only have publicly
accessible information.  Most of what we care about requires us
to be authenticated.

#### Basic auth

Here's a simple security driver:

```
::  Test url +https://api.github.com/user
::
::::  /hoon/github/com/sec
  ::
/+    basic-auth
!:
|_  [bal=(bale keys:basic-auth) $~]
++  aut  ~(standard basic-auth bal ~)
++  filter-request  out-adding-header:aut
--
```

Github supports authentication through either Basic
Authentication or OAuth2.  We'll show the basic auth example
first, but in general we'd prefer OAuth2.

Since this driver is for Github, put it in
`/=home=/sec/com/github/hoon`.

To try this out, we first have to initialize our credentials with
`|init-auth-basic`, which prompts for the url of the service
(api.github.com), username, and password.  It stores this
information in a manner that `%eyre` knows how to decode and send
put into your `bale`.  Note that `|init-auth-basic` is standard for
basic auth, but other auth schemes (like OAuth) are initialized
in other ways.

After you've run `|init-auth-basic`, you should be able to run
`+https://api.github.com/user` and get a response indicating who
you're logged in as.

You can similarly POST:

```
~your-urbit:dojo> +https://api.github.com/gists &json _(cork de-json:html need) '{"files":{"file1.txt":{"content":"can\'t stop the signal"}}}'
```

This creates a gist, go to `https://gist.github.com/<username>` to
see it.

The `+url` syntax used in "source" position makes a GET request,
but if you pass it data it will make a POST request with that
data as the body.  This request is authenticated seamlessly.  You
can send data of any mark as long as it has a conversion path to
`%mime`.

Let's take a look at the code and see if we can figure out what's
happening here:

```
/+    basic-auth
```

First, we load a library called `basic-auth`.  This library
exposes two items.  `keys` is the type of the basic auth key,
which is essentially a base64'd username and password.
`standard` accepts a `bale` and produces a core with everything
we'll need to implement basic auth.

Every security driver needs some amount of state, which is stored
in `bale`.  `bale` contains:

- `our`, our urbit name
- `now`, the current time
- `eny`, 256 bits of entropy
- `byk`, the urbit, desk and case which the security driver is running from
- `usr`, the particular identity we're logging in with
- `dom`, the site we're accessing
- `key`, the secrets required to authenticate requests.  The type for this entry is supplied by the programmer as the argument to `++bale`.  Thus, in our case, `key` in our bale is of type `keys:basic-auth`.

Additionally, a security driver contains at least one out of the
five "special" arms:

- `++filter-request` is a function which takes a hiss (http request) and produces a `sec-move` (defined in zuse), which is one of:
  - `[%send hiss]`, which sends the new hiss.  This is the case in, for example, basic auth, where all we need to do is add an extra header to the request.
  - `[%give httr]`, where httr is an http response.  This immediately returns an http response to the sender.
  - `[%show purl]`, where a purl is a parsed url.  This displays a message asking the user to visit the given url to continue the authentication process.
  - `[%redo ~]`, which redoes the request.
  - `%eyre` calls `++filter-request` just before sending an HTTP request to the specified domain.  This allows the security driver to filter the requests, decorating them with authentication data.
- `++filter-response` is a function which takes an httr and produces a `sec-move`.  `%eyre` calls it after receiving an HTTP response from the specified domain.  This allows the security driver to handle authentication errors, commonly caused by expired tokens, and retry the request.
- `++receive-auth-query-string` is a function that takes a `quay` (list of query parameters) and produces a `sec-move`.  `%eyre` calls it when it receives a request on the callback url. Generally, this happens in OAuth after the user has granted access to the urbit app, and the service makes a request to the callback url with the code.  The security driver should then make a request to convert the code into an access token.
- `++receive-auth-response` is a function that takes an httr and produces a `sec-move`.  `%eyre` calls it when it gets a response to the request made in `++receive-auth-query-string`.
- `++update` is a function which converts old state to a new format when the security driver gets updated.  If you want to just get rid of the old state, define `++discard-state` as `~`.

For basic auth, we only have to worry about `++filter-request`,
since all we need to do is add the correct header to each
request.  Our `++aut` core contains a function
`++out-addding-header`, which does exactly what we want.

Where do the keys come from, though?  Remember we ran
`|init-auth-basic` to input them.  This just prompts you for the
service url, username, and password, and it stores them next to
the driver.  In our case, that's
`/=home=/sec/com/gitub/api/atom`.  These keys are stored
encrypted, and you don't want to edit them directly.  `%eyre`
loads them directly into your `bale`.

#### OAuth2

Most services are better accessed through some form of OAuth.
Github can be accessed with OAuth2, which is a little more
complicated than basic auth, but not hugely so.

The basic steps for OAuth2 are these:

- create an app and get its client id and client secret (on Github)
- store these in Urbit (with `|init-oauth2`)
- try to make a request that requires authentication.  The security driver should prompt you to visit a particular url.
- visit the url and click "authorize", which gives the app access to your account
- the security driver will turn the code it receives into an access token
- on every request, include that access token

Creating an app is easy and
[well-documented](https://github.com/settings/applications/new).
If necessary, set the callback url to
`/~/ac/github.com/_state/in`, and note its client id and client
secret.

Run `|init-oauth2`, which will prompt for the hostname
(api.github.com), client id, and client secret.  This will store
the information, encrypted, in `/=home=/sec/com/github.atom`,
just as with Basic Authentication.

Now we need a security driver.  Use this:

```
::  Test url +https://api.github.com/user
::
::::  /hoon/github/com/sec
  ::
/+    oauth2
!:
::::
  ::
|_  [bal=(bale keys:oauth2) tok=token:oauth2]
++  scopes                          ::  comment out scopes to taste
  :~  'user'  'user:email'  'user:follow'  'public_repo'  'repo'
      'repo_deployment'  'repo:status'  'delete_repo'  'notifications'
      'gist'  'read:repo_hook'  'write:repo_hook'  'admin:repo_hook'
      'admin:org_hook'  'read:org'  'write:org'  'admin:org'
      'read:public_key'  'write:public_key'  'admin:public_key'
  ==
::  ++aut is a "standard oauth2" core, which implements the
::  most common handling of oauth2 semantics. see lib/oauth2 for more details,
::  and examples at the bottom of the file.
++  aut  (~(standard oauth2 bal tok) . |=(tok/token:oauth2 +>(tok tok)))
++  filter-request
  %^  out-add-query-param:aut  'access_token'
    scope=~[%client %admin]
  oauth-dialog='https://github.com/login/oauth/authorize'
::
++  receive-auth-query-string
  %-  in-code-to-token:aut
  url='https://github.com/login/oauth/api/access_token'
++  receive-auth-response  bak-save-token:aut
--
```

The oauth2 library provides the main "engine" in `standard`, just
like in basic auth, except that we also have to specify a
function to save the access token when we get it.  It's worth
noting that this library is well documented in the source,
including examples: `/=home=/lib/oauth2/hoon`.

Running `+http://api.github.com/user` tries to make a request to
Github with authentication.  This loads into the bale the keys,
which are of type `keys:oauth2`, defined in the oauth2 library.
We don't have to worry about the specifics of these keys -- the
library handles them -- but they include the client id and the
client secret.

Before the request is sent, `%eyre` calls `++filter-request` to
decorate it with authentication headers.  Since we don't yet have
an access token, we need to prompt the user to visit the "dialog"
url.  `++out-add-query-param` checks whether we have a token, and
if we don't it produces `%show` and a message telling the user to
visit the `oauth-dialog` url we provide, with the extra query
parameters added (client id, scopes, and state).

When the user visits that url, Github will ask them to log in and
authorize the application.  When they do so, Github will post a
request to `/~/ac/github.com/_state/in` with a code in the query
string.  `%eyre` sends the query string to
`++receive-auth-query-string`, which is a function that takes a
quay and produces a `sec-move`.  `++in-code-to-token` from our
`aut` takes the `code` parameter from the quay and uses it to
create a request to the given url.  This request includes the
client id, the client secret, and the code we just got.

Github's response to that request includes an access token in its
body.  This is handled in `++receive-auth-response`.
`++bak-save-token` extracts that token and gives it to the
function that we passed in the definition of `++aut`.  In our
case, we just save that token into our state for later usage.

Now we have the credentials we need, so `++filter-request` is
called with the original request, and `++out-add-query-param`
passes the request through with the addition of the query
parameter `access_token`.

Just like with Basic Authentication, you should be able to run
`+https://api.github.com/user` and get a response indicating who
you're logged in as.

Some drivers a slightly more complicated.  For example, Github's
access token's don't expire, but that's not the case for all
service.  The googleapis driver shows the flow when the access
token can expire.  Twitter uses OAuth1, for which we have another
library.

Remember, of course, that the best strategy for building security
drivers is to copy a similar one and tweak it to taste.

## State

In the last section we built a few small apps that sent moves. These apps were
entirely stateless, however. Most useful apps require some amount of state.
Let's build a trivial stateful app. It'll keep a running the sum of all the
atoms we poke it with. Here's `examples/app/sum.hoon`:

```
::  Keeps track of the sum of all the atoms it has been
::  poked with and prints the sum out
::
::::  /===/app/sum/hoon
  ::
!:
|%
+$  move  [bone card]
+$  card  $%  $~
          ==
--
|_  [bow=bowl:gall sum=@]
::
++  poke-atom
  |=  tom=@
  ^-  [(list move) _+>.$]
  ~&  sum+(add sum tom)
  [~ +>.$(sum (add sum tom))]
::
++  coup
  |=  [wir=wire err=(unit tang)]
  ^-  [(list move) _+>.$]
  ?~  err
    ~&  sum+success+'Poke succeeded!'
    [~ +>.$]
  ~&  sum+error+'Poke failed. Error:'
  ~&  sum+error+err
  [~ +>.$]
::
--
```

We can start it with `|start %sum`, and then run it:

```
~fintud-macrep:dojo> :sum &atom 5
[%sum 5]
>=

~fintud-macrep:dojo> :sum &atom 2
[%sum 7]
>=

~fintud-macrep:dojo> :sum &atom 15
[%sum 22]
>=
```

We can see that app state is being saved, but when, where, and how?

The state is stored as the second thing in the `|_` line. In our case, it's
simply an atom named `sum`. We change it by producing our state not with
`+>.$` (as before), but with `+>.$(sum (add sum tom))`. We've seen all these
parts before, but you might not recognize them.

Recall in the first chapter that we recursed with the expression
`$(b (add 3 b))`. This meant "produce `$` with `b` changed to `(add 3 b)`.
Similarly, `+>.$(sum (add sum tom))` means "produce `+>.$` (i.e. our
context, which contains our state) with `sum` changed to `(add sum tom)`.

At a high level, then, when we handle state, we do it explicitly. It's passed in
and produced explicitly. In Unix systems, application state is just a block of
memory, which you need to serialize to disk if you want to keep it around for
very long.

In Urbit, app state is a single (usually complex) value. In our example, we have
very simple state, so we defined `sum=@`, meaning that our state is an atom.
Of course, `sum` is just a name, and you're free to name your state whatever
you like. But let's clarify a couple other things before we continue.

First, `bowl` is a set of general global states. This set is managed by the
system. It includes things like `now` (the current time), `our` (our urbit
identity), and `eny` (512 bits of guaranteed-fresh entropy). For the full list
of things in `++bowl`, search for `++  bowl` (note: two spaces) in
`/arvo/zuse.hoon`.

> This is, perhaps, the most common way to learn Hoon. The easiest way to learn about an identifier you see in code is to search in `/arvo/sys/zuse.hoon` and `/arvo/sys/hoon.hoon` for it.\\ Urbit's codebase is less than 30000 lines of code combined, including the hoon parser, the compiler, and the `/arvo` microkernel, so you can usually use the code and its comments as a reference doc. You can also read [zuse.hoon](https://github.com/urbit/urbit/blob/master/pkg/arvo/sys/zuse.hoon) and [hoon.hoon](https://github.com/urbit/urbit/blob/master/pkg/arvo/sys/hoon.hoon) in your browser.

The second thing we should clear up is this: Urbit needs no "serialize to disk"
step. Everything you produce in the app state is persistent across calls to the
app, restarts of the urbit, and even power failure. If you want to write to the
Unix filesystem, you can, but it's not needed for persistence. Urbit has
transactional events, which makes it an [ACID operating
system](https://en.wikipedia.org/wiki/ACID). Thus, you don't have to worry about
persistence when programming in Urbit, or ever go through the hassle of having
to set up and write to a database.

**Exercises**:

- Modify `:sum` to reset the counter when you poke it with 0.

- Write an app called `last` that prints out the previous value you poked it with.

Sample output:

```
~fintud-macrep:dojo> :last 7
[%last 0]
>=

~fintud-macrep:dojo> :last [1 2 3]
[%last 7]
>=

~fintud-macrep:dojo> :last 'howdy'
[%last [1 2 3]]
```


## Subscriptions

We've dealt fairly extensively with "poke" messages to an app, but these
are somewhat limited. A poke is a one-way message, but more often we
want to subscribe to updates from another app. You could build a
subscription model out of one-way pokes, but it's such a common pattern
that it's built into Arvo.

Let's take a look at two apps, `:source` and `:sink`. First,
`:source`:

```
::  Sends subscription updates to sink.hoon
::
::::  /===/app/source/hoon
  ::
!:
::
|%
  +$  move  [bone card]
  +$  card  $%  [%diff diff-contents]
            ==
+$  diff-contents  $%  [%noun *]
                   ==
--
::
|_  [bow=bowl:gall $~]
::
++  poke-noun
  |=  non=*
  ^-  [(list move) _+>.$]
  :_  +>.$
  %+  turn  (prey:pubsub:userlib /example-path bow)
  |=([o=bone *] [o %diff %noun non])
::
++  peer-example-path
  |=  pax=path
  ^-  [(list move) _+>.$]
  ~&  source+peer-notify+'Someone subscribed to you!'
  ~&  source+[ship+src.bow path+pax]
  [~ +>.$]
::
++  coup
  |=  [wir=wire err=(unit tang)]
  ^-  [(list move) _+>.$]
  ?~  err
    ~&  source+success+'Poke succeeded!'
    [~ +>.$]
  ~&  source+error+'Poke failed. Error:'
  ~&  source+error+err
  [~ +>.$]
::
++  reap
  |=  [wir=wire err=(unit tang)]
  ^-  [(list move) _+>.$]
  ?~  err
    ~&  source+success+'Peer succeeded!'
    [~ +>.$]
  ~&  source+error+'Peer failed. Error:'
  ~&  source+error+err
  [~ +>.$]
::
--
```

Save this as `source.hoon` in the `/app` directory of your urbit's pier.

And secondly, `:sink`:

```
::  Sets up a simple subscription to source.hoon
::
::::  /===/app/sink/hoon
  ::
!:
|%
+$  move  [bone card]
+$  card  $%  [%peer wire dock path]
              [%pull wire dock $~]
          ==
--
::
|_  [bow=bowl:gall val=?]
::
++  poke-noun
  |=  non=*
  ^-  [(list move) _+>.$]
  ?:  &(=(%on non) val)
    :_  +>.$(val |)
      :~  :*  ost.bow
          %peer
          /subscribe
          [our.bow %source]
          /example-path
      ==
    ==
  ?:  &(=(%off non) !val)
    :_  +>.$(val &)
    ~[[ost.bow %pull /subscribe [our.bow %source] ~]]
  ~&  ?:  val
        sink+unsubscribed+'You are now unsubscribed!'
      sink+subscribed+'You are now subscribed!'
  [~ +>.$]
::
++  diff-noun
  |=  [wir=wire non=*]
  ^-  [(list move) _+>.$]
  ~&  sink+received-data+'You got something!'
  ~&  sink+data+non
  [~ +>.$]
::
++  coup
  |=  [wir=wire err=(unit tang)]
  ^-  [(list move) _+>.$]
  ?~  err
    ~&  sink+success+'Poke succeeded!'
    [~ +>.$]
  ~&  sink+error+'Poke failed. Error:'
  ~&  sink+error+err
  [~ +>.$]
::
++  reap
  |=  [wir=wire err=(unit tang)]
  ^-  [(list move) _+>.$]
  ?~  err
    ~&  sink+success+'Peer succeeded!'
    [~ +>.$]
  ~&  sink+error+'Peer failed. Error:'
  ~&  sink+error+err
  [~ +>.$]
::
--
```

Save this as `sink.hoon` in the `/app` directory of your urbit's pier (make sure both `source` and `sink` are on the same ship).

Two notes:

- `bowl` is the type of the system state within our app. For example, it includes things like `our`, the name of the host urbit, and `now`, the current time.

- You may have noticed the separate `|%` above the application core `|_`. We usually put our types in another core on top of the application core. We can access these type from our `|_` because in `hoon.hoon` files, all cores are called against each other. (The shorthand for 'called' is `=>`.) Thus, the `|%` with the types is in the context of the `|_`, as it lies above it: `hoon.hoon` `=> |% w types => |_`

Here's some sample output of the two working together:

```
~fintud-macrep:dojo> |start %source
>=

~fintud-macrep:dojo> |start %sink
>=

~fintud-macrep:dojo> :sink %on
[%source %peer-notify 'Someone subscribed to you!']
[%source [%ship ~fintud-macrep] %path /]
[%sink %success 'Peer succeeded!']
>=

~fintud-macrep:dojo> :source 5
[%sink %received-data 'You got something!']
[%sink %data 5]
>=

~fintud-macrep:dojo> :sink %off
>=

~fintud-macrep:dojo> :source 6
>=

~fintud-macrep:dojo> :sink %on
[%source %peer-notify 'Someone subscribed to you!']
[%source [%ship ~fintud-macrep] %path /]
[%sink %success 'Peer succeeded!']
>=

~fintud-macrep:dojo> :source 7
[%sink %received-data 'You got something!']
[%sink %data 7]
>=
```

###### :source

Hopefully you can get a sense for what's happening here. When we poke
`:sink` with `%on`, `:sink` subscribes to `:source`,
and so whenever we poke `:source`, `:sink` gets the update and
prints it out. Then we unsubscribe by poking `:sink` with `%off`, and
`:sink` stops getting updates. We then resubscribe.

There's a fair bit going on in this code. Let's look at `:source`
first.

Our definition of `move` is fairly specific, since we're only going to
sending one kind of move. The `%diff` move is a subscription update, and
its content is marked data which gall routes to our subscribers.

This is a slightly different kind of move than we've dealt with so
far. It's producing a result rather than calling other
code (i.e. it's a return rather than a function call), so if you recall
the discussion of ducts, a layer gets popped off the duct rather than
added to it. This is why no wire is needed for the move -- we won't
receive anything in response to it.

Anyways, there are four functions (arms) inside the `|_`. We already know when
`++poke-noun` is called. `++peer-example-path` is called when someone tries to
subscribe to our app. Of course, you don't just subscribe to an app; you
subscribe to a path on that app. This path comes in as the argument to `++peer`.

In our case, we don't care what path you subscribed on, and all we do is print
out that you subscribed. Arvo keeps track of your subscriptions, so you don't
have to. You can access your subscribers by looking at `sup` in the bowl that's
passed in. `sup` is of type `(map bone {@p path})`, which associates bones with
the urbit who subscribed, and which path they subscribed on. If you want to
communicate with your subscribers, send them messages along their bone.

`++poke-noun` "spams" the given argument to all our subscribers.
There's a few things we haven't seen before. Firstly, `:_(a b)` is the
same as `[b a]`. It's just a convenient way of formatting things when
the first thing in a cell is much more complicated than the second.
Thus, we're producing our state unchanged.

Our list of moves is the result of a call to `++turn`. `++turn` is what many
languages call "map" -- it runs a function on every item in a list and collects
the results in a list. The list is `(prey:pubsub:userlib /example-path bow)` and the function
is the `|=` line right after it.

`prey:pubsub:userlib` is a standard library function defined in `zuse.hoon`. It takes a path
and a bowl and gives you a list of the subscribers who are subscribed on a path
that begins with the given path. "Prey" is short for "prefix".

Now we have the list of relevant subscribers. This a list of triples,
`[bone @p path]`, where the only thing we really need is the bone, because we
don't need to know their urbit or what exact path they subscribed on. Thus, our
transformer function takes `[o=bone *]` and produces `[o %diff %noun non]`,
which is a move that provides bone `o` with this subscription update:
`[%noun non]`". This is fairly dense code, but what it's doing is
straightforward!

###### :sink

`:source` should now make sense. `:sink` is a little longer, but not much more
complicated.

In `:sink`, our definition of of `++move` is different. All moves start
with a `bone`, and we conventionally refer to the second half as the "card", so
that we can say a move is an action that sends a card along a bone.

We have two kinds of cards here: we `%peer` to start a subscription, and we
`%pull` to stop it. Both of these are "forward" moves that may receive a
response, so they need a wire to tack onto the duct before they pass it on. They
also need a target, which is a pair of an urbit and an app name. Additionally,
`%peer` needs a path on that app to subscribe too. `%pull` doesn't need this,
because its semantics are to cancel any subscriptions coming over this duct. If
your bone and wire are the same as when you subscribed, then the cancellation
will happen correctly.

The only state we need for `:sink` is a boolean to indicate whether
we're already subscribed to `:source`. We use `val=?`, where `?`
is the sign of type boolean (similar to `*`, `@`), which defaults to true (that
is, `0`).

In `++poke-noun` we check our input to see both if it's `%on` and we're
available (`val` is true). If so, we produce the move to subscribe to
`:source`:

```
:~  :*  ost.bow
    %peer
    /subscribe
    [our.bow %source]
    /example-path
    ==
==
```

Also, in the preceding lines, we set `val` to false (`|`) with `+>.$(val |)`.
Remember that the `:_` constructs an inverted cell, with the first child
(`+>.$(val |` in our case) as the tail and the second child as the head. Here,
the cell we produce when our subscription is `%on` and `val` is true has a
head with our new state where `val` is set to false and a tail of our list of
moves, which is shown in the code block above.

Otherwise, if our input is `%off` and we're already subscribed (i.e. `val`
is false), then we unsubscribe from `:source` and set `val` back to true (`&`),
again using our handy inverted cell constructor mold `:_`:

```
:_  +>.$(val &)
~[[ost.bow %pull /subscribe [our.bow %source] ~]]
```

It's important to send over the same bone and wire (`/subscribe`) as the
one we originally subscribed on.

If neither of these cases are true, then we print our current subscription
state, based on whether `val` is true or false, and return a cell containing
a null list of moves and our unchanged app state:

```
~&  ?:  val
      sink+unsubscribed+'You are now unsubscribed!'
    sink+subscribed+'You are now subscribed!'
[~ +>.$]
```

`++diff-noun` is called when we get a `%diff` update along a subscription with a
mark of `noun`. `++diff-noun` is given the wire that we originally passed with
the `%peer` subscription request along and the data we got back. In our case we
just print out the data:

```
~&  sink+received-data+'You got something!'
~&  sink+data+non
```

`++reap` is called when we receive an acknowledgment as to whether the
subscription was handled successfully. You can remember that `++reap` is the
counterpart to `++peer` as it's pronounced like 'peer' backwards. Similarly,
`coup` is similar to 'poke' backwards.

Moving forward, `++reap` is given the wire we attempted to subscribe over,
possibly along with an error message in cases of failure. `(unit type)` means
"either `~` or `[~ type]`, which means it's used like Haskell's "maybe" or C's
nullability. If `err` is `~`, then the subscription was successful and we tell
that to the user. Otherwise, we print out the error message.


## Backend

We've done purely functional web pages as hook files, and we've
done command line apps, so now let's interact with an app over
the web.  The fundamental concepts are no different than from the
command line -- you send "poke" messages to apps and subscribe to
data streams.  The only difference is that you do it with
javascript.

Let's create a small web app that counts the number of times you
poke it.  There'll be a button to poke the app, and line of text
below it saying how many times the app has been poked.  We can
update this by subscribing our page to the relevant path on its app.

Save the following as `click.hoon` in the `/app` directory of your urbit's pier.

```
/?    314
!:
|%
++  move  [bone %diff %mark *]
--
!:
|_  [hid=bowl:gall clicks=@]
++  poke-click
  |=  click=%click
  ~&  [%poked +(clicks)]
  :_  +>.$(clicks +(clicks))
  %+  turn  (prey:pubsub:userlib /the-path hid)
  |=([o=bone *] [o %diff %clicks +(clicks)])
++  peer-the-path
  |=  pax=path
  [[[ost.hid %diff %clicks clicks] ~] +>.$]
--
```

There's nothing really new here, except that we use a couple of
new marks, `click` and `clicks`.  When we get poked with a
`click`, we increment the variable `clicks` in our state and tell
all our subscribers the new value.  When someone subscribes to us
on the path `/the-path`, we immediately give them the current
number of clicks.

Let's take a look at the new marks.  Save this as `/mar/click.hoon`:

```
|_  click=%click
++  grab
  |%
  ++  noun  |=(* %click)
  ++  json
    |=  jon=^json
    ?>  =('click' (need (so:dejs-soft:format jon)))
    %click
  --
--
```

The mark `click` has type `%click`, which means the only
valid value is `%click`.  We can convert from `noun` by just
producing `%click`.

We also convert from json by parsing a json string with `so:dejs-soft:format`,
asserting the parsing succeeded with `need`, and asserting the
result was 'click' with `?>`, which asserts that its first child
is true.

> Note the argument to `++json`is `jon=^json`.  Why `^json`? `++json` shadows the type definition, so if we want to refer to the type, we have to prepend a `^`.  This extends to multiple levels:  `^^^foo` means the fourth most innermost instance of `foo`.

> `dejs-soft:format` in `zuse` is a useful library for parsing complex json into hoon structures. In this case, the `:` between `dejs-soft` and `format` means 'inside of', because `dejs-soft` is an arm contained within the core `format`.  Our case is actually simple enough that the `?>` line could have been `?>  =([%s 'click'] jon)`.

We can test this mark from the command line (don't forget to start your app with `|start %click`)

```
~fintud-macrep:dojo> &click %click
%click

~fintud-macrep:dojo> &click &json [%s 'click']
%click

~fintud-macrep:dojo> &click &json &mime [/text/json (as-octs:mimes:html '"click"')]
%click

~fintud-macrep:dojo> &click &json &mime [/text/json (as-octs:mimes:html '"clickety"')]
/~fintud-macrep/home/0/mar/click:<[7 5].[8 11]>
ford: casting %json to %click
ford: cast %click
```

And save the following as `/mar/clicks.hoon`:

```
|_  clicks=@
++  grab
  |%
  ++  noun  @
  --
++  grow
  |%
  ++  json
    (frond:enjs:format %clicks (numb:enjs:format clicks))
  --
--
```

`clicks` is just an atom.  We convert to json by creating an
object with a single field "clicks" with our value.

> Be sure to check out section 3bD, JSON and XML, in zuse.hoon `frond:enjs:format` is just a function that takes a key-value pair and produces a JSON object with one element.

```
~fintud-macrep:dojo> &json &clicks 6
[%o p={[p='clicks' q=[%n p=~.6]]}]
```

Now that we know the marks involved, take another look at the app
above.  Everything should be pretty straightforward.  Let's poke
the app from the command line.

```
~fintud-macrep:dojo> |start %click
>=
~fintud-macrep:dojo> :click &click %click
[%poked 1]
>=
~fintud-macrep:dojo> :click &click %click
[%poked 2]
>=
```

**Exercise**:

- Modify `:sink` from the subscriptions chapter to listen to `:click` and print out the subscription updates on the command line.

## Frontend

> Note: the instructions below are outdated and do not work in the current version of Urbit.  Feel free to experiment though.

That's all that's needed for the back end.  The front end is just
some "sail" html (Hoon markup for XML) and javascript.  Here's `/web/pages/click.hoon`:

```
;html
  ;head
    ;script(type "text/javascript", src "//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js");
    ;script(type "text/javascript", src "/~/at/lib/js/urb.js");
    ;title: Clickety!
  ==
  ;body
    ;div##cont
      ;input##go(type "button", value "Poke!");
      ;div##err(class "disabled");
      ;div##clicks;
    ==
    ;script(type "text/javascript", src "/pages/click/click.js");
  ==
==
```

You should recognize the sail syntax from an earlier chapter.
Aside from jquery, we also include `urb.js`, which is a framework
for interacting with urbit.

To view the frontend, point your browser at `ship-name.urbit.org/~~/pages/click` if you're on the live network. If you're running a fake galaxy, navigate to whatever port it's running on, which is usually: `https://localhost:80/~~/pages/click`.

We have a button labeled "Poke!" and a div with id `clicks` where
we'll put the number of clicks.  We also include a small
javascript file where the client-side application logic can be
found.  It's in `/web/pages/click.js`:

```
$(function() {
  var clicks, $go, $clicks, $err

  $go     = $('##go')
  $clicks = $('##clicks')
  $err    = $('##err')

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
  window.urb.bind('/the-path',
    function(err,dat) {
      clicks = dat.data.clicks
      $clicks.text(clicks)
    }
  )
})
```

We set up two event handlers.  When we click the button, we run
`window.urb.send`, which sends a poke to the app specified as the first argument, in this case our :click app.  The arguments
are data, parameters, and the callback.  The data is the specific
data we want to send.  The parameters are all optional, but here's a list
of the available ones:

- `ship`:  target urbit.  Defaults to `window.urb.ship`, which
  defaults to the urbit which served the page.
- `appl`:  target app.  Defaults to `window.urb.appl`, which
  defaults to null.
- `mark`:  mark of the data.  Defaults to `window.urb.send.mark`,
  which defaults to "json".
- `wire`:  wire of the poke.  Defaults to `/`.

In our case, we specify only that the mark is "click".

The callback function is called when we receive an
acknowledgment.  If there was an error, we put it in the `err`
div that we defined above.  Otherwise, we printf to the console a
message saying the poke succeeded.  As is common, we gray
out the button when it is clicked. It is only reenabled when positive acknowledgement is received.

Our second event handler is `window.urb.bind`, which is called immediately when the page is loaded, subscribing the page to the specified data stream on the app set with `urb.appl` (which is, in this case, :click).  It also takes three arguments: path, parameters, and callback.  The path is the path on the app to subscribe to.  The parameters are all optional (indeed, we omit them entirely here), but are similar to those for `send`:

- `ship`: target urbit.  Defaults to `window.urb.ship`, which defaults to the urbit which served the page.
- `appl`: target app.  Defaults to `window.urb.appl`, which defaults to null.
- `mark`: mark of expected data.  Data of other marks is converted to this mark on the server before coming to the web front end.  Defaults to `window.urb.bind.mark`, which defaults to "json".
- `wire`: wire of the subscription.  Defaults to the given path.

The callback function here just updates the data in the `clicks`
div.  A truly robust app would intelligently handle errors, of
course.

Note that the app doesn't have anything web-specific in itself.
As far as it knows, it's just receiving pokes and subscriptions.
The javascript is fairly pure as well, sending and receiving json
everywhere.  The marks are the translation layer, and they're the
only things that need to know how the hoon types map to json.

**Exercise**:

- Open the app in multiple tabs, click the button, and verify that all the tabs stay in sink.  Poke it manually from the command line and verify the tabs are updated as well.
