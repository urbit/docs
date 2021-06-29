+++
title = "Examples"
weight = 6
template = "doc.html"
+++

# Contents

- [Introduction](#introduction)
- [Authenticating](#authenticating)
- [Using the Channel System](#using-the-channel-system)
- [Scrying](#scrying)
- [Direct HTTP Handling With Gall Agents](#direct-http-handling-with-gall-agents)
- [Generators](#generators)
- [Managing CORS Origins](#managing-cors-origins)

# Introduction

This documents contains practical examples of the various ways of interacting with Eyre.

General documentation of the `task`s and methods described here are available in the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document and the [Internal API Reference](@/docs/arvo/eyre/tasks.md) document.

# Authenticating

In most cases we must obtain a valid session cookie by [authenticating](@/docs/arvo/eyre/external-api-ref.md#authentication) with our web login code (which can be obtained by running `+code` in the dojo) before we can use Eyre's interfaces (such as the channel system or scry interface).

Here we'll try authenticating with the default fakezod code.

Using `curl` in the unix terminal, we'll make an HTTP POST request with `"password=<code>"` in the body:

```
curl -i localhost:8080/~/login -X POST -d "password=lidlut-tabwed-pillex-ridrup"
```

Eyre will respond with HTTP status 204, and a `set-cookie` header containing the session cookie.

```
HTTP/1.1 204 ok
Date: Tue, 18 May 2021 01:38:48 GMT
Connection: keep-alive
Server: urbit/vere-1.5
set-cookie: urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm; Path=/; Max-Age=604800
```

The `urbauth-....` cookie can be now be included in subsequent requests (e.g. to the channel system) by providing it in a Cookie HTTP header.

# Using The Channel System

Here we'll look at a practical example of Eyre's channel system. You can refer to the [Channels](@/docs/arvo/eyre/external-api-ref.md#channels) section of the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document for relevant details.

First, we must obtain a session cookie by [authenticating](#authenticating).

Now that we have our cookie, we can try poking an app & simultaneously opening a new channel. In this case, we'll poke the `hood` app with a `mark` of `helm-hi` to print "Opening airlock" in the dojo.

We'll do this with an HTTP PUT request, and we'll include the cookie we obtained when we authenticated in the `Cookie` header. The URL path we'll make the request to will be `http://localhost:8080/~/channel/mychannel`. The last part of the path is the channel `UID` - the name for our new channel. Normally you'd use the current unix time plus a hash to ensure uniqueness, but in this case we'll just use `mychannel` for simplicity.

The data will be a JSON array containing a [poke](@/docs/arvo/eyre/external-api-ref.md#poke) `action`:

```
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" \
     --request PUT \
     --data '[{"id":1,"action":"poke","ship":"zod","app":"hood","mark":"helm-hi","json":"Opening airlock"}]' \
     http://localhost:8080/~/channel/my-channel
```

If we now have a look in the dojo we'll see it's printed our message, so the poke was successful:

```
< ~zod: Opening airlock
```

Now we can connect to the `mychannel` channel we opened. We do this with an HTTP GET request with our session cookie and the same path as the last request:

```
curl -i --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" http://localhost:8080/~/channel/my-channel
```

Eyre will respond with an HTTP status code of 200 and a `content-type` of `text/event-stream`, indicating an SSE (Server Sent Event) stream. It will also send us any pending events on the channel - in this case the poke ack as a [poke](@/docs/arvo/eyre/external-api-ref.md#poke-ack) `response` for our original poke:

```
HTTP/1.1 200 ok
Date: Tue, 18 May 2021 01:40:47 GMT
Connection: keep-alive
Server: urbit/vere-1.5
set-cookie: urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm; Path=/; Max-Age=604800
connection: keep-alive
cache-control: no-cache
content-type: text/event-stream
transfer-encoding: chunked

id: 0
data: {"ok":"ok","id":1,"response":"poke"}
```

Normally this event stream would be handled by an EventSource object or similar in Javascript or the equivalent in whatever other language you're using. Here, though, we'll continue using `curl` for simplicity.

Leaving the event stream connection open, in another shell session on unix we'll try subscribing to the watch path of a Gall agent - the `/updates` watch path of `graph-store` in this case.

We'll do this in the same way as the initial poke, except this time it will be a [subscribe](@/docs/arvo/eyre/external-api-ref.md#subscribe) `action`:

```
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" \
     --request PUT \
     --data '[{"id":2,"action":"subscribe","ship":"zod","app":"graph-store","path":"/updates"}]' \
     http://localhost:8080/~/channel/my-channel
```

Notice we've incremented the `id` to `2`. Eyre doesn't require IDs to be sequential, merely numerical and unique, but sequential IDs are typically the most practical.

Back in the event stream, we'll see a positive watch ack as a [subscribe](@/docs/arvo/eyre/external-api-ref.md#watch-ack) `response`, meaning the subscription has been successful:

```
id: 1
data: {"ok":"ok","id":2,"response":"subscribe"}
```

Now we'll try trigger an event on our event stream. In fakezod's landscape, create a new chat channel named "test". You should see the `add-graph` `graph-update` come through on our channel in a [diff](@/docs/arvo/eyre/external-api-ref.md#diff) `response`: 

```
id: 2
data: {"json":{"graph-update":{"add-graph":{"graph":{},"resource":{"name":"test-1183","ship":"zod"},"mark":"graph-validator-chat","overwrite":false}}},"id":2,"response":"diff"}
```

All events we receive must be `ack`ed so Eyre knows we've successfully received them. To do this we'll send an [ack](@/docs/arvo/eyre/external-api-ref.md#ack) `action` which specifies the `event-id` of the event in question - `2` in this case:

```
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" \
     --request PUT \
     --data '[{"id":3,"action":"ack","event-id":2}]' \
     http://localhost:8080/~/channel/my-channel
```

This same pattern would be repeated for all subsequent events. Note that when you `ack` one event, you also implicitly `ack` all previous events, so in this case event `1` will also be `ack`ed.

When we're finished, we can unsubscribe from `graph-store` `/update`. We do this by sending Eyre a [unsubscribe](@/docs/arvo/eyre/external-api-ref.md#unsubscribe) `action`, and specify the request ID of the original `subscribe` `action` in the `subscription` field - `2` in our case:

```
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" \
     --request PUT \
     --data '[{"id":4,"action":"unsubscribe","subscription":2}]' \
     http://localhost:8080/~/channel/my-channel
```

Unlike `poke` and `subscribe` actions, Eyre doesn't acknowledge `unsubscribe`s, but we'll now have stopped receiving updates from `graph-store`.

Finally, let's close the channel itself. We can do this simply by sending Eyre a [delete](@/docs/arvo/eyre/external-api-ref.md#delete-channel) `action`:

```
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.j2062.1prp1.qne4e.goq3h.ksudm" \
     --request PUT \
     --data '[{"id":5,"action":"delete"}]' \
     http://localhost:8080/~/channel/my-channel
```

With our channel deleted, we can now close the connection on the client side.

# Scrying

Here we'll look at performing scries through Eyre. You can refer to the [Scry](@/docs/arvo/eyre/external-api-ref.md#scry) section of the [External API Reference](@/docs/arvo/eyre/external-api-ref.md) document for relevant details.

First we must obtain a session cookie by [authenticating](#authenticating).

Having obtained a cookie, we can now try a scry. We'll scry the `graph-store` Gall agent on the `/x/keys` scry path, which will return the list of channels it has. If you don't already have any chat channels on your fakezod, go ahead and create one via landscape so it'll have something to return.

The url path will be `/~/scry/graph-store/keys.json`. The `/~/scry` part specifies a scry, the `/graph-store` part is the Gall agent, the `/keys` is the scry path without the `care`, and the `.json` file extension specifies the return `mark`.

The request will be an HTTP GET request:

```
curl -i --cookie "urbauth-~zod=0v1.1pseu.tq7hs.hps2t.ltaf1.tmqjm" \
        --request GET \
        http://localhost:8080/~/scry/graph-store/keys.json
```

Eyre will respond with HTTP status 200 if it's successful and the body of the response will contain the data we requested:

```
HTTP/1.1 200 ok
Date: Fri, 04 Jun 2021 10:16:32 GMT
Connection: keep-alive
Content-Length: 61
Server: urbit/vere-1.5
set-cookie: urbauth-~zod=0v1.1pseu.tq7hs.hps2t.ltaf1.tmqjm; Path=/; Max-Age=604800
content-type: application/json

{"graph-update":{"keys":[{"name":"test-1183","ship":"zod"}]}}
```

Now let's make a request to a non-existent scry endpoint:

```
curl -i --cookie "urbauth-~zod=0v1.1pseu.tq7hs.hps2t.ltaf1.tmqjm" \
        --request GET \
        http://localhost:8080/~/scry/foo/bar/baz.json
```

Eyre will respond with a 404 Missing status and an error message:

```
HTTP/1.1 404 missing
Date: Fri, 04 Jun 2021 10:22:51 GMT
Connection: keep-alive
Content-Length: 187
Server: urbit/vere-1.5
set-cookie: urbauth-~zod=0v1.1pseu.tq7hs.hps2t.ltaf1.tmqjm; Path=/; Max-Age=604800
content-type: text/html

<html><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>There was an error while handling the request for /foo/bar/baz.json.</p><code>no scry result</code></body></html>
```

# Direct HTTP Handling With Gall Agents

In many cases you'll just want to interact with Gall agents through the JSON API of the channel system, but it's also possible to bypass all that and just deal with HTTP requests directly. Here we'll take a look at how that practically works.

You can refer to the [%connect](@/docs/arvo/eyre/tasks.md#connect) section of the [Internal API Reference](@/docs/arvo/eyre/tasks.md) document for relevant details.

Here's a Gall agent that demonstrates this method. It binds the URL path `/foo`, serves `<h1>Hello, World!</h1>` for GET requests and a `405` error for all others. It also prints debug information to the terminal as various things happen.

Note that this example does a lot of things manually for demonstrative purposes. In practice you'd likely want to use a library like `/lib/server.hoon` to cut down on boilerplate code.

`eyre-agent.hoon`

```hoon
/+  default-agent, dbug
=*  card  card:agent:gall
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  on-init:def
++  on-save  on-save:def
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark
    (on-poke:def [mark vase])
  ::
      %noun
    ?.  =(q.vase %bind)
      %-  (slog leaf+"Bad argument." ~)
      `this
    %-  (slog leaf+"Attempting to bind /foo." ~)
    :_  this
    [%pass /bind-foo %arvo %e %connect `/'foo' %eyre-agent]~
  ::
      %handle-http-request
    =/  req  !<  (pair @ta inbound-request:eyre)  vase
    ~&  [mark req]
    ?+    method.request.q.req
      =/  data=octs
        (as-octs:mimes:html '<h1>405 Method Not Allowed</h1>')
      =/  content-length=@t
        (crip ((d-co:co 1) p.data))
      =/  =response-header:http
        :-  405
        :~  ['Content-Length' content-length]
            ['Content-Type' 'text/html']
            ['Allow' 'GET']
        ==
      :_  this
      :~
        [%give %fact [/http-response/[p.req]]~ %http-response-header !>(response-header)]
        [%give %fact [/http-response/[p.req]]~ %http-response-data !>(`data)]
        [%give %kick [/http-response/[p.req]]~ ~]
      ==
    ::
        %'GET'
      =/  data=octs
        (as-octs:mimes:html '<h1>Hello, World!</h1>')
      =/  content-length=@t
        (crip ((d-co:co 1) p.data))
      =/  =response-header:http
        :-  200
        :~  ['Content-Length' content-length]
            ['Content-Type' 'text/html']
        ==
      :_  this
      :~
        [%give %fact [/http-response/[p.req]]~ %http-response-header !>(response-header)]
        [%give %fact [/http-response/[p.req]]~ %http-response-data !>(`data)]
        [%give %kick [/http-response/[p.req]]~ ~]
      ==
    ==
  ==
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path
    (on-watch:def path)
  ::
      [%http-response *]
    %-  (slog leaf+"Eyre subscribed to {(spud path)}." ~)
    `this
  ==
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%bind-foo ~] wire)
    (on-arvo:def [wire sign-arvo])
  ?>  ?=([%eyre %bound *] sign-arvo)
  ?:  accepted.sign-arvo
    %-  (slog leaf+"/foo bound successfully!" ~)
    `this
  %-  (slog leaf+"Binding /foo failed!" ~)
  `this
++  on-fail   on-fail:def
--
```

Save the above to `/app/eyre-agent.hoon`. Commit it:

```
> |commit %home
>=
+ /~zod/home/2/app/eyre-agent/hoon
```

...and start it:

```
> |start %eyre-agent
>=
gall: loading %eyre-agent
activated app home/eyre-agent
[unlinked from [p=~zod q=%eyre-agent]]
```

Now, first we need to bind a url to our app. In the `++  on-poke` arm, our agent will send a [%connect](@/docs/arvo/eyre/tasks.md#connect) `task` to Eyre when poked with `%bind`:

```hoon
  %noun
?.  =(q.vase %bind)
  %-  (slog leaf+"Bad argument." ~)
  `this
%-  (slog leaf+"Attempting to bind /foo." ~)
:_  this
[%pass /eyre %arvo %e %connect `/'foo' %eyre-agent]~
```

...and when `%eyre` responds with a `%bound` gift, the `+on-agent` arm will print whether the bind succeeded:

```hoon
  [%eyre %bound *]
?:  accepted.sign-arvo
  %-  (slog leaf+"/foo bound successfully!" ~)
  `this
%-  (slog leaf+"Binding /foo failed!" ~)
`this
```
...so let's try:

```
> :eyre-agent %bind
>=
Attempting to bind /foo.
/foo bound successfully!
```

As you can see, we have successfully bound the `/foo` url path. Now we can try making an HTTP request. Over in the unix terminal, we can make a GET request using curl: 

```
> curl -i localhost:8080/foo
HTTP/1.1 200 ok
Date: Mon, 17 May 2021 04:39:40 GMT
Connection: keep-alive
Server: urbit/vere-1.5
Content-Type: text/html
Content-Length: 22
transfer-encoding: chunked

<h1>Hello, World!</h1>% 
```

...which has succeed! This is because the `+on-poke` arm tests for http GET requests and responds with `Hello, World!` when it sees one:

```hoon
  %'GET'
=/  data=octs
  (as-octs:mimes:html '<h1>Hello, World!</h1>')
=/  content-length=@t
  (crip ((d-co:co 1) p.data))
=/  =response-header:http
  :-  200
  :~  ['Content-Length' content-length]
      ['Content-Type' 'text/html']
  ==
:_  this
:~
  [%give %fact [/http-response/[p.req]]~ %http-response-header !>(response-header)]
  [%give %fact [/http-response/[p.req]]~ %http-response-data !>(`data)]
  [%give %kick [/http-response/[p.req]]~ ~]
==
```

Back in the dojo, our app's `+on-watch` arm has printed the path on which Eyre has subscribed for the response:

```
Eyre subscribed to /http-response/~.eyre_0v3.1knjk.l544e.5uds6.fn9l2.f8929.
```

...and it's also printed the request so you can see how it looks when it comes in:

```
[ %handle-http-request
  p=~.~.eyre_0v3.1knjk.l544e.5uds6.fn9l2.f8929
    q
  [ authenticated=%.n
    secure=%.n
    address=[%ipv4 .127.0.0.1]
      request
    [ method=%'GET'
      url='/foo'
        header-list
      ~[
        [key='host' value='localhost:8080']
        [key='user-agent' value='curl/7.76.1']
        [key='accept' value='*/*']
      ]
      body=~
    ]
  ]
]
```

This is a very rudimentary app but it demonstrates the basic mechanics of dealing with HTTP requests and serving responses.

# Generators

Here we'll look at running a generator via Eyre. Eyre doesn't have a mediated JSON API for generators, instead it just passes through the HTTP request and returns the HTTP response composed by the generator.

You can refer to the [%serve](@/docs/arvo/eyre/tasks.md#serve) section of the [Internal API Reference](@/docs/arvo/eyre/tasks.md) document for relevant details.

Here's a very simple generator that will just echo back the body of the request (if available) along with the current datetime. You can save it in the `/gen` directory and `|commit %home`.

Note that this example does some things manually for demonstrative purposes. In practice you'd likely want to use a library like `/lib/server.hoon` to cut down on boilerplate code.

`eyre-gen.hoon`

```hoon
|=  [[now=@da eny=@uvJ bec=beak] ~ ~]
|=  [authenticated=? =request:http]
^-  simple-payload:http
=/  msg=@t
  ?~  body.request
    (scot %da now)
  (cat 3 (cat 3 (scot %da now) 10) q.u.body.request)
=/  data=octs
  (as-octs:mimes:html msg)
=/  =response-header:http
  [200 ['Content-Type' 'text/plain']~]
[response-header `data]
```

Eyre requires generators to be a gate within a gate. The sample of the first gate must be:

```hoon
[[now=@da eny=@uvJ bec=beak] ~ ~]
```

The sample of the second nested gate must be:

```hoon
[authenticated=? =request:http]
```

The return type of the generator must be [simple-payload:http](@/docs/arvo/eyre/data-types.md#simple-payload-http). If you look at our example generator you'll see it meets these requirements.

Because generators return the entire HTTP message as a single `simple-payload`, Eyre can calculate the `content-length` itself and automatically add the header.

In order to make our generator available, we must bind it to a URL path. To do this, we send Eyre a `%serve` `task`, which looks like:

```hoon
[%serve =binding =generator]
```

The [binding](@/docs/arvo/eyre/data-types.md#binding) specifies the site and URL path, and the [generator](@/docs/arvo/eyre/data-types.md#generator) specifies the `desk`, the `path` to the generator, and arguments. Note that the passing of arguments to the generator by Eyre is not currently implemented, so you can just leave that as `~` since it won't do anything.

Let's bind our generator to the `/mygen` URL path with the `|pass` command in the dojo:

```
|pass [%e [%serve `/mygen %home /gen/eyre-gen/hoon ~]]
```

Note that Eyre responds with a `%bound` `gift` to indicate whether the binding succeeded but `|pass` doesn't take such responses so it's not shown.

Now let's try making an HTTP request using `curl` in the unix terminal:

```
curl -i http://localhost:8080/mygen --data 'blah blah blah'
```

We can see that the request has succeeded and our generator has responded with the datetime and request body:

```
HTTP/1.1 200 ok
Date: Sat, 29 May 2021 09:19:45 GMT
Connection: keep-alive
Content-Length: 41
Server: urbit/vere-1.5
Content-Type: text/plain
Content-Length: 41

~2021.5.29..09.19.45..e096
blah blah blah
```

# Managing CORS Origins

Here we'll look at approving and rejecting a CORS origin by passing Clay a [%approve-origin](@/docs/arvo/eyre/tasks.md#approve-origin) `task` and [%reject-origin](@/docs/arvo/eyre/tasks.md#reject-origin) `task` respectively.

In this example we'll use more manual methods for demonstrative purposes but note there are also the `|cors-approve` and `|cors-reject` generators to approve/reject origins from the dojo, and the `+cors-registry` generator for viewing the CORS configuration. 

First, using `|pass` in the dojo, let's approve the origin `http://foo.example` by sending Eyre a `%approve-origin` `task`:

```
|pass [%e [%approve-origin 'http://foo.example']] 
```

Now if we scry for the [approved](@/docs/arvo/eyre/scry.md#cors-approved) CORS `set`:

```
> .^(approved=(set @t) %ex /=//=/cors/approved)
approved={'http://foo.example'}
```

...we can see that `http://foo.example` has been added.

Next, let's test it by sending Eyre a CORS preflight request via `curl` in unix:

```
curl -i -X OPTIONS \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: X-Requested-With" \
     -H "Origin: http://foo.example" \
     http://localhost:8080
```

We can see in the response that it has succeeded:

```
HTTP/1.1 204 ok
Date: Fri, 28 May 2021 12:37:12 GMT
Connection: keep-alive
Server: urbit/vere-1.5
Access-Control-Allow-Origin: http://foo.example
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: X-Requested-With
Access-Control-Allow-Methods: POST
```

Now we'll try rejecting an `origin`. Back in the dojo, let's `|pass` Eyre a `%reject-origin` `task` for `http://bar.example`: 

```
|pass [%e [%reject-origin 'http://bar.example']]
```

If we scry for the [rejected](@/docs/arvo/eyre/scry.md#cors-rejected) CORS `set`:

```
> .^(rejected=(set @t) %ex /=//=/cors/rejected)
rejected={'http://bar.example'}
```

...we can see that `http://bar.example` has been added.

If we again test it with `curl` in unix:

```
curl -i -X OPTIONS \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: X-Requested-With" \
     -H "Origin: http://bar.example" \
     http://localhost:8080
```

...we can see that, as expected, it has not returned the access control headers:

```
HTTP/1.1 404 missing
Date: Fri, 28 May 2021 12:38:47 GMT
Connection: close
Server: urbit/vere-1.5
```

Finally, let's look at CORS requests that are neither approved nor rejected.

If we make another request with `curl` on unix, this time for `http://baz.example` which we haven't added to a list:

```
curl -i -X OPTIONS \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: X-Requested-With" \
     -H "Origin: http://baz.example" \
     http://localhost:8080
```

...we can see it also correctly fails to return the access control headers:

```
HTTP/1.1 404 missing
Date: Fri, 28 May 2021 12:39:59 GMT
Connection: close
Server: urbit/vere-1.5
```

Now if we scry for the [requests](@/docs/arvo/eyre/scry.md#cors-requests) CORS `set`: 

```
> .^(requests=(set @t) %ex /=//=/cors/requests)
requests={'http://baz.example' 'http://localhost:8080'}
```

... we can see it has automatically been added by the mere fact of the request being made.
