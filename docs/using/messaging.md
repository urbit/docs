---
navhome: /docs
next: true
sort: 4
title: Messaging (:talk)
---

# Messaging (`:talk`)

<div class="row">
<div class="col-md-8">

`:talk` is the Urbit messaging and notifications protocol.  Today we use `:talk` just to chat and coordinate, but it's really a general purpose piece of infrastructure.  

For the time being come join us in `/urbit-meta` by using the <a href="#-quickstart">quickstart</a> below.

Today `:talk` is sort of like a distributed, encrypted Slack that can be used from the CLI and the browser.  There’s no central `:talk` server.  Any Urbit can host one.

`:talk` is a general purpose tool for both aggregating and publishing streams of messages.  Applications can use `:talk` as their transport protcol, API connectors can push disparate data sources into `:talk`, and so on. There are lots of things a distributed message protocol can be used for that we haven't even thought of.

</div>
</div>

## Quickstart

For the most part we use `:talk` as a single-instance of Slack: one main channel (`/urbit-meta`) and dms.  Everyone is more than welcome in `/urbit-meta`.  It's the place to get help, ask questions and chat about Urbit in general.

Let's join `/urbit-meta`:

    ~your-urbit: ;join ~doznec/urbit-meta

You'll see:

    ---------:talk| %porch subscribed to /urbit-meta, called `>`
    ---------:talk| rules of /urbit-meta:
    ---------:talk|   don't be rude
    ---------:talk|   urbit-meta is politically correct and safe for work
           ~doznec= ~your-urbit admitted to %urbit-meta
    ~your-urbit:talk>

Post a line to `/urbit-meta`:

    ~your-urbit:talk> hello, world

You'll see, echoed back at you through `~doznec`:

    ~your-urbit> hello, world

To send a direct message to someone, first set your audience:

    ~your-urbit:talk> ;~talsur-todres

You'll see your prompt change:

    ~your-urbit:talk[~talsur-todres]

Now you and `~talsur-todres` can exchange messages directly.

To set your audience back to `/urbit-meta`:

    ~your-urbit:talk> ;~doznec/urbit-meta

Use `;leave` to unsubscribe from a channel:

    ~your-urbit:talk> ;leave ~doznec/urbit-meta

There are two ways of using `:talk`: from the CLI or through a web ui available at `http://your-urbit.urbit.org/talk` (or `http://localhost:8080/talk`).

The web ui ships as compiled JavaScript on your Urbit, but has its own source repo [here](https://github.com/urbit/talk).

Last, let's create a channel we can invite some friends to:

    ~your-urbit:talk> ;create channel %my-channel 'some description'

Now you can tell your friends to `;join ~your-urbit/my-channel`.

## Manual

`:talk`'s design is similar in spirit to [nntp](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol), the underlying protocol for Usenet.  

Our design is pretty simple: `:talk` messages are called ‘posts’.  Posts go to ‘stations’.  Any urbit can host or subscribe to any number of stations.  

There are four kinds of station: a write-only `%mailbox` for direct messages, an invite-only `%party` for private conversation, a read-only `%journal` for curated content, and a public-access `%channel` for general use.

### Posts

For the time being a post is either a line, a URL or a command.

#### Lines

A line is 64 bytes of ASCII lowercase, spaces and punctuation.  If the line starts with '@', it's an action (IRC `/me`).

The `:talk` interface will let you keep typing past 64 bytes, but
insert a Unicode bullet-point character in an appropriate space
in your post, to show you the prospective linebreak.  Your essay
will be posted in multiple lines.

#### URLs

A URL is any valid URL.

### Commands

A command is a hoon expression, prefaced by '#'.

### Creating and managing stations

`;create journal %serious-journal 'description'` - Creates a `%journal`, a privately writable publicly readable station.

`;create channel %serious-channel 'description'` - Creates a `%channel`, a publicly readable publicly writeable station.

### Presence

You'll see presence notifications when people enter or leave
stations you're subscribed to.

`;who`  - list everyone in all your stations

`;who station` - list everyone in that station

### Station Glyphs

Glyphs are assigned by station hash out of the following list

    > = + - } ) , . " ' ^ $ % & @

Alphanumeric characters and `|#;:*~_` are reserved; all others (the above lists, and `\/!?({<`) can be manually assigned.

`;bind > /urbit-test` - assigns the `>` glyph to `/urbit-test`.

### Prefixes

Received posts are prefixed with a glyph to let you know what the audience is.  You can activate an individual post to see the full audience.

`|` - Informational messages

`:` - Posts directly to you

`;` - Posts to you and others (a multiparty conversation)

`*` - Posts to a complex audience that doesn't directly include you.

### Audience

#### Prompt

The audience you're sending to is always shown in your prompt.  If there's a glyph for it, it's shown as the glyph.  

Here we're talking to the station bound to `=`:

    ~your-urbit:talk=

Here we're talking directly to `~dannum-mitryl`:

    ~your-urbit:talk(~dannum-mitryl)

#### Configuration

`;~urbit/station` - Set audience to `~urbit/station`

`;=` - Set audience to the station bound to the `=` glyph

`;~dannum-mitryl` - Set audience to `~dannum-mitryl` (a direct post).

`;%station` - Set audience to a station on your own ship

`;~dannum-mitryl this is a private message` - Set the audience and send a post in the same line.  This works for all of the above.

Your audience is configured 'implicitly' with regard to the following rules (in order):

- if you manually locked the audience, that audience.
- if typing a post, the audience when you started typing.
- if you activated a post, the post you activated.
- audience of the last post received.
- audience of the last post sent.

Clear any 'implicit' audience setting by moving your cursor to
the start of the line and pressing backspace (whether the line is
empty or not).  Posting a line clears the typing and activation
configurations.

### Nicknames

`;nick` - list all nicknames

`;nick ~your-urbit` - look up a nickname

`;nick plato` - search in reverse

`;nick ~your-urbit plato` create a nickname

`;nick ~your-urbit ~` clear an assigned nickname

`;set noob` show nicknames instead of urbit names

`;unset noob` show urbit names instead of nicknames

All nicknames must be 14 characters or less, lowercase.  Nicknames are strictly local - like the names on entries in a phonebook.  Sometimes in a post you want to mention someone you know by a nickname.  Just type `~plato`, and `:talk` will replace it with `~your-urbit`.
