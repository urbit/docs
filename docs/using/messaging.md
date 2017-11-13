---
navhome: '/docs'
next: True
sort: 4
title: Messaging (:talk)
---

# Messaging (`:talk`)

<div class="row">

<div class="col-md-8">

`:talk` is the built-in frontend for the Urbit messaging and notifications
protocol, `:hall`. Today we use `:hall` just to chat and coordinate, but
it's really a general purpose piece of infrastructure.

For the time being come join us in `/urbit-meta` by using the
<a href="#-quickstart">quickstart</a> below.

Today `:hall` is sort of like a distributed, encrypted Slack that can be
used from the CLI and the browser. There’s no central `:hall` server.
Any Urbit can host one.

`:hall` is a general purpose tool for both aggregating and publishing
streams of messages. Applications can use `:hall` as their transport
protocol, API connectors can push disparate data sources into `:hall`,
and so on. There are lots of things a distributed message protocol can
be used for that we haven't even thought of.

Here we'll be discussing how to operate the default CLI frontend, `:talk`,
to send and receive messages. For a more in-depth look at `:hall`'s
internals, take a look at its [documentation](#TODO).

</div>

</div>

## Quickstart

For the most part we use `:talk` as a single-instance of Slack: one main
channel (`/urbit-meta`) and direct messages. Everyone is more than welcome
in `/urbit-meta`. It's the place to get help, ask questions and chat about
Urbit in general.

Let's join `/urbit-meta`:

Use `ctrl-x` to switch from `:dojo` to `:talk`.

To join `/urbit-meta`:

    ~your-urbit:talk[] ;join /urbit-meta

You'll see:

    --------------| ;join /urbit-meta
    --------------| new glyph '>'
    ~your-urbit:talk>

Post a line to `/urbit-meta`:

    ~your-urbit:talk> hello, world

You'll see, echoed back at you:

    ~your-urbit> hello, world

To send a direct message to someone, first set your audience:

    ~your-urbit:talk> ;~talsur-todres

You'll see your prompt change:

    ~your-urbit:talk[~talsur-todres]

Now you and `~talsur-todres` can exchange messages directly.

To set your audience back to `/urbit-meta`:

    ~your-urbit:talk> ;/urbit-meta

Use `;leave` to unsubscribe from a channel:

    ~your-urbit:talk> ;leave /urbit-meta

There are two ways of using `:talk`: from the CLI or through a web ui
available at `http://your-urbit.urbit.org/talk` (or
`http://localhost:8080/talk`).

The web ui ships as compiled JavaScript on your Urbit, but has its own
source repo [here](https://github.com/urbit/talk).

Last, let's create a channel we can invite some friends to:

    ~your-urbit:talk> ;create channel %my-channel 'some description'

Now you can tell your friends to `;join ~your-urbit/my-channel`.

## Manual

`:hall`'s design is similar in spirit to
[nntp](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol),
the underlying protocol for Usenet.

Our design is pretty simple: `:hall` messages go to ‘circles’. Any urbit
can host or subscribe to any number of circles.

There are four kinds of circles: a write-only `%mailbox` for direct
messages, an invite-only `%village` for private conversation, a read-only
`%journal` for curated content, and a public-access `%channel` for
general use.

### Posts

A post can be a variety of different data structures. Let's look at the
ones you can use from within `:talk`: lines, URLs, expressions and
replies.

#### Lines

A line is simply a string of text. Depending on the filtering rules set
by the circle's host, these may or may not include uppercase and Unicode
characters.  
If the line starts with `@`, it's an action (IRC `/me`).

    ~your-urbit:talk> @sends a message

will print as

    ~your-urbit sends a message

#### URLs

A URL is any valid URL.

    ~your-urbit:talk> http://example.com/

### Expressions

Expressions can be used to show and evaluate Hoon code. Send an expression
by prefacing your message with `#`.

    ~your-urbit:talk> #(add 1 2)

will print as

    ~your-urbit# (add 1 2)
                 3

### Replies

To indicate what you're saying is in direct response to a specific
message, select the message (see Activating Lines below) and type your
response.

    ~some-urbit> hello! how are you?
    ~your-urbit:talk> ; good, thanks!

will print as

    ~your-urbit>^ good, thanks!

### Activating Lines

A line number identifying the *subsequent* line is displayed every 5
lines.

    ---------[0]
    ~your-urbit> this is my message
    ~your-urbit> this is another message
    ~your-urbit sends a message
    ~your-urbit/ http://example.com/
    ~your-urbit# (add 1 2)
                 3
    ---------[5]
    ~your-urbit>^ that's my message!

You can use a line number to *activate* a line:

    ~your-urbit:talk> ;5

which prints the number, line identifier, timestamp, sender, audience,
and contents:

    ? 0
      0v3.hl51p.jhege.amhec.vb37r.3rejr at ~2016.6.24..04.48.21..a235
      ~your-urbit to ~another-urbit
    in reply to: ~your-urbit:
    > this is my message
    that's my message!

If information got truncated — like happens for long URLs or expressions —
or if there's additional information available — as is the case with
replies and attachments — activating the message will show you all the
details.

You can activate the most recent line with `;`, the second-most recent
with `;;`, and so on.

### Creating and managing circles

`;create [type] %name 'description'`  
Creates and joins a circle, where `[type]` is any of the following:  
- `channel`: public circle. Has a blacklist for write control.
- `village`: invite-only circle.
- `journal`: publicly readable, invite-only for writing.
- `mailbox`: publicly writeable, can only be read by its host.

`;delete %name 'optional reason'`  
Deletes a circle. If a reason is specified, that gets sent to all
subscribers before the circle gets deleted.

`;depict %name 'description'`  
Changes the description of circle `%name`.

`;filter %name [capitals] [unicode]`  
Configures the message filter for circle `%name`: whether to allow
capital and/or unicode characters. `y`/`&`/`true` for allowed,
`n`/`|`/`false` for disallowed.

`;invite %name ~someone`  
Invite someone into your circle `%name`. If they were previously banished,
removes them from the blacklist.  
Can also invite multiple ships at once, `~comma, ~separated`.

`;banish %name ~someone`  
Banish someone from your circle `%name`. If they were previously invited,
removes them from the whitelist.  
Can also banish multiple ships at once, `~comma, ~separated`.

`;source %name ~other/circle`  
Adds `~other/circle` as a source for circle `%name`. This causes all
messages sent to `~other/circle` to also appear in `%name`.

`;unsource %name ~other/circle`  
Removes `~other/circle` as a source for circle `%name`.

### Membership

If you have joined a circle, you can make this information publicly
publicly available to help others find that circle as well.

`;show ~some/circle`  
Adds a circle to your public membership list.

`;hide ~some/circle`  
Removes a circle from your public membership list.

### Presence

You'll see presence notifications when people enter or leave stations
you're subscribed to.

`;set quiet`  
Turn off presence notifications

`;unset quiet`  
Turn on presence notifications

`;who`  
List everyone in all your subscribed circles. Optionally specify a
specific circle to list members of just those.

`;attend ~some/circle [presence]`  
Manually set your presence to show up as one of the following. (In the
future, a sufficiently advanced client can automatically set these for
you.)  
- `talk` - typing
- `hear` - listening
- `idle` - inactive
- `gone` - not present

`;name ~some/circle 'my handle'`  
Set a handle ("name") for yourself in a specific circle. It will display
to users who have done `;set nick`, but gets truncated if it's longer
than 14 characters.

### Audience

An audience consists of one or more messaging targets. These can be
circles or ships. (In the latter case, it's secretly the `~ship/inbox`
circle.)

### Circle glyphs

Glyphs are assigned by circle hash out of the following list

    > = + - } ) , . " ' ^ $ % & @

Alphanumeric characters and `|#;:*~_` are reserved; all others (the
above list, and `\/!?({<`) can be manually assigned.

`;bind + /urbit-test`
Assigns the `+` glyph to `/urbit-test`.

`;unbind + /urbit-test`
Unassigns the `+` glyph from `/urbit-test`.

To see what circle is bound to a glyph:

    ;what +  
    /urbit-test

### Prefixes

Received posts are prefixed with a glyph to let you know what the
audience is. You can activate an individual post to see the full
audience.  
There are a few special-purpose glyphs.

- `|` - Informational messages
- `:` - Posts directly to you
- `;` - Posts to you and others (a multiparty conversation)
- `*` - Posts to a complex audience that doesn't directly include you.

#### Prompt

The audience you're sending to is always shown in your prompt. If
there's a glyph for it, it's shown as the glyph.

Here we're talking to the station bound to `=`:

    ~your-urbit:talk=

Here we're talking directly to `~dannum-mitryl`:

    ~your-urbit:talk[~dannum-mitryl]

#### Configuration

`;~urbit/station`  
Set audience to `~urbit/station`.

`;=`  
Set audience to the station bound to the `=` glyph.

`;~dannum-mitryl`  
Set audience to `~dannum-mitryl` (a direct post).

`;%station`  
Set audience to a station on your own ship.

`;~dannum-mitryl this is a private message`  
Set the audience and send a post to it. This works for all of the above.

Your audience is configured 'implicitly' with regard to the following
rules (in order):

-   if you manually locked the audience, that audience.
-   if typing a post, the audience when you started typing.
-   if you activated a post, the post you activated.
-   audience of the last post received.
-   audience of the last post sent.

Clear any 'implicit' audience setting by moving your cursor to the start
of the line and pressing backspace (whether the line is empty or not).
Posting a line clears the typing and activation configurations.

### Local nicknames

`;nick`  
List all local nicknames.

`;nick ~your-urbit`  
Look up a nickname.

`;nick plato`  
Search in reverse.

`;nick ~your-urbit plato`  
Create a nickname.

`;nick ~your-urbit ~`  
Clear an assigned nickname.

`;set nicks`  
Show nicknames instead of urbit names. If no local nickname is set, uses
that user's handle. If the user has no handle, just the urbit name.

`;unset nicks`  
Show urbit names instead of nicknames.

Nicknames and handles longer than 14 character will be truncated in
output. Nicknames are strictly local - like the names on entries in a
phonebook.

### Miscellaneous configuration

`;set showtime`  
Show the timestamp for each message.

`;unset showtime`  
Stop showing the timestamp for each message.

`;set notify`  
Emit a terminal bell sound if your six-syllable ship name is mentioned in
a message.

`;unset notify`  
Do not notify when your ship name is mentioned.

`;set width [number]`  
Set the rendering width of `:talk` to a specific number of characters.
(Minimum of 30.)
