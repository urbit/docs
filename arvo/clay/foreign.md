+++
title = "Foreign Requests"
weight = 7
template = "doc.html"
+++

Parts of this document may be out of date as of March 2021.

Foreign reads and subscriptions are handled in much the same way as
local ones. The interface is the same -- a vane or app sends a `%warp`
kiss with the request. The difference is simply that the `sock` refers
to the foreign ship.

Thus, we start in the same place -- in `++call`, handling `%warp`.
However, since the two side of the `sock` are different, we follow a
different path.

```hoon
            =+  wex=(do now p.q.hic p.q.q.hic ruf)
            =+  ^=  woo
              ?~  q.q.q.hic
                abet:(ease:wex hen)
              abet:(eave:wex hen u.q.q.q.hic)
            [-.woo (posh q.p.q.hic p.q.q.hic +.woo ruf)]
```

If we compare this to how the local case was handled, we see that it's
not all that different. We use `++do` rather than `++un` and `++de` to
set up the core for the foreign ship. This gives us a `++de` core, so we
either cancel or begin the request by calling `++ease` or `++eave`,
exactly as in the local case. In either case, we call `++abet:de` to
resolve our various types of output into actual moves, as described in
the local case. Finally, we call `++posh` to update our raft, putting
the modified rung into the raft.

We'll first trace through `++do`.

```hoon
      ++  do
        |=  [now=@da [who=ship him=ship] syd=@tas ruf=raft]
        =+  ^=  rug  ^-  rung
            =+  rug=(~(get by hoy.ruf) him)
            ?^(rug u.rug *rung)
        =+  ^=  red  ^-  rede
            =+  yit=(~(get by rus.rug) syd)
            ?^(yit u.yit `rede`[~2000.1.1 ~ [~ *rind] *dome])
        ((de now ~ ~) [who him] syd red ran.ruf)
```

If we already have a rung for this foreign ship, then we use that.
Otherwise, we create a new blank one. If we already have a rede in this
rung, then we use that, otherwise we create a blank one. An important
point to note here is that we let `ref` in the rede be `[~ *rind]`.
Recall, for domestic desks `ref` is null. We use this to distinguish
between foreign and domestic desks in `++de`.

With this information, we create a `++de` core as usual.

Although we've already covered `++ease` and `++eave`, we'll go through
them quickly again, highlighting the case of foreign request.

```hoon
        ++  ease                                          ::  release request
          |=  hen=duct
          ^+  +>
          ?~  ref  +>
            =+  rov=(~(got by qyx) hen)
            =.  qyx  (~(del by qyx) hen)
            (mabe rov (cury best hen))
          =.  qyx  (~(del by qyx) hen)
          |-  ^+  +>+.$
          =+  nux=(~(get by fod.u.ref) hen)
          ?~  nux  +>+.$
          %=  +>+.$
            say        [[hen [(scot %ud u.nux) ~] for [u.nux syd ~]] say]
            fod.u.ref  (~(del by fod.u.ref) hen)
            bom.u.ref  (~(del by bom.u.ref) u.nux)
          ==
```

Here, we still remove the duct from our cult (we maintain a cult even
for foreign desks), but we also need to tell the foreign desk to cancel
our subscription. We do this by sending a request (by appending to
`say`, which gets resolved in `++abet:de` to a `%want` kiss to ames) to
the foreign ship to cancel the subscription. Since we don't anymore
expect a response on this duct, we remove it from `fod` and `bom`, which
are the maps between ducts, raves, and request sequence numbers.
Basically, we remove every trace of the subscription from our request
manager.

In the case of `++eave`, where we're creating a new request, everything
is exactly identical to the case of the local request except `++duce`.
We said that `++duce` simply puts the request into our cult. This is
true for a domestic request, but distinctly untrue for foreign requests.

```hoon
        ++  duce                                          ::  produce request
          |=  [hen=duct rov=rove]
          ^+  +>
          =.  qyx  (~(put by qyx) hen rov)
          ?~  ref  +>.$
          |-  ^+  +>+.$                                   ::  XX  why?
          =+  rav=(reve rov)
          =+  ^=  vaw  ^-  rave
            ?.  ?=([%& %v *] rav)  rav
            [%| [%ud let.dom] `case`q.p.rav r.p.rav]
          =+  inx=nix.u.ref
          %=  +>+.$
            say        [[hen [(scot %ud inx) ~] for [inx syd ~ vaw]] say]
            nix.u.ref  +(nix.u.ref)
            bom.u.ref  (~(put by bom.u.ref) inx [hen vaw])
            fod.u.ref  (~(put by fod.u.ref) hen inx)
          ==
```

If we have a request manager (i.e. this is a foreign desk), then we do
the approximate inverse of `++ease`. We create a rave out of the given
request and send it off to the foreign desk by putting it in `say`. Note
that the rave is created to request the information starting at the next
revision number. Since this is a new request, we put it into `fod` and
`bom` to associate the request with its duct and its sequence number.
Since we're using another sequence number, we must increment `nix`,
which represents the next available sequence number.

And that's really it for this side of the request. Requesting foreign
information isn't that hard. Let's see what it looks like on the other
side. When we get a request from another ship for information on our
ship, that comes to us in the form of a `%wart` from ames.

We handle a `%wart` in `++call`, right next to where we handle the
`%warp` case.

```hoon
            %wart
          ?>  ?=(%re q.q.hic)
          =+  ryf=((hard riff) s.q.hic)
          :_  ..^$
          :~  :-  hen
              :^  %pass  [(scot %p p.p.q.hic) (scot %p q.p.q.hic) r.q.hic]
                %c
              [%warp [p.p.q.hic p.p.q.hic] ryf]
          ==
```

Every request we receive should be of type `riff`, so we coerce it into
that type. We just convert this into a new `%warp` kiss that we pass to
ourself. This gets handled like normal, as a local request. When the
request produces a value, it does so like normal as a `%writ`, which is
returned to `++take` along the path we just sent it on.

```hoon
            %writ
          ?>  ?=([@ @ *] tea)
          =+  our=(need (slaw %p i.tea))
          =+  him=(need (slaw %p i.t.tea))
          :_  ..^$
          :~  :-  hen
              [%pass ~ %a [%want [our him] [%r %re %c t.t.tea] p.+.q.hin]]
          ==
```

Since we encoded the ship we need to respond to in the path, we can just
pass our `%want` back to ames, so that we tell the requesting ship about
the new data.

This comes back to the original ship as a `%waft` from ames, which comes
into `++take`, right next to where we handled `%writ`.

```hoon
            %waft
          ?>  ?=([@ @ ~] tea)
          =+  syd=(need (slaw %tas i.tea))
          =+  inx=(need (slaw %ud i.t.tea))
          =+  ^=  zat
            =<  wake
            (knit:(do now p.+.q.hin syd ruf) [inx ((hard riot) q.+.q.hin)])
          =^  mos  ruf
            =+  zot=abet.zat
            [-.zot (posh q.p.+.q.hin syd +.zot ruf)]
          [mos ..^$(ran.ruf ran.zat)]                         ::  merge in new obj
```

This gets the desk and sequence number from the path the request was
sent over. This determines exactly which request is being responded to.
We call `++knit:de` to apply the changes to our local desk, and we call
`++wake` to update our subscribers. Then we call `++abet:de` and
`++posh` as normal (like in `++eave`).

We'll examine `++knit` and `++wake`, in that order.

```hoon
        ++  knit                                          ::  external change
          |=  [inx=@ud rot=riot]
          ^+  +>
          ?>  ?=(^ ref)
          |-  ^+  +>+.$
          =+  ruv=(~(get by bom.u.ref) inx)
          ?~  ruv  +>+.$
          =>  ?.  |(?=(~ rot) ?=(& -.q.u.ruv))  .
              %_  .
                bom.u.ref  (~(del by bom.u.ref) inx)
                fod.u.ref  (~(del by fod.u.ref) p.u.ruv)
              ==
          ?~  rot
            =+  rav=`rave`q.u.ruv
            %=    +>+.$
                lim
              ?.(&(?=(| -.rav) ?=(%da -.q.p.rav)) lim `@da`p.q.p.rav)
            ::
                haw.u.ref
              ?.  ?=(& -.rav)  haw.u.ref
              (~(put by haw.u.ref) p.rav ~)
            ==
          ?<  ?=(%v p.p.u.rot)
          =.  haw.u.ref
            (~(put by haw.u.ref) [p.p.u.rot q.p.u.rot q.u.rot] ~ r.u.rot)
          ?.  ?=(%w p.p.u.rot)  +>+.$
          |-  ^+  +>+.^$
          =+  nez=[%w [%ud let.dom] ~]
          =+  nex=(~(get by haw.u.ref) nez)
          ?~  nex  +>+.^$
          ?~  u.nex  +>+.^$  ::  should never happen
          =.  +>+.^$     =+  roo=(edis ((hard nako) u.u.nex))
                         ?>(?=(^ ref.roo) roo)
          %=  $
            haw.u.ref  (~(del by haw.u.ref) nez)
          ==
```

This is kind of a long [gate](/docs/glossary/gate/), but don't worry, it's not bad at all.

First, we assert that we're not a domestic desk. That wouldn't make any
sense at all.

Since we have the sequence number of the request, we can get the duct
and rave from `bom` in our request manager. If we didn't actually
request this data (or the request was canceled before we got it), then
we do nothing.

Else, we remove the request from `bom` and `fod` unless this was a
subscription request and we didn't receive a null riot (which would
indicate the last message on the subscription).

Now, if we received a null riot, then if this was a subscription request
by date, then we update `lim` in our request manager (representing the
latest time at which we have complete information for this desk) to the
date that was requested. If this was a single read request, then we put
the result in our simple cache `haw` to make future requests faster.
Then we're done.

If we received actual data, then we put it into our cache `haw`. Unless
it's a `%w` request, we're done.

If it is a `%w` request, then we try to get the `%w` at our current head
from the cache. In general, that should be the thing we just put in a
moment ago, but that is not guaranteed. The most common case where this
is different is when we receive desk updates out of order. At any rate,
since we now have new information, we need to apply it to our local copy
of the desk. We do so in `++edis`, and then we remove the stuff we just
applied from the cache, since it's not really a true "single read", like
what should really be in the cache.

```hoon
        ++  edis                                          ::  apply subscription
          |=  nak=nako
          ^+  +>
          %=  +>
            hit.dom  (~(uni by hit.dom) gar.nak)
            let.dom  let.nak
            lat.ran  %+  roll  (~(tap in bar.nak) ~)
                     =<  .(yeb lat.ran)
                     |=  [sar=blob yeb=(map lobe blob)]
                     =+  zax=(blob-to-lobe sar)
                     %+  ~(put by yeb)  zax  sar
            hut.ran  %+  roll  (~(tap in lar.nak) ~)
                     =<  .(yeb hut.ran)
                     |=  [sar=yaki yeb=(map tako yaki)]
                     %+  ~(put by yeb)  r.sar  sar
          ==
```

This shows, of course, exactly why nako is defined the way it is. To
become completely up to date with the foreign desk, we need to merge
`hit` with the foreign one so that we have all the revision numbers. We
update `let` so that we know which revision is the head.

We merge the new blobs in `lat`, keying them by their hash, which we get
from a call to `++blob-to-lobe`. Recall that the hash is stored in the
actual blob itself. We do the same thing to the new yakis, putting them
in `hut`, keyed by their hash.

Now, our local dome should be exactly the same as the foreign one.

This concludes our discussion of `++knit`. Now the changes have been
applied to our local copy of the desk, and we just need to update our
subscribers. We do so in `++wake:de`.

```hoon
        ++  wake                                          ::  update subscribers
          ^+  .
          =+  xiq=(~(tap by qyx) ~)
          =|  xaq=(list ,[p=duct q=rove])
          |-  ^+  ..wake
          ?~  xiq
            ..wake(qyx (~(gas by *cult) xaq))
          ?-    -.q.i.xiq
              &
            =+  cas=?~(ref ~ (~(get by haw.u.ref) `mood`p.q.i.xiq))
            ?^  cas
              %=    $
                  xiq  t.xiq
                  ..wake  ?~  u.cas  (blub p.i.xiq)
                          (blab p.i.xiq p.q.i.xiq u.u.cas)
              ==
            =+  nao=(~(case-to-aeon ze lim dom ran) q.p.q.i.xiq)
            ?~  nao  $(xiq t.xiq, xaq [i.xiq xaq])
            $(xiq t.xiq, ..wake (balk p.i.xiq u.nao p.q.i.xiq))
          ::
              |
            =+  mot=`moot`p.q.i.xiq
            =+  nab=(~(case-to-aeon ze lim dom ran) p.mot)
            ?~  nab
              $(xiq t.xiq, xaq [i.xiq xaq])
            =+  huy=(~(case-to-aeon ze lim dom ran) q.mot)
            ?~  huy
              =+  ptr=[%ud +(let.dom)]
              %=  $
                xiq     t.xiq
                xaq     [[p.i.xiq [%| ptr q.mot r.mot s.mot]] xaq]
                ..wake  =+  ^=  ear
                            (~(lobes-at-path ze lim dom ran) let.dom r.p.q.i.xiq)
                        ?:  =(s.p.q.i.xiq ear)  ..wake
                        =+  fud=(~(make-nako ze lim dom ran) u.nab let.dom)
                        (bleb p.i.xiq let.dom fud)
              ==
            %=  $
              xiq     t.xiq
              ..wake  =-  (blub:- p.i.xiq)
                      =+  ^=  ear
                          (~(lobes-at-path ze lim dom ran) u.huy r.p.q.i.xiq)
                      ?:  =(s.p.q.i.xiq ear)  (blub p.i.xiq)
                      =+  fud=(~(make-nako ze lim dom ran) u.nab u.huy)
                      (bleb p.i.xiq +(u.nab) fud)
            ==
          ==
        --
```

This is even longer than `++knit`, but it's pretty similar to `++eave`.
We loop through each of our subscribers `xiq`, processing each in turn.
When we're done, we just put the remaining subscribers back in our
subscriber list.

If the subscriber is a single read, then, if this is a foreign desk
(note that `++wake` is called from other arms, and not only on foreign
desks). Obviously, if we find an identical request there, then we can
produce the result immediately. Referential transparency for the win. We
produce the result with a call to `++blab`. If this is a foreign desk
but the result is not in the cache, then we produce `++blub` (canceled
subscription with no data) for reasons entirely opaque to me. Seriously,
it seems like we should wait until we get an actual response to the
request. If someone figures out why this is, let me know. At any rate,
it seems to work.

If this is a domestic desk, then we check to see if the case exists yet.
If it doesn't, then we simply move on to the next subscriber, consing
this one onto `xaq` so that we can check again the next time around. If
it does exist, then we call `++balk` to fulfill the request and produce
it.

`++balk` is very simple, so we'll describe it here before we get to the
subscription case.

```hoon
        ++  balk                                          ::  read and send
          |=  [hen=duct oan=@ud mun=mood]
          ^+  +>
          =+  vid=(~(read-at-aeon ze lim dom ran) oan mun)
          ?~  vid  (blub hen)  (blab hen mun u.vid)
```

We call `++read-at-aeon` on the given request and aeon. If you recall,
this processes a `mood` at a particular aeon and produces the result, if
there is one. If there is data at the requested location, then we
produce it with `++blab`. Else, we call `++blub` to notify the
subscriber that no data can ever come over this subscriptioin since it
is now impossible for there to ever be data for the given request.
Because referential transparency.

At any rate, back to `++wake`. If the given rave is a subscription
request, then we proceed similarly to how we do in `++eave`. We first
try to get the aeon referred to by the starting case. If it doesn't
exist yet, then we can't do anything interesting with this subscription,
so we move on to the next one.

Otherwise, we try to get the aeon referred to by the ending case. If it
doesn't exist yet, then we produce all the information we can. We call
`++lobes-at-path` at the given aeon and path to see if the requested
path has actually changed. If it hasn't, then we don't produce anything;
else, we produce the correct nako by calling `++bleb` on the result of
`++make-nako`, as in `++eave`. At any rate, we move on to the next
subscription, putting back into our cult the current subscription with a
new start case of the next aeon after the present.

If the aeon referred to by the ending case does exist, then we drop this
subscriber from our cult and satisfy its request immediately. This is
the same as before -- we check to see if the data at the path has
actually changed, producing it if it has; else, we call `++blub` since
no more data can be produced over this subscription.

This concludes our discussion of foreign requests.

