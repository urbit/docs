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

Each time you start your Urbit, the Arvo kernel calls the `%born` task for Eyre.
This `task` closes all previously open connections.

#### Accepts

```hoon
[~]
```

#### Returns

```hoon
[%set-config =http-config]
```

Eyre `%give`s a `%set-config` `gift` containing the default http configuration.


### `%cancel-request`

This `task` cancels a previous `%request`. Which `%request` to cancel is
inferred from the duct. 

#### Accepts

```hoon
[~]
```

#### Returns

What this `task` returns depends on the type of `%request` being canceled.

Associated to the `duct` is an `+outstanding-connection`, which contains an
`+action` that is in queue to be performed. The return depends on the value of the `+action`.

If the connection is empty, nothing has yet handled it and so Eyre does nothing.

A `%gen` `+action` triggers the following `move`:
```hoon
[%pass /run-build %f %kill ~]
```

For a `%app` `+action`,
```hoon
[%pass /watch-response/[eyre-id] %g %deal [our our] app.action.u.connection %leave ~]
```

For a `%authentication` `+action`, Eyre returns nothing.

For a `%channel` `+action`, Eyre cancels the subscription associated to the duct
but does not return any gift (I think?)

For a `%four-oh-four` `+action`, Eyre crashes as it should be impossible for a 404
page to be asynchronous.


### `%connect`

A `%connect` `task` binds an app to a site. It takes in the name of an app, the
`path` to that app, and a URL and adds it to `server-state.ax`, allowing the
site at the URL to interface with the app. This binding may be deleted with the
`%disconnect` `task`.

#### Accepts

```hoon
[=binding app=term]
```

A `+binding` is a system unique mapping that associates `path=(list @t)` to a
`site=(unit @t)` (typically a URL), and `app` is the name of the app.

#### Returns

```hoon
[%bound accepted=? =binding]
```
The `+binding` returned is always the `binding` that was given in the
`%connect` `task`.

Since `+binding`s are system unique, this `task` may fail if the `path` in the
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
report in response.

#### Accepts

```hoon
[=error]
```

An `$error` is a `[tag=@tas =tang]`.

#### Returns

Eyre does not `%give` a `gift` in response to a `%crud` `task`, but it does
`%slip` Dill a `%flog` `task` instructing it to print `error`.


### `%disconnect`

This `task` removes a `+binding` that was previously created with a `%connect`
or `%serve` `task`. This must be called via the same duct that the `+binding`
was originally created with.

#### Accepts

```hoon
[=binding]
```

#### Returns

This `task` returns no `gift`s.


### `%init`

`%init` is called a single time during the very first boot process, immediately
after the [larval stage](@/docs/tutorials/arvo/arvo.md#larval-stage-core)
is completed. This initializes the vane. Jael is initialized first, followed by
other vanes such as Eyre.

In response to receiving the `%init` `task`, Eyre sets the initial values for
the login handler.

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
As expected, `insecure` is the port number of the insecure port to be set, while
`secure` is the port number of the optional secure port to be set.

#### Returns

This `task` returns no `gift`s.


### `%request`

This `task` is used to start handling an inbound http request.

#### Accepts

```hoon
[secure=? =address =request:http]
```
The value of `secure` states whether the request is secure or not. `address` is
the client IP address.

`request:http` is a single http request. It consists of standard data for http
requests, formatted as follows.

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

The `method` is an http verb from the following list: `%'CONNECT'`, `%'DELETE'`, `%'GET'`,
`%'HEAD'`, `%'OPTIONS'`, `%'POST'`, `%'PUT'`, `%'TRACE'`.

#### Returns

This `task` may return a `%response` `gift` whose form depends on the `method` in the `request`.

```hoon
[=http-event:http]
```


### `%request-local`

#### Accepts

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
`cert`. If the card is `[%cert ~]` then the certificate and key pair stored by
Eyre are cleared.

For adding/removing a DNS binding, `http-rule` is  `[%turf action=?(%put %del)
=turf]`. As expected, `action=%put` adds a new DNS binding, and `action=%del`
deletes a DNS binding. A `$turf` is a `(list @t)` with the first entry being the
top level domain. `turf` is the DNS binding that is either being added or
deleted. In the case of trying to add a DNS binding that already exists or
deleting one that does not already exist, this `task` is a no-op.

#### Returns

If `http-rule` is a `%cert`, Eyre `%give`s Unix the following card,
```hoon
[%set-config config]
```
where `config` is the new http configuration stored by Eyre.

If `http-rule` is a `%turf`, Eyre will `%pass` `acme` (a Gall app for...) a
`%poke` of sort `%acme-order` with a `vase` containing the new `set` of `turf`s.
```hoon
[%pass /acme/order %g %deal [our our] %acme %poke `cage`[%acme-order !>(set turf)]]
```


### `%serve`

`%serve` is a cousin of `%connect`, and is used to connect a `+binding` to a
`+generator`. A `+generator` is a generator in the usual Hoon sense, along with
information on the `desk` and `path` where it is located and `args=*` to be
passed to the generator. This binding may be deleted with the `%disconnect` `task`.

#### Accepts

```hoon
[=binding =generator]
```
`binding` is the `+binding` that associates a `path=(list @t)` to a
`site=(unit @t)`, and `generator` is the `+generator` to be coupled to the `binding`.

#### Returns

```hoon
[%bound accepted=? =binding]
```
The `binding` returned is always the `+binding` that was given in the
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
