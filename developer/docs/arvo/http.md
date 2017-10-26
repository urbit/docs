---
navhome: /developer/docs/
next: false
sort: 19
title: HTTP requests and timers
---

# Writing an HTTP request

There's a variety of arvo services we haven't touched on yet. Let's figure out 
how to make HTTP requests and set timers.

Let's build an uptime-monitoring system. It'll ping a web service periodically 
and print out an error when the response code isn't 2xx. Here's 
`/examples/app/up.hoon`:

```                                                         
::  Up-ness monitor. Accepts atom url, 'on', or 'off'   ::  1
::                                                      ::  2
::::  /===/app/up/hoon                                  ::  3
  ::                                                    ::  4
!:                                                      ::  5
::                                                      ::  6
|%                                                      ::  7
+=  move  [bone card]                                   ::  8
+=  card                                                ::  9
  $%  [$hiss wire $~ $httr [$purl p=purl:eyre]]         ::  10
      [$wait wire @da]                                  ::  11
  ==                                                    ::  12
+=  action                                              ::  13
  $%  [$on $~]                                          ::  14
      [$off $~]                                         ::  15
      [$target p=cord]                                  ::  16
  ==                                                    ::  17
--                                                      ::  18
|_  [bow=bowl:gall on=_| in-progress=_| target=@t]      ::  19
::                                                      ::  20
++  poke-atom                                           ::  21
  |=  url-or-command=@t                                 ::  22
  ^-  (quip move +>)                                    ::  23
  =+  ^-  act=action                                    ::  24
      ?:  ?=($on url-or-command)  [%on ~]               ::  25
      ?:  ?=($off url-or-command)  [%off ~]             ::  26
      [%target url-or-command]                          ::  27
  ?-  -.act                                             ::  28
    $target  [~ +>.$(target p.act)]                     ::  29
    $off  [~ +>.$(on |)]                                ::  30
    $on                                                 ::  31
      :-  ?:  |(on in-progress)  ~                      ::  32
          :~  :*  ost.bow                               ::  33
                  %hiss                                 ::  34
                  /request                              ::  35
                  ~                                     ::  36
                  %httr                                 ::  37
                  %purl                                 ::  38
                  (need (de-purl:html target))          ::  39
              ==                                        ::  40 
          ==                                            ::  41 
      +>.$(on &, in-progress &)                         ::  42 
  ==                                                    ::  43 
++  sigh-httr                                           ::  44 
  |=  [wir=wire code=@ud headers=mess body=(unit octs)] ::  45 
  ~&  'arrive here'                                     ::  46 
  ^-  [(list move) _+>.$]                               ::  47 
  ?:  &((gte code 200) (lth code 300))                  ::  48 
    ~&  [%all-is-well code]                             ::  49 
    :_  +>.$                                            ::  50 
    [ost.bow %wait /timer (add ~s10 now.bow)]~          ::  51 
  ~&  [%we-have-a-problem code]                         ::  52 
  ~&  [%headers headers]                                ::  53 
  ~&  [%body body]                                      ::  54 
  :_  +>.$                                              ::  55 
  [ost.bow %wait /timer (add ~s10 now.bow)]~            ::  56 
++  wake-timer                                          ::  57 
  |=  [wir=wire $~]  ^-  (quip move +>)                 ::  58 
  ?:  on                                                ::  59 
    :_  +>.$                                            ::  60 
    :~  :*  ost.bow                                     ::  61 
            %hiss                                       ::  62 
            /request                                    ::  63 
            ~                                           ::  64 
            %httr                                       ::  65 
            %purl                                       ::  66 
            (need (de-purl:html target))                ::  67 
        ==                                              ::  68
    ==                                                  ::  69 
  [~ +>.$(in-progress |)]                               ::  70 
::                                                      ::  71 
++  prep  ~&  target  _`.                               ::  72 
--                                                      ::  73
```

There's some fancy stuff going on here. We'll go through it line by line, 
though.

There's two kinds of cards we're sending to arvo. A `%hiss` move tells `%eyre` 
to make an HTTP request. It expects a `(unit iden)`, which will be null here 
because we aren't doing any authentication; a mark, in this case the http 
request mark `&httr`; and some data in the form of a `cage`, which is a 
`[mark vase]`. This is confusing, so the mold in the code quoted above 
includes a bunch of otherwise unnecessary faces for the purpose of 
illustration. Compare: `[$hiss p=(unit iden) q=mark r=cage]` from `zuse`.

> You can grep zuse.hoon and arvo.hoon for most of these definitions.
> However, beware the ambiguity surrounding "hiss": there's ++hiss in
> section 3bI of `zuse` ("Arvo structures"), and there's `%hiss` the
> move that is sent to %eyre to make our HTTP request happen. Here we're
> talking about the latter. See `++kiss-eyre` in `zuse`.

> Recall that `++unit` means "maybe".  Formally, "`(unit a)` is
> either null or a pair of null and a value in `a`". Also recall
> that to pull a value out of a unit (`u.unit`), you must first
> verify that the unit is not null (for example with `?~`). See
> `++need`.

A `purl` is a parsed url structure, which can be created with `++de-purl`, which 
is a function that takes a url as text and parses it into a `(unit purl)`. 
Thus, the result is null if and only if the url is malformed. `&purl` is also 
the mark which will be applied to this result.  

When you send this request, you can expect a `%sigh` with the response, which 
we handle later on in `++sigh-httr`.

For `%wait`, you just pass a [`@da`](/../../hoon/library/3c/) (absolute date), 
and arvo will produce a `%wake` when the time comes.

> A timer is guaranteed to not be triggered before the given
> time, but it's currently impossible to guarantee the timer will be
> triggered at *exactly* the requested time.

Let's take a look at our state:

```
|_  [bow=bowl:gall on=_| in-progress=_| target=@t]
```

We have three pieces of app-specific state. `target` is the url we're 
monitoring. `on` and `in-progress` are booleans representing, respectively, 
whether or not we're supposed to keep monitoring and whether or not we're in 
the middle of a request.

The type of booleans is usually written as `?`, which is a union of `&` (true) 
and `|` false.  This type defaults to `&` (true).  In our case, we want both 
of these to default to `|` (false). Because of that, we use `_|` as the type. 
`_value` means "take the type of `value`, but make the default value be 
`value`". Thus, our type is still a boolean, just like `?`, but the default 
value is `|` (false).

> This is the same `_` used in `_+>.$`, which means "the same
> type as the value "+>.$". In other words, the same type as our
> current context and state.

Let's take a look at `++poke-atom`. When we're poked with an atom, we first 
check whether the atom is `'off'`. If so, we set our state variable `on` to 
false.

If not, we check whether the atom is `'on'`.  If so, we set `on` and
`in-progress` to true.  If it was already either on or in progress, then
we don't take any other immediate action. If it was both off and not in
progress, then we send an HTTP request.

If the argument is neither 'off' nor 'on', then we assume it's an
actual url, so we save it in `target`.

Here's the move that sends the HTTP request, which is just a null-terminated 
list constructed with [`:~`](/../../hoon/twig/col/sig/) ('colsig'):
```
          :~  :*  ost.bow                               ::  33
                  %hiss                                 ::  34
                  /request                              ::  35
                  ~                                     ::  36
                  %httr                                 ::  37
                  %purl                                 ::  38
                  (need (de-pur:html target))           ::  39
              ==                                        ::  40 
          ==                                            ::  41 
```

> Remember, we are expected to produce a *list* of moves. We could normally 
> construct our list of moves using the common square bracket syntax (as shown 
> below this note), but our move is too wide to use wide form. Instead,
> we use a combination of cell-construction runes for what we need to produce. 
> The first rune (`:~`) constructs a null-terminated list. The second (`:*`) 
> constructs an n-tuple. The final product is a null-terminated list with one 
> element (itself a list) which contains our move.

Check out how we could produce the same list of moves using wide form: 
```
[ost.bow %hiss /request ~ %httr %purl (need (de-purl:html target))]~
```

> With this, notice how the move is followed by a `~`. This is a convenient 
> shortcut for creating a list of a single element. It's part of a small 
> family of creating a list of a single element. It's part of a small family 
> of such shortcuts. `~[a b c]` is `[a b c ~]`, `[a b c]~` is `[[a b c] ~]` 
> and `\`[a bc]` is `[~ a b c]`. These may be mixed and matched to create 
> various convoluted structures and emojis. The problem with this code is that 
> it extends wider than 55 columns, which is beyond what is recommended.

When the HTTP response comes back, we handle it with `++sigh-httr`, which, 
along with the wire the request was sent on, takes the status code, the 
response headers, and the response body.

We check whether the status code is between 200 and 300. If so, all is well, 
and we print a message saying so. We start the timer for ten seconds after the 
present time.

If we got a bad status code, then we print out the entire response and start 
the timer again.

After ten seconds, arvo will give us a `%wake` event, which will be handled in 
`++wake-timer`. If we're still supposed to keep monitoring, we send the same 
HTTP request as before. Otherwise, we set `in-progress` to false.

Let's try it out:

```
~fintud-macrep:dojo/examples> |start %up
>=
~fintud-macrep:dojo/examples> :up &atom 'on'
~fintud-macrep:dojo/examples> :up &atom 'http://www.google.com'
>=
[%all-is-well 200]
'arrive here'
[%all-is-well 200]
'arrive here'
~fintud-macrep:dojo/examples> :up &atom 'http://example.com'
>=
[%all-is-well 200]
'arrive here'
~fintud-macrep:dojo/examples> :up &atom 'http://google.com'
>=
[%we-have-a-problem 301]
'arrive here'
[ %headers
  ~[
    [p='X-Frame-Options' q='SAMEORIGIN']
    [p='X-XSS-Protection' q='1; mode=block']
    [p='Content-Length' q='219']
    [p='Server' q='gws']
    [p='Cache-Control' q='public, max-age=2592000']
    [p='Expires' q='Sun, 10 Jan 2016 23:45:05 GMT']
    [p='Date' q='Fri, 11 Dec 2015 23:45:05 GMT']
    [p='Content-Type' q='text/html; charset=UTF-8']
    [p='Location' q='http://www.google.com/']
  ]
]
[ %body
  [ ~
    [ p=219
        q
      \/'<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">\0a<TITLE>301 Moved</TI\/
        TLE></HEAD><BODY>\0a<H1>301 Moved</H1>\0aThe document has moved\0a<A HREF="http://www.google.com/">her
        e</A>.\0d\0a</BODY></HTML>\0d\0a'
      \/                                                                                                      \/
    ]
  ]
]
~fintud-macrep:dojo/examples> :up &atom 'off'
```
