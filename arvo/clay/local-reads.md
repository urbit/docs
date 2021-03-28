+++
title = "Local Reads and Writes"
weight = 5
template = "doc.html"
+++

Parts of this document may be out of date as of March 2021.

There are two real types of interaction with a filesystem: you can read,
and you can write. We'll describe each process, detailing both the flow
of control followed by the kernel and the algorithms involved. The
simpler case is that of the read, so we'll begin with that.

When a vane or an application wishes to read a file from the filesystem,
it sends a `%warp` kiss, as described above. Of course, you may request
a file on another ship and, being a global filesystem, clay will happily
produce it for you. That code pathway will be described in another
section; here, we will restrict ourselves to examining the case of a
read from a ship on our own pier.

The kiss can request either a single version of a file node or a range
of versions of a desk. Here, we'll deal only with a request for a single
version.

As in all vanes, a kiss enters clay via a call to `++call`. Scanning
through the arm, we quickly see where `%warp` is handled.

```hoon
            ?:  =(p.p.q.hic q.p.q.hic)
              =+  une=(un p.p.q.hic now ruf)
              =+  wex=(di:une p.q.q.hic)
              =+  ^=  wao
                ?~  q.q.q.hic
                  (ease:wex hen)
                (eave:wex hen u.q.q.q.hic)
              =+  ^=  woo
                abet:wao
              [-.woo abet:(pish:une p.q.q.hic +.woo ran.wao)]
```

We're following the familar patern of producing a list of moves and an
updated state. In this case, the state is `++raft`.

We first check to see if the sending and receiving ships are the same.
If they're not, then this is a request for data on another ship. We
describe that process later. Here, we discuss only the case of a local
read.

At a high level, the call to `++un` sets up the core for the domestic
ship that contains the files we're looking for. The call to `++di` sets
up the core for the particular desk we're referring to.

After this, we perform the actual request. If there is no rave in the
riff, then that means we are cancelling a request, so we call
`++ease:de`. Otherwise, we start a subscription with `++eave:de`. We
call `++abet:de` to resolve our various types of output into actual
moves. We produce the moves we found above and the `++un` core resolved
with `++pish:un` (putting the modified desk in the room) and `++abet:un`
(putting the modified room in the raft).

Much of this is fairly straightforward, so we'll only describe `++ease`,
`++eave`, and `++abet:de`. Feel free to look up the code to the other
steps -- it should be easy to follow.

Although it's called last, it's usually worth examining `++abet` first,
since it defines in what ways we can cause side effects. Let's do that,
and also a few of the lines at the beginning of `++de`.

```hoon
        =|  yel=(list ,[p=duct q=gift])
        =|  byn=(list ,[p=duct q=riot])
        =|  vag=(list ,[p=duct q=gift])
        =|  say=(list ,[p=duct q=path r=ship s=[p=@ud q=riff]])
        =|  tag=(list ,[p=duct q=path c=note])
        |%
        ++  abet
          ^-  [(list move) rede]
          :_  red
          ;:  weld
            %+  turn  (flop yel)
            |=([a=duct b=gift] [hun %give b])
          ::
            %+  turn  (flop byn)
            |=([a=duct b=riot] [a %give [%writ b]])
          ::
            %+  turn  (flop vag)
            |=([a=duct b=gift] [a %give b])
          ::
            %+  turn  (flop say)
            |=  [a=duct b=path c=ship d=[p=@ud q=riff]]
            :-  a
            [%pass b %a %want [who c] [%q %re p.q.d (scot %ud p.d) ~] q.d]
          ::
            %+  turn  (flop tag)
            |=([a=duct b=path c=note] [a %pass b c])
          ==
```

This is very simple code. We see there are exactly five different kinds
of side effects we can generate.

In `yel` we put gifts that we wish to be sent along the `hun:room` duct
to dill. See the documentation for `++room` above. This is how we
display messages to the terminal.

In `byn` we put riots that we wish returned to subscribers. Recall that
a riot is a response to a subscription. These are returned to our
subscribers in the form of a `%writ` gift.

In `vag` we put gifts along with the ducts on which to send them. This
allows us to produce arbitrary gifts, but in practice this is only used
to produce `%ergo` gifts.

In `say` we put messages we wish to pass to ames. These messages are
used to request information from clay on other piers. We must provide
not only the duct and the request (the riff), but also the return path,
the other ship to talk to, and the sequence number of the request.

In `tag` we put arbitrary notes we wish to pass to other vanes. For now,
the only notes we pass here are `%wait` and `%rest` to the timer vane.

Now that we know what kinds of side effects we may have, we can jump
into the handling of requests.

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

This is called when we're cancelling a subscription. For domestic desks,
`ref` is null, so we're going to cancel any timer we might have created.
We first delete the duct from our map of requests, and then we call
`++mabe` with `++best` to send a `%rest` kiss to the timer vane if we
have started a timer. We'll describe `++best` and `++mabe` momentarily.

Although we said we're not going to talk about foreign requests yet,
it's easy to see that for foreign desks, we cancel any outstanding
requests for this duct and send a message over ames to the other ship
telling them to cancel the subscription.

```hoon
        ++  best
          |=  [hen=duct tym=@da]
          %_(+> tag :_(tag [hen /tyme %t %rest tym]))
```

This simply pushes a `%rest` note onto `tag`, from where it will be
passed back to arvo to be handled. This cancels the timer at the given
duct (with the given time).

```hoon
        ++  mabe                                            ::  maybe fire function
          |*  [rov=rove fun=$+(@da _+>.^$)]
          ^+  +>.$
          %-  fall  :_  +>.$
          %-  bind  :_  fun
          ^-  (unit ,@da)
          ?-    -.rov
              %&
            ?.  ?=(%da -.q.p.rov)  ~
            `p.q.p.rov
              %|
            =*  mot  p.rov
            %+  hunt
              ?.  ?=(%da -.p.mot)  ~
              ?.((lth now p.p.mot) ~ [~ p.p.mot])
            ?.  ?=(%da -.q.mot)  ~
            ?.((lth now p.q.mot) [~ now] [~ p.q.mot])
          ==
```

This decides whether the given request can only be satsified in the
future. In that case, we call the given function with the time in the
future when we expect to have an update to give to this request. This is
called with `++best` to cancel timers and with `++bait` to start them.

For single requests, we have a time if the request is for a particular
time (which is assumed to be in the future). For ranges of requests, we
check both the start and end cases to see if they are time cases. If so,
we choose the earlier time.

If any of those give us a time, then we call the given funciton with the
smallest time.

The more interesting case is, of course, when we're not cancelling a
subscription but starting one.

```hoon
        ++  eave                                          ::  subscribe
          |=  [hen=duct rav=rave]
          ^+  +>
          ?-    -.rav
              &
            ?:  &(=(p.p.rav %u) !=(p.q.p.rav now))
              ~&  [%clay-fail p.q.p.rav %now now]
              !!
            =+  ver=(aver p.rav)
            ?~  ver
              (duce hen rav)
            ?~  u.ver
              (blub hen)
            (blab hen p.rav u.u.ver)
```

There are two types of subscriptions -- either we're requesting a single
file or we're requesting a range of versions of a desk. We'll dicuss the
simpler case first.

First, we check that we're not requesting the `rang` from any time other
than the present. Since we don't store that information for any other
time, we can't produce it in a referentially transparent manner for any
time other than the present.

Then, we try to read the requested `mood:clay` `p.rav`. If we can't access
the request data right now, we call `++duce` to put the request in our
queue to be satisfied when the information becomes available.

This case occurs when we make a request for a case whose (1) date is
after the current date, (2) number is after the current number, or (3)
label is not yet used.

```hoon
        ++  duce                                            ::  produce request
          |=  [hen=duct rov=rove]
          ^+  +>
          =.  qyx  (~(put by qyx) hen rov)
          ?~  ref
            (mabe rov (cury bait hen))
          |-  ^+  +>+.$                                     ::  XX  why?
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

The code for `++duce` is nearly the exact inverse of `++ease`, which in
the case of a domestic desk is very simple -- we simply put the duct and
rave into `qyx` and possibly start a timer with `++mabe` and `++bait`.
Recall that `ref` is null for domestic desks and that `++mabe` fires the
given function with the time we need to be woken up at, if we need to be
woken up at a particular time.

```hoon
        ++  bait
          |=  [hen=duct tym=@da]
          %_(+> tag :_(tag [hen /tyme %t %wait tym]))
```

This sets an alarm by sending a `%wait` card with the given time to the
timer vane.

Back in `++eave`, if `++aver` returned `[~ ~]`, then we cancel the
subscription. This occurs when we make (1) a `%x` request for a file
that does not exist, (2) a `%w` request with a case that is not a
number, or (3) a `%w` request with a nonempty path. The `++blub` is
exactly what you would expect it to be.

```hoon
        ++  blub                                          ::  ship stop
          |=  hen=duct
          %_(+> byn [[hen ~] byn])
```

We notify the duct that we're cancelling their subscription since it
isn't satisfiable.

Otherwise, we have received the desired information, so we send it on to
the subscriber with `++blab`.

```hoon
        ++  blab                                          ::  ship result
          |=  [hen=duct mun=mood dat=*]
          ^+  +>
          +>(byn [[hen ~ [p.mun q.mun syd] r.mun dat] byn])
```

The most interesting arm called in `++eave` is, of course, `++aver`,
where we actually try to read the data.

```hoon
        ++  aver                                          ::  read
          |=  mun=mood
          ^-  (unit (unit ,*))
          ?:  &(=(p.mun %u) !=(p.q.mun now))              ::  prevent bad things
            ~&  [%clay-fail p.q.mun %now now]
            !!
          =+  ezy=?~(ref ~ (~(get by haw.u.ref) mun))
          ?^  ezy  ezy
          =+  nao=(~(case-to-aeon ze lim dom ran) q.mun)
          ?~(nao ~ [~ (~(read-at-aeon ze lim dom ran) u.nao mun)])
```

We check immediately that we're not requesting the `rang` for any time
other than the present.

If this is a foreign desk, then we check our cache for the specific
request. If either this is a domestic desk or we don't have the request
in our cache, then we have to actually go read the data from our dome.

We need to do two things. First, we try to find the number of the commit
specified by the given case, and then we try to get the data there.

Here, we jump into `arvo/zuse.hoon`, which is where much of the
algorithmic code is stored, as opposed to the clay interface, which is
stored in `arvo/clay.hoon`. We examine `++case-to-aeon:ze`.

```hoon
      ++  case-to-aeon                                      ::    case-to-aeon:ze
        |=  lok=case                                        ::  act count through
        ^-  (unit aeon)
        ?-    -.lok
            %da
          ?:  (gth p.lok lim)  ~
          |-  ^-  (unit aeon)
          ?:  =(0 let)  [~ 0]                               ::  avoid underflow
          ?:  %+  gte  p.lok
              =<  t
              %-  tako-to-yaki
              %-  aeon-to-tako
              let
            [~ let]
          $(let (dec let))
        ::
            %tas  (~(get by lab) p.lok)
            %ud   ?:((gth p.lok let) ~ [~ p.lok])
        ==
```

We handle each type of `case:clay` differently. The latter two types are
easy.

If we're requesting a revision by label, then we simply look up the
requested label in `lab` from the given dome. If it exists, that is our
aeon; else we produce null, indicating the requested revision does not
yet exist.

If we're requesting a revision by number, we check if we've yet reached
that number. If so, we produce the number; else we produce null.

If we're requesting a revision by date, we check first if the date is in
the future, returning null if so. Else we start from the most recent
revision and scan backwards until we find the first revision committed
before that date, and we produce that. If we requested a date before any
revisions were committed, we produce `0`.

The definitions of `++aeon-to-tako` and `++tako-to-yaki` are trivial.

```hoon
      ++  aeon-to-tako  ~(got by hit)

      ++  tako-to-yaki  ~(got by hut)                       ::  grab yaki
```

We simply look up the aeon or tako in their respective maps (`hit` and
`hut`).

Assuming we got a valid version number, `++aver` calls
`++read-at-aeon:ze`, which reads the requested data at the given
revision.

```hoon
      ++  read-at-aeon                                      ::    read-at-aeon:ze
        |=  [oan=aeon mun=mood]                             ::  seek and read
        ^-  (unit)
        ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))                ::  NB only for speed
          ?^(r.mun ~ [~ oan])
        (read:(rewind oan) mun)
```

If we're requesting the revision number with a case other than by
number, then we go ahead and just produce the number we were given.
Otherwise, we call `++rewind` to rewind our state to the given revision,
and then we call `++read` to get the requested information.

```hoon
      ++  rewind                                            ::    rewind:ze
        |=  oan=aeon                                        ::  rewind to aeon
        ^+  +>
        ?:  =(let oan)  +>
        ?:  (gth oan let)  !!                               ::  don't have version
        +>(ank (checkout-ankh q:(tako-to-yaki (aeon-to-tako oan))), let oan)
```

If we're already at the requested version, we do nothing. If we're
requesting a version later than our head, we are unable to comply.

Otherwise, we get the hash of the commit at the number, and from that we
get the commit itself (the yaki), which has the map of path to lobe that
represents a version of the filesystem. We call `++checkout-ankh` to
checkout the commit, and we replace `ank` in our context with the
result.

```hoon
      ++  checkout-ankh                                     ::    checkout-ankh:ze
        |=  hat=(map path lobe)                             ::  checkout commit
        ^-  ankh
        %-  cosh
        %+  roll  (~(tap by hat) ~)
        |=  [[pat=path bar=lobe] ank=ankh]
        ^-  ankh
        %-  cosh
        ?~  pat
          =+  zar=(lobe-to-noun bar)
          ank(q [~ (sham zar) zar])
        =+  nak=(~(get by r.ank) i.pat)
        %=  ank
          r  %+  ~(put by r.ank)  i.pat
             $(pat t.pat, ank (fall nak _ankh))
        ==
```

Twice we call `++cosh`, which hashes a commit, updating `p` in an
`ankh`. Let's jump into that algorithm before we describe
`++checkout-ankh`.

```hoon
    ++  cosh                                                ::  locally rehash
      |=  ank=ankh                                          ::  NB v/unix.c
      ank(p rehash:(zu ank))
```

We simply replace `p` in the hash with the `cash` we get from a call to
`++rehash:zu`.

```hoon
    ++  zu  !:                                              ::  filesystem
      |=  ank=ankh                                          ::  filesystem state
      =|  myz=(list ,[p=path q=miso])                       ::  changes in reverse
      =|  ram=path                                          ::  reverse path into
      |%
      ++  rehash                                            ::  local rehash
        ^-  cash
        %+  mix  ?~(q.ank 0 p.u.q.ank)
        =+  axe=1
        |-  ^-  cash
        ?~  r.ank  _@
        ;:  mix
          (shaf %dash (mix axe (shaf %dush (mix p.n.r.ank p.q.n.r.ank))))
          $(r.ank l.r.ank, axe (peg axe 2))
          $(r.ank r.r.ank, axe (peg axe 3))
        ==
```

`++zu` is a core we set up with a particular filesystem node to traverse
a checkout of the filesystem and access the actual data inside it. One
of the things we can do with it is to create a recursive hash of the
node.

In `++rehash`, if this node is a file, then we xor the remainder of the
hash with the hash of the contents of the file. The remainder of the
hash is `0` if we have no children, else we descend into our children.
Basically, we do a half SHA-256 of the xor of the axis of this child and
the half SHA-256 of the xor of the name of the child and the hash of the
child. This is done for each child and all the results are xored
together.

Now we return to our discussion of `++checkout-ankh`.

We fold over every path in this version of the filesystem and create a
great ankh out of them. First, we call `++lobe-to-noun` to get the raw
data referred to be each lobe.

```hoon
      ++  lobe-to-noun                                      ::  grab blob
        |=  p=lobe                                          ::  ^-  *
        %-  blob-to-noun
        (lobe-to-blob p)
```

This converts a lobe into the raw data it refers to by first getting the
blob with `++lobe-to-blob` and converting that into data with
`++blob-to-noun`.

```hoon
      ++  lobe-to-blob  ~(got by lat)                       ::  grab blob
```

This just grabs the blob that the lobe refers to.

```hoon
      ++  blob-to-noun                                      ::  grab blob
        |=  p=blob
        ?-   -.p
           %delta  (lump r.p (lobe-to-noun q.p))
           %direct  q.p
           %indirect  q.p
        ==
```

If we have either a direct or an indirect blob, then the data is stored
right in the blob. Otherwise, we have to reconstruct it from the diffs.
We do this by calling `++lump` on the diff in the blob with the data
obtained by recursively calling the parent of this blob.

```hoon
    ++  lump                                                ::  apply patch
      |=  [don=udon src=*]
      ^-  *
      ?+    p.don  ~|(%unsupported !!)
          %a
        ?+  -.q.don  ~|(%unsupported !!)
          %a  q.q.don
          %c  (lurk ((hard (list)) src) p.q.don)
          %d  (lure src p.q.don)
        ==
      ::
          %c
        =+  dst=(lore ((hard ,@) src))
        %-  roly
        ?+  -.q.don  ~|(%unsupported !!)
          %a  ((hard (list ,@t)) q.q.don)
          %c  (lurk dst p.q.don)
        ==
      ==
```

This is defined in `arvo/hoon.hoon` for historical reasons which are
likely no longer applicable. Since the `++umph` structure will likely
change we convert clay to be a typed filesystem, we'll only give a
high-level description of this process. If we have a `%a` udon, then
we're performing a trivial replace, so we produce simply `q.q.don`. If
we have a `%c` udon, then we're performing a list merge (as in, for
example, lines of text). The merge is performed by `++lurk`.

```hoon
    ++  lurk                                                ::  apply list patch
      |*  [hel=(list) rug=(urge)]
      ^+  hel
      =+  war=`_hel`~
      |-  ^+  hel
      ?~  rug  (flop war)
      ?-    -.i.rug
          &
        %=   $
          rug  t.rug
          hel  (slag p.i.rug hel)
          war  (weld (flop (scag p.i.rug hel)) war)
        ==
      ::
          |
        %=  $
          rug  t.rug
          hel  =+  gur=(flop p.i.rug)
               |-  ^+  hel
               ?~  gur  hel
               ?>(&(?=(^ hel) =(i.gur i.hel)) $(hel t.hel, gur t.gur))
          war  (weld q.i.rug war)
        ==
      ==
```

We accumulate our final result in `war`. If there's nothing more in our
list of merge instructions (unces), we just reverse `war` and produce
it. Otherwise, we process another unce. If the unce is of type `&`, then
we have `p.i.rug` lines of no changes, so we just copy them over from
`hel` to `war`. If the unice is of type `|`, then we verify that the
source lines (in `hel`) are what we expect them to be (`p.i.rug`),
crashing on failure. If they're good, then we append the new lines in
`q.i.rug` onto `war`.

And that's really it. List merges are pretty easy. Anyway, if you
recall, we were discussing `++checkout-ankh`.

```hoon
      ++  checkout-ankh                                     ::    checkout-ankh:ze
        |=  hat=(map path lobe)                             ::  checkout commit
        ^-  ankh
        %-  cosh
        %+  roll  (~(tap by hat) ~)
        |=  [[pat=path bar=lobe] ank=ankh]
        ^-  ankh
        %-  cosh
        ?~  pat
          =+  zar=(lobe-to-noun bar)
          ank(q [~ (sham zar) zar])
        =+  nak=(~(get by r.ank) i.pat)
        %=  ank
          r  %+  ~(put by r.ank)  i.pat
             $(pat t.pat, ank (fall nak _ankh))
        ==
```

If the path is null, then we calculate `zar`, the raw data at the path
`pat` in this version. We produce the given ankh with the correct data.

Otherwise, we try to get the child we're looking at from our parent
ankh. If it's already been created, this succeeds; otherwise, we simply
create a default blank ankh. We place ourselves in our parent after
recursively computing our children.

This algorithm really isn't that complicated, but it may not be
immediately obvious why it works. An example should clear everything up.

Suppose `hat` is a map of the following information.

```
    /greeting                 -->  "customary upon meeting"
    /greeting/english         -->  "hello"
    /greeting/spanish         -->  "hola"
    /greeting/russian/short   -->  "привет"
    /greeting/russian/long    -->  "Здравствуйте"
    /farewell/russian         -->  "до свидания"
```

Furthermore, let's say that we process them in this order:

```
    /greeting/english
    /greeting/russian/short
    /greeting/russian/long
    /greeting
    /greeting/spanish
    /farewell/russian
```

Then, the first path we process is `/greeting/english` . Since our path
is not null, we try to get `nak`, but because our ankh is blank at this
point it doesn't find anything. Thus, update our blank top-level ankh
with a child `%greeting`. and recurse with the blank `nak` to create the
ankh of the new child.

In the recursion, we our path is `/english` and our ankh is again blank.
We try to get the `english` child of our ankh, but this of course fails.
Thus, we update our blank `/greeting` ankh with a child `english`
produced by recursing.

Now our path is null, so we call `++lobe-to-noun` to get the actual
data, and we place it in the brand-new ankh.

Next, we process `/greeting/russian/short`. Since our path is not null,
we try to get the child named `%greeting`, which does exist since we
created it earlier. We put modify this child by recursing on it. Our
path is now `/russian/short`, so we look for a `%russian` child in our
`/greeting` ankh. This doesn't exist, so we add it by recursing. Our
path is now `/short`, so we look for a `%short` child in our
`/greeting/russian` ankh. This doesn't exist, so we add it by recursing.
Now our path is null, so we set the contents of this node to `"привет"`,
and we're done processing this path.

Next, we process `/greeting/russian/long`. This proceeds similarly to
the previous except that now the ankh for `/greeting/russian` already
exists, so we simply reuse it rather than creating a new one. Of course,
we still must create a new `/greeting/russian/long` ankh.

Next, we process `/greeting`. This ankh already exists, so after we've
recursed once, our path is null, and our ankh is not blank -- it already
has two children (and two grandchildren). We don't touch those, though,
since a node may be both a file and a directory. We just add the
contents of the file -- "customary upon meeting" -- to the existing
ankh.

Next, we process `/greeting/spanish`. Of course, the `/greeting` ankh
already exists, but it doesn't have a `%spanish` child, so we create
that, taking care not to disturb the contents of the `/greeting` file.
We put "hola" into the ankh and call it good.

Finally, we process `/farewell/russian`. Here, the `/farewell` ankh
doesn't exist, so we create it. Clearly the newly-created ankh doesn't
have any children, so we have to add a `%russian` child, and in this
child we put our last content -- "до свидания".

We hope it's fairly obvious that the order we process the paths doesn't
affect the final ankh tree. The tree will be constructed in a very
different order depending on what order the paths come in, but the
resulting tree is independent of order.

At any rate, we were talking about something important, weren't we? If
you recall, that concludes our discussion of `++rewind`, which was
called from `++read-at-aeon`. In summary, `++rewind` returns a context
in which our current state is (very nearly) as it was when the specified
version of the desk was the head. This allows `++read-at-aeon` to call
`++read` to read the requested information.

```hoon
      ++  read                                              ::    read:ze
        |=  mun=mood                                        ::  read at point
        ^-  (unit)
        ?:  ?=(%v p.mun)
          [~ `dome`+<+<.read]
        ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))
          ?^(r.mun ~ [~ let])
        ?:  ?=(%w p.mun)
          =+  ^=  yak
              %-  tako-to-yaki
              %-  aeon-to-tako
              let
          ?^(r.mun ~ [~ [t.yak (forge-nori yak)]])
          ::?>  ?=(^ hit)  ?^(r.mun ~ [~ i.hit])     ::  what do?? need [@da nori]
        (query(ank ank:(descend-path:(zu ank) r.mun)) p.mun)
```

If we're requesting the dome, then we just return that immediately.

If we're requesting the revision number of the desk and we're not
requesting it by number, then we just return the current number of this
desk. Note of course that this was really already handled in
`++read-at-aeon`.

If we're requesting a `%w` with a specific revision number, then we do
something or other with the commit there. It's kind of weird, and it
doesn't seem to work, so we'll ignore this case.

Otherwise, we descend into the ankh tree to the given path with
`++descend-path:zu`, and then we handle specific request in `++query`.

```hoon
      ++  descend-path                                      ::  descend recursively
        |=  way=path
        ^+  +>
        ?~(way +> $(way t.way, +> (descend i.way)))
```

This is simple recursion down into the ankh tree. `++descend` descends
one level, so this will eventually get us down to the path we want.

```hoon
      ++  descend                                           ::  descend
        |=  lol=@ta
        ^+  +>
        =+  you=(~(get by r.ank) lol)
        +>.$(ram [lol ram], ank ?~(you [*cash ~ ~] u.you))
```

`ram` is the path that we're at, so to descend one level we push the
name of this level onto that path. We update the ankh with the correct
one at that path if it exists; else we create a blank one.

Once we've decscended to the correct level, we need to actually deal
with the request.

```hoon
      ++  query                                             ::    query:ze
        |=  ren=?(%u %v %x %y %z)                           ::  endpoint query
        ^-  (unit ,*)
        ?-  ren
          %u  [~ `rang`+<+>.query]
          %v  [~ `dome`+<+<.query]
          %x  ?~(q.ank ~ [~ q.u.q.ank])
          %y  [~ as-arch]
          %z  [~ ank]
        ==
```

Now that everything's set up, it's really easy. If they're requesting
the rang, dome, or ankh, we give it to them. If the contents of a file,
we give it to them if it is in fact a file. If the `arch`, then we
calculate it with `++as-arch`.

```hoon
      ++  as-arch                                           ::    as-arch:ze
        ^-  arch                                            ::  arch report
        :+  p.ank
          ?~(q.ank ~ [~ p.u.q.ank])
        |-  ^-  (map ,@ta ,~)
        ?~  r.ank  ~
        [[p.n.r.ank ~] $(r.ank l.r.ank) $(r.ank r.r.ank)]
```

This very simply strips out all the "real" data and returns just our own
hash, the hash of the file contents (if we're a file), and a map of the
names of our immediate children.

