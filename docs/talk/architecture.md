# Talk architecture

This document is complemented by talk's source code, but doesn't require it. Definitions of data structures will be provided where useful.

>**Current implementation** remarks mention where the [current implementation](https://github.com/Fang-/arvo/tree/talk-split) differs from what is described, and why changing that to match this document would be desirable.


## Overview

At the time of writing, talk is Urbit's biggest user-facing application, and fresh out of a big restructuring. Previously, talk the platform and talk the application were one and the same. Now, they have been split to help clarify their distinction, provide an example of how the platform can be used, and to aid in maintaining and extending it.

Official Urbit terminology calls the platform a `guardian` (like a unix daemon) and the application an `agent`. You may also view them as your personal server and client. To be more semantically appropriate for talk, we're calling them `broker` and `reader` respectively.

>It may be desirable to separate the platform from the "talk" name entirely, to decouple it from the client implementation we know and love. Also, "reader" is starting to feel more and more incorrect.

Everyone (per identity) has a single broker that does all the heavy lifting. This broker can be used by any number of readers to help them realize their messaging functionality. Examples include the talk application we're all familiar with and the brand new Twitter clone [feed](http://urbit.org/fora/posts/~2017.4.12..21.14.00..fe17~/).

Since reader implementations will vary widely, we'll be looking exclusively at the functionality the broker provides and how that can be used. In order to do so, we first look at the core concepts that govern talk's architecture, then delve continuously deeper by examining the interfaces the broker offers, seeing how communication between brokers happens, and finally looking at how it's all implemented.

## Core concepts

Before we dive into interfacing with the broker, we need to understand how it sees the world. Let's pull up part of the structure for the broker's state, and some structures that relate to it.

```
++  house                                               ::  broker state
  $:  stories/(map knot story)                          ::  conversations
      readers/(map bone (set knot))                     ::  our message readers
      ::  ...                                           ::
  ==                                                    ::
++  story                                               ::  wire content
  $:  grams/(list telegram)                             ::  all messages
      locals/atlas                                      ::  local presence
      remotes/(map partner atlas)                       ::  remote presence
      shape/config                                      ::  configuration
      mirrors/(map station config)                      ::  remote config
      followers/(map bone river)                        ::  subscribers
      ::  ...                                           ::
  ==                                                    ::
++  config                                              ::  party configuration
  $:  sources/(set partner)                             ::  pulls from
      ::  ...                                           ::
  ==                                                    ::
```

### Stories

A `story` is the structure in which a local `station`'s full state is stored. All its messages and configuration, as well as those of other stations.

Why those of other stations? Observe that a station's configuration contains `sources`. These are the station's subscriptions, from which is receives messages and metadata like presences and configurations. When you subscribe to a foreign station, you're not subscribing your identity to it. Rather, you're telling whatever story your reader is using to subscribe to it.

Because subscriptions are essentially story-to-story instead of broker-to-story, it is easy for different reader implementations to isolate their functionality from each other. For example, cli-talk uses the `%mailbox` story for subscriptions and message management, and feed uses a `%feed` story for doing the same. Neither have to deal with each other's data, but they can still choose to subscribe to it if they want to (and know the name of the story the other application uses).

>**Current implementation** of "cli-talk" (and web-talk too) instantiates with default mailbox and journal stations. This is likely not desirable. Applications should specify their own stories. Using defaults will just end up with them becoming bloated streams of unfiltered noise.

### `partner` or `station`?

```
++  partner    (each station passport)                  ::  interlocutor
++  station    (pair ship knot)                         ::  domestic flow
```

A `partner` is either a `station` (a "chat room" hosted on a ship's broker, represented as `~ship-name/station-name`) or a `passport`, which represents a non-station target. An example of a passport is a Twitter handle. Since passports aren't yet fully implemented for any kind of usage, we'll ignore them.

## Interfaces for readers

Now that we know how a broker keeps track of things, we should have an easier time understanding the different interfaces it offers for user/reader actions.

>The interfaces presented here are suggestions, backed by functional implementations. Adding a new interface for existing functionality is trivial. These may be changed or added to as the use cases for talk (the platform) evolve.

```
++  action                                              ::  user action
  $%  ::  station configuration                         ::
      {$create (trel knot cord posture)}                ::  create station
      {$depict (pair knot cord)}                        ::  change description
      {$adjust (pair knot posture)}                     ::  change posture
      {$delete (pair knot (unit @t))}                   ::  delete + announce
      {$permit (trel knot ? (set ship))}                ::  invite/banish
      {$source (trel knot ? (set partner))}             ::  un/sub p to/from r
      ::  messaging                                     ::
      {$convey (list thought)}                          ::  post exact
      {$phrase (pair (set partner) (list speech))}      ::  post easy
      ::  personal metadata                             ::
      {$status (pair (set partner) status)}             ::  our status update
      ::  changing shared ui                            ::
      {$human (pair ship human)}                        ::  new identity
      {$glyph (pair char (set partner))}                ::  bind a glyph
  ==                                                    ::
++  reaction                                            ::  user information
  $:  kind/?($info $fail)                               ::  result
      what/@t                                           ::  explain
      why/(unit action)                                 ::  cause
  ==                                                    ::
```

>**Current implementation** doesn't include *all* of the above actions yet, but adding them in is trivial since the functionality is already there.

>**Current implementation** uses a `(set knot)` for `%status` commands, which limits us to updating our status on local stations only.

Most of these `action`s should (hopefully) be fairly self-explanatory. Loobs `?` are used to differentiate between "add" and "delete" actions, `knot`s are used to specify local stations, `partner`s are targets of actions and...  
"shared ui"? Yes, some UI state gets stored in the broker. Currently these are nicknames and glyph bindings. Those get kept up to date across readers to ensure the user can easily identify other users and stations in a familiar manner, regardless of what reader they're using. (Of course, readers can choose to ignore this if they want to.)

To give the broker a way to communicate warnings and errors to the readers, it can send them a `reaction`. This way, even though the broker itself isn't user-facing, it can still inform the user of potential failure of their action, or other warnings.

By using these interfaces exclusively, a reader as functional as our current talk can be implemented. Most of the reader code will go towards UI-related tasks, since the broker generically implements all messaging functionality.

### Reader subscriptions

Those interfaces alone can't provide the reader with any data, however. It still needs to subscribe itself to the stories it's interested in. Let's take a look at a `%peer` move that does just that!

```
:*  ost.hid                                             ::  bone
    %peer                                               ::  move type
    /story/some-story                                   ::  diff path
    [our %broker]                                       ::  peer target
    /reader/some-story                                  ::  peer path
==
```

Fairly standard. We should mention the paths being used here, however.  
The diff path is simply something for the reader to use to identify what subscription a diff came from. That is, what story the diff relates to. Not all readers will need this (cli-talk doesn't!), but that's entirely up to the implementation.  
The peer path informs the broker as to what kind of subscription this is. We always start with `/reader` to identify this as a reader subscription. If we leave the path at that, we subscribe to changes to the shared UI state. If we append a story name to it, we subscribe to changes to that story.

Over a subscription we can either get sent a `reaction` as described above, or a `lowdown`. Let's see what that looks like.

```
++  lowdown                                             ::  changed shared state
  $%  ::  story state                                   ::
      {$confs (unit config) (map station (unit config))}::  changed configs
      {$precs (pair atlas (map partner atlas))}         ::  changed presences
      {$grams (pair @ud (list telegram))}               ::  new grams
      ::  ui state                                      ::
      {$glyph (jug char (set partner))}                 ::  new bindings
      {$names (map ship (unit human))}                  ::  new identities
  ==                                                    ::
```

`lowdown`s inform a reader of changes to story or UI state. You'll see these cover most of the story state we described above.

It's important to note that lowdowns contain just that which has changed, just the "diff". This is why configurations are wrapped in `unit`s, so we can signify deletion. This means simple readers that don't even keep state can still inform you when someones presence has changed.

>Sending "just the diff" is a little bit trickier for `config`s, since they're a more complex structure than "just a map of maps". For now, the best we do is send only the configs that have changed, but not the individual changes within those configs.

## Communication between brokers

```
++  command                                             ::  effect on party
  $%  {$review (list thought)}                          ::  deliver
  ==                                                    ::
```

>**Current implementation** hasn't deprecated the `%design` and `%publish` commands yet. They should be, because they have `action` equivalents and are exclusively used by your own identity.

When you tell your broker to post a message (through the `%convey` or `%phrase` commands), it looks at the audience you want the message to be sent to. For each station, it sends a `%review` command to the host ship, asking for the message to be reviewed and accepted.

When a message gets added to a story, or a presence or configuration in it gets changed, all who are subscribed to that story get notified. This is done via `report`s.

```
++  report                                              ::  talk update
  $%  {$cabal config}                                   ::  local config
      {$group register}                                 ::  presences
      {$grams (pair @ud (list telegram))}               ::  thoughts
  ==                                                    ::
++  register  (pair atlas (map partner atlas))          ::  ping me, ping srcs
```

>Whereas lowdowns send just the information that has changed, reports always send the entire thing. It might technically be possible to send just the diff, but this needs to be looked into further. Diffs are in a bit of a vague spot currently anyway, see below.

Non-message reports include both local and remote presences. This is useful in federation, where subscribers are also interested in the presences on related stations.

>Federation is, at the time of writing, completely untested. Messages should work fine, but proper configuration and presence propagation has yet to be seen. We'll probably need a `/federate` subscription path to integrate this cleanly into the existing system. It's an entirely new can of worms though.

>**Current implementation** also sends remote configurations in the `%cabal` report. This doesn't seem to be useful for anything. In case of federation, you would want all stations to copy each other's configuration.


## Broker implementation

For every event (poke, peer, etc.) the broker receives, it calls an arm from the `++ra` core. The event gets processed, and if needed, the `++pa` core is invoked to make changes to stories. If anything interesting happens, an event is sent to relevant brokers and/or readers.

Below you'll find diagrams outlining the arm flows for various common events. If you want to see what they do in more detail, looking at the code might be a good idea.

@TODO update diagrams where necessary, put them here, walk the reader through them briefly.


## Roadmap

Things currently on the to-do list, roughly in order of priority:  
(Cleanup, rewriting for clarity and improving inline documentation will be done once we have a shippable talk.)

* **Architecture** / high-impact changes
  * Implement federation.
    * Should config be determined by the original station, or should "federators" be allowed to make changes as well?
    * Is anyone allowed to federate any station they can subscribe to? (Definitely not if the above is "allowed to make changes"!)
  * Move fora things out of the broker.
    * *Maybe* make it its own reader app?
  * Improve presence capabilities.
    * Separate presence from handles.
    * Command for setting our presence in a foreign station.
    * "Typing", "idle", etc.
  * Extended permissions management?
    * It might be nice to be able to white/blacklist entire classes
* **Functionality**
  * Flexible subscribe ranges.
    * As opposed to the current always-default "a day old, and everything newer forever". of ships (ie, disallow all comets.)
  * List (accessible) stations on ships.
  * Talkpolls!
  * Per-channel message sanitization configuration?
    * Allow/disallow capitals, unicode, etc.
  * Better glyph management.
  * Better line splitting.
