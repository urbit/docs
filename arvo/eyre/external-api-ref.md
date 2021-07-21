+++
title = "External API Reference"
weight = 2
template = "doc.html"
+++

# Contents

- [Introduction](#introduction)
- [Authentication](#authentication)
- [Channels](#channels)
   - [HTTP Requests](#http-requests)
   - [Actions](#actions)
     - [Poke](#poke)
     - [Subscribe](#subscribe)
     - [Ack](#ack)
     - [Unsubscribe](#unsubscribe)
     - [Delete Channel](#delete-channel)
   - [Responses](#responses)
     - [Poke Ack](#poke-ack)
     - [Watch Ack](#watch-ack)
     - [Diff](#diff)
     - [Quit](#quit)
- [Scry](#scry)
- [Spider](#spider)
  
# Introduction

This document contains reference information about Eyre's external APIs including [the channel system](#channels) and [scries](#scry). Each section will also have practical examples in the [Examples](@/docs/arvo/eyre/examples.md) document.

# Authentication

To use Eyre's channel system, run threads or perform scries you must first obtain a session cookie by authenticating with the following HTTP request:

| HTTP Method | Data                                   | URL Path   | Notes                                                                               |
|-------------|----------------------------------------|------------|-------------------------------------------------------------------------------------|
| `POST`      | `password=lidlut-tabwed-pillex-ridrup` | `/~/login` | The password is your web login code which can be obtained with `+code` in the dojo. |

Eyre's response will include a `set-cookie` header like:

```
set-cookie: urbauth-~zod=0v4.ilskp.psv00.t09r0.l8rps.3n97v; Path=/; Max-Age=604800
```

The `urbauth-{...}` cookie provided must be included in a `cookie` header with all subsequent requests like:

```
cookie: urbauth-~zod=0v4.ilskp.psv00.t09r0.l8rps.3n97v
```

# Channels

Eyre's channel system is the primary way of interacting with Gall agents from outside of Urbit.

Data from an external HTTP client is sent to Eyre as an [HTTP PUT request](#http-requests) containing one or more [action](#actions) JSON objects. Clients must obtain a session cookie by [authenticating](#authentication) with Eyre in order to make such requests.

Data from Eyre is sent back to the external HTTP client on a channel as SSEs ([Server Sent Events](https://html.spec.whatwg.org/#server-sent-events)) containing a [response](#responses) JSON object.

A new channel is automatically created whenever a client sends an [action](#action) in an [HTTP PUT request](#http-requests) to `http{s}://{host}{port}/~/channel/{uid}` with a new `uid`. To connect to the channel and receive any pending events, you just send an HTTP GET request with a valid session cookie to that URL.

The response you'll get to the GET request will be an event stream. Events will come in like:

```
id: 0
data: {"ok":"ok","id":1,"response":"poke"}
```

If you're working with Javascript in the browser context you'll handle these with an EventSource object or by using fetch and ReadableStream. If you're using another language, there'll likely be a library available to handle SSEs.

All the events that Eyre sends you on a channel must be [ack](#ack)ed so that Eyre can forget about them and clear them from the channel state. If `fact`s (as [diff](#diff)s) from Gall agents to which you've subscribed are left un`ack`ed long enough, Eyre will consider the particular subscription clogged and automatically unsubscribe you. Note that `ack`ing one event will implicitly `ack` all previous events.

When you're finished with a channel, you can send Eyre a [delete action](#delete-channel) to close it.

See the [Using the Channel System](@/docs/arvo/eyre/examples.md#using-the-channel-system) section of the [Examples](@/docs/arvo/eyre/examples.md) document for a practical example.

## HTTP Requests

[Actions](#actions) are sent to Eyre in HTTP PUT requests:

| HTTP Method | Required Headers          | Data                                                           | URL Path           |
|-------------|---------------------------|----------------------------------------------------------------|--------------------|
| `PUT`       | `Content-Type` & `Cookie` | One or more [actions](#actions) wrapped in a JSON array (`[]`) | `/~/channel/{uid}` |

The `cookie` header contains the session cookie obtained by [authenticating](#authentication). The data is a JSON array containing one or more JSON [action](#actions) objects. The channel `uid` is a unique name of your choosing. Typically you'd use the current unix time and a hash but there's no specific requirements. If you're opening a new channel you'd choose a new `uid` and if you already have a channel open you'd just use that.

If successful, Eyre will respond with a status code of 204. Note the HTTP response will have no content, any [responses](#responses) will be sent as SSEs on the channel event stream.

## Actions

### Poke

This is for poking a Gall agent.

| Key      | JSON Type | Example Value | Description                                                   |
|----------|-----------|---------------|---------------------------------------------------------------|
| `id`     | Number    | `1`           | ID for keeping track of sent messages.             |
| `action` | String    | `'poke'`      | The kind of action.                                           |
| `ship`   | String    | `'zod'`       | Target ship name, excluding leading `~`.                             |
| `app`    | String    | `'hood'`      | Name of the gall agent you're poking.                         |
| `mark`   | String    | `'helm-hi'`   | Type of data. Must correspond to a mark definition in `/mar`. |
| `json`   | Any       | `'hello'`     | Actual payload. Any JSON type, determined by app.             |

**Example**

```json
{
  'id': 1,
  'action': 'poke',
  'ship': 'zod',
  'app': 'hood',
  'mark': 'helm-hi',
  'json': 'hello'
}
```

**Response**

Eyre will send a [poke ack](#poke-ack) as an SSE event on the channel event stream.

### Subscribe

This is for subscribing to a watch `path` of a Gall agent.

| Key      | JSON Type | Example Value   | Description                                         |
|----------|-----------|-----------------|-----------------------------------------------------|
| `id`     | Number    | `2`             | ID for keeping track of sent messages.   |
| `action` | String    | `'subscribe'`   | The kind of action.                                 |
| `ship`   | String    | `'zod'`         | Target ship name, excluding leading `~`.                   |
| `app`    | String    | `'graph-store'` | Name of the gall agent to which you're subscribing. |
| `path`   | String    | `'/updates'`    | The path to watch. Depends on the app.              |

**Example**

```json
{
  'id': 2,
  'action': 'subscribe',
  'ship': 'zod',
  'app': 'graph-store',
  'path': '/updates'
}
```

**Response**

Eyre will send back a [watch ack](#watch-ack). If subscribing was successful, you will also begin receiving any [diff](#diff)s sent by the Gall agent on the specified `path`.

### Ack

This is for acknowledging an SSE event. If you `ack` one event, you also implicitly `ack` all previous events. Events *must* be `ack`ed so that Eyre can forget them. If you leave `fact`s (as [diff](#diff)s) un`ack`ed long enough, Eyre will consider the subscription clogged and automatically unsubscribe you.

| Key        | JSON Type | Example Value | Description                                            |
|------------|-----------|---------------|--------------------------------------------------------|
| `id`       | Number    | `3`           | ID for keeping track of sent messages.      |
| `action`   | String    | `'ack'`       | The kind of action.                                    |
| `event-id` | Number    | `7`           | ID of SSE event up to which you're acknowledging receipt |

**Example**

```json
{
  'id': 3,
  'action': 'ack',
  'event-id': 7,
}
```

**Response**

Eyre will not respond to an `ack` action.

### Unsubscribe

This is for unsubscribing from a Gall agent watch `path` to which you've previously subscribed.

| Key            | JSON Type | Example Value | Description                                                |
|----------------|-----------|---------------|------------------------------------------------------------|
| `id`           | Number    | `4`           | ID for keeping track of sent messages.          |
| `action`       | String    | `unsubscribe` | The kind of action.                                        |
| `subscription` | Number    | `2`           | Request ID of the initial `subscribe` action from earlier. |

**Example**

```json
{
  'id': 4,
  'action': 'unsubscribe',
  'subscription': 2
}
```

**Response**

Eyre will not respond to an `unsubscribe` action.

### Delete Channel

This is for deleting the channel itself.

| Key      | JSON Type | Example Value | Description                                       |
|----------|-----------|---------------|---------------------------------------------------|
| `id`     | Number    | `5`           | ID for keeping track of sent messages. |
| `action` | String    | `'delete'`    | The kind of action.                               |

**Example**

```json
{
  'id': 5,
  'action': 'delete'
}
```

**Response**

Eyre will not respond to a `delete` action.

## Responses

### Poke Ack

This acknowledgement comes in response to a [poke](#poke) action. A poke ack with an `ok` key means the poke succeeded. A poke ack with an `err` key means the poke failed.

**Positive Poke Ack**

| Key        | JSON Type | Example Value | Description                                  |
|------------|-----------|---------------|----------------------------------------------|
| `ok`       | String    | `'ok'`        | Positive acknowledgement.                    |
| `id`       | Number    | `1`           | Request ID of the `poke` being acknowledged. |
| `response` | String    | `'poke'`      | The kind of action being acknowledged.       |

**Example**

```json
{
  'ok': 'ok',
  'id': 1,
  'response': 'poke'
}
```

**Negative Poke Ack**

| Key        | JSON Type | Example Value    | Description                                                           |
|------------|-----------|------------------|-----------------------------------------------------------------------|
| `err`      | String    | `'some text...'` | Negative acknowledgement. Contains an error message and/or traceback. |
| `id`       | Number    | `1`              | Request ID of the `poke` being acknowledged.                          |
| `response` | String    | `'poke'`         | The kind of action being acknowledged.                                |

**Example**

```json
{
  'err': '<error message and traceback>',
  'id': 1,
  'response': 'poke'
}
```

**Action Required**

You must ack the event.

### Watch Ack

This acknowledgement comes in response to a [subscribe](#subscribe) action. A watch ack with an `ok` key means the subscription was successful. A watch ack with an `err` key means the subscription failed.

**Positive Watch Ack**

| Key        | JSON Type | Example Value | Description                                   |
|------------|-----------|---------------|-----------------------------------------------|
| `ok`       | String    | `'ok'`        | Positive acknowledgement.                     |
| `id`       | Number    | `2`           | Request ID of the initial `subscribe` action. |
| `response` | String    | `'subscribe'` | The kind of action being acknowledged.        |

**Example**

```json
{
  'ok': 'ok',
  'id': 2,
  'response': 'subscribe'
}
```

**Negative Watch Ack**

| Key        | JSON Type | Example Value    | Description                                                           |
|------------|-----------|------------------|-----------------------------------------------------------------------|
| `err`      | String    | `'some text...'` | Negative acknowledgement. Contains an error message and/or traceback. |
| `id`       | Number    | `2`              | Request ID of the initial `subscribe` action.                         |
| `response` | String    | `'subscribe'`    | The kind of action being acknowledged.                                |

**Example**

```json
{
  'err': '<error message and traceback>',
  'id': 2,
  'response': 'subscribe'
}
```

**Action Required**

You must ack the event.

### Diff

All `fact`s sent by a Gall agent on the `path` to which you've subscribed are delivered as `diff`s. Note that Eyre makes a best effort to convert the `fact` to a `json` mark. If it can't, Eyre will crash and close the subscription, and you won't receive any `diff` for the `fact`.

| Key        | JSON Type | Example Value    | Description                                                  |
|------------|-----------|------------------|--------------------------------------------------------------|
| `json`     | Any       | `{'foo': 'bar'}` | The actual data from the agent, could be any JSON structure. |
| `id`       | Number    | `3`              | Request ID of the initial `subscribe` action from earlier.   |
| `response` | String    | `'diff'`         | The kind of response. All `fact`s are marked `'diff'`.       |

**Example**

```json
{
  'json': {'foo': 'bar'},
  'id': 3,
  'response': 'diff'
}
```

**Action Required**

You must [ack](#ack) each `diff` that comes in the event stream.

### Quit

A `quit` comes in when a subscription has been ended. You may be intentionally kicked by the Gall agent to which you're subscribed, but certain network conditions can also trigger a `quit`. As a result, it's best to try and re[subscribe](#subscribe) when you get a `quit`, and if the resulting [watch ack](#watch-ack) is negative you can then conclude the `quit` was intentional and give up.

| Key        | JSON Type | Example Value | Description                                   |
|------------|-----------|---------------|-----------------------------------------------|
| `id`       | Number    | `4`           | Request ID of the initial `subscribe` action. |
| `response` | String    | `'quit'`      | The kind of response.                         |

**Example**

```json
{
  'id': 4,
  'response': 'quit'
}
```

**Action Required**

You must ack the event and you may wish to try and re[subscribe](#subscribe).

# Scry

A scry is a read-only request for some data.

A scry takes the form of an [authenticated](#authentication) HTTP GET request to a URL path with the following format:

```
http{s}://{host}/~/scry/{app}{path}.{mark}
```

The `{app}` is the name of the Gall agent you want to query, for example `graph-store`.

The `{path}` is a scry endpoint of the Gall agent in question. Eyre will always scry with a care of `%x`, so the `{path}` needn't specify that. For example, the `/x/keys` scry endpoint of `graph-store` would just be specified as `keys`.

The `{mark}` is the type you want returned. It needn't just be `json` as with the channel system, it can be any `mark`, with two conditions:

1. It must be possible to convert the `mark` produced by the specified scry endpoint to the `mark` you want returned.
2. It must be possible to convert the `mark` you want returned to a `mime` `mark`, otherwise Eyre can't encode it in the HTTP response.

If your session cookie is invalid or missing, Eyre will respond with a 403 Forbidden status. If the scry endpoint cannot be found, Eyre will respond with a 404 Missing status. If the `mark` conversions can't be done, Eyre will respond with a 500 Internal Server Error status. Otherwise, Eyre will respond with a 200 OK status with the requested data in the body of the HTTP response.

See the [Scrying](@/docs/arvo/eyre/examples.md#scrying) section of the [Examples](@/docs/arvo/eyre/examples.md) document for a practical example.

# Spider

See the [HTTP API](@/docs/userspace/threads/http-api.md) section of the [Threads](@/docs/userspace/threads/overview.md) documentation.
