+++
title = "Fetch JSON"
weight = 1
template = "doc.html"
+++

Grabbing JSON from some url is very easy. 

`strandio` includes the `fetch-json` function which will handle the http request and response parsing and just return unformatted json data.

Here's a simple thread that will: 
- grab JSON of the latest base-hash from https://www.whatsthelatestbasehash.com/latesthash.json
- grab JSON of a list of all base-hashes with version info from https://www.whatsthelatestbasehash.com/all.json
- format and cast them
- check `all.json` includes the latest base-hash
- print the details of the latest base-hash to the dojo

### latest-hash.hoon

```hoon
/-  spider
/+  *strandio
=,  strand=strand:spider
=>
|%
++  url-1  "https://www.whatsthelatestbasehash.com/latesthash.json"
++  url-2  "https://www.whatsthelatestbasehash.com/all.json"
++  latest-format
  =,  dejs:format
  %-  ot
  :~  ['hash' so]
      ['timestamp' so]
      ['last_five' so]
  ==
++  latest-sur
  $:  hash=@t
      timestamp=@t
      last-five=@t
  ==
++  all-format
  =,  dejs:format
  %-  ar
  %-  ot
  :~  ['hash' so]
      ['pill' bo]
      ['version' so]
      ['published' so]
      ['release' so]
  ==
++  all-sur
  $:  hash=@t
      pill=?
      version=@t
      published=@t
      release=@t
  ==
--
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  js-latest=json  bind:m  (fetch-json url-1)
;<  js-all=json     bind:m  (fetch-json url-2)
=/  latest  `latest-sur`(latest-format js-latest)
=/  all  `(list all-sur)`(all-format js-all)
=/  res  (skim all |=(a=all-sur =(hash.a hash.latest)))
?~  res
  %-  (slog leaf+"Not Found" ~)  (pure:m !>(~))
%-  (slog leaf+"Hash: {(trip hash.i.res)}" ~)
%-  (slog leaf+"Pill? {?:(pill.i.res "Yes" "No")}" ~)
%-  (slog leaf+"Version: {(trip version.i.res)}" ~)
%-  (slog leaf+"Published: {(trip published.i.res)}" ~)
%-  (slog leaf+"Release: {(trip release.i.res)}" ~)
(pure:m !>(~))
```

Save it as `/ted/latest-hash.hoon`, `|commit %home` and run it with `-latest-hash`. You should see something like:

```
> -latest-hash
Hash: 0vj.dqqil.77m3k.a7v8d.mvrmi.8mavk.0a2nl.te6i6.cstfa.1ko6e.872gd
Pill? No
Version: v2.39
Published: ~2021.3.10..02.20.48
Release: https://github.com/urbit/urbit/releases/tag/urbit-os-v2.39
~
```

## Analysis 

`fetch-json` takes a url as a tape, so we've added a core with the urls like:

```hoon
=>
|%
++  url-1  "https://www.whatsthelatestbasehash.com/latesthash.json"
++  url-2  "https://www.whatsthelatestbasehash.com/all.json"
...
```

...then just called `fetch-json` like:

```hoon
;<  js-latest=json  bind:m  (fetch-json url-1)
```

We've added formatting and structure arms like:

```hoon
++  latest-format
  =,  dejs:format
  %-  ot
  :~  ['hash' so]
      ['timestamp' so]
      ['last_five' so]
  ==
++  latest-sur
  $:  hash=@t
      timestamp=@t
      last-five=@t
  ==
```

...to turn it from `json` to a noun with faces. You can have a look at the JSON formatting functions under `dejs:format` in `zuse.hoon` for how to deal with the various json types.

After that it's just some ordinary list logic and printing.
