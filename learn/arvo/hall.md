+++
title = "Hall"
weight = 7
template = "doc.html"
+++
> Last major revision of this tutorial: 2017. Some of the information and Hoon syntax here may
  be outdated.


Hall is the Urbit messaging and notifications protocol. This document details Hall's architecture, its interfaces, and the new Gall model it's built to target.

## Table of contents

- [Hall Architecture](#hall-architecture)

- [The Hall Interface](#the-hall-interface)

- [The New Gall Model](#the-new-gall-model)

# Hall Architecture

This document is complemented by Hall's source code, but doesn't require it. Definitions of data structures, code snippets and diagrams will be provided where useful.

Hall's implementation is structured according to the new Gall model. Familiarity with its concepts is assumed. See [the new Gall model](#the-new-gall-model).

## Talk

Talk was Urbit's first big user-facing application. It continues to enjoy a prominent role in the Urbit landscape, but now does so as two separate applications.

The messaging parts of Talk have been separated from its user-interface parts. What we ended up with is a shiny new generic messaging bus, and the chat interface we all know and love. The messaging bus, which should now prove useful to many different applications, will be named `Hall`. Applications that use it are referred to as **clients**. One such application, as you might have guessed, is `:talk`.


## Structures & functionality

### Circles

```
++  circle     {hos/ship nom/term}                      ::  native target
```

A `circle` is essentially a named collection of messages created by and hosted on a ship's Hall, usually represented as `~ship-name/circle-name`. Most of Hall revolves around doing things with circles.

### Messages

When we subscribe to a circle, the primary thing we're interested in is its messages. Message data itself isn't that complicated, but a fair amount of metadata comes into play when actually sending a message. Let's work our way up, starting at the contents.

```
++  speech                                              :>  content body
  $%  {$lin pat/? msg/cord}                             :<  no/@ text line
      {$url url/purf:eyre}                              :<  parsed url
      {$exp exp/cord res/(list tank)}                   :<  hoon line
      {$ire top/serial sep/speech}                      :<  in reply to
      {$fat tac/attache sep/speech}                     :<  attachment
      {$app app/term sep/speech}                        :<  app message
      {$inv inv/? cir/circle}                           :<  inv/ban for circle
  ==                                                    ::
```

At the heart of every message lies a `speech` that describes the message body. There's a large number of different speech types, from simple text messages to parsed URLs, Hoon expressions and more.

```
++  audience   (set circle)                             :<  destinations
++  serial     @uvH                                     :<  unique identifier
++  thought                                             :>  inner message
  $:  uid/serial                                        :<  unique identifier
      aud/audience                                      :<  destinations
      wen/@da                                           :<  timestamp
      sep/speech                                        :<  content
  ==                                                    ::
```

A `speech` is always accompanied by various bits of metadata. We include a unique identifier, a message timestamp and an `audience`, the set of all intended recipients of the message.

```
++  telegram   {aut/ship thought}                       :<  whose message
++  envelope   {num/@ud gam/telegram}                   :<  outward message
```

Finally, before sending the message over the wire, we add on the message's original author. In most cases, we also include a sequence number, the index of the message in the originating circle's list of messages. This can be a useful point of reference for clients.

### Participant metadata

Messages aren't the only thing a subscription gets us. We're also kept up to date with relevant metadata.

```
++  crowd      {loc/group rem/(map partner group)}      :<  our & srcs presences
++  group      (map ship status)                        :<  presence map
++  status     {pec/presence man/human}                 :<  participant
++  presence                                            :>  status type
  $?  $gone                                             :<  absent
      $idle                                             :<  idle
      $hear                                             :<  present
      $talk                                             :<  typing
  ==                                                    ::
++  human                                               :>  human identifier
  $:  han/(unit cord)                                   :<  handle
      tru/(unit truename)                               :<  true name
  ==                                                    ::
++  truename   {fir/cord mid/(unit cord) las/cord}      :<  real-life name
```

`status` is user-set metadata that describes, well, the status of users in a circle. This encompasses their `presence`, which shows their activity, and their `human` identity, which includes their display handle.

For reasons we'll discover shortly, circles keep track of both their own `group` and those of the circles they're subscribed to. `crowd` encapsulates this.

### Configurations

```
++  lobby      {loc/config rem/(map circle config)}     :<  our & srcs configs
++  config                                              :>  circle config
  $:  src/(set circle)                                  :<  active sources
      cap/cord                                          :<  description
      fit/filter                                        :<  message rules
      con/control                                       :<  restrictions
  ==                                                    ::
++  filter                                              :>  content filters
  $:  cas/?                                             :<  dis/allow capitals
      utf/?                                             :<  dis/allow non-ascii
  ==                                                    ::
++  control    {sec/security ses/(set ship)}            :<  access control
```

Another part of metadata we get from circle subscriptions is configurations. Again, circles want to remember their own configuration, as well as those of their subscriptions. But why, precisely?

The `config` structure contains `src`, a set of partners. These indicate the different sources a circle is currently pulling content from. This allows circles to aggregate messages from multiple places. In doing so, it also receives metadata from those places, hence why we have structures for storing "remote" presences and configurations alongside local ones.

Aside from that, `config` contains a description for the circle, which is exactly what it sounds like. It also specifies a `filter`, which are content formatting rules all messages passing through this circle are made to adhere to.

Lastly, there's a `control` structure that contains both a security mode and a list of ships, which is either a white- or blacklist depending on the aforementioned mode. There are four such modes available.

```
++  security                                            :>  security mode
  $?  $channel                                          :<  blacklist
      $village                                          :<  whitelist
      $journal                                          :<  pub r, whitelist w
      $mailbox                                          :<  our r, blacklist w
  ==                                                    ::
```

A `channel` is publicly readable and writable, with a blacklist for blocking.
A `village` is privately readable and writable, with a whitelist for inviting.
A `journal` is publicly readable and privately writable, with a whitelist for authors.
A `mailbox` is readable by its owner and publicly writable, with a blacklist for blocking.

### Stories

To see how that all ties together, we're going to take a look at Hall's state.

```
++  state                                               :>  hall state
  $:  stories/(map term story)                          :<  conversations
      ::  ...                                           ::
  ==                                                    ::
++  story                                               :>  wire content
  $:  grams/(list telegram)                             :<  all messages
      locals/group                                      :<  local presence
      remotes/(map circle group)                        :<  remote presence
      shape/config                                      :<  configuration
      mirrors/(map circle config)                       :<  remote config
      ::  ...                                           ::
  ==                                                    ::
```

Stories are the primary driver behind Hall. They are the structures that are used to power circles, which we can now say are named stories hosted on ships.

With the configuration described above in mind, we can try and imagine the things we can do with stories. Knowing that we can subscribe them to any number of sources, they can function as central hubs for our messaging, aggregate specific kinds of data feeds, or simply accept whatever messages get sent to it like a regular old chatroom.

### General use

Upon initial startup, Hall creates a default story, a mailbox named `inbox`. This mailbox is the primary target for anyone and anything that wants to reach its owner. Applications can use it to send notifications and other information to the user (Hall itself does this as well), and users can use it to send direct messages to each other.

Applications that use Hall, especially clients, are encouraged to use the default mailbox as the primary messaging hub. This way, users can easily switch between different applications without "losing" their subscriptions, message backlog, etc.

As an example, Talk operates like this, serving as an interface for reading from and managing the user's mailbox. Local stories are subscribed to through the `inbox`, which ends up containing all messages the user receives.

### Public membership

To aid in discoverability of circles, it is possible for users to make their participation in any given circle public. This data can then be used by things like profile widgets, or read out directly by other users.


## Interfaces for applications

Applications can interact with Hall in two complementary ways: they can tell it what actions to perform, and they can subscribe to its state and the changes made to it.

### Interactions

Hall can be commanded by poking it with `action`s.

```
++  action                                              :>  user action
  $%  ::  circle configuration                          ::
      {$create nom/term des/cord sec/security}          :<  create circle
      {$delete nom/term why/(unit cord)}                :<  delete + announce
      {$depict nom/term des/cord}                       :<  change description
      {$filter nom/term fit/filter}                     :<  change message rules
      {$permit nom/term inv/? sis/(set ship)}           :<  invite/banish
      {$source nom/term sub/? srs/(set source)}         :<  un/sub to/from src
      ::  messaging                                     ::
      {$convey tos/(list thought)}                      :<  post exact
      {$phrase aud/audience ses/(list speech)}          :<  post easy
      ::  personal metadata                             ::
      {$notify aud/audience pes/(unit presence)}        :<  our presence update
      {$naming aud/audience man/human}                  :<  our name update
      ::  changing shared ui                            ::
      {$glyph gyf/char aud/audience bin/?}              :<  un/bind a glyph
      {$nick who/ship nic/cord}                         :<  new identity
      ::  misc changes                                  ::
      {$public add/? cir/circle}                        :<  show/hide membership
  ==                                                    ::
```

The largest part of these actions concern themselves with managing local circles. `nom` is always the name used to identify the relevant story. To disambiguate between "add" and "delete" type actions (for permissions and subscriptions), a loob `?` is used.

To send messages, two interfaces are available. `%convey` lets you specify all details of the messages, including its timestamp, serial, and fully assembled audience. `%phrase`, on the other hand, takes care of that for you, allowing you to specify just the target partners and message contents.

`%notify` and `%naming` are useful for setting your own presence and nickname in a circle respectively, so others can see if you're active and what to call you by.

"Shared UI" encompasses UI data that should be consistent across applications. For example, if the user sets a local nickname for an identity, they expect to see that nickname regardless of the application they're currently using. The same goes for glyph bindings, for easy audience targeting.

### Queries, prizes and rumors

To receive data from Hall, applications will have to query it. There are two paths that are useful for clients to query. Let's look at them and their results.

```
++  query                                               :>  query paths
  $%  {$client $~}                                      :<  shared ui state
      $:  $circle                                       :>  story query
          nom/naem                                      :<  circle name
          wat/(set circle-data)                         :<  data to get
          ran/range                                     :<  query duration
      ==                                                ::
      ::  ...                                           ::
  ==                                                    ::
++  circle-data                                         :>  kinds of circle data
  $?  $grams                                            :<  messages
      $group-l                                          :<  local presence
      $group-r                                          :<  remote presences
      $config-l                                         :<  local config
      $config-r                                         :<  remote configs
  ==                                                    ::
++  range                                               :>  inclusive msg range
  %-  unit                                              :<  ~ means everything
  $:  hed/place                                         :<  start of range
      tal/(unit place)                                  :<  opt end of range
  ==                                                    ::
++  place                                               :>  range indicators
  $%  {$da @da}                                         :<  date
      {$ud @ud}                                         :<  message number
  ==                                                    ::
++  prize                                               :>  query result
  $%  $:  $client                                       :<  /client
          gys/(jug char (set partner))                  :<  glyph bindings
          nis/(map ship cord)                           :<  nicknames
      ==                                                ::
      {$circle burden}                                  :<  /circle
      ::  ...                                           ::
  ==                                                    ::
++  burden                                              :<  full story state
  $:  gaz/(list telegram)                               :<  all messages
      cos/lobby                                         :<  loc & rem configs
      pes/crowd                                         :<  loc & rem presences
  ==                                                    ::
```

To be clear, the paths for those queries are `/client` and `/circle/[name]/[data]/[start]/[end]`, where data is at least one `circle-data`, and `start` and `end` are optional and can be either a date or a message number.

`/client` queries produce shared UI state. That is, glyph bindings and nicknames.
`/circle` queries produce the entire public state of the requested story, including remotes.

Any changes to the results of these queries are communicated via the following `rumor`s. It's a fairly long list of potential changes,

```
++  rumor                                               :<  query result change
  $%  {$client rum/rumor-client}                        :<  /client
      {$circle rum/rumor-story}                         :<  /circle
      ::  ...                                           ::
  ==                                                    ::
++  rumor-client                                        :<  changed ui state
  $%  {$glyph diff-glyph}                               :<  un/bound glyph
      {$nick diff-nick}                                 :<  changed nickname
  ==                                                    ::
++  diff-glyph  {bin/? gyf/char aud/audience}           :<  un/bound glyph
++  diff-nick   {who/ship nic/cord}                     :<  changed nickname
++  diff-story                                          :>  story change
  $%  {$new cof/config}                                 :<  new story
      {$config cir/circle dif/diff-config}              :<  new/changed config
      {$status cir/circle who/ship dif/diff-status}     :<  new/changed status
      {$remove $~}                                      :<  removed story
      ::  ...                                           ::
  ==                                                    ::
++  rumor-story                                         ::>  story rumor
  $?  diff-story                                        ::<  both in & outward
  $%  {$gram nev/envelope}                              ::<  new/changed msgs
  ==  ==                                                ::
++  diff-config                                         :>  config change
  $%  {$full cof/config}                                :<  set w/o side-effects
      {$source add/? src/source}                        :<  add/rem sources
      {$caption cap/cord}                               :<  changed description
      {$filter fit/filter}                              :<  changed filter
      {$secure sec/security}                            :<  changed security
      {$permit add/? sis/(set ship)}                    :<  add/rem to b/w-list
      {$remove $~}                                      :<  removed config
  ==                                                    ::
++  diff-status                                         :>  status change
  $%  {$full sat/status}                                :<  fully changed status
      {$presence pec/presence}                          :<  changed presence
      {$human dif/diff-human}                           :<  changed name
      {$remove $~}                                      :<  removed status
  ==                                                    ::
++  diff-human                                          :>  name change
  $%  {$full man/human}                                 :<  fully changed name
      {$handle han/(unit cord)}                         :<  changed handle
      {$true tru/(unit truename)}                       :<  changed true name
  ==                                                    ::
```

These are, as enforced by Gall, the changes as they happen. This makes it possible for very minimal Hall clients to be implemented that only display a stream of changes, rather than keeping state themselves.


## Communication between Halls

Halls can communicate with other Halls by sending commands and subscription updates.

### Commands

To request changes to a story, Halls can send `command`s.

```
++  command                                             :>  effect on story
  $%  {$publish tos/(list thought)}                     :<  deliver
      {$present nos/(set term) dif/diff-status}         :<  status update
      ::  ...                                           ::
  ==                                                    ::
```

A `%publish` command contains messages. These are sent to foreign Halls to be published to their stories.

The `%present` command is used for sending status updates about our ship.

### Querying

Halls can query other halls. Here's the peer move we send when we open a query on a foreign circle:

```
:*  ost.bol                                             :<  bone
    %peer                                               :<  move type
    /[our-circle]/[host]/[query-path]                   :<  rumor path
    [host %hall]                                        :<  query target
    /circle/[their-circle]/[data]/[start]/[end]         :<  query path
==                                                      ::
```

Again, the rumor path is what our Hall uses to identify what query a received message originates from. Our circle is specified so that we know what story is interested in the changes we get.

The query path is slightly more interesting. Of course it specifies the name of their story we want to subscribe our story to, but also a "start" and "end". These can (optionally) be used to specify the range of messages we want to get from our query. Once that range has passed, we stop receiving updates.

### Federation implementation

Along the way so far, we've skipped some parts of structures. Most of those relate to federation. Let's see what we missed.

```
++  query                                               :>  query paths
  $%  {$burden who/ship}                                :<  duties to share
      {$report $~}                                      :<  duty reports
      ::  ...                                           ::
  ==                                                    ::
++  prize                                               :>  query result
  $%  {$burden sos/(map term burden)}                   :<  /burden
      ::  ...                                           ::
  ==                                                    ::
++  rumor                                               :<  query result change
  $%  {$burden nom/term rum/rumor-story}                :<  /burden
      ::  ...                                           ::
  ==                                                    ::
++  diff-story                                          ::
  $%  {$bear bur/burden}                                :<  new inherited story
      ::  ...                                           ::
  ==                                                    ::
++  burden                                              :>  full story state
  $:  gaz/(list telegram)                               :<  all messages
      cos/lobby                                         :<  loc & rem configs
      pes/crowd                                         :<  loc & rem presences
  ==                                                    ::
```

We briefly touched upon how federation works on the higher level. On the lower, this is how things go down.

1. When Hall boots on a star or galaxy, it starts querying its parent's `/burden` path. (Galaxies query ~zod.)
2. Upon receiving that query, the parent sends a `%burden` prize containing all state of its channels (fully public circles) to the child. It also subscribes to `/report` on that child.
3. When a new story gets created on the parent, its children get a `%burden` rumor with a `%bear` story diff, and they create a local copy of that channel.
4. When something about a parent's story changes, a `%burden` rumor is sent to all its children (because they're querying `/burden`). The children apply this change to their local version of the story.
5. When a child's story has a `%grams` or `%status` change, a `%burden` rumor is sent to the parent (because they're querying `/report`). The parent applies this change to their local version of the story, and #4 happens.


## Hall implementation

Now that we know what gets sent over the wire and why, let's see what happens whenever such events happen. We won't be covering everything, but enough to illustrate the general flow.

First though, it's useful to understand how Hall's code is structured. It consists of primary cores, designed to work optimally with Gall.

- `++ta` is the transaction core. For every event that happens, be it a poke, peer or diff, the transaction core gets put to work to process it. Once it's done, it produces a list of deltas that describe how our state needs to be modified.
- `++da` is the delta application core. It is used to apply `++ta`'s deltas to our application state, and produce a list of side-effects.

Both those cores also have a core within themselves dedicated solely to dealing with stories, `++so` and `++sa` respectively.

Once all work in an engine core has finished, its `-done` arm is called to produce the result of all the core's computation.

In the diagrams that follow, regular lines indicate flows that always happen. Dashed lines indicate flows that are traversed if the described condition is met.
Below the diagrams you will find brief explanations of the involved arms. In a particularly bright future, these might be available on-hover instead.
For brevity, utility arms that aren't a direct and important part of the flow have been omitted.

(You will find that the origins still use old Gall arms, with some glue code in between. At the time of writing, new Gall has not yet been implemented, so this will have to do.)

We will only display the delta generation parts of the flow. Delta application is usually implemented simply enough to deduce what it does from looking at the label.

### Subscriptions

Hall-to-Hall subscriptions happen when a source gets added to a story. This is done with a `%source` action, and results in a `%peer` move being sent (prompted by a `%story %follow` delta).
Upon receiving a valid peer on a `/circle` path, the subscribing ship is added to that circle's presence map.

![subscriptions implementation flow](https://media.urbit.org/docs/hall/diagrams/flow-subscriptions.png)

```
++  poke-talk-action      :<  we got poked with an action.
  ++  ta-action           :<  applies an action.
  ++  ta-config           :<  (re)configures a story.
::                        ::
++  peer                  :<  we got peered.
  ++  g-query             :<  resolves query to prize.
  ++  ta-subscribe        :<  act upon subscription.
  ++  so-attend           :<  adds a ship's status to the story.
```

### Rumors

Once a query has opened, Hall will receive updates on it, rumors. The changes describes in these rumors are applied via the following flow.

![rumor implementation flow](https://media.urbit.org/docs/hall/diagrams/flow-rumors.png)

```
++  diff-talk-rumor       :<  we got a query update.
  ++  ta-hear             :<  applies a rumor to the story it's intended for.
  ++  so-hear             :<  applies a %circle rumor to the story.
    ++  so-config-full    :<  splits a %full diff-config into separate changes.
    ++  so-bear           :<  accept burden, assimilate into the story's state.
    ++  so-lesson         :<  sends a report with presences.
```

### Messaging

To send messages, the user sends a `%convey` or `%phrase` action, resulting in a `%publish` command being sent to the involved partners. Receiving a `%publish` command causes its messages to be added to the story through the creation of a `%story %grams` delta.

![messaging implementation flow](https://media.urbit.org/docs/hall/diagrams/flow-messaging.png)

```
++  poke-talk-action      :<  we got poked with an action.
  ++  ta-action           :<  applies an action.
::                        ::
++  poke-talk-command     :<  we get poked with a command.
  ++  ta-apply            :<  applies a command.
  ++  ta-think            :<  consumes each message in the given list.
  ++  ta-consume          :<  conducts a message to each partner in audience.
  ++  ta-conduct          :<  records or sends a message.
    ++  ta-transmit       :<  sends a message to a partner.
    ++  ta-record         :<  stores a message in a story.
    ++  so-learn          :<  either adds or modifies a message.
```


## The future

Hall is neither complete nor perfect. There are features that need to be implemented, varying from small quality of life changes to broad-reaching functionality.

### Features and functionality

To turn Talk into a [sustainable social platform](https://urbit.org/fora/posts/~2017.4.26..18.00.25..b93c~/), it needs a number of things.

We want to have some kind of discoverability for circles. This could be realized by making it possible for users to add friends, who would have their Hall subscribe to a list of circles the added friends are in. The existing public membership functionality can be leveraged for this.

Eventually, content self-moderation might need to be implemented. Users would flag their content if it is potentially offensive. Others would easily be able to filter out content that might offend them.
This functionality brings its own large sets of challenges that need to be tackled.

Additionally, federation might be put to broader use. Knowing that a circle is federated could help fall back to alternative hosts in case the one Hall originally subscribed to is unavailable. Implementation-wise, care would need to be taken for this to not get ugly. Not to mention, when/how would availability of a host be verified?

Other changes that might have a fair impact on the functioning of Hall are un/read states for messages, and being able to use moons to allow your friends to chat with you in a local channel.

More minor functionalities that need to be implemented include:
- Extended permissions management. Being able to black-/whitelist entire ship classes.
- Improved presence functionality. Actually using the presence system, and sending "typing", "idle", etc. statuses.
- Polls.

And, of course, there's a lot that the Talk client can improve on as well.


## Further reading

To gain a more thorough understanding of Hall's inner workings, take a look at its source code. It comes with inline documentation.
[On Github.](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/hall.hoon)

To see an expansive example of a Hall client, take a look at the code of Talk. It, too, comes with inline documentation.
[On Github.](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/talk.hoon)

# The Hall Interface

This document describes the different interfaces Hall provides and the data that is accessible and modifiable through them. Knowledge of the Urbit application model (including [new gall](#the-new-gall-model)) and [Hall's architecture](#hall-architecture) is assumed.

While the structures here are given in Hoon, they match fairly closely to their JSON equivalent. Most important to note is that `$%({$x y/z})` becomes accessible as `json.x.y`.

## Queries

Queries are the paths you pass into `%peer` moves. Internally, they get translated to a `++query` structure for easier handling. We'll be giving examples of valid query paths alongside the structures themselves.

### /client

To be able to keep certain UI elements like glyphs and local nicknames consistent across different Hall clients, they can query Hall for the current UI state.

```
++  query                                               ::
  $%  {$client $~}                                      :<  shared ui state
      ::  ....                                          ::
  ==                                                    ::
```

Valid paths include:

```
:>  all shared ui state
/client
```

#### /client prize

Contains a map of glyphs and the audiences that they map to, as well as a map of ships and their locally set nicknames.

```
++  prize                                               :>  query result
  $%  {$client prize-client}                            :<  /client
      ::  ...                                           ::
  ==                                                    ::
++  prize-client                                        :> shared ui state
  $:  gys/(jug char audience)                           :<  glyph bindings
      nis/(map ship nick)                               :<  local nicknames
  ==                                                    ::
```

#### /client rumor

Contains either a bound or unbound glyph and its target, or a ship with its new nickname. A nickname of `''` means the associated ship no longer has a nickname set for it.

```
++  rumor                                               :>  query result change
  $%  {$client rum/rumor-client}                        :<  /client
      ::  ...                                           ::
  ==                                                    ::
++  rumor-client                                        :<  changed ui state
  $%  {$glyph diff-glyph}                               :<  un/bound glyph
      {$nick diff-nick}                                 :<  changed nickname
  ==                                                    ::
++  diff-glyph  {bin/? gyf/char aud/audience}           :<  un/bound glyph
++  diff-nick   {who/ship nic/nick}                     :<  changed nickname
```


### /public

To aid in circle discoverability, users can add circles to their "public membership" list. This can then be queried for by, for example, a profile page.

```
++  query                                               ::
  $%  {$public $~}                                      :<  public memberships
      ::  ....                                          ::
  ==                                                    ::
```

Valid paths include:

```
:>  all public memberships
/public
```

#### /public prize

Contains the set of circles the user has on their public list.

```
++  prize                                               :>  query result
  $%  {$public cis/(set circle)}                        :<  /public
      ::  ...                                           ::
  ==                                                    ::
```

#### /public rumor

Contains a circle that was either added or removed from the public list.

```
++  rumor                                               :>  query result change
  $%  {$public add/? cir/circle}                        :<  /public
      ::  ...                                           ::
  ==                                                    ::
```

### /peers

To allow a circle owner to inspect who is currently subscribed to their stories, they can issue a query to retrieve subscription data.

```
++  query                                               ::
  $%  {$peers nom/naem}                                 :<  readers of story
      ::  ....                                          ::
  ==                                                    ::
```

Query paths are structured as follows:

```
/peers/[circle-name]
```

Valid paths include:

```
:>  peers for circle %urbit-help
/peers/urbit-help
```

#### /peers prize

Contains a map of ships and the different queries they currently have active for the selected story.

```
++  prize                                               :>  query result
  $%  {$peers pes/(jar ship query)}                     :<  /peers
      ::  ...                                           ::
  ==                                                    ::
```

#### /peers rumor

Contains a ship and a query, and a flag to indicate whether that subscription has started or ended.

```
++  rumor                                               :>  query result change
  $%  {$peers add/? who/ship qer/query}                 :<  /peers
      ::  ...                                           ::
  ==                                                    ::
```

### /circle

Circle queries allow for the retrieving of data from stories. Their messages, configuration, and presences can all be accessed. Since this is a lot of data, there are lots of possibilities for filtering it built in to the query itself.


A quick refresher on the difference between "local" and "remote" presence and configuration: "local" means it pertains to the circle itself; "remote" means it pertains to one of its configured sources. The latter is primarily useful to clients when using a circle for aggregation, like the `%inbox`.

```
++  query                                               ::
  $%  $:  $circle                                       :>  story query
          nom/naem                                      :<  circle name
          wer/(unit circle)                             :<  from source
          wat/(set circle-data)                         :<  data to get
          ran/range                                     :<  query duration
      ==                                                ::
      ::  ....                                          ::
  ==                                                    ::
++  circle-data                                         :>  kinds of circle data
  $?  $grams                                            :<  messages
      $group-l                                          :<  local presence
      $group-r                                          :<  remote presences
      $config-l                                         :<  local config
      $config-r                                         :<  remote configs
  ==                                                    ::
++  range                                               :>  inclusive msg range
  %-  unit                                              :<  ~ means everything
  $:  hed/place                                         :<  start of range
      tal/(unit place)                                  :<  opt end of range
  ==                                                    ::
++  place                                               :>  range indicators
  $%  {$da @da}                                         :<  date
      {$ud @ud}                                         :<  message number
  ==                                                    ::
```

Query paths are structured as follows:

```
/circle/[circle-name]/(from-circle)/[what/data]/(range-start(/range-end))
(from-circle)  :  optional message source, ~ship/circle
[what/data]    :  one or more of grams, group, group-l, group-r,
               :  config, config-l, config-r, combined using /
(range)        :  an optional range with an optional end, its points denoted
               :  in either message number (@ud) or date (@da)
```

Valid paths include:

```
:>  get all messages from circle %urbit-help
/circle/urbit-help/grams
:>  get all messages, all presences and local configs from %urbit-help
/circle/urbit-help/grams/group/config-l
:>  get all messages %urbit-help has heard from its source ~zod/fora
/circle/urbit-help/~zod/fora/grams
:>  get the first 100 messages from %urbit-help
/circle/urbit-help/grams/0/99
:>  get the first 100 messages %urbit-help has heard from its source ~zod/fora
/circle/urbit-help/~zod/fora/grams/0/99
:>  get all messages from %urbit-help, starting now
/circle/urbit-help/grams/group/(scow %da now)
:>  get all messages from %urbit-help, starting now, ending at the 100th message
/circle/urbit-help/grams/(scow %da now)/99
:>  get local presences from %urbit-help for a week
/circle/urbit-help/group-l/(scow %da now)/(scow %da (add now ~d7))
```

#### /circle prize

Contains (where applicable) messages in envelopes (with message numbers), as well as local and remote configurations and presences.

```
++  prize                                               :>  query result
  $%  {$circle package}                                 :<  /circle
      ::  ...                                           ::
  ==                                                    ::
++  package                                             :>  story state
  $:  nes/(list envelope)                               :<  messages
      cos/lobby                                         :<  loc & rem configs
      pes/crowd                                         :<  loc & rem presences
  ==                                                    ::
```

#### /circle rumor

Contains a detailed change description of the data relevant to the query that changed.

Messages are wrapped in envelopes to include their sequence number, and note the source they were heard from. Configuration and status changes specify the circle they apply to.

```
++  rumor                                               :>  query result change
  $%  {$circle rum/rumor-story}                         :<  /circle
      ::  ...                                           ::
  ==                                                    ::
++  rumor-story                                         :>  story rumor
  $%  {$new cof/config}                                 :<  new story
      {$gram src/circle nev/envelope}                   :<  new/changed message
      {$config cir/circle dif/diff-config}              :<  new/changed config
      {$status cir/circle who/ship dif/diff-status}     :<  new/changed status
      {$remove $~}                                      :<  removed story
  ==                                                    ::
++  diff-config                                         :>  config change
  $%  {$full cof/config}                                :<  set w/o side-effects
      {$source add/? src/source}                        :<  add/rem sources
      {$caption cap/cord}                               :<  changed description
      {$filter fit/filter}                              :<  changed filter
      {$secure sec/security}                            :<  changed security
      {$permit add/? sis/(set ship)}                    :<  add/rem to b/w-list
      {$remove $~}                                      :<  removed config
  ==                                                    ::
++  diff-status                                         :>  status change
  $%  {$full sat/status}                                :<  fully changed status
      {$presence pec/presence}                          :<  changed presence
      {$human dif/diff-human}                           :<  changed name
      {$remove $~}                                      :<  removed status
  ==                                                    ::
++  diff-human                                          :>  name change
  $%  {$full man/human}                                 :<  fully changed name
      {$handle han/(unit cord)}                         :<  changed handle
      {$true tru/(unit truename)}                       :<  changed true name
  ==                                                    ::
```


## Actions

Actions can be sent by poking Hall with data marked as `%hall-action`. Actions are used for all user operations. If an error or other unexpected behavior occurs while executing an action, Hall notifies the user by sending an `%app` message to their `%inbox`.

### Circle configuration

Since all of these apply to a specific circle, they all specify a name `nom` of the circle to operate on.

```
++  action                                              :>  user action
  $%  {$create nom/naem des/cord sec/security}          :<  create circle
      {$delete nom/naem why/(unit cord)}                :<  delete + announce
      {$depict nom/naem des/cord}                       :<  change description
      {$filter nom/naem fit/filter}                     :<  change message rules
      {$permit nom/naem inv/? sis/(set ship)}           :<  invite/banish
      {$source nom/naem sub/? srs/(set source)}         :<  un/sub to/from src
      ::  ...                                           ::
  ==
```

`%create`: Creates a circle with description `des` and security mode `sec`. If this mode is a whitelist, the user is automatically added to it.

`%delete`: Deletes the circle. If a reason `why` is provided, posts that as the last message to the circle before deleting it.

`%depict`: Set the description of the circle to `des`.

`%filter`: Set the filter (message sanitation rules) for the circle to `fit`.

`%permit`: Either invite or banish ships to/from the circle, modifying the access control list accordingly. Regardless of whether this actually makes any changes, sends an `%inv` message to the involved ships' `%inbox`es.

`%source`: Add or remove sources to/from the circle, un/subscribing it to/from the `grams`, `group-l` and `config-l` each one.

### Messaging

There are two interfaces for telling Hall to send a message. The first takes entire `thought`s, the second only `speech`es and the audience to send them to.

```
++  action                                              :>  user action
  $%  {$convey tos/(list thought)}                      :<  post exact
      {$phrase aud/audience ses/(list speech)}          :<  post easy
      ::  ...
  ==
```

`%convey`: Sends the thoughts to their audiences.

`%phrase`: Turns the speeches into thoughts by applying sane defaults for metadata (auto-generated `uid`, `now` for `wen`), and then sends those thoughts.

### Personal metadata

These concern the presence users have in circles they are participating in.

```
++  action                                              :>  user action
  $%  {$notify aud/audience pes/(unit presence)}        :<  our presence update
      {$naming aud/audience man/human}                  :<  our name update
      ::  ...                                           ::
  ==
```

`%notify`: Sets the user's presence in the audience circles to `pes`. A good client will automatically set these based on the user's activity. (`%talk` on typing, `%idle` on idle, `%gone` on sign-off.)

`%naming`: Sets the user's name (handle and real name) for the given audience. Good clients can display these in place of ship names.

### Changing shared UI

When the user makes any changes to shared UI elements (elements that should persist between clients), this has to be communicated to Hall.

```
++  action                                              :>  user action
  $%  {$glyph gyf/char aud/audience bin/?}              :<  un/bind a glyph
      {$nick who/ship nic/nick}                         :<  new identity
      ::  ...                                           ::
  ==
```

`%glyph`: Adds or removes a binding of a glyph to an audience.

`%nick`: Sets a local nickname for a ship. An empty nickname `''` means the ship has no nickname.

### Miscellaneous changes

```
++  action                                              :>  user action
  $%  {$public add/? cir/circle}                        :<  show/hide membership
      ::  ...                                           ::
  ==
```

`%public`: Adds or removes a circle to/from the user's public membership list.

# The New Gall Model

This document is complemented by the source code of applications that use the new Gall model (like [Hall](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/hall.hoon)), but doesn't require it. Code snippets will be provided where useful. Some knowledge of Hoon and the functioning of Hoon apps is assumed.

New `%gall` has not yet fully solidified. As such, its structure and naming are tentative.

## Renewing a pillar of Arvo

When you write an app, Gall is responsible for making sure its event arms like `++poke` get called when they need to. In essence, it provides developers with a consistent interface for hooking their app up to the operating system.

It's not doing a lot to make sure this is done in a structured way, though, which results in apps (especially larger ones) feeling like big, tangled messes. Something needs to be done about this.

### Problems

Imagine a `++poke`, `++diff`, or even a `++peer` arm. In current implementations, you'll often see their product defined through cast as the following:
`^-  (quip move +>)`
Or (sadly) more commonly:
`^-  {(list move) _+>.$}`

These arms are producing both side-effects and new state. To do this, their code has to simultaneously figure out "how does this poke/diff/whatever change our state?" and "what side-effects does this change have?"

You'll find that the logic relating to these two often becomes tangled, making the flow of the whole more difficult to understand. And the side-effects more often than not relate to subscriptions, for which the developer may be writing a lot of boilerplate code. Gall currently does not help in either of these places.

> The main significant cost of software development is the cost of untangling what the computer is doing, and or is supposed to be doing, over and over again in your head. Any way of lowering this untangling cost is extremely welcome.

**~sorreg-namtyv**

### Solutions

Let's imagine a world in which Gall **does** help, in both of those places.

It would be wonderful if Gall could take care of all standard subscription management logic for you, and direct the flow of code as it concludes is appropriate. Applications, then, would have to help Gall by providing the different parts of this flow, and providing the checks that allow Gall to make the right decisions. This takes some work out of the developer's hands and results in more structured application code.

If we expand on that a bit, then we can even have Gall help us in untangling state changes from side effects. We do so by separating state changes into two phases: **analyzing** what changes need to be made, and **applying** those changes.

But where do the side-effects go, then? We need to realize there's two kinds: side-effects that are subscription updates, and side-effects that aren't. The latter get produces by applying state changes, while the former get integrated into the Gall flow we described above.

Since subscriptions are essentially queries to an app, requesting a specific part of its data/state, we can deduce subscription updates from state changes. We merely provide the logic, and Gall chains it all together. Having Gall support all this allows us to cleanly and structurally untangle state change analysis, application, and subscription logic into their own arms.

For trivial apps, this might result in some arms with trivial code. Though it may feel like writing cruft, it makes understanding the app just as simple as it actually as. For more complex apps, all logic is no longer a big chunk of "what do we do when x happens?" Rather, it's a few smaller chunks, like "x happened, how does that change our state?" and "if our state changes like y, what does that mean for subscription z?" These are precisely the kinds of questions that application developers should be asked.


## As seen in new Gall

Of course, for the above to be made into reality, Gall will need to see some changes. Let's outline the new structures and the arms they get passed between.

### Structures

This wouldn't be Urbit if we didn't have cool terminology for people to learn. These ones are (for the most part) semantically sensible, and you might already see how they relate to the story above.

`brain`: application state.
`delta`: change to application state.
`opera`: side-effect, operation, move.
`query`: request (to an app) for data on a specific path.
`prize`: query result.
`rumor`: change to a query result.

These should be fairly straightforward. Like packets are to Urbits, `delta`s are to `brain`s and `rumor`s are to `prize`s. If one diligently updates the `prize` they received using all the `rumor`s that are relevant to it, they will always have the same `prize` as if they queried for it all over again.

### Arms

This also wouldn't be Urbit if we couldn't boil that down to a few simple pseudocode functions. Let's try, shall we?

```
++  bake  |=  {brain delta}  ^-  {brain opera}
++  peek  |=  {brain query}  ^-  (unit (unit prize))
++  feel  |=  {query delta}  ^-  (unit rumor)
++  gain  |=  {prize rumor}  ^-  prize

::  for any given brain, delta and query:
.=  (peek brain:(bake brain delta) query)
    (gain rumor:(feel query delta) prize:(peek brain query))
```

There. In the first three arms we already have the bulk of new Gall! `++gain` won't be part of it, since most applications don't need to keep track of `prize`s directly. Those that do may still implement and hook it up themselves though.

Of course, these aren't all of the new Gall arms. Most important to still mention is `++leak`, which takes a `ship` and `query` and checks if the former has permission to ask for the latter.

There's also `++look` for asynchronous reads, `++hear` for subscription updates (rumors), `++fail` for dealing with process errors, `++cope` for dealing with transaction results, and `++pour` for dealing with responses from Arvo.
`++prep`, `++poke` and `++pull` continue to function as they do right now.

For a more verbose specification of all of these, see the new Gall spec.


## By example

To help solidify this and see what this would looks like in the wild, let's make a very simple example app. It's a counter that can go up and down, and can be queried for its value, or whether or not its value is a multiple of x. First we write all the structures that will support our app, and then we implement the arms that operate on them.
(The app code in its entirety can be found [here](example).)

### State & deltas

Below is the application state, and the deltas we'll be using to modify it.

```
|%
++  brain  {num/@ud $~}                                 :<  application state
++  delta                                               :>  state change
  $%  {$increment $~}                                   :<  +1
      {$decrement $~}                                   :<  -1
  ==                                                    ::
```

Fairly simple, right? We store a number, and every change either in- or decrements it.

### Queries & rumors

Let's also define the queries we'll be supporting, their results, and the changes to their results. Instead of only allowing people to query the current number, let's make it a tad more interesting by allowing them to query whether or not the current number is a multiple of something.

```
++  query                                               :>  valid queries
  $%  {$number $~}                                      :<  current number
      {$mul-of val/@ud}                                 :<  is num multiple of?
  ==                                                    ::
++  prize                                               :>  query results
  $%  {$number num/@ud}                                 :<  /number
      {$mul-of mul/?}                                   :<  /mul-of
  ==                                                    ::
++  rumor                                               :>  query result changes
  $%  {$number delta}                                   :<  /number
      {$mul-of mul/?}                                   :<  /mul-of
  ==                                                    ::
--
```

You'll see the `rumor` for a `/number` query just contains a delta. In this specific case, a change in state maps directly to a change to `prize`. For `/mul-of` queries, things aren't that simple.

### Responding to queries

Now, let's implement all the arms that will be called as things start happening. First, we want to implement `++leak`, which checks if a given `ship` is allowed to make a certain `query`. In this case, we're fine with everyone checking out our application's data.

```
|_  {bol/bowl brain}
::
++  leak                                                :>  read permission
  |=  {who/ship qer/query}
  ^-  ?
  &  ::  everyone's allowed
```

Next, let's create the `prize`s for the folks that make it through `++leak`. We'll be producing a `(unit (unit prize))` so we can potentially say `~` for "unavailable" and `[~ ~]` for "invalid query."

```
++  peek                                                :>  synchronous read
  |=  qer/query
  ^-  (unit (unit prize))
  ?-  -.qer
    $number   ``[%number num]
    $mul-of   ?:  =(0 mul.qer)  [~ ~]
              ``[%mul-of =(0 (mod num mul.qer))]
  ==
```


### Updating state & query results

Our app can be queried! If they're interested enough, they'll want to receive updates on that whenever relevant state changes. First, let's see how state changes happen. We still have regular old `++poke` arms, let's use that to prompt our application to change its state.

```
++  poke-loob                                           :>  regular old poke
  |=  inc/?
  ^-  (list delta)
  :_  ~
  ?:  inc  [%increment ~]
  [%decrement ~]
::
++  bake                                                :>  apply delta to state
  |=  del/delta
  ^-  (quip opera +>)
  :-  ~
  ?-  -.del
    $increment  +>(num +(num))
    $decrement  +>(num (dec num))
  ==
```

`delta`s get redirected into `++bake` so that our state can get changed as described. After this happens the same `delta`s get, for each active query, routed into `++feel`. That then figures out what the `rumor` relevant to the query is, if applicable.

```
++  feel                                                :>  delta to rumor
  |=  {qer/query del/delta}
  ^-  (unit rumor)
  ?-  -.qer
      $number
    `[%number del]
    ::
      $mul-of
    ::  since we only want to send a rumor if result
    ::  changed, we need to deduce the old state from
    ::  the current state and the delta. depends on the
    ::  fact that state changes before ++feel. funky!
    ::  we could, of course, store mul/? in state, and
    ::  make a delta for it, but should we need to?
    =/  old
      .=  0
      %+  mod
        ?-  -.del
          $increment  (dec num)
          $decrement  +(num)
        ==
      mul.qer
    =/  new  =(0 (mod num mul.qer))
    ?:  =(old new)  ~
    `[%mul-of new]
  ==
```

As we saw earlier, for `/number` queries the `delta`s match one-on-one with the relevant `rumor`s. For `/mul-of` queries we do a little bit of work to see if anything actually changed. No need to send a `rumor` if it hasn't.


## Criticism

- Where event arms currently get passed a `wire`, and the new Gall described above passes them a custom `query` structure, the original new Gall spec gave them `(list coin)`, a "pre-parsed wire". These structures (eg `[%$ p=[p=~.ud q=123]]`) are uncomfortable to work with. Even with a "coin list parsing library" it still doesn't feel ideal. Because of custom structures being easier to work with than lists of `++knot`s or `++coin`s, writing a `++path-to-query` arm by hand is a small cost for huge gains.

- Why do `prize` units mean what they do? One would expect `~` to mean "invalid" and `[~ ~]` to mean "unavailable" as opposed to the other way around.

- The original new Gall spec mentions output lists (like `(list delta)` etc.) to be in reverse order. This was done because adding to the head of a list (`[item list]`) is easier than appending to the tail of a list (`(weld list [item ~])` or other). While it's technically easier to produce a list in reverse order, semantically it's yet another thing to keep in mind. Luckily, most of the "add to x, produce all of it later" code is set-and-forget, so probably not a huge deal. But do we really fear a few stray `++flop`s that much?

- There's some weirdness with relation to relying on old state in `++feel` to determine whether a query result actually changed. Just relying on state in general for delta-to-rumor conversion may or may not violate the new Gall spec.

- The original new Gall spec specifies `++leak` as taking a `(unit (set ship))`, where `~` means public. Is there a use case for checking more than just a single ship?

- Gall should probably cache `++feel` results during a single pass, to avoid the cycles of generating what it can be certain of is the same `(unit rumor)`. (But then for eg `/circle/nom/13` and `/circle/nom/14` it would still recalculate. Better than nothing.)


## The original new-Gall spec

`~sorreg-namtyv`

```
=>  |%
    --
|*  $:  :>  vinyl: historical state (including version)
        :>  brain: working state of the application (not including version)
        :>  delta: grain of change across all state
        :>  prize: (pair mark noun) for namespace value
        :>  rumor: (pair mark noun) for namespace diff
        :>  opera: (pair bone card) for operation (old ++move)
        :>
        vinyl/mold
        brain/mold
        delta/mold
        prize/mold
        rumor/mold
        opera/mold
    ==
|_  $:  :>  ops: pending operations, in reverse order
        :>  ego: current state
        :>
        ops/(list opera)
        ego/brain
    ==
::                                                      ::  ++bake
++  bake                                                :<  apply delta
  |=  $:  :>  del: change
          :>
          del/delta
      ==
  :>  core after change (including operations)
  ^-  _+>
  !!
::                                                      ::  ++cope
++  cope                                                :<  transaction result
  |=  $:  :>  weg: forward identity
          :>  het: success or error report
          :>
          weg/(list coin)
          het/(unit tang)
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
::                                                      ::  ++fail
++  fail                                                :<  process error
  |=  $:  :>  why: error dump
          :>
          why/tang
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
::                                                      ::  ++feel
++  feel                                                :<  update
  |=  $:  :>  del: change
          :>  pex: preparsed path, inside-first
          :>
          del/delta
          pex/(list coin)
      ==
  :>  query updates in reverse order
  :>
  ^-  (list rumor)
  !!
::                                                      ::  ++hear
++  hear                                                :<  subscription update
  |=  $:  :>  weg: forward identity
          :>
          weg/(list coin)
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
::                                                      ::  ++pull
++  pull                                                :<  subscription cancel
  |=  $:  :>  weg: forward identity
          :>  het: error report, if any
          :>
          weg/(list coin)
          het/(unit tang)
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
::                                                      ::  ++leak
++  leak                                                :<  check access
  |=  $:  :>  lec: leakset (~ means public)
          :>  pex: preparsed path, inside-first
          :>
          lec/(unit (set ship))
          pex/(list coin)
      ==
  :>  if path `pex` is visible to ships in `lec`
  ^-  ?
  !!
::                                                      ::  ++load
++  look                                                :<  asynchronous read
  |=  $:  :>  pex: preparsed path, inside-first
          :>
          pex/(list coin)
      ==
  :>  actions in reverse order
  ^-  _+>
  !!
::                                                      ::  ++prep
++  prep                                                :<  load system
  |=  $:  old/vinyl
      ==
  :>  core after boot
  ^-  _+>
  !!
::                                                      ::  ++peek
++  peek                                                :<  synchronous read
  |=  $:  :>  pex: preparsed path, inside-first
          :>
          pex/(list coin)
      ==
  :>  value at `pec`; ~ for unavailable, [~ ~] for invalid
  :>
  ^-  (unit (unit prize))
  !!
::                                                      ::  ++poke
++  poke                                                :<  generic poke
  |=  $:  :>  ost: opaque cause
          :>  msg: message with mark and vase
          :>
          ost/bone
          msg/cage
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
::                                                      ::  ++pour
++  pour                                                :<  arvo response
  |=  $:  :>  weg: forward identity
          :>  sin: response card
          :>
          weg/(list coin)
          sin/sign
      ==
  :>  actions in reverse order
  :>
  ^-  (list delta)
  !!
--
```

## A new-Gall example app

```
::  counter app
::  new gall example, may or may not compile.
::
|%
++  query                                               :>  valid queries
  $%  {$number $~}                                      :<  current number
      {$mul-of val/@ud}                                 :<  is num multiple of?
  ==                                                    ::
++  prize                                               :>  query results
  $%  {$number num/@ud}                                 :<  /number
      {$mul-of mul/?}                                   :<  /mul-of
  ==                                                    ::
++  rumor                                               :>  query result changes
  $%  {$number delta}                                   :<  /number
      {$mul-of mul/?}  ::TODO  or just flip?            :<  /mul-of
  ==                                                    ::
::  the above would ordinarily be placed in sur/,       ::
::  since other apps might want to use it.              ::
++  brain  {num/@ud $~}                                 :<  application state
++  delta                                               :>  state change
  $%  {$increment $~}                                   :<  +1
      {$decrement $~}                                   :<  -1
  ==                                                    ::
--
::
|_  {bol/bowl brain}
::
++  leak                                                :>  read permission
  |=  {who/ship qer/query}
  ^-  ?
  &  ::  everyone's allowed
::
++  peek                                                :>  synchronous read
  |=  qer/query
  ^-  (unit (unit prize))
  ?-  -.qer
    $number   ``[%number num]
    $mul-of   ?:  =(0 mul.qer)  [~ ~]
              ``[%mul-of =(0 (mod num mul.qer))]
  ==
::
++  poke-loob                                           :>  regular old poke
  |=  inc/?
  ^-  (list delta)
  :_  ~
  ?:  inc  [%increment ~]
  [%decrement ~]
::
++  bake                                                :>  apply delta to state
  |=  del/delta
  ^-  (quip opera +>)
  :-  ~
  ?-  -.del
    $increment  +>(num +(num))
    $decrement  +>(num (dec num))
  ==
::
++  feel                                                :>  delta to rumor
  |=  {qer/query del/delta}
  ^-  (unit rumor)
  ?-  -.qer
      $number
    `[%number del]
    ::
      $mul-of
    ::  since we only want to send a rumor if result
    ::  changed, we need to deduce the old state from
    ::  the current state and the delta. depends on the
    ::  fact that state changes before ++feel. funky!
    ::  we could, of course, store mul/? in state, and
    ::  make a delta for it, but should we need to?
    =/  old
      .=  0
      %+  mod
        ?-  -.del
          $increment  (dec num)
          $decrement  +(num)
        ==
      mul.qer
    =/  new  =(0 (mod num mul.qer))
    ?:  =(old new)  ~
    `[%mul-of new]
  ==
::
::  not pictured: ++path-to-query
--
```
