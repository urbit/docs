+++
title = "Scry Reference"
weight = 4
template = "doc.html"
+++

## Contents

- [Introduction](#introduction)
- [/cors](#cors) - CORS settings.
   - [/cors/requests](#cors-requests) - Requested origins.
   - [/cors/approved](#cors-approved) - Approved origins.
   - [/cors/approved/\<origin\>](#cors-approved-origin) - Check if origin approved.
   - [/cors/rejected](#cors-rejected) - Rejected origins.
   - [/cors/rejected/\<origin\>](#cors-rejected-origin) - Check if origin rejected.
- [/authenticated/cookie/\<cookie\>](#authenticated-cookie-cookie) - Check if cookie authenticated.
- [bindings](#bindings) - URL path bindings.
- [connections](#connections) - Open http connections.
- [authentication-state](#authentication-state) - Authentication details.
- [channel-state](#channel-state) - Details of each channel.
- [host](#host) - Host details.

# Introduction

Here are all of Eyre's scry endpoints. There's not too many and they mostly deal with either CORS settings or aspects of the state of connections.

The first few have a `care` of `x` and are a scry like `.^(<type> %ex /=//=/<some-path>)` (note the empty `desk`). The rest have no `care` and the tag replaces the `desk` like `.^(<type> %e /=<something>=)`.

All examples are run from the dojo.

# `/cors`

An `x` scry with a `path` of `/cors` will return Eyre's CORS origin registry. The type returned is a [cors-registry](@/docs/arvo/eyre/data-types.md#cors-registry) which contains the `set`s of approved, rejected and requested origins.

Example:

```
> .^(cors-registry:eyre %ex /=//=/cors)
[ requests={~~http~3a.~2f.~2f.baz~.example}
  approved={~~http~3a.~2f.~2f.foo~.example}
  rejected={~~http~3a.~2f.~2f.bar~.example}
]
```

## `/cors/requests`

An `x` scry with a `path` of `/cors/requests` will return the `set` of pending origin requests. These are origins that were in an `Origin: ...` HTTP header but weren't in the existing approved or rejected sets. The type returned is a `(set origin:eyre)`.

Example:

```
> .^(requests=(set origin:eyre) %ex /=//=/cors/requests)
requests={~~http~3a.~2f.~2f.baz~.example}
```

## `/cors/approved`

An `x` scry with a `path` of `/cors/approved` will return the `set` of approved CORS origins. The type returned is a `(set origin:eyre)`.

Example:

```
> .^(approved=(set origin:eyre) %ex /=//=/cors/approved)
approved={~~http~3a.~2f.~2f.foo~.example}
```

## `/cors/approved/<origin>`

An `x` scry whose `path` is `/cors/approved/<origin>` tests whether the given origin URL is in the `approved` set of the CORS registry. The type returned is a simple `?`.

The origin URL is a `@t`, but since `@t` may not be valid in a path, it must be encoded in a `@ta` using `+scot` like `(scot %t 'foo')` rather than just `'foo'`.

Examples:

```
> .^(? %ex /=//=/cors/approved/(scot %t 'http://foo.example'))
%.y
```

```
> .^(? %ex /=//=/cors/approved/(scot %t 'http://bar.example'))
%.n
```

## `/cors/rejected`

An `x` scry with a `path` of `/cors/rejected` will return the `set` of rejected CORS origins. The type returned is a `(set origin:eyre)`.

Example:

```
> .^(rejected=(set origin:eyre) %ex /=//=/cors/rejected)
rejected={~~http~3a.~2f.~2f.bar~.example}
```

## `/cors/rejected/<origin>`

An `x` scry whose `path` is `/cors/rejected/<origin>` tests whether the given origin URL is in the `rejected` set of the CORS registry. The type returned is a simple `?`.

The origin URL must be a cord-encoded `@t` rather than just the plain `@t`, so you'll have to do something like `(scot %t 'foo')` rather than just `'foo'`.

Examples:

```
> .^(? %ex /=//=/cors/rejected/(scot %t 'http://bar.example'))
%.y
```

```
> .^(? %ex /=//=/cors/rejected/(scot %t 'http://foo.example'))
%.n
```

# `/authenticated/cookie/<cookie>`

An `x` scry whose `path` is `/authenticated/cookies/<cookie>` tests whether the given cookie is currently valid. The type returned is a `?`.

The cookie must be the full cookie including the `urbauth-<ship>=` part. The cookie must be a cord-encoded `@t` rather than just a plain `@t`, so you'll have to do something like `(scot %t 'foo')` rather than just `'foo'`.

Examples:

```
> .^(? %ex /=//=/authenticated/cookie/(scot %t 'urbauth-~zod=0vvndn8.bfsjj.j3614.k40ha.8fomi'))
%.y
```

```
> .^(? %ex /=//=/authenticated/cookie/(scot %t 'foo'))
%.n
```

# `bindings`

A scry with `bindings` in place of the `desk` in the `beak` will return Eyre's URL path bindings. The type returned is a `(list [binding:eyre duct action:eyre])` (see the [binding](@/docs/arvo/eyre/data-types.md#binding) & [action](@/docs/arvo/eyre/data-types.md#action) sections of the Data Types document for details).

Example:

```
> .^((list [binding:eyre duct action:eyre]) %e /=bindings=)
~[
  [ [site=~ path=<|~landscape js bundle|>]
    ~[/gall/use/file-server/0w2.EijQB/~zod/~landscape/js/bundle /dill //term/1]
    [%app app=%file-server]
  ]
  [ [site=~ path=<|~landscape|>]
    ~[/gall/use/file-server/0w2.EijQB/~zod/~landscape /dill //term/1]
    [%app app=%file-server]
  ]
  ...(truncated for brevity)...
]
```

# `connections`


A scry with `bindings` in place of the `desk` in the `beak` will return all open HTTP connections that aren't fully complete. The type returned is a `(map duct outstanding-connection:eyre)` (see the [outstanding-connection](@/docs/arvo/eyre/data-types.md#outstanding-connection) section of the Data Types document for details).

Example:

```
> .^((map duct outstanding-connection:eyre) %e /=connections=)
{}
```

# `authentication-state`

A scry with `authentication-state` in place of the `desk` in the `beak` will return authentication details of all current sessions. The type returned is a [authentication-state](@/docs/arvo/eyre/data-types.md#authentication-state). The `p` field is the cookie sans the `urbauth-<ship>=` part.

Example:

```
> .^(authentication-state:eyre %e /=authentication-state=)
  sessions
{ [ p=0v3.kags1.hj7hm.6llrl.cga2j.eh1r7
    q=[expiry-time=~2021.5.20..08.44.27..39e0 channels={}]
  ]
}
```

# `channel-state`

A scry with `channel-state` in place of the `desk` in the `beak` will return details of the state of each channel. The type returned is a [channel-state](@/docs/arvo/eyre/data-types.md#channel-state).

Example:

```
> .^(channel-state:eyre %e /=channel-state=)
[   session
  { [ p='1601844290-ae45b'
        q
      [ state=[%.y p=[date=~2021.5.13..20.44.27..39e0 duct=~[//http-server/0v2.kmj6q/26/1]]]
        next-id=1
        last-ack=~2021.5.13..08.44.27..39e0
        events={[id=0 request-id=2 channel-event=[%poke-ack p=~]]}
        unacked={}
        subscriptions={}
        heartbeat=~
      ]
    ]
  }
  duct-to-key={}
]
```

# `host`

A scry with `host` in place of the `desk` in the `beak` will return host details of the ship. The type returned is a `hart:eyre`.

Example:

```
> .^(hart:eyre %e /=host=)
[p=%.n q=[~ 8.080] r=[%.y p=<|localhost|>]]
```
