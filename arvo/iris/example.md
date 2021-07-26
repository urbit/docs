+++
title = "Example"
weight = 4
template = "doc.html"
+++

Here we'll look at a simple example of fetching a remote HTTP resource with Iris. We'll use the following thread, which you can save in the `/ted` directory of your `%home` desk:

`iris-thread.hoon`

```hoon
/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  url=@t  (need !<((unit @t) arg))
=/  =request:http  [%'GET' url ~ ~]
=/  =task:iris  [%request request *outbound-config:iris]
=/  =card:agent:gall  [%pass /http-req %arvo %i task]
;<  ~  bind:m  (send-raw-card:strandio card)
;<  res=(pair wire sign-arvo)  bind:m  take-sign-arvo:strandio
?.  ?=([%iris %http-response %finished *] q.res)
  (strand-fail:strand %bad-sign ~)
~&  +.q.res
?~  full-file.client-response.q.res
  (strand-fail:strand %no-body ~)
(pure:m !>(`@t`q.data.u.full-file.client-response.q.res))
```

This thread takes a fully qualified URL in a `@t` as an argument. It will ask Iris to fetch the HTTP resource at the given URL by passing it a [%request task](@/docs/arvo/iris/tasks.md#request) containing an HTTP GET [$request:http](@/docs/arvo/eyre/data-types.md#request-http):

```hoon
=/  url=@t  (need !<((unit @t) arg))
=/  =request:http  [%'GET' url ~ ~]
=/  =task:iris  [%request request *outbound-config:iris]
=/  =card:agent:gall  [%pass /http-req %arvo %i task]
```

In this example, our `request:http` specifies no additional headers and has no body so it has a `~` for each of those fields. Of course in practice if you have headers or data you want to send you would include those.

Our thread will take the `%http-response` `gift` that comes back from Iris and debug print it to the terminal so you can have a look at the structure, and then it will cast the body of the HTTP message to a `@t` and print it.

Let's try it out:

```
> -iris-thread 'http://example.com'
[ %http-response
    client-response
  [ %finished
      response-header
    [ status-code=200
        headers
      ~[
        [key='age' value='212909']
        [key='cache-control' value='max-age=604800']
        [key='content-type' value='text/html; charset=UTF-8']
        [key='date' value='Thu, 24 Jun 2021 04:12:13 GMT']
        [key='etag' value='"3147526947+ident"']
        [key='expires' value='Thu, 01 Jul 2021 04:12:13 GMT']
        [key='last-modified' value='Thu, 17 Oct 2019 07:18:26 GMT']
        [key='server' value='ECS (oxr/8328)']
        [key='vary' value='Accept-Encoding']
        [key='x-cache' value='HIT']
        [key='content-length' value='1256']
      ]
    ]
      full-file
    [ ~
      [ type='text/html; charset=UTF-8'
          data
        [ p=1.256
            q
          224.708.415.080.409.844.273.808.970.700.472.455.882.111.359.8(...truncated for brevity)
        ]
      ]
    ]
  ]
]
```

...and here's the data from the HTTP response cast to a `@t`:

```
'<!doctype html>\0a<html>\0a<head>\0a    <title>Example Domain</title>\0a\0a (...truncated for brevity)' 
```
