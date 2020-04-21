+++
title = "2.7 Gall"
weight = 35
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/gall/"]
+++

> Note: This guide is outdated. For an updated explanation of Gall, take a look at [/tutorial/arvo/gall](/docs/tutorials/arvo/gall)

Gall is the Arvo vane responsible for handling user space applications. When writing a Gall application there are several things you will need to understand.

## bowl and moves

The [core](/docs/glossary/core/) of a gall app is a [door](/docs/glossary/door/) which has two parts of its subject, the first a `bowl:gall` which contains a lot of standard things used by gall apps, the second a type containing app state information.

Vanes in Arvo communicate by means of `moves`. When a move is produced by an [arm](/docs/glossary/arm/) in a gall app, it's dispatched by Arvo to the correct handler for the request, be it another application or another vane. A `move` is pair of `bone` and `card`. These are essential components to understand when learning to use gall.

A `bone` is an opaque cause that initiates a request. When constructing a `move` you can often use `ost.bowl` and when responding to an incoming `move` you can use the `bone` in that `move` to construct your response.

A `card` is the effect or event that is being requested. Each application should define the set of `cards` it can produce. Here is an excerpt from `clock.hoon` showing its `cards`

```hoon
+$  card
  $%  [%poke wire dock poke]
      [%http-response =http-event:http]
      [%connect wire binding:eyre term]
      [%diff %json json]
  ==
```

Each `card` is a pair of a tag and a [noun](/docs/glossary/noun/). The tag indicates what the event being triggered is and the [noun](/docs/glossary/noun/) is any data required for that event.

## Arms

Gall applications can have a number of arms that get called depending on the information they are sent.

### ++prep

`++prep` is the arm that is called when an application is first started or when it's updated. This arm should be a [gate](/docs/glossary/gate/) that takes a `unit` of a noun and provides a way, if necessary, to make any changes to the application's data required by an upgrade. As a reminder, a `unit` is a type that may contain another type or it might contain `~`. They are used when there may or may not be some data available.

Often when developing an application you will not initially care about the data. Here is a sample `++prep` arm that will simply throw away the previous application state.

```hoon
++  prep
    |=  a=(unit *)
    `(quip move _+>.$)`[~ +>.$]
```

### ++poke

`++poke` is one of the primary arms used when building a Gall application. A `poke` is often a request to perform some operation that the application was designed for. These are requests from outside the application. `++poke` will get called with the raw noun data which can then be inspected to perform the requested actions with.

Many arms, `++poke` included, have variants that end in the name of a mark e.g. `++poke-noun`. Which one gets called will be based on which mark was used to create the poke. Gall will attempt to use the most specific arm it can find, eventually falling back to `++poke` if no matching mark arm is found. Use of these mark arms, however, is now discouraged.

### ++coup

`++coup` is a response handler for any pokes our application sent out.

### ++peer

`++peer` is used to handle subscriptions. When something subscribes to your application this arm will run. The something could be another Gall application on your ship or another ship or a tile from landscape or anything else that is able to communicate with Gall. Your outgoing subscriptions will not be tracked automatically but incoming ones will live in `sup.bowl` so that you can send information to them when required.

### ++pull

`++pull` is run when someone unsubscribes from your application, this is used to run any changes needed for your application when they unsubscribed. Their removal from `sup.bowl` is handled for you.

### ++quit

`++quit` gets called when a subscription is dropped. Often you will just want to resubscribe when this happens.

### ++reap

`++reap` is to `++peer` as `++coup` is to `++poke`, that is to say it's the arm that gets run in acknowledgment of outgoing subscription requests.

### ++diff

`++diff` gets called when an application you are subscribed to has an update. It could either be an entirely new set of data for that application or an update to existing data.

### ++sigh

`++sigh` gets called when Eyre has a response to an http request made by our application.

Let's take a look in the next section at an example Gall app.
