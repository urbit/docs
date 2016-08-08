# Specification

The `%eyre` vane serves one purpose: receiving inbound HTTP requests from browsers and clients pretending to be browsers. To facilitate this communication, `%eyre` does two things: 1. provide an API for traditional clients to talk to; and 2. provide a mechanism for saving state that allows the server to keep track of identities/sessions, subscription data, and active connections.

This document outlines the following:

1. [`perk`](#perk), a `pork` subset that defines what URLs the client can send to `%eyre`.
2. [the values stored on the client](#client), both statically in cookies and dynamically as the `window.urb` object, which facilitate this transaction.

3. [`kiss`](#kiss), the requests `%eyre` will accept.
4. [`gift`](#gift), the responses it will give to those requests.

5. [`note`](#note), the set of arvo requests that %eyre makes to the other vanes.
6. [`whir`](#whir), a `wire` subset, the associated dynamic state
7. [`sign`](#sign), the responses `%eyre` accepts
8. [`bolo`](#bolo), the state stored between separate events.

# 1. URL structure <a id="perk"/>
There exist several URL forms accepted by `%eyre`. 

## 1.1 Functional request
The simplest of them is a static `%f` functional publish request:

  ```hoon
  GET /[ship]/[desk]/[case]/path/to/file.[mark]
  ```
e.g.

  ```hoon
  /~pittyp-pittyp/main/5/lib/urb.js
  ```
A `case` of 0 signifies the most recent version.

If no file extension is provided, the default `mark` is `%urb`, which consists of `%html` injected with an auto-refresh script.

A shorter form:

  ```hoon
  /path/to.[mark]
  ```
is prepended with the [default request path](#prefix). For example, if `%eyre`
is configured with a root of `/<our>/main/0/pub`, then `/doc/arvo` is
interpreted as a request for `/=main=/pub/doc/arvo.urb`.

Auxiliary paths start with `/~/`, and provide other functionality, such as:

## 1.2 Auto-reload
When a new version of a page becomes available, it is useful to propagate it to the client. The `%f` vane manages the particulars, and provides an update token along with all published pages. The `/~/on` long-polling endpoint makes use of that token, which is a hash of the server-stored dependency set.
- `/~/on/[hash].json` retuns `true` when a page may require updating.
- `/~/on/[hash].js` is a lightweight script that polls for the above. It is primarily used in error messages.

## 1.3 Authentication <a id="auth"/>
Authenticated requests are accomplished through sessions, tracked with cookies which are set on the first such request.
- `/~/as/[user]/...` is an authenticated request to `...`, where `user` can be a `@p` ship, `'own'`, `'any'`, or `'anon'`. 
  + `'anon'` is a randomly-generated per-session submarine, and requires no further authentication.
  + `'own'` represents the serving ship. The short form of `/~/as/own/` is `/~~/`
  + `'any'` requires a network ship, chosen with a prompt if unknown. The short form of `/~/as/any/` is `/_/`
  + Auth requests are handled in three ways:
  + I. If the session is associated with the `ship`, serve `...`, storing the ship as the session's default ship.
    For example,
        /~/as/sivtyv-barnel/main/pub/test.html
    is an authenticated request of
        /main/pub/test.html
    with the identity of `~sivtyv-barnel`.
  + II. If the session is not associated with the `ship` in the path, the client is redirected to a login page, where a password can be entered. Successful authentication results in a page refresh to the requested path.
  + III. otherwise, [send a message](#foreign) to the claimed ship, and redirect the user to `https://[foreign-host]/~/am/[ses]/...#[current-host]&?code=[code]`


- `/~/am/[ses]/...#original-host` similarly serves a login page. Upon success, inform the `ship` of the success and redirect it back to `http://[original-host]/~/as/<this-ship>/...`
- `/~/away.html` is a log-out page.
- `/~/auth.json` returns `{ship,oryx,user,auth}`: the serving ship, a CSRF token, active user, and all allowed users respectively.
- `/~/at/{...}.js` is an alternate form of `/~/auth.json`, which injects a line into the served js file that sets `{ship, oryx, user, auth}` on the `window.urb` object. 

So far, all the paths specified have been GET requests. Authentication, however, requires sending data. This is also done at the `/~/auth.json` endpoint.
- `POST {oryx,ship,code} /~/auth.json?PUT` is used by the login script to authorize a user, and returns the same result as `GET`, additionally containing either`{ok:true}` or `{fail:'type',mess:"Error message"}`
- `POST {oryx,ship?} /~/auth.json?DELETE` revokes authorization. Response as above.

## 1.4 Messaging
- `POST {oryx, wire, xyro} /~/to/[app]/[mark].json`, where `xyro` is data that will be converted to the `mark`. In the simplest case, `/~/to/hello/json.json` will pass `xyro` through verbatim, sending `[%json xyro]` to the `++poke` arm of app `%hello`.
- `POST {oryx, wire, xyro} /~/to/<ship>/[app]/[mark].json` is a foreign message send, as above.

## 1.5 Subscriptions <a id="subs"/>
- `/~/of/[ixor]`<a id="of-ixor"/> is an `EventSource`: a conceptually infinite file containing a stream of events. By default, it sends a newline every 30 seconds serving to signal that the connection is alive to both the server and IP middleware.
  + `/~/of/[ixor]?poll={n}` is a long-polling fallback interface. Produces event number {n}, blocking until it occurs. 

Its contexts can be affected by  `POST` requests with a body of `{oryx, wire}`, and a query string of `PUT` or `DELETE`. They return either `{mark}`(which may be `null`), or [`{fail, mess}`](#mean-json)

- `/~/in/[hash].json` is a dual to [`/~/on`](#on-change). It binds `mod` events, which echo the requesting token.
- `/~/is/[app]/path/to.[mark]` binds `rush` events, formatted with a first line of `[app] /path/to`, and the rest containing subscription data. Additionally, `mean` events formatted similarly may arrive, also converted to the relevant mark.

## 1.6 Ablative <a id="temp"/>
These interfaces will temporarily exist to aid development, and are to be considered unstable.
- `/~/debug/...` access normally inaccessible pages. For example, `/~/debug/as.html` will present the login page, regardless of current session status.

# 2. Client state <a id="client"/>
Some information is stored on, and provided to, browser clients

## 2.1 Cookies
Authenticated users receive a cookie on the domain of `*.urbit.org`. The cookie contains a client session token, keyed by the serving ship.

## 2.2 Authentication <a id="auth-json"/>
It is common(e.g. by the `%urb` mark) to set window.urb to the contents of `/~/auth.json`:
- `ship` is the serving ship
- `oryx` is a unique CSRF token that identifies this view, bound to the session cookie
- `ixor` is a hash of `oryx`, used as an insecure view identifier
- `user` is the authenticated/generated ship name
- `auth` is a list of identities usable by this session

## 2.3 Client library
To this object, `/main/lib/urb.js` adds helpers:
- `app` is an optional app name to send messages to by default 
- `send({data,mark?='json',app?=urb.app,ship?}, cb?)` delivers messages
- `bind({path,app?=urb.app}, cb)` subscribes by path
- `drop({path,app?=urb.app}, cb?)` pulls the subscription
- `util` is an object containing methods for converting between JavaScript types and Hoon atom odors.

# 3. Requests <a id="kiss"/>

## `[%born port=@ud]`, unix init
When the `vere` process is re/started, a TCP port is bound, HTTP requests on which are the scope of this document. The `%born` gift informs eyre of this occurrence, which in turn updates [its state.](#bolo)

**Gifts given in response:** none.

## `[%hiss p=mark q=cage]`, outbound http
Userspace http request, converted by `%ford` into an actual `hiss`.

**Gifts given in response:** a [`%sigh`]()

## 3.1 `[%this httq]`, inbound http
The primary `%eyre` request type comes from the host system, and constitutes an inbound http request. It consists of five parts:

I. `p=[? @if]`: a loobean determining whether the request is being made over https, and the client source, an IPv6 address possibly encoding an IPv4 one as `.0.0.0.0.0.ffff.wwxx.yyzz`

II. `q=meth`, an http method

III. `r=@t`, the unparsed URL

IV. `s=mess`, an associative list of header keys/values

V. `t=(unit octs)`, the request body, if any.

After `r` is parsed to a `purl`, the `pork`(relative path) determines the resource being served. The first step in handling an http request is [classifying its intent](#perk).

- A ford request results in a [`%boil` note](#boil).
- `/~/[name].js` is generated from [session](#sink) or [view](#stem) state, and [served](#mime) as `%js`.
- `/~/am` generates a login page.
- `/~/as` is resolved further if authenticated, generates a similar login page if the claimed ship is local, and otherwise is saved to [session state](#sink) and sends a ["login" `%a` message](#lon) to the foreign ship.
- `/~/at` and `/~/auth.json` generate a new `oryx` and store it in the [session state](#sink).
- `/~/in` and `/~/is` affect [view state](#stem), possibly sending subscriptions or unsubscriptions to `%f` and `%g` respectively, and are generated from view state.
- `/~/on` is saved to the `bolo` by `hash`, and translated to a [`%wasp` note](#wasp).
- `/~/of` fails if the `ixor` is unknown, and otherwise is stored in the `ixor`, receiving a partial response and all events after its [last-seen header](#). If it has a `poll` parameter, the response is full, and only occurs if the body is non-empty. Otherwise the oryx is saved as a [live](#live) request in case of cancellation.
- `/~/to` transforms into a [`%g` message](#mess).

**Gifts given in response:** a [`%thou`](), or a [`%that`](#that) followed by multiple [`%thar`]()s.

## 3.2 `[%thud ~]`, inbound close
Sent when an unresponded-to request is cancelled. The [live](#live) effect of the request is looked up, and
- `%exec` ford boil requests are cancelled with `[%exec ~]`
- `%wasp` ford deps requests are cancelled with `[%wasp |]`
- `%poll` session polls `%rest` the session heartbeat timeout

## 3.3 `[%thin p=@ud]`, delivery failure
Sent when a partial [response](#that) or [body](#thar) fails to arrive. Its `duct` is the same as that of the original request. This is handled by [waiting](#wait) for the client to reconnect, and if this not occur, unwinding all subscription state.

**Gifts given in response:** None.

## 3.4 ``[%wart sock [path *]]``, inbound message
Sometimes, messages are received from other ships. They are expected to take the from of a [`gram`]().

**Gifts given in response:** [`%nice` or `%mean`](#ack).

### 3.4.1 `gram` <a id="gram"/>

There are three messages of note, all concerning authentication <a id="foreign"/>
- `[/lon ses]` <a id="lon"/> is a login request, which contains the session wishing to authenticate.
- if the session is already authorized, a reply of `[/aut ses]` from (%eyre on) a foreign ship prescribes that the session is henceforth allowed to act on its behalf.
All waiting `/~/as` are resolved as succesful.
- otherwise, `[/hat ses hart]` contains the ship's preferred hostname. This can then be used to redirect the client.
All waiting `/~/as` are given `307 Redirect`s to `/~/am` on the provided host.

**Gifts given in response:** nice?

# 4. Responses <a id="gift"/>
## 4.1 `[%nice ~]`, `[%mean ares]`, network acknowledgement <a id="ack"/>
A `%nice` is given upon receiving an [ames message](#gram), indicating succesful receipt. `%mean` is currently unused directly, but reserved for error conditions. 

## `[%sigh p=cage]`, inbound http response
An HTTP response gets converted to the requested mark, or `%tang` in case of error.

## 4.2 `[%thou httr]`, full HTTP response
Most requests are served with one coherent response, consisting of
- `p=@ud`, an HTTP status code
- `q=mess`, response headers
- `r=(unit octs)`, an optional body

## 4.3 `[%that httr]`, partial HTTP response <a id="that"/>
[EventStream responses](#of-ixor) consist of multiple sequential chunks. Treated as `%thou`, except the request is kept open.

## 4.4 `[%thar (unit octs)]`, partial HTTP body <a id="thar"/>
Complementing `%that`, `%thar` is a body chunk, containing an event. An empty `%thar` signals for the connection to be closed.

Body chunks, besides `[1 '\0a']`(a heartbeat newline), are encoded from `even` events. The stem becomes the [`event` field](#eventsource), and the content, `data` lines.

### 4.4.1 `even`, event types <a id="even"/>
There are three events that a [client subscription](#subs) will be given.

- `[%news hash]`<a id="even-news"/> is a `%f` update, and contains the relevant dependency token.
- `[%rush [term path] wain]`<a id="even-rush"/> is sourced subscription data.
- `[%mean [term path] ares]` is a sourced subscription error.

# 5. Vane requests <a id="note"/>
## 5.1 ``[%a %wont sock `[path *]`gram]``, outbound message
The `%a` interface provides conveyance of [messages](#gram) over UDP.

Signs a `%woot` upon message arrival.

## 5.2 `[%b ?(%wait %rest) time]`, timeout set/unset <a id="wait"/>
All open [subscriptions](#of-ixor) require a "heartbeat" newline every `~s30`. When this fails to arrive, a complementary timer is set for `~m1`, after which the client is considered to have departed. 
The `%b` timer interface is used to schedule the next such event, or cancel past scheduled ones when a connection closes. 

Signs a `%wake` upon timer activation.

## 5.3 `[%f %wasp @uvI]`, dependency listen <a id="wasp"/>
Knowledge of filesystem changes, requested by `/~/on` and `/~/in`, is requested the `%wasp` note. It contains the hash token which idenitifes a set of dependencies to query. Saved as a (live[live](#live)#live] request in case of cancellation when caused by `/~/on`.

Signs a `%writ` upon change. 

## 5.4 `[%f %exec (unit silk)]`, functional transformations
The `%f` interface converts nouns from one form to another. An empty unit represents cancellation.

Signs a `%made` containing the computation result.

The `silk`s used are as follows: 

### `[%cast %mime %boil mark beam [%web span ~]]`, file load
The simplest functional request is the construction of a page. Saved as a [live](#live) request in case of cancellation.
- The `mark` is the request extension, defaulting to `%html`.
- A `beam`(path in `%clay`) is decoded from the request path.
- A `/web/<nyp ced quy>` virtual path is appended, span-encoding method, auth, and query string.

### `[%cast mark %done ~ cage]`, convert <a id="done"/>
This is used when communicating with apps, in both directions.
- Client messages are encoded as JSON objects, but can contain many different marks. Ones sent to non-`json.json` endpoints are `%cast` to he relevant mark, with a `cage` of `[%json p:!>(*json) jon]`, prior to being sent onwards to applications with `[%g %mess]`.
- Subscription responses also come in arbitrary marks, but are required to be sent as whichever mark an endpoint is subscribed to. They get `%cast` prior to being sent back as a `%that` EventSource segment.

## 5.5 `%g`, app actions
The end goal of many a userspace `hymn.hook` is to provide UI for a `%gall` app. To accommodate this, various functionality needs to be interfaced with.

### `[%mess hapt ship cage]`, app message <a id="mess"/>
After a `/~/to` POST has been received, and possibly converted to the correct mark, it is sent to `%g` for processing. The `hapt` is the destination, the `ship` is the source, the `cage` is the marked message data.

Signs a `%nice` or `%mean`, in userspace or upon crashing.

### `[%show hapt ship path]`, app subscription<a id="show"/>
An `/~/is` PUT, if not already registered, results in a new subscription. A request for such contains the destination `hapt`, requesting `ship`, and app-internal `path`.

Signs a `%nice` on init, `%rush` on data, and a `%mean` in subscription termination.

### `[%took hapt ship]`, %rush confirmation
A `%took` must be sent to acknowledge the receipt of subscription data, which in this case occurs automatically.

Causes no signs.

### `[%nuke hapt $|(ship [ship path])]`, subscription cancel
An `/~/is` DELETE is used to remove a subscription, and is converted straightforwardly to a `%nuke`. Additionally, when a client disconnects, all of its subscriptions are `%nuke`d to reflect their experiation.

Signs an empty `%mean` for each open subscription that is closed.

# 6. In-flight metadata <a id="whir"/>
Various state can be associated with requests, but not necessarily be returned in responses to them.

## 6.1 `~`, dropthrough <a id="wire-drop"/>
If the response should be sent statelessly further up the duct, the `wire` is empty. This is used in `%f` pure functional page generation.

## 6.2 `[?(%y %n) ...]`, stability <a id="wire-live"/>
The first element of a [`%b` timer](#wait) path distinguishes between live(%y) and dying(%n) channels.

## 6.3 `/of/[ixor]`, view
Designates which stream to act upon. Present on `%b` timer cards.

## 6.4 `/on/<deps>`
Present on `%f` dependency news. Looked up in [the state](#bolo) to see if any response is necessary.

## 6.5 `/to/<hasp>/<ship>`, app <a id="wire-to"/>
Present on `%f` translations of message marks

## 6.6 `/is/[ixor]/{hasp path}`, subscription <a id="wire-is"/>
Subscription requests. Present on `%g` subscription requests, and `%f` translations of [`%rush` subscription data](#show).

# 7. Vane responses <a id="sign"/>
The goal of requests is to cause some manner of result. Specifically, 

## 7.1 `[%a %woot ship coop]`, acknowledgement
A [message](#mess) which has been acknowledged remotely.

## 7.2 `[%b %wake ~]`, timer
Timer activate. If this is a `%y` [timer](#wire-live), send a newline to each `/~/of/[oryx]`; if `%n` and the `oryx` still has no listeners, wipe its state/subscriptions.

## 7.3 `[%f %news ~]`, dependency update
This message signifies a `hash` has changed, and listeners to it should be updated. Results in [`%news` events](#even-news) to concerned streams, and [full responses](#thou) to relevant long-polls.

## 7.4 `[%f %made (each bead (list tank))]`, compute result
Further action depends on the [`wire`](#whir). It can:
- Be empty, designating direct request data, which is [served](#mime) back up the `duct`.
- Contain [app and requester identities](#wire-to), which designates an app message has been converted to the correct `mark`, and can now be [sent to the app](#mess) with an empty `wire`. 
- Contain an `oryx`, app, and `path`, designating subscription data. If the subscription is active in the relevant `stem`, it is acknowledged with a `%took` and given as a [`%rush` event](#even-rush) to all listeners. Otherwise, the subscription is `%nuke`d.

## 7.5 `%g`, applications
The `%g` interface sends several responses.

### `[%nice ~]` and `[%mean ares]`, acknowledgment
These are given as a response to `%mess`, with an empty wire, and `%show`s, with a [subscription wire](#wire-is).
The former is [served](#mime) back to the requester(i.e. the remaining duct), and the latter returned to the client.

### 7.5 `[%rush cage]`, subscription data
A `%rush` arrives on a [subscription wire](#wire-is), and is then sent [for conversion](#done) to the correct mark. An unexpected `%rush` is `%nuke`d.

# 8. Server state <a id="bolo"/>
There is a quantity of data that persists between events.

## 8.1 Global
- `path` <a id="prefix"/> the default path which is prepended to relative plain requests. Initialized to `/<our>`, the serving ship; this interprets the first element of requests as a desk, and injects a `case` of `0`.
- `(jar ship hart)` remembered hostnames in order of preference, made accessible through `.^`
  + The default values(for self) are `http://<ship>.urbit.org:80` if not on a fake network, followed by `https://0.0.0.0:[port]`.
- `(jug deps (each duct oryx))`, `/~/on` and `/~/in` endpoints listening to `%c` updates.
- `(map duct live)`, inbound request state
- `(map ixor oryx)`, open `/~/of` streams. 
- `(map oryx stem)`, open view state.
- `(map hole sink)`, session state.
- `(map hole ,[ship ?])`, foreign session names, along with their origin ships and whether they are authorized to act on our behalf.

## 8.2 `live`, per-request state <a id="live"/>
To honor request cancellations, each unserved request must track which effect it is causing.
+ `[%exec whir]` if it is a ford data request 
+ `[%wasp (list @uvH)]` if it is a ford dependency poll
+ `[%xeno ship]` if this is a proxied request
+ `[%poll ixor]` if this is a session long-poll

## 8.3 `sink`, per-session state <a id="sink"/>
Each `hole` has associated authentication state.
- `priv`, a random secret that verifies the session, stored in cookie.
- `[ship (set ship)]`, the `ship` a session is acting as and any others it has been authorized with.
- `(jug ship ,[path duct])`, authentication `/~/as` requests waiting on foreign ships.
- `(set oryx)`, views associated with this session. Dual of `hole` in `stem`.

## 8.4 `stem`, per-view state <a id="stem"/>
Each `oryx` has active subscription state.
- `hole`, session in which this view resides. Dual of `(set oryx)` in `sink`.
- `ixor`<a id="ixor"/>, a cached hash of the `oryx` that is used as a subscription id, by the `/~/of` EventStream.
- `[,@u (map ,@u even)]`, queued [events](#even). Has a maximum size.
- `(unit ,[duct @u ?])`, http connection, its last received event, and whether it is a long-poll request.
- `(set deps)`, subscribed `/~/in` points. Mirrored in `bolo`.
- `(map ,[hasp path] mark)`, subscribed `/~/is` points
- `(que duct)`, where any `%nice`/`%mean 

# Appendix A: Glossary
- An `oryx` is a CSRF token used for [authenticated requests](#auth)
- `mean.json`<a id="mean-json"/> is a rendering of hoon `ares`: an error message formatted as `{fail:'type',mess:"Error message"}`
- `urb.js`<a id="urb-js"/> is the standard client-side implementation of the `%eyre` protocols, normally found in `/=main=/lib`
- The act of "serving"<a id="mime"/>, refers to the wrapping of a `%mime` cage in an HTTP `200 Success` response, and errors or other marks being [sent to ford](#done) for conversion. Inside a `sign`, this conversion occurs along the same [`wire`](#wire); otherwise, the `wire` is [empty](#wire-drop).

# Appendix B: EventSource <a id="eventsource"/>

UNIMPLEMENTED

For more information, see <http://dev.w3.org/html5/eventsource/>

An EventSource is a stream of events, encoded in a conceptually infinite `GET` request. Each event is formatted as
  ```http
  id: {number}
  event: {type}
  data: {contents}
  data: {more-contents}
  ```

Data lines are joined by ASCII `10` newline characters; multiple newlines signify separate events. The `id` is used in a `Last-Event-ID` HTTP request header upon reconnection.
