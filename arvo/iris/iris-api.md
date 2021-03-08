+++
title = "API Reference"
weight = 10
template = "doc.html"
+++

In this document we describe the public interface for Iris. Namely, we describe
each `task` that Iris can be `%pass`ed, and which `gift`(s) Iris can `%give` in
return.

## Returns to Unix

Much of what Iris does is translating `task`s from other vanes into `card`s
meant for Unix via the `%request` and `%cancel-request` `task`s. What this means in practice is that Iris may be `%pass`ed a
`task` via some `duct`, which in response Iris then `%give`s a `gift` to Unix
via another `duct`. This `gift` will actually be a response to the `%born`
`task` that Iris was `%pass`ed when the Urbit was resumed, which came along the
duct to Unix.


## Tasks

### `%born`

Each time you start your Urbit the Arvo kernel calls the `%born` `task` for
Iris. This causes Iris to cancel any outstanding http requests and resets all
connection states.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

In response to a `%born` `task` Iris `give`s a `%http-response %cancel` `gift`
to each outstanding connection.


### `%cancel-request`

This `task` cancels a previous fetch. Iris knows which request is meant based on the
`duct` that the `task` comes on.

 We note that `%cancel-request` is also a `gift` that Iris can `%give`.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

```hoon
[%cancel-request id=@ud]
```
Receiving this `task` causes Iris to `%give`s a `%cancel-request` `gift` to Unix,
which then cancels the request in the runtime. See [Returns to Unix](#returns-to-unix).

`id` is obtained via a `(map duct @ud)`, with the `duct` corresponding to one along
which the `%cancel-request` `task` came with.


### `%crud`

`%crud` is called whenever an error involving Iris occurs. It produces a crash
report in response.

#### Accepts

```hoon
[p=@tas q=(list tank)]
```

`p` is the type of error, `q` is the error message.

#### Returns

Iris does not `%give` a `gift` in response to a `%crud` `task`, but it does
`%slip` Dill a `%flog` `task` instructing it to print the error.


### `%receive`

The `%receive` `task` is used to receive a response from Unix to an `http-request` that
was made.

#### Accepts

```hoon
[id=@ud =http-event:http]
```

`id` is the identification number assigned by Iris to the http connection under
consideration. `http-event` is a packet that contains a header and data.

#### Returns

The response depends on what kind of packet `http-event` is: `%start`,
`%continue`, or `%cancel` and whether the `complete` flag is `%.y` or `%.n`.

If the packet says to `%start` or `%continue` and `complete=%.n`, Iris will `%give` a
`%http-response %progress` `gift`.

If the packet says to `%start` or `%continue` and `complete=%.y`, Iris will
`%give` a `%http-response %finished` `gift`.

If the packet says to `%cancel`, Iris will `%give` a `%http-response %cancel`
`gift` in return. The `complete` flag is unused here.


### `%request`

`%request` is used to fetch a remote resource. `%request` is also a `gift` Iris
can `%give`.

#### Accepts

```hoon
[=request:http =outbound-config]
```

A `$request` consists of the following:
 - `=method`, the http method, which is one of `CONNECT`, `DELETE`, `GET`,
 `HEAD`, `OPTIONS`, `POST`, `PUT`, and `TRACE`.
 - `url=@t`, the URL being requested
 - `=header-list`, a list of headers to pass with the request,
 - `body=(unit octs)`, optional data to include in the request.

 A `$outbound-config` contains the number of redirects and retries that Iris
 will attempt. By default this is 5 redirects (the recommended limit for the
 http standard) and 3 retries.

#### Returns

```hoon
[id=@ud request=request:http]
```
Iris will `%give` a `%request` `gift` to Unix in response to a `%request`
`task`. See [Returns to Unix](#returns-to-unix). This `gift`
contains the `request` in the original `task` as well as the ID number assigned
by Iris for that particular http connection, which is extracted from the input `task`.


### `%trim`

This `task` is sent by the interpreter to free up memory. It has no effect on Iris.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task` returns no `gift`s.


### `%vega`

This `task` informs the vane that the kernel has been upgraded. Iris does not do
anything in response to this.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task` returns no `gift`s.


### `%wegh`

This `task` asks Iris to product a memory usage report.

#### Accepts

This `task` has no arguments.

#### Returns

When Iris is `%pass`ed this `task`, it will `%give` a `%mass` `gift` in response
containing Iris' current memory usage.


