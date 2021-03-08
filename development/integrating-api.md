+++
title = "Using the HTTP API"
description = "How to use Urbit's API."
weight = 20
template = "doc.html"
+++

This guide is aimed at developers who have a working knowledge of HTTP grammar (`PUT`, `GET`), and should not require any special knowledge of Urbit's internals. To learn more about a specific application within Urbit, please search for that with the docs once you have finished this guide.

## Authentication

The first step in creating an application *on* Urbit (to be distinguished from an Urbit application) is to authenticate with the desired ship. This can be a planet, comet, or any other Urbit ship. For the purposes of this example, we will be running a "fakezod" on port 8080. Run this code, substituting the appropriate path to your Urbit binary:

```bash
/path/to/urbit -p 8080 -F zod
```

(for the unfamiliar, this will create a folder named "zod" in your working directory, from which the ship will run. Use `/path/to/urbit -p 8080 zod` in the future)

You can run `+code` in the dojo to get the key, but a fakezod's key is always `lidlut-tabwed-pillex-ridrup`. This is our password, our API token that we will use.

Run this code in your bash terminal (requires cURL):

```bash
curl -i localhost:8080/~/login -X POST -d "password=lidlut-tabwed-pillex-ridrup"
```
Let's explain what this does:

 - `-i` displays the headers, so that you can see the cookie that gets sent
 - `localhost:8080/~/login` is the URL to which you are POSTing. You will note this is also the URL you visit when you log into Landscape.
 - `-X POST` specifies that you are POSTing data, not GETting.
 - `-d "password=lidlut-tabwed-pillex-ridrup"` specifies the key for your Urbit that we retrieved above. It is sent as form data, as if it were sent from an HTML form input field (which it is in Landscape)

You should see the following:

```bash
HTTP/1.1 200 ok
Date: Sun, 01 Jan 2020 00:00:00 GMT
Connection: keep-alive
Server: urbit/vere-0.10.8
set-cookie: urbauth-~zod=0v3.fvaqc.nnjda.vude1.vb5l6.kmjmg; Path=/; Max-Age=604800
transfer-encoding: chunked
```

The `Date` and `set-cookie` will be slightly different of course.

Take a look at the `set-cookie` line. This is now your session authentication, and will need to be sent with any future requests. It consists of three parts:

 - `urbauth` is a prefix that Eyre uses to check for presence of authentication
 - `~zod` is the name of the ship you are logging in as
 - `0v3.fvaqc.nnjda.vude1.vb5l6.kmjmg` is the actual authentication token.

At present there is no way to separate these parts — you must pass a cookie *as* a cookie. This string must be in the `Cookie` header. The `set-cookie` header is only used for this request upon response. It is what browsers expect when receiving a cookie.

## Interacting with Urbit

Once authenticated, you will perform all your operations on a channel. You may open as many channels as needed using the same authentication token, but this will increase complexity and memory usage on your Urbit ship.

Interacting with Urbit comprises two parts:

1. Sending information via PUT requests, which receive HTTP status code `204` (no content) upon success. We will not receive updated information (as in a POST request).
2. Receiving data on channels, which must first be subscribed to via an initial request. These come in the form of SSEs ([Server-Sent Events](https://www.w3.org/TR/eventsource/))

These can be used independently, i.e. you may choose to only send information or only receive information from your Urbit, based on your application. Both can take place on the same channel.

### Creating a Channel

For this example, we will use the following channel:

```
http://localhost:8080/~/channel/1601844290-ae45b
```

Let's examine the parts. A channel is simply a URL in this pattern: `{url}/~/channel/{uid}` where `{uid}` is a string of your choosing. Most libraries default to the current unix time plus six hexadecimal characters. Your program should determine a channel for its current session and store that in its state.

The channel does not yet exist in Urbit, however. To subscribe to events on this URL, you must first make a request (PUT) to Urbit on this URL. The simplest way to do this is to `hi` ourselves, as if we had entered `|hi our` in the dojo. A `hi` is analogous to a ping, and does not manipulate state. Let's learn how to make requests using this as an example.

### Making Requests

All requests will take the form of sending a message. Messages can take different forms, such as `subscribe`s, `ack`s, and `poke`s. These are called actions and there are more than these, but these will cover most basic use cases. You can think of them as a somewhat more sophisticated HTTP grammar. A message always requires an `id` and an `action`. Other fields depend on the specific action.

Let's look at the structure of a message by examining the most basic `hi` we will send.

```js
{
  'id': 1, // Required. A sequential ID. Keep track of which messages you have sent.
  'action': 'poke', // Required. The action to take. poke is the most basic way of sending data, like HTTP POST
  'ship': 'zod', // Required by poke. The ship on which to perform the poke. You can only poke foreign ships with JSON, but this is the authenticated ship.
  'app': 'hood', // Required by poke. The Urbit app to which to send the data.
  'mark': 'helm-hi', // Required by poke. The "mark," or type, of data being sent.
  'json': 'Opening airlock' // Required by poke. The actual data being sent.
}
```

Let's open our channel by sending the following request using cURL (**remember to change the cookie**):

```bash
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.fvaqc.nnjda.vude1.vb5l6.kmjmg" \
     --request PUT \
     --data '[{"id":1,"action":"poke","ship":"zod","app":"hood","mark":"helm-hi","json":"Opening airlock"}]' \
     http://localhost:8080/~/channel/1601844290-ae45b
```

If you switch to your fakezod's dojo, you should see `< ~zod: Opening airlock`.

Note that in the JSON that we sent via `--data`, the payload is wrapped in `[]`. This is because we can send multiple messages in a single payload, and Eyre expects a list of items, even if we are only sending one.

You will always receive a `204` status code if the `PUT` request successfully reached Urbit, authentication succeeded, and the payload was valid. This is merely an HTTP status code, however. If the request failed within Urbit itself, however, you will receive a "nack" event that you will have to process separately.

Let's look at how to receive events from Urbit.

### Subscribing to Events

Now that Urbit has opened an Eyre channel at our URL, we can watch for events on that URL by sending a `subscribe` message. Let's look at the anatomy of a `susbcribe`:

```js
{
  'id': 2, // Required. This is the next message we are sending, so we give it the next ID.
  'action': 'subscribe', // Required.
  'ship': 'zod', // Required by subscribe.
  'app': 'chat-view', // Required by subscribe. In this case, we want to watch events that occur in the chat-view app, which is responsible for handling incoming chats.
  'path': '/primary' // Required by subscribe. All apps have different path structures. In the case of chat-view, this is where we see all incoming chats.
}
```

This is all we need to send Urbit to say "On this URL through which I am sending information, send me SSEs whenever something occurs on this app at this path."

You should be able to send this information if you were able to send the above cURL example. However, we now need to be able to listen to the SSEs. The `EventSource` object is available for JavaScript in the browser context, as this is why SSEs were invented, but there should be a library for it in your chosen language. Take a look at a Browser JavaScript example:

```js
const eventSource = new EventSource('http://localhost:8080/~/channel/1601844290-ae45b', {
  withCredentials: true // Required, sends your cookie
});

eventSource.addEventListener('message', function (event) {
  ack(Number(event.lastEventId)); // See section below
  const payload = JSON.parse(event.data); // Data is sent in JSON format
  payload.id === event.lastEventId; // The SSE spec includes event IDs. This information is duplicated in the payload.
  const data = payload.json; // Beyond this, the actual data will vary between apps
});

eventSource.addEventListener('error', function (event) {
  handleError(event);
});

```

### Handling Received Events

Once you have received an event, it is expected that you will "ack" or "acknowledge" that you have received them. To do so, simply send a message in the following format:

```js
{
  'id': 3, // Required. Picking up where we left off
  'action': 'ack', // Required.
  'event-id': 15, // Required by ack. Whichever SSE of which you are acknowledging receipt
}
```

### Unsubscribing from Events

You may want to stop receiving events from a particular app path, but you don't want to close the channel altogether yet. Let's look at how to do that. Take a look at the example for subscribing.  We sent that message with `id: 2`. We will use that ID to cancel the relevant subscription:

```javascript
{
  'id': 4, // Required. We always increment the ID as we send messages.
  'action': 'unsubscribe', // Required.
  'subscription': 2 // Required by unsubscribe. This corresponds to the id of a subscribe message sent earlier.
}
```

### Deleting a Channel

You should clean up your channel when able. To do so, simply send a `delete` message and Eyre will handle the rest so your program can safely exit.

```javascript
{
  'id': 5, // Required.
  'action': 'delete' // Required.
}
```

## Other Operations

There are other operations which require authentication but do not require the use of a channel. Some operations are app-specific and will not be enumerated here, but there are two operations that exist across Urbit: `scry` and `spider`.

### Scrying

Scrying lets you see what an app has exposed at a particular path. It does not manipulate state.

It takes the form `{url}/~/scry/{app}{path}.{mark}`

 Let's get the base hash of our fakezod in the same way that Landscape does it.

```bash
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.fvaqc.nnjda.vude1.vb5l6.kmjmg" \
     --request GET \
     http://localhost:8080/~/scry/file-server/clay/base/hash.json
```

Note the use of a `GET` request.

In this example we're scrying the `file-server` app at the path `/clay/base/hash` and using the `json` mark, which is most common. We receive `"0"` which is correct because we are at the top level of the hierarchy using a fake ship.

Scry will fail with a 500 or return a 404 if no data is found.

### Running Threads with Spider

Running threads is an exception to the rule that we outlined in the section on channels. It uses a `POST` request and both manipulates state and receives information back. It also exposes the ability to send a sequence of commands, i.e. a "thread," hence the name.

It takes the form `{url}/spider/{inputMark}/{threadname}/{outputmark}.json`

This should be considered an advanced technique, but the basic structure of a request can be seen here:

```bash
curl --header "Content-Type: application/json" \
     --cookie "urbauth-~zod=0v3.fvaqc.nnjda.vude1.vb5l6.kmjmg" \
     --request POST \
     --data '[{"foo": "bar"}]' \
     http://localhost:8080/spider/graph-view-action/graph-create/json.json

```
