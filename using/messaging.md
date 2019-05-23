+++
title = "Messaging"
weight = 2
template = "doc.html"
+++
Talk is the built-in frontend for the Urbit messaging and notifications
protocol, Hall. Today we use Hall to chat and coordinate, but it's really
a general purpose piece of infrastructure.

For the time being come join us in `~dopzod/urbit-help` by using the
'quickstart' section below. `~dopzod` is the host ship, and `/urbit-help` is the
channel on that ship.

Today, Hall is sort of like a distributed, encrypted Slack that can be
used from the CLI and the browser. There’s no central Hall server.
Any urbit can host one.

Hall is a general purpose tool for both aggregating and publishing
streams of messages. Applications can use Hall as their transport
protocol, API connectors can push disparate data sources into Hall,
and so on. There are lots of things a distributed message protocol can
be used for that we haven't even thought of.

Here we'll be discussing how to operate the default CLI frontend, Talk,
to send and receive messages. For a more in-depth look at Hall's internals,
take a look at its [documentation](./docs/learn/arvo/hall.md).

## Quickstart

The most common use of talk right now is as a single-instance of Slack: one main
channel (`~dopzod/urbit-help`) and direct messages. Everyone is more than welcome
in `~dopzod/urbit-help`. It's the place to get help, ask questions and chat about
Urbit in general.

There are two ways of using Talk: from the terminal running the Urbit process,
or through a web UI available at `http://localhost:8080/~~/talk`. This
quick-start guide will cover the first method.

### Joining a Channel

In Hall, a medium for a message is called a _circle_. There are four types of
circles, but we for now we'll be dealing with the _channel_: a publicly
accessible chatroom for general use. We'll discuss the other three
kinds in the [manual](#manual) section.

Let's join the `~dopzod/urbit-help` channel. Use `ctrl-x` to switch from Dojo to Talk.
Then:

```
~your-urbit:talk> ;join ~dopzod/urbit-help
```

Scrolling down your terminal window, you'll probably see the playback of
previous `~dopzod/urbit-help` messages that you missed.

Post a line to `~dopzod/urbit-help:`

```
~your-urbit:talk= Hello, world!
```

You'll see your message printed below messages from others that came before it:

```
~your-urbit= Hello, world!
```

### Direct Messaging

To send a direct message to someone, first set your audience:

```
~your-urbit:talk= ;~talsur-todres
```

You'll see your prompt change:

```
~your-urbit:talk[~talsur-todres]
```

Now you and `~talsur-todres` can exchange messages directly.

```
~your-urbit:talk[~talsur-todres] Hey buddy!
```

To set your audience back to `~dopzod/urbit-help`:

```
~your-urbit:talk[~talsur-todres] ;~dopzod/urbit-help
```

You'll see your prompt change back:

```
~your-urbit:talk=
```

You can also use the ASCII "glyph" assigned to your `~dopzod/urbit-help` circle as a shortcut:

```
~your-urbit:talk[~talsur-todres] ;=
~your-urbit:talk=
```

(Your ship may have a different glyph than `=` for your circle)

Use `;leave` to unsubscribe from a channel:

```
~your-urbit:talk= ;leave ~dopzod/urbit-help
```

The web UI ships as compiled JavaScript on your urbit, but has its own
source repo [here](https://github.com/urbit/talk).

Last, let's create a channel we can invite some friends to:

```
~your-urbit:talk= ;create channel %my-channel 'Some description.'
```

Now you can tell your friends to `;join ~your-urbit/my-channel`.

---

<span id="manual"></span>
## Manual

Hall's design is similar in spirit to
[NNTP](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol),
the underlying protocol for Usenet.

Our design is pretty simple: Hall messages are called _posts_. Posts
go to _circles_. Any urbit can host or subscribe to any number of circles.

There are four kinds of circles: a write-only `%mailbox` for direct
messages, an invite-only `%village` for private conversation, a read-only
`%journal` for curated content, and a public-access `%channel` for
general use.

### Posts

A post can be a variety of different data structures. Let's look at the
ones you can use from within Talk: lines, URLs, Hoon and replies.

#### Lines

A line is simply a string of text. Depending on the filtering rules set
by the circle's host, these may or may not include uppercase and Unicode
characters (see [filter](#filter)).

If the line starts with `@`, it's an action (like `/me` in IRC).

```
~your-urbit:talk= @sends a message.
```

will print as

```
~your-urbit sends a message.
```

#### URLs

A URL is any valid URL.

```
~your-urbit:talk= https://example.com/
```

#### Hoon

You can use Talk to evaluate Hoon code and share the result with everyone in a
Hall circle. To do so, preface your Hoon with `#`.

```
~your-urbit:talk= #(add 2 2)
```

will print as

```
~your-urbit# (add 2 2)
4
```

#### Replies

To indicate what you're saying is in direct response to a specific
message, select the message (see Activating Lines below) and type your
response.

```
~some-urbit= Hello! How are you?
~your-urbit:talk= ; Well, thanks!
```

will print as

```
~your-urbit=^ Well, thanks!
```

### Activating Lines

A line number identifying the **subsequent** line is displayed every 5
lines.

```
---------[0]
~your-urbit= This is my message.
~your-urbit= This is another message.
~your-urbit sends a message.
~your-urbit/ http://example.com/
~your-urbit# (add 2 2)
             4
---------[5]
~your-urbit=^ That's my message!
```

You can use a line number to **activate** a line:

```
~your-urbit:talk= ;5
```

which prints the number, line identifier, timestamp, sender, audience,
and contents:

```
? 0
0v3.hl51p.jhege.amhec.vb37r.3rejr at ~2016.6.24..04.48.21..a235
~your-urbit to ~another-urbit
in reply to: ~your-urbit:
> This is my message.
That's my message!
```

If information got truncated — like what happens for long URLs or expressions,
or if there's additional information available — as is the case with
replies and attachments (e.g. stack traces) — activating the message will show
you all the details.

You can also activate the most recent line with `;`, the second-most recent
with `;;`, and so on.

### Creating and managing circles

As mentioned before, any urbit can host any number of circles. Existing circles
can be deleted or modified with various commands. All commands in this section
shoild be sent from the `talk>` prompt.

#### Create

Syntax: `;create [type] %name 'description'`

Creates and joins a circle, where `[type]` is any of the following:
- `channel`: public circle. Has a blacklist for write control.
- `village`: invite-only circle.
- `journal`: publicly readable, invite-only for writing.
- `mailbox`: publicly writeable, can only be read by its host.

Let's create an example mailbox:

```
sampel-palnet:talk> ;create mailbox %coolbox 'cool messages only'
```

Something like this should print:

```
--------------| ;create mailbox %coolbox 'cool messages only'
--------------| :: onn %coolbox
--------------| bound '>' {[hos=~sampel-palnet nom=%coolbox]}
--------------| %coolbox: see ~sampel-palnet hear
--------------| new > %coolbox
--------------| %coolbox: cap: cool messages only
--------------| %coolbox: fit: caps:Y unic:â
```

###### Delete

Syntax: `;delete %name 'optional reason'`

Deletes a circle. If a reason is specified, that gets sent to all
subscribers before the circle gets deleted.

To delete our example above:

```
sampel-palnet:talk> ;delete %coolbox 'people sent uncool messages'
```

#### Change Description

Syntax: `;depict %name 'description'`

Changes the description of an existing circle `%name`.

For example:

```
sampel-palnet:talk> ;depict %coolbox 'cool messages only. NO EXCEPTIONS.'
```

<span id="filter"></span>
#### Filter

Syntax: `;filter %name [capitals] [unicode]`

Configures the message filter for circle `%name`: whether to allow
capital and/or unicode characters. `y`/`&`/`true` for allowed,
`n`/`|`/`false` for disallowed.

So, to allow capital letters and disallow unicode in the circle `%coolbox`:

```
sampel-palnet:talk> ;filter %coolbox & |
```
or
```
sampel-palnet:talk> ;filter %coolbox y n
```

And we get the output:

```
--------------| ;filter %coolbox & |
--------------| %coolbox: fit: caps:Y unic:n
```

#### Invite

Syntax: `;invite %name ~someone`

Invites someone into your circle `%name`. If they were previously banished,
removes them from the blacklist.
Can also invite multiple ships at once, `~comma, ~separated`.

For example:

```
~sampel-palnet:talk> ;invite %coolbox ~lodleb-ritrul
```

#### Banish

Syntax: `;banish %name ~someone`

Removes someone from your circle `%name`. If they were previously invited,
removes them from the whitelist.
Can also banish multiple ships at once, `~comma, ~separated`.

#### Source

Syntax: `;source %name ~other/circle`

Adds `~other/circle` as a source for circle `%name`. This causes all
messages sent to `~other/circle` to also appear in `%name`.

For example:

```
~sampel-palnet:talk> ;source %coolbox ~marzod/urbit-help
```

#### Unsource

Syntax: `;unsource %name ~other/circle`

Removes `~other/circle` as a source for circle `%name`.

For example:

```
~sampel-palnet:talk> ;unsource %coolbox ~marzod/urbit-help
```

### Circle Membership

If you have joined a circle, you can make this information publicly
available to help others find that circle as well.

#### Show Membership

Syntax: `;show ~some/circle`

Adds a circle to your public membership list on your Hall profile. Hall profiles
are not used yet.

#### Hide Membership

Syntax: `;hide ~some/circle`

Removes a circle from your public membership list on your Hall profile. Hall
profiles are not used yet.

### Status

You'll see status notifications when people enter or leave circles you're
subscribed to.

#### Notifications Off

Syntax: `;set quiet`

Turn off status (and config) notifications.

#### Notifications On

Syntax: `;unset quiet`

Turn on status (and config) notifications.

#### Who

Syntax: `;who`

List everyone in all your subscribed circles. Optionally specify a
specific circle to list members of just those: `;who ~some/circle`

For example:

```
~sampel-palnet:talk> ;who ~marzod/urbit-help
```

#### Attend

Syntax: `;attend ~some/circle [presence]`

Manually set your presence to show up as one of the following. (In the
future, a sufficiently advanced client can automatically set these for
you.)

- `talk` - typing
- `hear` - listening
- `idle` - inactive
- `gone` - not present

For example:

```
~sampel-palnet:talk> ;attend ~marzod/urbit-help idle
```

#### Set Display Name

Syntax: `;name ~some/circle 'my handle'`

Set a handle ("name") for yourself in a specific circle. It will display
to users who have done `;set nicks`, but gets truncated if it's longer
than 14 characters.

## Audience

An audience consists of one or more messaging targets. These can be
circles or ships. (In the latter case, it's secretly the `~ship/inbox`
circle.)

### Circle Glyphs

Glyphs are found at the end of your prompt to as a quick indicator of where
your messages will be sent.

Glyphs are assigned by circle hash out of the following list:

```
> = + - } ) , . " ' ^ $ % & @
```

Alphanumeric characters and `|#;:*~_` are reserved; all others (the
above list, and `\/!?({<`) can be manually assigned.

For example, `-` the glyph at the end of the prompt below might indicates that
messages sent from this prompt will go to some circle with that glyph:

```
~sampel-palnet:talk-
```

To see what circle is bound to a glyph, use the `;what` command followed by the
glyph in question. For example, to see `=`:

```
~sampel-palnet:talk> ;what =
/urbit-help
```

Not every audience has a glyph, however. When the audience doesn't have a glyph,
such as in the case of direct-messaging a ship, we see their name at the end of
the prompt instead. Here we're talking directly to `~dannum-mitryl`:

```
~sampel-palnet:talk[~dannum-mitryl]
```

#### Bind

Syntax: `;bind [glyph] /circle-name`

Assigns the chosen glyph to a circle owned by your ship.

For example:

```
~sampel-palnet:talk> ;bind + /my-circle
```

#### Unbind

Syntax: `;unbind [glyph] /circle-name`

Unassigns the chosen glyph from a circle owned by your ship.

For example:

```
~sampel-palnet:talk> ;unbind + /my-circle
```

### Prefixes

Received posts are prefixed with a glyph to let you know what the
audience is. You can activate an individual post to see the full
audience.

There are a few special-purpose glyphs:

- `|` - Informational messages
- `:` - Posts directly to you
- `;` - Posts to you and others (a multiparty conversation)
- `*` - Posts to a complex audience that doesn't directly include you.


### Configuration

#### Set Audience

`;~ship/circle`

Set audience to `~ship/circle`.

#### Set Audience by Glyph

Syntax: `;[glyph]`

Set audience to the circle previously bound to the chosen glyph.

#### Set Audience to Ship

syntax `;~ship`

Set audience to another ship.

#### Set Audience to Own Circle

Syntax: `;%circle`

Set audience to a circle on your own ship

#### Set Audience + Send Message

Syntax: `;~dannum-mitryl this is a private message`

Set the audience and send a post in the same line. This works for all of the
above audience commands.

Your audience is configured with regard to the following rules (in order):

- if you manually set the audience, that audience.
- if you activated a post, the post you activated.
- audience of the last post sent.

### Local nicknames

#### See Nicknames

Syntax: `;nick`

List all local nicknames.

#### Find Nickname

Syntax: `;nick ~some-urbit`

Look up a nickname using the known ship-name.

#### Reverse Find Nickname

syntax: `;nick plato`

Find a ship's name using its nickname.

#### Set Nickname

Syntax: `;nick ~some-urbit plato`

Create a new nickname.

#### Clear Nickname

Syntax: `;nick ~some-urbit ~`

Clear an assigned nickname.

#### Display Nicks, Not Ship-Names

Syntax: `;set nicks`

Show nicknames instead of ship-names. If no local nickname is set, uses
that user's handle. If the user has no handle, just the urbit name.

#### Display Ship-Names, Not Nicks

Syntax: `;unset nicks`

Show ship-names instead of nicknames.

Nicknames and handles longer than 14 character will be truncated in
output. Nicknames are strictly local - like the names on entries in a
phonebook.

### Miscellaneous configuration

#### Show Timestamps

Syntax: `;set showtime`

Show the timestamp for each message.

#### Hide Timestamps

Syntax: `;unset showtime`

Stop showing the timestamp for each message.

#### Change Time Zone

Syntax: `;set timezone [+/-][hours]`

Adjust the display of the timestamps to a specific timezone. Relative to UTC.

#### Sound Notification On

Syntax: `;set notify`

Emit a terminal bell sound if your six-syllable ship name is mentioned in
a message.

#### Sound Notification Off

Syntax `;unset notify`

Do not notify when your ship name is mentioned.

#### Set Width

Syntax: `;set width [number]`

Set the rendering width of `:talk` to a specific number of characters.
(Minimum of 30.)
