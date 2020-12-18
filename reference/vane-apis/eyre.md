+++
title = "Eyre Public API"
weight = 4
template = "doc.html"
+++

# Eyre

In this document we describe the public interface for Eyre. Namely, we describe
each `task` that Eyre can be `%pass`ed, and which `gift`(s) Eyre can `%give` in return.


## Tasks

### `%born`

Every time you resume your urbit, the Arvo kernel calls the `%born` task for Eyre.
This `task` closes all previously open connections.

#### Accepts

```hoon
[~]
```

#### Returns

```hoon
[%set-config =http-config]
```

Eyre `%give`s a `%set-config` `gift` containing the default http server configuration
to Arvo, which then sets the configuration for the external http server in Unix
(which lives in the King).


### `%cancel-request`

This `task` cancels a previous `%request`. Which `%request` to cancel is
inferred from the `duct`. 

#### Accepts

```hoon
[~]
```

#### Returns

This `task` does not return any `gift`s.



### `%connect`

A `%connect` `task` conditionally associates an `%app` `action` to a `binding`.
This means that when an http request is made to Eyre via a `%request` `task`
that matches `binding`, Eyre will subscribe to the Gall app previously
identified by this `task` and poke it with the request data. This `task` will
fail if the `binding` already exists.

The `binding` created by this `task` may later be deleted with a `%disconnect` `task`.

#### Accepts

```hoon
[=binding app=term]
```

A `binding` is a `[site=(unit @t) path=(list @t)]`. The `site `is a domain
literal being hosted by Eyre, while `path` is an identifier for the app. Each
value of `binding` may only be used once on the ship - it is system unique.

`app` is the name of the Gall app to be associated to the `binding`.

#### Returns

Eyre `%give`s the following `gift`:
```hoon
[%bound accepted=? =binding]
```
The `binding` returned is always the `binding` that was given in the
`%connect` `task`.

Since `binding`s are system unique, this `task` will fail if the
`binding` is already in use. In this case, `accepted=%.n`, else `accepted=%.y`.

#### Example

`%chat-view` is an app that sets up the `chat` Javascript client, paginates data,
and combines commands into semantic actions for the UI. When initialized, it
`%pass`es a `%connect` `task` to Eyre asking it to associate the default URL
(represented by `~` and corresponding to `your.urbit.org`) and the `path`
`/'~chat'` to the `%chat-view` app like so.

```hoon
[%pass / %arvo %e %connect [~ /'~chat'] %chat-view]
```


### `%crud`

`%crud` is called whenever an event involving Eyre fails. It produces a crash
report in response, printed by Dill.

#### Accepts

```hoon
[=error]
```

An `error` is a `[tag=@tas =tang]`. `tag` is the type of error, and `tang` is
the error message.

#### Returns

Eyre does not `%give` a `gift` in response to a `%crud` `task`,



### `%disconnect`

This `task` removes a `binding` that was previously created with a `%connect`
or `%serve` `task`. This must be called via the same duct that the `binding`
was originally created with, or else the task will do nothing.

#### Accepts

```hoon
[=binding]
```
`binding` is the `$binding` to be removed.

#### Returns

This `task` returns no `gift`s.


### `%init`

`%init` is called a single time during the very first boot process, immediately
after the [larval stage](@/docs/tutorials/arvo/arvo.md#larval-stage-core)
is completed. This initializes the vane.

In response to receiving the `%init` `task`, Eyre adds the following entries to
`bindings` stored in the server state, where `bindings=(list [=binding =duct
=action])`.

```
[~ /~/login] duct [%authentication ~]
[~ /~/logout] duct [%logout ~]
[~ /~/channel] duct [%channel ~]
[~ /~/scry] duct [%scry ~]
```
Here, `duct` is the `$duct` to Unix.

#### Accepts

```hoon
[p=ship]
```
The argument with `%init` is always the `@p` of the ship, but Eyre does not make
use of it.

#### Returns

This `task` returns no `gift`s.


### `%live`

This `task` is used to tell Eyre the ports of the currently live http servers on
the ship. Each server must have an insecure port `@ud`, and may have a secure
one as well.

#### Accepts

```hoon
[insecure=@ud secure=(unit @ud)]
```
`insecure` is a `@ud` to which the insecure port number is to be set, while
`secure` is an optional `@ud` to which the secure port number is to be set.

#### Returns

This `task` returns no `gift`s.


### `%request`

This `task` is used to start handling an inbound http request. As such, it is
the `task` that does most of the heavy lifting for Eyre.

The general concept and structure of a `%request` is more or less the same as it
is for an ordinary http server request - it consists of a method (such as POST,
GET, etc.), the URL that was input by the client, the list of headers, and an
optional body of raw input.

#### Accepts

```hoon
[secure=? =address =request:http]
```
`secure` states whether the request is secure or not. `address` is
the client IP address.

`request:http` is a single http request. It consists of standard data for http
requests, formatted as follows. Here, the `header-list` is a `(list [key=@t value=@t])`.

```hoon
+$  request
    $:  ::  method: http method
        ::
        method=method
        ::  url: the url requested
        ::
        ::    The url is not escaped. There is no escape.
        ::
        url=@t
        ::  header-list: headers to pass with this request
        ::
        =header-list
        ::  body: optionally, data to send with this request
        ::
        body=(unit octs)
    ==
```

This `task` triggers an `action` to be performed based on the input data.

First, Eyre checks whether `url.request:http` is a prefix for any of the `path`s
listed in `bindings` kept by Eyre's server state that have `site` equal to the
value of the `'host'` key in the `header-list`

Assuming there is a match, the matched `binding` will have previously been
paired with some `action` by a `%connect` `task` or `%init` `task`. This
`action` declares what sort of target the `http-request` is intended for - an
app, generator, channel, authentication page, or 404 error.

`method` is an http verb from the following list: `%'CONNECT'`, `%'DELETE'`, `%'GET'`,
`%'HEAD'`, `%'OPTIONS'`, `%'POST'`, `%'PUT'`, `%'TRACE'`. This is the type of
request being made to the target given by the `action` triggered
by the `task`.

#### Actions

If the `url.request:http` matches one of Eyre's `bindings`, it will trigger one
of the following `action`s: `%gen`, `%app`, `%authentication`, `%logout`,
`%channel`, `%scry`, or `%four-oh-four`. We describe each of these actions here.

Each `binding` in the `bindings` in Eyre's `server-state` is associated with a
`duct` as well as an `action`. Eyre's `connections.server-state` associates each `duct`
with an `outstanding-connection`.

??? A `%gen` `action` will trigger a `%pass` to Ford to `%build`. - not sure this
is still true

A `%app` `action` will cause Eyre to `%pass` Gall two `card`s:
 - a `%deal` `note` wrapping a `%watch` `card` to the `app` associated with the
   `action` in `bindings`, and
 - a `%deal` `note` wrapping a `%poke %handle-http-request` `card` to the `app`
   containing the `request:http`.
   
A `%authentication` `action` will cause Eyre to handle an http request for the
login page (the same one used by Landscape). How this proceeds depends on the
`method` in the `request`.

```hoon
::
        %app
      :_  state
      (subscribe-to-app app.action inbound-request.connection)
    ::
        %authentication
      (handle-request:authentication secure address request)
    ::
        %logout
      (handle-logout:authentication authenticated request)
    ::
        %channel
      (handle-request:by-channel secure authenticated address request)
    ::
        %scry
      (handle-scry authenticated address request(url suburl))
    ::
        %four-oh-four
      %^  return-static-data-on-duct  404  'text/html'
      (error-page 404 authenticated url.request ~)
    ==
```

#### Returns

This `task` may return a `%response` `gift` whose contents depends on the form
of the `%request` `task`.

We split into cases based on the `action` that was triggered.

A `%gen` `action` returns no `gift`s.

A `%authentication` `action` may return a `%response` `gift`:
```hoon
[=http-event:http]
```
The form of `http-event` depends on the `method`. A `'GET'` will return the
requested `site`. A `'POST'` will process the `body` of the `http-request` as
form data and submit it. Any other `method` will return a `[%response %cancel]`
`gift`, indicating an error. This will also happen if a `'GET'` or `'POST'`
request is improperly formatted.

A `%channel` `action` is for a request to a specific `$channel` specified in the
`http-request`. The response depends on the `method`.

A `'PUT'` will start/modify a channel, and returns a `%response` `gift` `[=http-event:http]`.

3 arms that I think are involved here: on-put-request, on-get-request, on-cancel-request.
They are called by +handle-request, of which there are two: in +by-channel and +authentication


### `%request-local`

This `task` is used to start handling a backdoor http request, meaning that it
skips the authentication step.

#### Accepts

```hoon
[%request-local secure=? =address =request:http]
```

#### Returns


### `%rule`

This `task` is used to update Eyre's http configuration. More specifically, it
is used to set or clear a TLS certificate and key pair, or add/remove a DNS binding.


#### Accepts

```hoon
[=http-rule]
```

For setting or clearing a certificate, `http-rule` is `[%cert cert=(unit
[key=wain cert=wain])]`. If `cert` is equal to the one already stored
by Eyre, this `task` is a no-op. If `cert` is different, the old one is replaced by
`cert`. If the `card` is `[%cert ~]` then the certificate and key pair stored by
Eyre are cleared.

For adding/removing a DNS binding, `http-rule` is  `[%turf action=?(%put %del)
=turf]`. As expected, `action=%put` adds a new DNS binding, and `action=%del`
deletes a DNS binding. A `turf` is a `(list @t)` with the first entry being the
top level domain. `turf` is the DNS binding that is either being added or
deleted. In the case of trying to add a DNS binding that already exists or
deleting one that does not already exist, this `task` is a no-op.

#### Returns

If `http-rule` is a `%cert`, Eyre `%give`s Unix the following `gift`,
```hoon
[%set-config config]
```
where `config` is the new http configuration stored by Eyre.

If `http-rule` is a `%turf`, Eyre will `%pass` `acme` via Gall a
`%acme-order` `%poke`  with a `vase` containing the new `set` of `turf`s.
```hoon
[%pass /acme/order %g %deal [our our] %acme %poke `cage`[%acme-order !>(set turf)]]
```


### `%serve`

`%serve` is a cousin of `%connect`, and is used to connect a `binding` to a
`generator`.  This binding may be deleted with the `%disconnect` `task`.

#### Accepts

```hoon
[=binding =generator]
```
`binding` associates a `path=(list @t)` to a
`site=(unit @t)`, and `generator` is to be coupled to the `binding`.

A `generator` is used to represent a generator on the local ship run with a set
of arguments. It contains the `desk` and `path`
where the generator is located and `args=*` to be passed to the gate.

#### Returns

```hoon
[%bound accepted=? =binding]
```
The `binding` returned is always the `binding` that was given in the
`%connect` `task`.

Since `binding`s are system unique, this `task` may fail if the `path` in the
`binding` is already in use. In this case, `accepted=%.n`, else `accepted=%.y`.


### `%trim`

#### Accepts

#### Returns


### `%vega`

`%vega` is called whenever the kernel is updated. Eyre currently does not do
anything in response to this.

#### Accepts

`%vega` takes no arguments.

#### Returns

This `task` returns no `gift`s.


### `%wegh`

This `task` is a request to Eyre to produce a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

In response to this `task,` Eyre `%give`s a `%mass` `gift` containing Eyre's
current memory usage.
