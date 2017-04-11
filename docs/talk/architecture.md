# Talk architecture

This document is complemented by talk's source code, but doesn't require it. Definitions of data structures will be provided where useful. Descriptions of processes will be accompanied by diagrams describing this flow in code arms. For an overview of the different cores and their most important arms, see the end of this document.

>**Current implementation** remarks mention where the [current implementation](https://github.com/Fang-/arvo/tree/talk-split) differs from what is described, and why changing that to match this document would be desirable.


## Overview

At the time of writing, talk is Urbit's biggest user-facing application, and fresh out of a big restructuring. Previously, talk was a single application. Now, it has been split into two, to improve maintainability and extensibility.

Official Urbit terminology calls these the `guardian` (like a unix daemon) and `agent`. You may also view them as your personal server and client. To be more semantically appropriate for talk, we're calling them `broker` and `reader` respectively.

Everyone (per identity) has a single talk broker that does all the heavy lifting. Connected to it can be any number of readers, whose task it is to present the user with an interface for interacting with talk. Brokers and readers will only interact with each other if they are in the same team. That is, if they belong to the same identity, with moons counting as their planets.

### Partners

```
++  partner    (each station passport)                  ::  interlocutor
```

A `partner` is either a `station` (a "chat room" hosted on a ship, represented as `~ship-name/station-name`) or a `passport`, which represents a non-station target. An example of a passport is a Twitter handle. Since passports aren't yet fully implemented for any kind of usage, we'll ignore them for now.


## Broker

The broker is responsible for all primary talk functionality, everything that happens "under the hood". It can send, receive and store messages, keeps track of presence lists and configurations, and manages the stations you've created.

> **Note**: You may see `lowdown`s as output in some of the arm flows. These are sent to readers. Their purpose is described later in this document.

### General messaging flow (broker to broker)

```
++  command                                             ::  effect on party
  $%  {$publish (list thought)}                         ::  originate
      {$review (list thought)}                          ::  deliver
      ::  ...                                           ::
  ==                                                    ::
++  thought    (trel serial audience statement)         ::  which whom what
++  report                                              ::  talk update
  $%  {$grams (pair @ud (list telegram))}               ::  beginning thoughts
      ::  ...                                           ::
  ==                                                    ::
```

Posting a message is done by poking your own broker with a `%publish` `command`, which prompts the broker to verifies that command originated from someone in its `team` (its own ship, or one of its moons), and to actually publish it.

Having received and verified the command to publish a message, your broker sends a `%review` `command` to the brokers of all members of the `audience`. That is, all ships of the stations in the audience. (Again, messaging to other kinds of partners isn't implemented yet.)

Upon getting poked with a command to review a message, a broker seeks out the appropriate story and (after checking if the sender has write permissions) adds the message to the story. Doing this causes a `%grams` `report` to be sent to everyone that has subscribed to that story.

When a broker gets a diff ("subscription poke") with a `%grams` report, it adds all messages in it to the appropriate story.

![messaging implementation flow](./diagrams/talk_flow-messaging.png "messaging implementation flow")

```
++  diff-talk-report        ::
  ++  ra-diff-talk-report   ::  sends report to its appropriate story.
  ++  pa-diff-talk-report   ::  processes a report for a story.
  ++  pa-lesson             ::  learns a list of messages.
++  poke-talk-command       ::
  ++  ra-apply              ::  applies a talk command.
  ++  ra-think              ::  consumes a list of messages.
  ++  ra-consume            ::  conducts a message to each partner in audience.
  ++  ra-conduct            ::  records a message or send it.
    ++  ra-transmit         ::  sends a message to a partner.
    ++  ra-record           ::  stores a message in a story.
      ++  pa-learn          ::  either adds or modifies a message.
        ++  pa-append       ::  adds a message to the story.
        ++  pa-revise       ::  modifies a message in the story.
      ++ pa-refresh         ::  sends messages to all interested subscribers.
```

### Stories (broker to broker)

```
++  story                                               ::  wire content
  $:  count/@ud                                         ::  (lent grams)
      grams/(list telegram)                             ::  all history
      locals/atlas                                      ::  local presence
      sequence/(map partner @ud)                        ::  partners heard
      shape/config                                      ::  configuration
      known/(map serial @ud)                            ::  messages heard
      followers/(map bone river)                        ::  subscribers
  ==                                                    ::
```

A `story` is the structure in which a station's full state is stored. Its the canonical source for its messages, configuration, presence and subscribers.

#### Telling stories

```
++  house                                               ::  broker state
  $:  stories/(map knot story)                          ::  conversations
      ::  ...                                           ::
  ==                                                    ::
++  command                                             ::  effect on party
  $%  {$design (pair knot (unit config))}               ::  configure+destroy
      ::  ...                                           ::
  ==                                                    ::
```

To create a station, you send a `%design` command to your broker, containing the name of the station and its initial configuration. After verifying you are in the broker's team, it sets the configuration for a story with the specified name, creating that story if it doesn't yet exist.

When people subscribe to a station it sends a `%peer` to the station's ship's broker. In the subscription path, the name of the station is specified, as well as the range of the subscription. For example, a subscriber may only be interested in messages up to a month from now.

>**Current implementation** always gets you messages from up to a day old, and all messages after that. Giving the user the option to specify the range of the subscription should prove useful to future applications of the talk system. The same can be said for making a range enforceable on a per-station basis.

When a broker gets peered, it checks the source for read permissions on the specified story before adding it to the story's list of subscribers. When this happens, the broker sends a bunch of different reports to the new subscriber to bring them up to speed on configuration, presences and messages of the station.

![subscribe implementation flow](./diagrams/talk_flow-subscribe.png "subscribe implementation flow")

```
++  poke-talk-command     ::
  ++  ra-apply            ::  applies a talk command.
  ++  ra-config           ::  (re)configures a story.
  ++  pa-reform           ::  changes the configuration of the story.
++  peer                  ::
  ++  ra-subscribe        ::  adds a subscriber to a story, sends them info.
  ++  pa-report-cabal     ::  sends subscribers a report with configuration.
  ++  pa-notify           ::  changes a ship's presence in the story.
    ++  pa-report-group   ::  sends subscribers a report with presences.
  ++  pa-first-grams      ::  determines the backlog of messages to send.
    ++  pa-start          ::  sends a range of messages.
```

#### Hearing stories

```
++  house                                               ::  broker state
  $:  remotes/(map partner atlas)                       ::  remote presence
      mirrors/(map station config)                      ::  remote config
      ::  ...                                           ::
  ==                                                    ::
++  report                                              ::  talk update
  $%  {$cabal config}                                   ::  config neighborhood
      {$group atlas}                                    ::  presence
      ::  ...                                           ::
  ==                                                    ::
```

When subscribing, no stories are created. A story is the one true canonical source of a station, there can only be one. A subscriber keeps a station's data and other

Every instance of a talk broker comes with a default mailbox. For planets, this is their `%porch`. It can be written to by everyone, but only read by its owner. The mailbox is used to store *all* incoming messages from *all* subscriptions. This means that if you are subscribed to a station you host, messages will be stored in both the station's story *and* your mailbox. (This is not a problem, and actually a good thing. It provides clear separation between subscriptions and stations themselves and makes it simple to not be subscribed to your own stations.)

>**Current implementation** still draws this line a bit unclearly, because of how the mailbox itself is also a regular story, and the storage of relevant data being as described below. The effort for changing this is not worth the small gains in clarity, however, and may even end up increasing clutter. (You'd almost think a broker-host and broker-guest would be appropriate, but likely not.)

Presence lists and configurations of stations you've joined are stored in maps in the broker's general state. These are updated whenever a `%cabal` or `%group` `report` is received. Such updates are sent to all subscribers of a story whenever changes occur.

>**Current implementation** doesn't store presence and config of local stations in the maps, instead keeping this strictly in the stories themselves. Also adding local story presences and configs to the global maps would help simplify communication with readers and readers themselves. (See also "Reader" below.)

>**Current implementation** includes remote presences and configs in `%cabal` and `%group` reports. Leaving those out should not hinder functionality. "But federation?" No party in a federation scenario should care where presence/config originated.

![subscription reports implementation flow](./diagrams/talk_flow-reports.png "subscription reports implementation flow")

```
++  diff-talk-report        ::
  ++  ra-diff-talk-report   ::  applies a report to the story it's intended for.
  ++  pa-diff-talk-report   ::  processes a report.
    ++  pa-cabal            ::  stores remote configuration.
      ++  pa-report-cabal   ::  sends subscribers a report with configuration.
    ++  pa-remind           ::  stores remote presence.
      ++  pa-report-group   ::  sends subscribers a report with presences.
```


## Reader

A reader is an application used for interfacing with a talk broker. As such, it communicates solely with the broker of the identity it is associated with. No other brokers. No other readers. That is all left up to the broker itself.

>**Current implementation** still stores different tales (subsets of stories). Ideally, and taking the changes described below into account, readers should be able to get away with a single list of messages and maps for presences and configurations. Practically, you could say it's like subscribing to the broker's mailbox and the changes made to broker's presence and config lists. This means that the `man/knot` that's still passed around to cores in the reader has become mostly meaningless, and should be removed.

### Staying informed (broker to reader)

```
++  lowdown                                             ::  reader update
  $%  {$confs (map station (unit config))}              ::  changed config
      {$precs (map partner atlas)}                      ::  changed presence
      {$grams (pair knot (pair @ud (list telegram)))}   ::  new grams
      ::  ...                                           ::
  ==                                                    ::
```

As silently illustrated in the flow diagrams shown earlier in this document, `lowdown`s may get sent whenever something about a story changes: new or changed messages (`%grams`), presence (`%precs`) or configuration (`%confs`). Those lowdowns contain exclusively the changes compared to what the reader knows. When it first boots up, this is all state of all the broker's subscriptions. Afterwards, this is just whatever change the broker recently recorded.

>**Current implementation** has many more lowdowns, which include different lowdowns for local and remote station changes. Taking the changes described above into account (ditching tales for simpler storage) would make it possible to simplify reader state and the lowdowns that update it considerably.

>**Current implementation** sends much more than just the change for most lowdowns, often sending the entire new state. This places the burden of calculating the differences with the reader, even though the broker had that information readily available. Sending the change alone would free the reader from the required logic, and potentially allow the reader to stop mirroring broker state altogether. Reports might also be updated to behave this way. If needed, ++scry arms could be added to the broker for (hopefully infrequent) state access.

![subscription lowdowns implementation flow](./diagrams/talk_flow-lowdowns-subs.png "subscription lowdowns implementation flow")

```
++  diff-talk-lowdown
  ++  ra-lowdown        ::  processes a lowdown.
    ++  ra-low-precs    ::  applies changes from a presence lowdown.
      ++  sh-low-precs  ::  displays changes from a presence lowdown.
    ++  ra-low-confs    ::  applies changes from a configuration lowdown.
      ++  sh-low-confs  ::  displays changes from a configuration lowdown.
    ++  ra-low-grams    ::  applies changes from a messages lowdown.
      ++  sh-low-grams  ::  displays changes from a messages lowdown.
      ++  pa-lesson     ::  learns a list of messages.
      ++  pa-learn      ::  either adds or modifies a message.
        ++  pa-append   ::  adds a message to the story.
        ++  pa-revise   ::  modifies a message in the story.
```

### Changing shared UI (reader to broker to reader)

```
++  update                                              ::  change shared state
  $%  {$status (pair (set partner) status)}             ::  our status update
      {$human (pair ship human)}                        ::  new identity
      {$bind (pair char (set partner))}                 ::  bind a glyph
  ==                                                    ::
++  lowdown                                             ::  reader update
  $%  {$glyfs (jug char (set partner))}                 ::  new bindings
      {$names (map ship (unit human))}                  ::  new identities
      ::  ...                                           ::
  ==                                                    ::
```

Generally, readers should be free to carry their own configurations, independent from other readers. Some of the currently available UI configuration, however, is worth syncing across readers to present information to the user in a consistent way. These are glyph bindings and nicknames, and are shared across readers through the broker.  
On top of that, readers are in a good position for determining a user's status, like "idle", "active" or "typing", or allow the user to set such a status themselves. This, too, needs to be done through the broker.

When a reader wants something done, it sends an `update` to its broker, containing the change that needs to happen. The reader applies the change to its own state before sending a `lowdown` describing it to all readers. Even the reader that requested the change gets informed, so it knows for sure that its change went through.  
In the case of a `%status` update, we follow a similar flow similar to when we receive a `%group` `report`.

>**Current implementation** doesn't deal with status updates very well. You want to be able to set your status per partner, but it's currently set by knot, which means it only works for local stations. What's more, there's no `command` for telling a foreign station you want to change your status, so unless you own the station your change won't be propagated.

>**Current implementation** also considers a `status` to be both `presence` and `human`. This same `human` structure is also used in storing local nicknames, however. All this needs some work for clarity and simplicity. (What's a "true name"? Demonology?) Allowing users to set per-station handles is probably fine, but this needs to actually be implemented.

![UI lowdowns implementation flow](./diagrams/talk_flow-lowdowns-ui.png "UI lowdowns implementation flow")

```
++  poke-talk-update        ::
  ++  ra-update             ::  processes an update.
    ++  pa-notify           ::  changes a ship's presence in the story.
      ++  pa-report-group   ::  sends subscribers a report with presences.
    ++  ra-inform           ::  sends a lowdown with changes to all readers.
++  diff-talk-lowdown       ::
  ++  ra-lowdown            ::  processes a lowdown.
    ++  ra-low-names        ::  applies new or changed local identities.
    ++  ra-low-glyfs        ::  applies new or changed glyph bindings.
```

## Implementation overview

We're not going to be explaining talk's usage of cores here. ~~Please see the "core shenanigans" document for that.~~

The different cores used by the talk applications are described below. Renaming (of both cores and their arms) is going to happen.

### `++ra` transactions (broker and reader)

Whenever an event happens (poke, peer, diff, etc.) `++ra` core arms are usually the first to be called.

Important arms in the broker's `++ra` include:
* `++ra-apply` for processing `command` pokes.
* `++ra-update` for processing `update` pokes.
* `++ra-diff-talk-report` for processing `report` diffs, delegates to `++pa-diff-talk-report`.
* `++ra-subscribe` for peers.
* `++ra-cancel` for pulls.

Important arms in the reader's `++ra` include:
* `++ra-low` for processing `lowdown` diffs.
* `++ra-sole` for processing `sole-action` pokes.

When it needs to apply changes to complex structures (stories, shells), it directs flow into the appropriate core.

It modifies state and produces `command`s, `report`s and `lowdown`s.

### `++pa` stories (broker)

Used for modifying stories.

>**Current implementation** still has a `++pa` core in the reader, for dealing with tales. All it does is add messages to the specified tale. When ditching tales, this functionality should just get moved into the reader's `++ra` core.

Important arms include:
* `++pa-diff-talk-report` for processing `report`s.
* `++pa-acquire` for subscribing a partner to the story.
* `++pa-abjure` for unsubscribing a partner from the story.

It modifies a story's state and produces `report`s and `lowdown`s.

### `++sh` shell (reader)

Used for doing sole (console, cli) work. Does work on input and prints changes to the screen.

Important arms include:
* `++sh-sole` for applying `sole-action`s.
* `++sh-scad` for parsing cli input and turning it into a work item.
* `++sh-work` for doing a work item.

For constructing printable strings of structures like `partner`s and `telegram`s, it uses their rendering cores.

It modifies the shell's state and produces `command`s, `update`s and `sole-effect`s.

### `++sn` station rendering (reader)

Used in both station and ship rendering. Creates tapes representing the station or ship.

### `++ta` partner rendering (reader)

Used in partner rendering. Creates tapes representing the partner. Makes use of `++sn`.

### `++te` audience rendering (reader)

Used in audience rendering. Creates tapes representing the set of partners. Makes use of `++ta`.

### `++tr` telegram rendering (reader)

Used in telegram rendering. Can turn telegrams into their full representations, or a single 64-character line. Makes use of `++sn` and `++te`.


@TODO maybe insert full flow diagram?


## Notes on the talk API

The broker does "the heavy lifting", but still leaves a lot of light work up to the readers. For example, readers can instruct a broker to send messages, but they have to send an entire thought. The client should not be responsible for, say, generating a message serial when that's something the broker can handle perfectly fine.

Similarly, I'm currently working on implementations for `;invite` and `;banish` for modifying blacklists (channels, mailboxes) and whitelists (journals, villages). I find myself doing checks on the station type and constructing an updated config within the reader, and even building an `%inv` message to send! These are all things the broker should take care of, because they will be (should be) implemented that way for all readers.

If we want to make talk an easy platform to use for messaging applications, it needs a better API. The current command structure works, but isn't as simple as it could be. The broker also has no way of sending an informative message back to the reader if anything fails, so doing checks on the reader-side is currently mandatory if you want to be able tot ell your user what is up.

```
++  action                                              ::  user action
  $%  {$create (pair knot (pair cord posture))}         ::  configure + destroy
      {$permit (trel knot ? (set ship))}                ::  invite/banish
      {$say (list (trel audience statement))}           ::  originate
      ::  probably include ++update in this.            ::
  ==                                                    ::
++  reaction                                            ::  user information
  $:  kind/?($info $fail)                               ::  result
      what/@t                                           ::  explain
      why/(unit action)                                 ::  cause
  ==                                                    ::
```

You want the broker to do as much lifting as possible, so that readers don't have to reimplement the same things over and over again. The structure above helps the reader instruct the broker in a simpler, more low-effort way, and enables the broker to pass on a potential failure cause.

(Readers can of course choose to not display all reactions they get. At this point I don't think it's worth implementing something like error codes for readers to display their own custom messages, but very much possibly to add that in the future if it becomes desirable.)


## Miscellaneous notes

* Federation might be implemented as a new subscription type, where multiple brokers subscribe to a station, mirror its state, and (after processing) relay commands/reports to the other federation nodes.
