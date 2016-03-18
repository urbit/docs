---
next: true
sort: 4
title: Talk manual
---

# `:talk` 

`:talk` is the Urbit messaging and notifications protocol.  Today we use `:talk` to chat and coordinate, sort of like a distributed, encrypted Slack.  This is the simplest, most immediate use for `:talk`, but we hope it can become much more than just persistent IRC.  `:talk` is a general purpose tool for both aggregating and publishing heterogenous streams of messages.  Applications can use `:talk` as their transport protcol, API connectors can push disparate data sources into `:talk`, there are lots of things a distributed message protocol can be used for.

`:talk`s design is similar in spirit to [nntp](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol) the underlying protocol for Usenet.  Let's briefly outline the design: `:talk` messages are called ‘posts’.  Posts go to ‘stations’.  Any urbit can host or subscribe to any number of stations.  There’s no central `:talk` server.  Any Urbit can host one.  There are four kinds of station: a write-only `%mailbox` for direct messages, an invite-only `%party` for private conversation, a read-only `%journal` for curated content, and a public-access `%board` for general use.

## Quickstart

There are two ways of using `:talk`: from the CLI or through a web interface available at `http://localhost:8080/talk` (or equivalent).  The web interface ships as compiled JavaScript on your Urbit, but has its own source repo [here](https://github.com/urbit/talk).

The web interface doesn't expose *all* the functionality of the CLI, and it's more or less self-explanatory.  We'll give examples from the command line.

Let's join a station:

    ~fintud-macrep: ;join ~doznec/urbit-meta

You'll see:

    ---------:talk| %porch subscribed to /urbit-meta, called `>`
    ---------:talk| rules of /urbit-meta:
    ---------:talk|   don't be rude
    ---------:talk|   urbit-meta is politically correct and safe for work
           ~doznec= ~fintud-macrep admitted to %urbit-meta
    ~fintud-macrep:talk>

Post a line to `/urbit-meta`:

    ~fintud-macrep:talk> hello, world

You'll see, echoed back at you through `~doznec`:

    ~fintud-macrep> hello, world

To send a direct message to someone, first set your audience:

    ~fintud-macrep:talk> ;~talsur-todres

You'll see your prompt change:

    ~fintud-macrep:talk[~talsur-todres]

Then you're ready to chat away.  

Those are the basics, and the rest is covered below.

## Manual

### Input conventions

There are three kinds of inputs you can type at the `:talk`
prompt: lines, URLs, and commands.

#### Lines

A line is 64 bytes of ASCII lowercase and spaces.  If the line
starts with '@', it's an action (IRC `/me`).

The `:talk` interface will let you keep typing past 64 bytes, but
insert a Unicode bullet-point character in an appropriate space
in your post, to show you the prospective linebreak.  Your essay
will be posted in multiple lines.

#### URLs

A URL is any valid URL. 

### Commands

A command is any line starting with `;`.

### Prefixes

`|` - Informational messages

`:` - Posts directly to you

`;` - Posts to you and others (a multiparty conversation)

`*` - Posts to a complex audience that doesn't directly include you are.

### Station Glyphs

Glyphs are assigned by station hash out of the lists `>=+-`, `}),.`,
``"'`^``, and `$%&@`, in decreasing order of preference, and cycling
back to the first in case of sufficient collisions.

You can see a list of glyph bindings with `;what`.  Write

Alphanumeric characters and `|#;:*~_` are reserved; all others (the above
lists, and `\/!?({<`) can be manually assigned. `;bind > /urbit-test`
will assign the `>` annotation to `/urbit-test`.

### Audience selection

The audience is always shown in your prompt.  If there's a glyph
for it, it's shown as the glyph:

    ~fintud-macrep:talk= 

Otherwise, the audience is shown in parens:

    ~fintud-macrep:talk(~dannum-mitryl) 

To manually set the audience, the command
is simply `;station` - eg, `;~dannum-mitryl` for a direct post;
`;/urbit-meta` or `;~doznec/urbit-meta` to post to a federal
station, `;%mystation` to post to a station on your own ship.
For a station bound to a glyph, `;` then the glyph; eg, `;>`.

You can post a line and set the audience in one command, eg:

    ;~dannum-mitryl this is a private message

You can configure your audience in a number of ways, which are
applied in priority order.  From strongest to weakest:

- if typing a post, the audience when you started typing.
- if you activated a post (see below), the post you activated.
- if you manually locked the audience (see above), that audience.
- audience of the last post received.
- audience of the last post sent.

You can clear any audience setting layer by moving your cursor to
the start of the line and pressing backspace (whether the line is
empty or not).  Posting a line clears the typing and activation
configurations.

### Post activation and numbering

Every post can summarize itself in 64 bytes.  But some posts
contain more information, which is not displayed by default.
Displaying this "attachment" is an opt-in operation.  In the
post, it's marked by an underscore `_`, instead of a space,
between source and content.

The conventional example is a URL.  When you post a URL:

    ~fintud-macrep:talk= http://foobar.com/moo/baz

This will appear in the flow as:

    ~fintud-macrep>_foobar.com

meaning that `~fintud-macrep` posted a link to `foobar.com`,
on the station or conversation whose glyph is `>`.

The effect of activating a post depends on the post.  For a link,
the full URL is shown.  For a text
post, activating shows the full audience, for complex audiences.

Posts in your `:talk` flow are numbered; the numbers are printed
every five posts, as

    ----------[5955]

You can specify a post to activate in two ways: by absolute or
relative position.  Absolute position is a direct history number:

    ;5955

If you use fewer digits than are in the current flow number, the
high digits are defaulted "deli style" - if the current number is
5955, typing `;3` means `;5953`, and `;140` means `;5140`.  To
actually activate post `3`, write `;0003`.

A unary sequence of `;` characters looks backward from the
present.  `;` activates the most recent post; `;;` the second
most recent; etc.

### Nicknames

Sometimes you know your Urbit friends by other names, on or
offline.   Use the `;nick` command to assign or look up
nicknames.

`;nick` - list all nicknames

`;nick ~fintud-macrep` - look up a nickname

`;nick plato` - search in reverse

`;nick ~fintud-macrep plato` create a nickname

`;nick ~fintud-macrep ~` clear an assigned nickname

`;set noob` show nicknames instead of urbit names

`;unset noob` show urbit names instead of nicknames

All nicknames must be 14 characters or less, lowercase.  Nicknames are strictly local - like the names on
entries in a phonebook.  Sometimes in a post you want to mention
someone you know by a nickname.  Just type `~plato`, and `:talk`
will replace it with `~fintud-macrep`.

### Presence

You'll see presence notifications when people enter or leave
stations you're subscribed to.

`;who`  - list everyone in all your stations

`;who station` - list everyone in that station

### Creating and managing stations
To create your own mailbox, party, journal or board:

    ;create journal %serious-journal
    ;create channel %serious-journal

etc.

Every form of station has an exception list; to block
`~dannum-mitryl` from your default mailbox `%porch`,

    ;block %porch ~dannum-mitryl

To invite people to `%myfunparty`:

    ;invite %myfunparty ~dannum-mitryl, ~lagret-marpub

To ban from `%bizarre-board`:

    ;banish %bizarre-board ~dannum-mitryl

To appoint a coauthor of `%serious-journal`:

    ;author %serious-journal ~lagret-marpub

