+++
title = "Messaging"
weight = 2
template = "doc.html"
+++

Chat (also called "chat-cli") is the built-in messaging app for Urbit.

For the time being come join us in `~dopzod/urbit-help` by using the
'quickstart' section below. `~dopzod` is the host ship, and `/urbit-help` is the
channel on that ship.

### Quickstart

The most common uses of `:chat-cli` right now are communicating over a public chat channel on `~dopzod/urbit-help`, and sending direct messages. Everyone is more than welcome in `~dopzod/urbit-help`. It's the place to get help, ask questions and chat about Urbit in general.

There are two ways of using `:chat-cli`: from the terminal running the Urbit process, or through the Landscape web UI available from your ship’s URL address, mentioned earlier in this guide.

### Joining a chat

In `:chat-cli`, any kind of medium for a message is called a _chat_. There are four types of chats: the _channel_ (public with blacklist), _village_ (private with whitelist), the _journal_ (publicly readable, privately writable), and the _mailbox_ (privately readable, publicly writable). But for now we'll be dealing with the _channel_, a publicly accessible chatroom for general use. We'll discuss the other three kinds in the [manual](#messaging-manual) section later on.

Let's join the `~dopzod/urbit-help` channel. Use `ctrl-x` to switch from the Dojo prompt to the Chat prompt.

Then:

```
~your-urbit:chat-cli> ;join ~dopzod/urbit-help
```

Scrolling down your terminal window, you'll probably see a playback of previous `~dopzod/urbit-help` messages that you missed. You c

Post a line to `~dopzod/urbit-help:`

```
~your-urbit:chat-cli= Hello, world!
```

You'll see your message printed below messages from others that came before it. You can always type `;chats` in the `chat-cli` prompt to list all the chats you're in:



Glyphs will be automatically assigned to channels, but have the option of binding a glyph (single non-alphanumeric character) to the channel you're joining; the syntax is in the form of `;join ~dopzod/books +`. The chosen glyph will be the symbol that ends your prompt, and it will be what you use as a shortcut to switch to this channel.

```
~your-urbit:chat-cli= ;+
~your-urbit:chat-cli+
```

Use `;leave` to unsubscribe from a channel:

```
~your-urbit:chat-cli= ;leave ~dopzod/urbit-help
```

Now, let's create a channel we can invite some friends to:

```
~your-urbit:chat-cli= ;create channel /my-channel
```

Now you can tell your friends to `;join ~your-urbit/my-channel`.

### Direct messaging

To send a direct message to someone, first set your audience:

```
~your-urbit:chat-cli= ;~talsur-todres
```

You'll see your prompt change:

```
~your-urbit:chat-cli[~talsur-todres]
```

Now you and `~talsur-todres` can exchange messages directly.

```
~your-urbit:chat-cli[~talsur-todres] Hey buddy!
```

To set your audience back to `~dopzod/urbit-help`:

```
~your-urbit:chat-cli[~talsur-todres] ;~dopzod/urbit-help
```

You'll see your prompt change back:

```
~your-urbit:chat-cli=
```

#### Hoon

You can use Chat to evaluate Hoon code and share the results with everyone in a chat. To do so, preface your Hoon with `#`.

```
~your-urbit:chat-cli= #(add 2 2)
```

will print as

```
~your-urbit# (add 2 2)
4
```

### Creating and managing chats

As mentioned before, any urbit can host any number of chats. Existing chats can be deleted or modified with various commands. All commands in this section should be sent from the `chat-cli>` prompt.

#### Create

Syntax: `;create [type] /name +`, where `+` represents an optional glyph.

Creates and joins a chat, where `[type]` is any of the following:
- `channel`: public chat. Has a blacklist for write control.
- `village`: invite-only chat.
- `journal`: publicly readable, invite-only for writing.
- `mailbox`: publicly writeable, can only be read by its host.

Let's create an example mailbox:

```
sampel-palnet:chat-cli> ;create mailbox /coolbox ^
```

#### Delete

Syntax: `;delete /name`

Deletes a chat.

### Status

You'll see status notifications when people enter or leave chats you're subscribed to.

#### Notifications off

Syntax: `;set quiet`

Turn off status (and config) notifications.

#### Notifications on

Syntax: `;unset quiet`

Turn on status (and config) notifications.

#### Chat glyphs

Glyphs are found at the end of your prompt to as a quick indicator of where
your messages will be sent.

Glyphs are assigned by chat hash out of the following list:

```
> = + - } ) , . " ' ^ $ % & @
```

Alphanumeric characters and `|#;:*~_` are reserved; all others (the
above list, and `\/!?({<`) can be manually assigned.

For example, `-` the glyph at the end of the prompt below might indicates that
messages sent from this prompt will go to some chat with that glyph:

```
~sampel-palnet:chat-cli-
```

To see what chat is bound to a glyph, use the `;what` command followed by the
glyph in question, or use `;what` without specifying a glyph to see all of your
subscriptions which are bound to glyphs. For example, to see `=`:

```
~sampel-palnet:chat-cli> ;what =
~dopzod/urbit-help
```

To see all of your glyph-bound subscriptions:

```
~sampel-palnet:chat-cli> ;what
> ~paldev/numismatic-forum
. ~middev/ny-martians
= ~dopzod/urbit-help
```

Not every audience has a glyph, however. When the audience doesn't have a glyph,
such as in the case of direct-messaging a ship, we see their name at the end of
the prompt instead. Here we're talking directly to `~dannum-mitryl`:

```
~sampel-palnet:chat-cli[~dannum-mitryl]
```

#### Bind

Syntax: `;bind [glyph] /chat-name`

Assigns the chosen glyph to a chat owned by your ship.

For example:

```
~sampel-palnet:chat-cli> ;bind + /my-chat
```

#### Unbind

Syntax: `;unbind [glyph] /chat-name`

Unassigns the chosen glyph from a chat owned by your ship.

For example:

```
~sampel-palnet:chat-cli> ;unbind + /my-chat
```

#### Prefixes

Received posts are prefixed with a glyph to let you know what the
audience is. You can activate an individual post to see the full
audience.

There are a few special-purpose glyphs:

- `|` - Informational messages
- `:` - Posts directly to you
- `;` - Posts to you and others (a multiparty conversation)
- `*` - Posts to a complex audience that doesn't directly include you.


### Configuration

#### Set audience

`;~ship/chat`

Set audience to `~ship/chat`.

#### Set audience by glyph

Syntax: `;[glyph]`

Set audience to the chat previously bound to the chosen glyph.

#### Set audience to ship

syntax `;~ship`

Set audience to another ship.

#### Set audience to own chat

Syntax: `;%chat`

Set audience to a chat on your own ship.

#### Set audience and send message

Syntax: `;~dannum-mitryl this is a private message`

Set the audience and send a post in the same line. This works for all of the
above audience commands.

Your audience is configured with regard to the following rules (in order):

- if you manually set the audience, that audience.
- if you activated a post, the post you activated.
- audience of the last post sent.

### Miscellaneous configuration

#### Show timestamps

Syntax: `;set showtime`

Show the timestamp for each message. This is set by default.

#### Hide timestamps

Syntax: `;unset showtime`

Stop showing the timestamp for each message.

#### Change timezone

Syntax: `;set timezone [+/-][hours]`

Adjust the display of timestamps to a specific timezone. Relative to UTC.

#### Sound notification on

Syntax: `;set notify`

Emit a terminal bell sound if your six-syllable ship name is mentioned in
a message. This is set by default.

#### Sound notification off

Syntax `;unset notify`

Do not notify when your ship name is mentioned.

#### Set width

Syntax: `;set width [number]`

Set the rendering width of `:chat-cli` to a specific number of characters.
(Minimum of 30.)
