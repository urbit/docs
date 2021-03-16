+++
title = "Subscriptions"
weight = 50
template = "doc.html"
+++

Urbit relies heavily on subscriptions throughout the stack.  We strongly
prefer reactive data flow compared to querying or polling, which is why
for example our equivalent to git natively supports subscriptions to its
data.

We have many application-level styles of subscription, but we only have
three true subscription types in Arvo, named for the vane they're
implemented in: Clay subscriptions (filesystem), Gall subscriptions
(applications), and Jael subscriptions (Urbit ID info).  They're at
three different points in the idea maze of subscriptions, and we'll
encounter each of them here.

For our purposes, a subscription is a stream of events from a publisher
to a subscriber, where (1) the publisher has indicated interest in that
stream, (2) any update sent to one subscriber is sent to all subscribers
on the same stream, and (3) when the publisher has a new update ready,
they send it immediately to their subscribers instead of waiting for a
later request.

## Basic properties

### Exactly-once updates

Some subscriptions need the subscriber to receive each update separately
instead of collapsing them into a single diff.  Sometimes a subscription
is really a sequence of commands, in which case there's no meaningful
way to collapse them.  Similarly, software updates may be expected to be
applied in order.

### Syncing data

Other times, it's more natural to think of a subscription as
communicating a data structure, where the only goal is to keep the data
structure on the subscriber's side up-to-date with what's on the
publisher's side.  In this case, it's perfectly fine to collapse several
updates into one large update, or even to resend the entire data
structure.  Partial updates exist only as an optimization.

For this sort of subscription, we commonly use terms like "diff" instead
of "message" or "update", and we say that we "apply a diff" instead of
"process an update".  We also often identify the subscription with the
data structure itself.

## Memory pressure

Naively implemented, subscriptions pose a memory leak risk if the
subscriber can't receive updates as fast as the publisher wants to send
them.  This commonly happens when the subscriber goes offline for an
extended period of time (possibly forever; especially for comets).  It's
sufficient to bound the amount of memory dedicated to any particular
subscriber.

In a synchronous system, you don't have to worry about what happens if
one side or the other ceases to be available.  All of our subscriptions,
though, can happen between ships.

### Small data

For particularly low-volume subscriptions, it may be acceptable to
ignore the problem.  Jael uses this approach, since the only time it's
used across ships is to update moon keys, which is very low-volume and
less than 1KB per update.  If these subscriptions are used for more,
this strategy will have to be revisited.

### Buffers

A common solution to this problem is the venerable buffer.  If more than
N updates need to be sent, start dropping updates.  There are several
options for what to do when the buffer is full and the publisher wishes
to send another message:

- Drop the oldest message.  Particularly suitable for systems where new
messages obsolete old ones.  For example, if you just need the latest
ticker price for an asset, you could use a buffer size of one and
replaced it any time you have a new price.

- Don't add the new message to the buffer.  Semantically this is usually
less helpful, but mechanically it can be simpler and reduce memory
churn, since the buffer stops changing and new messages are simply
ignored.

- Drop the newest message and close the subscription.  Unlike the
previous two, this is compatible with the principle of exactly-once
messaging.  Specifically, it preserves the guarantee that you won't
receive two non-consecutive subscription updates, at the cost of making
you resubscribe if you fall behind.

Gall subscriptions use the last of these.  The buffer is bounded by a
simple heuristic, and when a subscription exceeds that buffer, it is
closed and the app is expected to resubscribe when they come back
online.  Note that even though the subscription is closed, messages in
flight cannot be removed until they've been acknowledged since Ames
guarantees exactly-once messaging, so those last few messages will be
stuck in memory until the subscriber comes back online.

Buffers are commonly bounded by size, but this puts constraints on the
types of messages may be sent.  They may also be bounded in time: if the
subscriber stops taking messages for at least X time, the buffer is
full.  Gall taks a hybrid approach; currently the heuristic is that the
buffer counts as full if it has at least five messages and it has been
30 seconds since a message was acknowledged.

### One at a time

Another scheme is to avoid multi-message subscriptions.  Instead of
allowing the subscriber to subscribe to all future updates on a path,
allow them to "subscribe" to the *next* update only.  When they get that
update, they subscribe to the new next update, so that they ultimately
get every message.

Commonly this is implemented where each update is given a version
number, and every time you hear update N you request update N+1 (even
though you won't get an answer for an indeterminate period of time).

This is near the theoretical ideal for memory usage, since you'll never
queue up several messages to send to the subscriber.

It also encourages processing each update in order rather than zooming
forward from time to time.  It's possible (if a little awkward) to
simulate this with buffers though, and it's possible to allow zooming
forward in the one-at-a-time scheme by having the requests be "most
recent after update N" instead of "next after update N".

This scheme is at its strongest, then, when you're already storing
intermediate states or updates, or when you don't care about
intermediate states and always send the most recent one.  Otherwise,
buffers are a convenient place to temporarily store updates that you
don't want to store internally.  Of course, if it's semantically
important that you give each update separately, buffers won't save you
from having to store the intermediate updates, since they may fill up.

Another conceptual advantage is that it has no notion of "connectivity".
It operates forever in a single mode.  By contrast, buffer-based
solutions must keep track of whether the buffer is full and react to
that.  This increases complexity in the system, and complexity is the
great evil.

The biggest disadvantage of this system is that it takes much longer to
process many small updates.  With buffers, the publisher could have a
dozen small updates in flight at the same time, while in this scheme
they would only send one at a time, waiting for a response between each
one.  Losing this pipelining can be quite significant for some
applications, but for low-volume subscriptions (certainly anything that
updates less than once per minute) this will have no noticeable effect.

Clay uses this scheme.  It's low-volume, it stores all previous states
anyway (since it's a revision-control system), and it's sometimes
important to get updates one at a time (for example when downloading OTA
software updates).  Ships that send OTA updates often have many ships
subscribed to them, and the updates themselves may be large, so it's
important they don't queue up when ships inevitably disappear.

I tend to think most Gall subscriptions should follow this pattern as
well.  Our most latency-sensitive subscriptions are chat messages, and
while I haven't tested it, I would guess that even those wouldn't be
affected by this scheme.
