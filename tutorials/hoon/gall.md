+++
title = "2.7 Gall"
weight = 35
template = "doc.html"
aliases = ["/docs/learn/hoon/hoon-tutorial/gall/"]
+++

Gall is the Arvo vane responsible for handling stateful user space applications. When writing a Gall application there are several things you will need to understand.

## bowl and moves

The core of a Gall app is a door whose subject has two parts: a `bowl:gall` which contains standard things used by Gall apps and a type containing app state information.

The data contained in `bowl:gall` is quite generic.
```hoon
  ++  bowl                                              ::  standard app state
          $:  $:  our=ship                              ::  host
                  src=ship                              ::  guest
                  dap=term                              ::  agent
              ==                                        ::
              $:  wex=boat                              ::  outgoing subs
                  sup=bitt                              ::  incoming subs
              ==                                        ::
              $:  ost=bone                              ::  opaque cause
                  act=@ud                               ::  change number
                  eny=@uvJ                              ::  entropy
                  now=@da                               ::  current time
                  byk=beak                              ::  load source
          ==  ==
```

Vanes in Arvo communicate by means of `move`s. When a `move` is produced by an arm in a Gall app, it's dispatched by Arvo to the correct handler for the request, be it another application or another vane. A `move` is `pair` of `bone` and `card`. These are essential components to understand when learning to use Gall.

A `bone` is an opaque cause that initiates a request. When constructing a outgoing `move` you will frequently use `ost.bowl` to acquire essential information, such as a `bone` describing the initial cause. When responding to an incoming `move` you can use the `bone` in the received `move` to construct your response.

A `card` describes the effect or event that is being requested. Each application should define the set of `card`s that it can produce. Here is an excerpt from `clock.hoon` showing its `card`s.

```hoon
+$  card
  $%  [%poke wire dock poke]
      [%http-response =http-event:http]
      [%connect wire binding:eyre term]
      [%diff %json json]
  ==
```

Each `card` is a `pair` consisting of a tag and a noun. The tag indicates what the event being triggered is (such a tag is referred to as a mark), and the noun is any data required for that event.

## Arms

Gall applications can have a number of arms that get called depending on the `move`s they are sent. Here we describe several arms that nearly every Gall app will have.

### ++prep

`++prep` is the arm that is called when an application is first started or when it's updated. This arm should be a gate that takes a `unit` of a noun and provides a way, if necessary, to make any changes to the application's data required by an upgrade.  As a reminder, `++unit` is a mold generator which takes in a type `a` and constructs a new type whose values are `~` to represent the absence of data and `[~ u=a]` to represent data of type `a`. Accordingly, they are used when there may or may not be some data available. 

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

`++peer` is used to handle subscriptions. When something subscribes to your application this arm will be called. The something could be another Gall application on your ship, another ship, a tile from Landscape, or anything else that is able to communicate with Gall. Your outgoing subscriptions will not be tracked automatically but incoming ones will live in `sup.bowl` so that you can send information to them when required.

### ++pull

`++pull` is called whenever something unsubscribes from your application. This is used to perform any changes needed for your application once the unsubscribe request is received and accepted. The removal of the subscription from `sup.bowl` is handled for you.

### ++quit

`++quit` gets called when a subscription is dropped. Often you will just want to resubscribe when this happens.

### ++reap

`++reap` is to `++peer` as `++coup` is to `++poke`, that is to say it's the arm that gets run in acknowledgment of outgoing subscription requests.

### ++diff

`++diff` gets called when an application you are subscribed to has an update. It could either be an entirely new set of data for that application or an update to existing data.

In the next section we will look at a simple example of a Gall app.