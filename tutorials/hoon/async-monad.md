+++
title = "2.7.2 Gall: Async Monad"
weight = 37
template = "doc.html"
+++

Gall apps can be difficult to understand and simple ones often don't need the full complexity available when writing standard Gall apps. To that end, the `tapp` library implements the "async monad" which is more accurately described as a transitional IO monad. If you're not familiar with monads, don't worry as that understanding will not be necessary to use the `tapp` library.

The following code is from `app/example-tapp-fetch.hoon` Much of this file should already be pretty readable, particularly given the comments in it, so we'll focus here on specific parts of the file rather than a full walkthrough. This app is intended to get the top comment of the top ten stories on Hacker News.

```hoon
::  Little app to demonstrate the structure of programs written with the
::  transaction monad.
::
::  Fetches the top comment of each of the top 10 stories from Hacker News
::
/+  tapp, stdio
::
::  Preamble
::
=>
  |%
  +$  state
    $:  top-comments=(list tape)
    ==
  +$  peek-data  _!!
  +$  in-poke-data   [%noun =cord]
  +$  out-poke-data  ~
  +$  in-peer-data   ~
  +$  out-peer-data
    $%  [%comments (list tape)]
    ==
  ++  tapp   (^tapp state peek-data in-poke-data out-poke-data in-peer-data out-peer-data)
  ++  stdio  (^stdio out-poke-data out-peer-data)
  --
=>
  |%
  ::  Helper function to print a comment
  ::
  ++  comment-to-tang
    |=  =tape
    ^-  tang
    %+  welp
      %+  turn  (rip 10 (crip tape))
      |=  line=cord
      leaf+(trip line)
    [leaf+""]~
  ::
  ::  All the URLs we fetch from
  ::
  ++  urls
    =/  base  "https://hacker-news.firebaseio.com/v0/"
    :*  top-stories=(weld base "topstories.json")
        item=|=(item=@ud `tape`:(welp base "item/" +>:(scow %ui item) ".json"))
    ==
  --
=,  async=async:tapp
=,  tapp-async=tapp-async:tapp
=,  stdio
::
::  The app
::
%-  create-tapp-poke-peer-take:tapp
^-  tapp-core-poke-peer-take:tapp
|_  [=bowl:gall state]
::
::  Main function
::
++  handle-poke
  |=  =in-poke-data
  =/  m  tapp-async
  ^-  form:m
  ::
  ::  If requested to print, just print what we have in our state
  ::
  ?:  =(cord.in-poke-data 'print')
    ~&  'drumroll please...'
    ;<  now=@da  bind:m  get-time
    ;<  ~        bind:m  (wait (add now ~s3))
    ~&  'Top comments:'
    %-  (slog (zing (turn top-comments comment-to-tang)))
    (pure:m top-comments)
  ?:  =(cord.in-poke-data 'poll')
    ;<  ~  bind:m  (wait-effect (add now.bowl ~s15))
    (pure:m top-comments)
  ::
  ::  Otherwise, fetch the top HN stories
  ::
  =.  top-comments  ~
  ::
  ::  If this whole thing takes more than 15 seconds, cancel it
  ::
  %+  (set-timeout _top-comments)  (add now.bowl ~s15)
  ;<  =top-stories=json  bind:m  (fetch-json top-stories:urls)
  =/  top-stories=(list @ud)
    ((ar ni):dejs:format top-stories-json)
  ::
  ::  Loop through the first 5 stories
  ::
  =.  top-stories  (scag 5 top-stories)
  |-  ^-  form:m
  =*  loop  $
  ::
  ::  If done, tell subscribers and print the results
  ::
  ?~  top-stories
    ;<  ~  bind:m  (give-result /comments %comments top-comments)
    (handle-poke %noun 'print')
  ::
  ::  Else, fetch the story info
  ::
  ~&  "fetching item #{+>:(scow %ui i.top-stories)}"
  ;<  =story-info=json  bind:m  (fetch-json (item:urls i.top-stories))
  =/  story-comments=(unit (list @ud))
    ((ot kids+(ar ni) ~):dejs-soft:format story-info-json)
  ::
  ::  If no comments, say so
  ::
  ?:  |(?=(~ story-comments) ?=(~ u.story-comments))
    =.  top-comments  ["<no top comment>" top-comments]
    loop(top-stories t.top-stories)
  ::
  ::  Else, fetch comment info
  ::
  ;<  =comment-info=json  bind:m  (fetch-json (item:urls i.u.story-comments))
  =/  comment-text=(unit tape)
    ((ot text+sa ~):dejs-soft:format comment-info-json)
  ::
  ::  If no text (eg comment deleted), record that
  ::
  ?~  comment-text
    =.  top-comments  ["<top comment has no text>" top-comments]
    loop(top-stories t.top-stories)
  ::
  ::  Else, add text to state
  ::
  =.  top-comments  [u.comment-text top-comments]
  loop(top-stories t.top-stories)
::
++  handle-peer
  |=  =path
  =/  m  tapp-async
  ^-  form:m
  ~&  [%tapp-fetch-take-peer path]
  (pure:m top-comments)
::
++  handle-take
  |=  =sign:tapp
  =/  m  tapp-async
  ^-  form:m
  ::  ignore %poke/peer acknowledgements
  ::
  ?.  ?=(%wake -.sign)
    (pure:m top-comments)
  ;<  =state  bind:m  (handle-poke %noun 'fetch')
  =.  top-comments  state
  (pure:m top-comments)
--
```

As indicated by the comments, `handle-poke` is the main [arm](/docs/glossary/arm/) of our Gall app. This is equivalent to the `poke` [arm](/docs/glossary/arm/)s in a standard Gall app, but will not differentiate by mark. Let's look at the first part of this [gate](/docs/glossary/gate/).

```hoon
++  handle-poke
  |=  =in-poke-data
  =/  m  tapp-async
  ^-  form:m
  ::
  ::  If requested to print, just print what we have in our state
  ::
  ?:  =(cord.in-poke-data 'print')
    ~&  'drumroll please...'
    ;<  now=@da  bind:m  get-time
    ;<  ~        bind:m  (wait (add now ~s3))
    ~&  'Top comments:'
    %-  (slog (zing (turn top-comments comment-to-tang)))
    (pure:m top-comments)
  ?:  =(cord.in-poke-data 'poll')
    ;<  ~  bind:m  (wait-effect (add now.bowl ~s15))
    (pure:m top-comments)
```

The first part of this [gate](/docs/glossary/gate/) inspects the `in-poke-data` structure, specifically the `cord` to determine what request is being made. Here the request is to just print the data that we already have. 

The most important part to see here is the `;<` rune. If you're familiar with monadic bind, this is what this rune is. If you're not, don't worry! While we wont be discussing the implementation details of this rune, it's quite simple to use. 

`;<` has four children: `A`, `B`, `C` and `D`.

`A` is a mold that describes the type produced by `C`. 

`B` is the monadic bind function, `bind:tapp-async`.

`C` is some code we want to run and `D` is code to run after the `C` has completed successfully. If `C` fails, then the entire `;<` call will fail. This will allow us to chain a series of calls which may take a long time to complete, such as http requests, together and proceed when they actually complete.

`D` must produce the type defined by `B`, `tapp-async` or `(async ,state)`. In the final leg of the `;<` series in this app you'll see the calls to `pure:m` which is used to wrap `top-comments` in an `async`.

In a number of cases `D` here is going to be another `;<` rune. This is how you can chain these together to perform a lot of asynchronous actions that need to all complete.

```hoon
  ::
  ::  Otherwise, fetch the top HN stories
  ::
  =.  top-comments  ~
  ::
  ::  If this whole thing takes more than 15 seconds, cancel it
  ::
  %+  (set-timeout _top-comments)  (add now.bowl ~s15)
  ;<  =top-stories=json  bind:m  (fetch-json top-stories:urls)
  =/  top-stories=(list @ud)
    ((ar ni):dejs:format top-stories-json)
```

Continuing on, here is a use of `fetch-json` with the `;<` that is an example worth reading. `fetch-json` takes a `tape` and produces a `form:(async ,json)` which can be processed to obtain the data we want.

Armed with an understanding of `;<`, the rest of `handle-poke` should be quite readable though you may need to consult the `dejs-soft:format` [core](/docs/glossary/core/) to get a firm grasp on how JSON parsing works. Hopefully, you now have an understanding of the basic use of the `tapp` library. This style of Gall app can result in code that, while potentially less flexible, is easier to read and reason about than a traditional Gall app.