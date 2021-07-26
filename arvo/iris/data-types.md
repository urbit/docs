+++
title = "Data Types"
weight = 2
template = "doc.html"
+++

Iris itself only has three structures defined in `lull.hoon`, but it also uses [$http](@/docs/arvo/eyre/data-types.md#http) structures which are shared between Iris and Eyre. The `$http` structures are detailed in the [Eyre](@/docs/arvo/eyre/data-types.md) Data Types documentation.

# `$client-response`

```hoon
+$  client-response
  $%
      $:  %progress
          =response-header:http
          bytes-read=@ud
          expected-size=(unit @ud)
          incremental=(unit octs)
      ==
      [%finished =response-header:http full-file=(unit mime-data)]
      [%cancel ~]
  ==
```

This structure represents data which Iris has fetched from a remote HTTP resource, and is what's returned in a `%http-response` `gift` (see the [%request](@/docs/arvo/iris/tasks.md#request) documentation for details) by Iris to the app or thread which requested it. There are three kinds of `client-response` - `%progress`, `%finished` and `%cancel`. A `%progress` `client-response` is a partial response, such as when an HTTP response is split into multiple separate chunks. A `%finished` `client-response` is the final complete, assembled and parsed HTTP response. A `%cancel` `client-response` is sent when the runtime cancels the request for some reason.

Note that at the time of writing, **neither `%progress` nor `%cancel` `client-response`s are implemented**, so in practice you'll only ever get a single `%finished` `client-response`.

In a `%progress` `client-response`, the [$response-header:http](@/docs/arvo/eyre/data-types.md#response-header-http) contains the HTTP status code and headers. The `bytes-read` field is the total number of bytes fetched so far. The `expected-size` field is the total size specified in the content-length header if it has one. The `incremental` field is the data received since the last `%http-response`.

In a `%finished` `client-response`, the `full-file` is the complete body of the HTTP message as a (maybe) [$mime-data](#mime-data).

# `$mime-data`

```hoon
+$  mime-data
  [type=@t data=octs]
```

Unvalidated mime data that has been fetched from a remote HTTP resource.

# `$outbound-config`

```hoon
+$  outbound-config
  $:
      redirects=_5
      retries=_3
  ==
```

This structure is used in a [%request task](@/docs/arvo/iris/tasks.md#request) to specify settings for an HTTP request. The `redirects` field specifies the number of redirects to automatically follow before failing, and defaults to 5. The `retries` field specifies the number of times to retry a failed request before giving up, and defaults to 3.

Note that at the time of writing, **neither redirects nor retries have been implemented**, so these settings will not do anything and you can just use the bunt value in all cases.
