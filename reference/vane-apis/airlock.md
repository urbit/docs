+++
title = "Airlock"
weight = 1
template = "doc.html"
insert_anchor_links = "none"
+++

Airlock is the term to describe the set of APIs for interacting with a running Urbit ship from outside of the Urbit network.

## Urlock-py

Urlock-py is a python library for using Airlock.

It consists of a single class `Urlock`. Methods are below.

`__init__(url, code)`

    Constructor

    `url` - url to the http interface of the running ship

    `code` - the `+code` of the ship, should never be published


`connect()`

    Connect to the running ship


`poke(ship, app, mark, j)`

    `ship` - ship to send the poke

    `app` - gall application to send the poke to

    `mark` - mark of data sent to the gall application

    `j` - json poke data


`ack(eventId)`

    Send an acknowledgment of receipt of a message so it's cleared from the ship's queue

    `eventId` - id of the event to acknowledge


`sse_pipe()`

    returns the sseclient object


`subscribe(ship, app, path)`

    `ship` - ship on which the gall application lives

    `app` - gall application to subscribe to

    `path` - path to subscribe on


Below is a simple script to send a message and subscribe to a chat channel. The specifics require an understanding of the `chat-store` and `chat-hook` interfaces.

Even without experience with python this should be pretty readable.

```
#!/usr/bin/python3

import urlock
import baseconvert
import time
import random
import dumper

zod = urlock.Urlock("http://localhost:8080", "lidlut-tabwed-pillex-ridrup")
r = zod.connect()
s = zod.subscribe("zod", "chat-store", "/mailbox/~/~zod/mc")

pipe = zod.sse_pipe()

s = baseconvert.base(random.getrandbits(128), 10, 32, string=True).lower()
uid = '0v' + '.'.join(s[i:i+5] for i in range(0, len(s), 5))[::-1]

p = zod.poke("zod", "chat-hook", "json", {"message": {"path": "/~/~zod/mc",
                                                      "envelope": {"uid": uid,
                                                                   "number": 1,
                                                                   "author": "~zod",
                                                                   "when": int(time.time() * 1000),
                                                                   "letter": {"text": "hello world!"}}}})


for m in pipe.events():
   dumper.dump(m)
   dumper.dump(zod.ack(int(m.id)))
```

After the imports, instantiating the Urlock class with the address of the running ship and the `+code` from the ship. This code should not be shared. The one used here is for fakezods.

```
zod = urlock.Urlock("http://localhost:8080", "lidlut-tabwed-pillex-ridrup")
```

Next we connect to the ship and set up a subscription to chat-store

```
r = zod.connect()
s = zod.subscribe("zod", "chat-store", "/mailbox/~/~zod/mc")
```

After this we get the SSE pipe that all responses will arrive on.

```
pipe = zod.sse_pipe()
```

Next comes some setup for specific implementation details of `chat-hook` and a `poke` is sent to create a new chat message.

```
s = baseconvert.base(random.getrandbits(128), 10, 32, string=True).lower()
uid = '0v' + '.'.join(s[i:i+5] for i in range(0, len(s), 5))[::-1]

p = zod.poke("zod", "chat-hook", "json", {"message": {"path": "/~/~zod/mc",
                                                      "envelope": {"uid": uid,
                                                                   "number": 1,
                                                                   "author": "~zod",
                                                                   "when": int(time.time() * 1000),
                                                                   "letter": {"text": "hello world!"}}}})
```

Finally, the loop here is used to read messages from the sse pipe and send back an acknowledgment. This is important to clear the queue on the ship.

```
for m in pipe.events():
   dumper.dump(m)
   dumper.dump(zod.ack(int(m.id)))
```
