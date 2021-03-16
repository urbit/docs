+++
title = "Local Subscriptions"
weight = 6
template = "doc.html"
+++

Parts of this document may be out of date as of March 2021.

A subscription to a range of revisions of a desk initially follows the
same path that a single read does. In `++aver`, we checked the head of
the given rave. If the head was `&`, then it was a single request, so we
handled it above. If `|`, then we handle it with the following code.

```hoon
            =+  nab=(~(case-to-aeon ze lim dom ran) p.p.rav)
            ?~  nab
              ?>  =(~ (~(case-to-aeon ze lim dom ran) q.p.rav))
              (duce hen (rive rav))
            =+  huy=(~(case-to-aeon ze lim dom ran) q.p.rav)
            ?:  &(?=(^ huy) |((lth u.huy u.nab) &(=(0 u.huy) =(0 u.nab))))
              (blub hen)
            =+  top=?~(huy let.dom u.huy)
            =+  sar=(~(lobes-at-path ze lim dom ran) u.nab r.p.rav)
            =+  ear=(~(lobes-at-path ze lim dom ran) top r.p.rav)
            =.  +>.$
              ?:  =(sar ear)  +>.$
              =+  fud=(~(make-nako ze lim dom ran) u.nab top)
              (bleb hen u.nab fud)
            ?^  huy
              (blub hen)
            =+  ^=  ptr  ^-  case
                [%ud +(let.dom)]
            (duce hen `rove`[%| ptr q.p.rav r.p.rav ear])
          ==
```

Recall that `++case-to-aeon:ze` produces the revision number that a case
corresponds to, if it corresponds to any. If it doesn't yet correspond
to a revision, then it produces null.

Thus, we first check to see if we've even gotten to the beginning of the
range of revisions requested. If not, then we assert that we haven't yet
gotten to the end of the range either, because that would be really
strange. If not, then we immediately call `++duce`, which, if you
recall, for a local request, simply puts this duct and rove into our
cult `qyx`, so that we know who to respond to when the revision does
appear.

If we've already gotten to the first revision, then we can produce some
content immediately. If we've also gotten to the final revision, and
that revision is earlier than the start revision, then it's a bad
request and we call `++blub`, which tells the subscriber that his
subscription will not be satisfied.

Otherwise, we find the data at the given path at the beginning of the
subscription and at the last available revision in the subscription. If
they're the same, then we don't send a notification. Otherwise, we call
`++gack`, which creates the `++nako` we need to produce. We call
`++bleb` to actually produce the information.

If we already have the last requested revision, then we also tell the
subscriber with `++blub` that the subscription will receive no further
updates.

If there will be more revisions in the subscription, then we call
`++duce`, adding the duct to our subscribers. We modify the rove to
start at the next revision since we've already handled all the revisions
up to the present.

We glossed over the calls to `++lobes-at-path`, `++make-nako`, and
`++bleb`, so we'll get back to those right now. `++bleb` is simple, so
we'll start with that.

```hoon
        ++  bleb                                          ::  ship sequence
          |=  [hen=duct ins=@ud hip=nako]
          ^+  +>
          (blab hen [%w [%ud ins] ~] hip)
```

We're given a duct, the beginning revision number, and the nako that
contains the updates since that revision. We use `++blab` to produce
this result to the subscriber. The case is `%w` with a revision number
of the beginning of the subscription, and the data is the nako itself.

We call `++lobes-at-path:ze` to get the data at the particular path.

```hoon
      ++  lobes-at-path                                     ::    lobes-at-path:ze
        |=  [oan=aeon pax=path]                             ::  data at path
        ^-  (map path lobe)
        ?:  =(0 oan)  ~
        %-  mo
        %+  skim
          %.  ~
          %~  tap  by
          =<  q
          %-  tako-to-yaki
          %-  aeon-to-tako
          oan
        |=  [p=path q=lobe]
        ?|  ?=(~ pax)
            ?&  !?=(~ p)
                =(-.pax -.p)
                $(p +.p, pax +.pax)
        ==  ==
```

At revision zero, the theoretical common revision between all
repositories, there is no data, so we produce null.

We get the list of paths (paired with their lobe) in the revision
referred to by the given number and we keep only those paths which begin
with `pax`. Converting to a map, we now have a map from the subpaths at
the given path to the hash of their data. This is simple and efficient
to calculate and compare to later revisions. This allows us to easily
tell if a node or its children have changed.

Finally, we will describe `++make-nako:ze`.

```hoon
      ++  make-nako                                         ::  gack a through b
        |=  [a=aeon b=aeon]
        ^-  [(map aeon tako) aeon (set yaki) (set blob)]
        :_  :-  b
            =-  [(takos-to-yakis -<) (lobes-to-blobs ->)]
            %+  reachable-between-takos
              (~(get by hit) a)                             ::  if a not found, a=0
            (aeon-to-tako b)
        ^-  (map aeon tako)
        %-  mo  %+  skim  (~(tap by hit) ~)
        |=  [p=aeon *]
        &((gth p a) (lte p b))
```

We need to produce four things -- the numbers of the new commits, the
number of the latest commit, the new commits themselves, and the new
data itself.

The first is fairly easy to produce. We simply go over our map of
numbered commits and produce all those numbered greater than `a` and not
greater than `b`.

The second is even easier to produce -- `b` is clearly our most recent
commit.

The third and fourth are slightly more interesting, though not too
terribly difficult. First, we call `++reachable-between-takos`.

```hoon
      ++  reachable-between-takos
        |=  [a=(unit tako) b=tako]                          ::  pack a through b
        ^-  [(set tako) (set lobe)]
        =+  ^=  sar
            ?~  a  ~
            (reachable-takos r:(tako-to-yaki u.a))
        =+  yak=`yaki`(tako-to-yaki b)
        %+  new-lobes-takos  (new-lobes ~ sar)              ::  get lobes
        |-  ^-  (set tako)                                  ::  walk onto sar
        ?:  (~(has in sar) r.yak)
          ~
        =+  ber=`(set tako)`(~(put in `(set tako)`~) `tako`r.yak)
        %-  ~(uni in ber)
        ^-  (set tako)
        %+  roll  p.yak
        |=  [yek=tako bar=(set tako)]
        ^-  (set tako)
        ?:  (~(has in bar) yek)                             ::  save some time
          bar
        %-  ~(uni in bar)
        ^$(yak (tako-to-yaki yek))
```

We take a possible starting commit and a definite ending commit, and we
produce the set of commits and the set of data between them.

We let `sar` be the set of commits reachable from `a`. If `a` is null,
then obviously no commits are reachable. Otherwise, we call
`++reachable-takos` to calculate this.

```hoon
      ++  reachable-takos                                   ::  reachable
        |=  p=tako                                          ::  XX slow
        ^-  (set tako)
        =+  y=(tako-to-yaki p)
        =+  t=(~(put in _(set tako)) p)
        %+  roll  p.y
        |=  [q=tako s=_t]
        ?:  (~(has in s) q)                                 ::  already done
          s                                                 ::  hence skip
        (~(uni in s) ^$(p q))                               ::  otherwise traverse
```

We very simply produce the set of the given tako plus its parents,
recursively.

Back in `++reachable-between-takos`, we let `yak` be the yaki of `b`,
the ending commit. With this, we create a set that is the union of `sar`
and all takos reachable from `b`.

We pass `sar` into `++new-lobes` to get all the lobes referenced by any
tako referenced by `a`. The result is passed into `++new-lobes-takos` to
do the same, but not recomputing those in already calculated last
sentence. This produces the sets of takos and lobes we need.

```hoon
      ++  new-lobes                                         ::  object hash set
        |=  [b=(set lobe) a=(set tako)]                     ::  that aren't in b
        ^-  (set lobe)
        %+  roll  (~(tap in a) ~)
        |=  [tak=tako bar=(set lobe)]
        ^-  (set lobe)
        =+  yak=(tako-to-yaki tak)
        %+  roll  (~(tap by q.yak) ~)
        |=  [[path lob=lobe] far=_bar]
        ^-  (set lobe)
        ?~  (~(has in b) lob)                               ::  don't need
          far
        =+  gar=(lobe-to-blob lob)
        ?-  -.gar
          %direct  (~(put in far) lob)
          %delta  (~(put in $(lob q.gar)) lob)
          %indirect  (~(put in $(lob s.gar)) lob)
        ==
```

Here, we're creating a set of lobes referenced in a commit in `a`. We
start out with `b` as the initial set of lobes, so we don't need to
recompute any of the lobes referenced in there.

The algorithm is pretty simple, so we won't bore you with the details.
We simply traverse every commit in `a`, looking at every blob referenced
there, and, if it's not already in `b`, we add it to `b`. In the case of
a direct blob, we're done. For a delta or an indirect blob, we
recursively add every blob referenced within the blob.

```hoon
      ++  new-lobes-takos                                   ::  garg & repack
        |=  [b=(set lobe) a=(set tako)]
        ^-  [(set tako) (set lobe)]
        [a (new-lobes b a)]
```

Here, we just update the set of lobes we're given with the commits we're
given and produce both sets.

This concludes our discussion of a local subscription.


