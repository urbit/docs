+++
title = "HTTP API"
weight = 2
template = "doc.html"
+++

Spider has an Eyre binding which allows threads to be run externally via [authenticated](@/docs/arvo/eyre/external-api-ref.md#authentication) HTTP POST requests.

Spider is bound to the `/spider` URL path, and expects the requested URL to look like:

```
http{s}://{host}/spider/{inputMark}/{threadName}/{outputMark}
```

The `inputMark` is the `mark` the thread takes. The `threadName` is the name of the thread, e.g. `foo` for `/ted/foo/hoon`. The `outputMark` is the `mark` the thread produces. You may also include a file extension though it doesn't have an effect.

When Spider receives an HTTP request, the following steps happen: 

1. It converts the raw body of the message to `json` using `de-json:html`
2. It creates a `tube:clay` (`mark` conversion gate) from `json` to whatever input `mark` you've specified and does the conversion.
3. It runs the specified thread and provides a `vase` of `(unit inputMark)` as the argument.
4. The thread does its thing and finally produces its result as a `vase` of `outputMark`.
5. Spider creates another `tube:clay` from the output `mark` to `json` and converts it.
6. It converts the `json` back into raw data suitable for the HTTP response body using `en-json:html`.
7. Finally, it composes the HTTP response and passes it back to Eyre which passes it on to the client.

Thus, it's important to understand that the original HTTP request and final HTTP response must contain JSON data, and therefore the input & output `mark`s you specify must each have a `mark` file in `/mar` that includes a conversion method for `json -> inputMark` and `outputMark -> json` respectively.


# Example

Here we'll look at running Spider threads through Eyre.

Here's an extremely simple thread that takes a `vase` of `(unit json)` and just returns the `json` in a new `vase`. You can save it in `/ted` and `|commit %home`:

`eyre-thread.hoon`

```hoon
/-  spider
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  =json
  (need !<((unit json) arg))
(pure:m !>(json))
```

First we must obtain a session cookie by [authenticating](@/docs/arvo/eyre/examples.md#authenticating).

Now we can try and run our thread. Spider is bound to the `/spider` URL path, and expects the rest of the path to be `/{inputMark}/{thread}/{outputMark}`. Our `{thread}` is called `eyre-thread`, and both its `{inputMark}` and `{outputMark}` are `json`, so our URL path will be `/spider/json/eyre-agent/json`. Our request will be an HTTP POST request and the body will be some `json`, in this case `[{"foo": "bar"}]`:

```
curl -i --header "Content-Type: application/json" \
        --cookie "urbauth-~zod=0v6.h6t4q.2tkui.oeaqu.nihh9.i0qv6" \
        --request POST \
        --data '[{"foo": "bar"}]' \
        http://localhost:8080/spider/json/eyre-thread/json
```

Spider will run the thread and the result will be returned through Eyre in the body of an HTTP response with a 200 status code:

```
HTTP/1.1 200 ok
Date: Sun, 06 Jun 2021 05:32:45 GMT
Connection: keep-alive
Server: urbit/vere-1.5
set-cookie: urbauth-~zod=0v6.h6t4q.2tkui.oeaqu.nihh9.i0qv6; Path=/; Max-Age=604800
content-type: application/json
transfer-encoding: chunked

[{"foo":"bar"}]
```
