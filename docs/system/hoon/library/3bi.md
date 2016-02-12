section 3bI, Arvo models
========================

### `++acru`

    ++  acru                                                ::  asym cryptosuite
              $_  ^?  |%                                    ::  opaque object

Cryptosuite interface, see %ames documentation

    ~zod/main=> `acru`crua
    <6?guc 243.nxm 41.spz 374.iqw 100.rip 1.ypj %164>
    ~zod/main=> `acru`crub
    <6?guc 243.nxm 41.spz 374.iqw 100.rip 1.ypj %164>
    ~zod/main=> *acru
    <6?guc 243.nxm 41.spz 374.iqw 100.rip 1.ypj %164>

### `++as`

              ++  as  ^?                                    ::  asym ops
                |%  ++  seal  |=([a=pass b=@ c=@] _@)       ::  encrypt to a

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++seal`

    ++  seal                                                ::  auth conversation
              $:  whu=(unit ship)                           ::  client identity
                  pul=purl                                  ::  destination url
                  wit=?                                     ::  wait for partner
                  foy=(unit ,[p=ship q=hole])               ::  partner to notify
                  pus=(unit ,@ta)                           ::  password
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sign`

                    ++  sign  |=([a=@ b=@] _@)              ::  certify as us

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sure`

                    ++  sure  |=([a=@ b=@] *(unit ,@))      ::  authenticate from us

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tear`

                    ++  tear  |=  [a=pass b=@]              ::  accept from a 
                              *(unit ,[p=@ q=@])            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++de`

              ++  de  |+([a=@ b=@] *(unit ,@))              ::  symmetric de, soft

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++dy`

              ++  dy  |+([a=@ b=@] _@)                      ::  symmetric de, hard

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++en`

              ++  en  |+([a=@ b=@] _@)                      ::  symmetric en

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++ex`

              ++  ex  ^?                                    ::  export
                |%  ++  fig  _@uvH                          ::  fingerprint

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++fig`


    XX document

    Accepts
    -------

    Produces
    --------

    Source
    ------

    Examples
    --------

    ###++pac

    ```
                    ++  pac  _@uvG                          ::  default passcode
    ```

    XX document

    Accepts
    -------

    Produces
    --------

    Source
    ------

    Examples
    --------

    ###++pub

    ```
                    ++  pub  *pass                          ::  public key
    ```

    XX document

    Accepts
    -------

    Produces
    --------

    Source
    ------

    Examples
    --------

    ###++sec

    ```
                    ++  sec  *ring                          ::  private key
    ```

    XX document

    Accepts
    -------

    Produces
    --------

    Source
    ------

    Examples
    --------

    ###++nu

    ```
              ++  nu  ^?                                    ::  reconstructors
                 |%  ++  pit  |=([a=@ b=@] ^?(..nu))        ::  from [width seed]
    ```

    XX document

    Accepts
    -------

    Produces
    --------

    Source
    ------

    Examples
    --------

    ###++pit

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++nol`

                     ++  nol  |=(a=@ ^?(..nu))              ::  from naked ring

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++com`

                     ++  com  |=(a=@ ^?(..nu))              ::  from naked pass

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++aeon`

    ++  aeon  ,@ud                                          ::

Clay revision number

### `++agon`

    ++  agon  (map ,[p=ship q=desk] ,[p=@ud q=@ud r=waks])  ::  mergepts

See %clay doc

    ~zod/main=> *agon
    {}

### `++ankh`

    ++  ankh                                                ::  fs node (new)
              $:  p=cash                                    ::  recursive hash
                  q=(unit ,[p=cash q=*])                    ::  file
                  r=(map ,@ta ankh)                         ::  folders
              ==                                            ::

State at path

See also ++ze, %clay documentation

### `++ankz`

    ++  ankz  ,[p=@ (map ,@ta ankz)]                        ::  trimmed ankh

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++apex`

    ++  apex  ,[p=@uvI q=(map ,@ta ,@uvI) r=(map ,@ta ,~)]  ::  node report (old)

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++ares`

    ++  ares  (unit ,[p=term q=(list tank)])                ::  possible error

Failure cause: unknown, or machine-readable term and stack trace.

    ~zod/main=> `ares`~
    ~
    ~zod/main=> `ares`[~ %syntax-error leaf/"[1 27]" ~]
    [~ [p=%syntax-error q=~[[%leaf p="[1 27]"]]]]
    ~zod/main=> 

### `++ball`

    ++  ball  ,@uw                                          ::  statement payload

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++bait`

    ++  bait  ,[p=skin q=@ud r=dove]                        ::  fmt nrecvd spec

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++bath`

    ++  bath                                                ::  convo per client
              $:  sop=shed                                  ::  not stalled
                  raz=(map path race)                       ::  statements inbound
                  ryl=(map path rill)                       ::  statements outbound
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++beam`

    ++  beam  ,[[p=ship q=desk r=case] s=path]              ::  global name

See section 2dF, %clay documentation

    ~zod/try=> (need (tome %/bin))
    [[p=~zod q=%try r=[%da p=~2014.11.3..17.30.07..ca8f]] s=/bin]

### `++beak`

    ++  beak  ,[p=ship q=desk r=case]                       ::  garnish with beak

Global root

### `++bird`

    ++  bird                                                ::  packet in travel
              $:  gom=soap                                  ::  message identity
                  mup=@ud                                   ::  pktno in msg
                  nux=@ud                                   ::  xmission count
                  lys=@da                                   ::  last sent
                  pac=rock                                  ::  packet data
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++blob`

    ++  blob  $%  [%delta p=lobe q=lobe r=udon]             ::  delta on q
                  [%direct p=lobe q=* r=umph]               ::
                  [%indirect p=lobe q=* r=udon s=lobe]      ::
              ==                                            ::

Stored data, see ++ze

### `++boat`

    ++  boat  ,[(list slip) tart]                           ::  user stage

XX deprecated

### `++boon`

    ++  boon                                                ::  fort output
              $%  [%beer p=ship q=@uvG]                     ::  gained ownership
                  [%cake p=sock q=soap r=coop s=duct]       ::  e2e message result
                  [%coke p=sock q=soap r=cape s=duct]       ::  message result
                  [%mead p=lane q=rock]                     ::  accept packet
                  [%milk p=sock q=soap r=*]                 ::  accept message
                  [%mulk p=sock q=soap r=*]                 ::  e2e pass message
                  [%ouzo p=lane q=rock]                     ::  transmit packet
                  [%wine p=sock q=tape]                     ::  notify user
              ==                                            ::

See %ford documentation

### `++bowl`

    ++  bowl  ,[p=(list gift) q=(unit boat)]                ::  app product

XX deprecated

### `++bray`

    ++  bray  ,[p=life q=(unit life) r=ship s=@da]          ::  our parent us now

Ship identity. See %ames documentation

### `++brow`

    ++  brow  ,[p=@da q=@tas]                               ::  browser version

XX unused?

### `++buck`

    ++  buck  ,[p=mace q=will]                              ::  all security data

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cake`

    ++  cake  ,[p=sock q=skin r=@]                          ::  top level packet

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cape`

    ++  cape                                                ::  end-to-end result
              $?  %good                                     ::  delivered
                  %dead                                     ::  rejected
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cart`

    ++  cart  ,[p=cash q=cash]                              ::  hash change

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++care`

    ++  care  ?(%u %v %w %x %y %z)                          ::  clay submode

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++case`

    ++  case                                                ::  ship desk case spur
              $%  [%da p=@da]                               ::  date
                  [%tas p=@tas]                             ::  label
                  [%ud p=@ud]                               ::  number
              ==                                            ::

Access by absolute date, term label, or revision number. See %clay
documentation

### `++cash`

    ++  cash  ,@uvH                                         ::  ankh hash

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++chum`

    ++  chum  ,@uvI                                         ::  hashed passcode

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++clot`

    ++  clot                                                ::  symmetric record
              $:  yed=(unit ,[p=hand q=code])               ::  outbound
                  heg=(map hand code)                       ::  proposed
                  qim=(map hand code)                       ::  inbound
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++coal`

    ++  coal  ,*                                            ::  untyped vase

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++code`

    ++  code  ,@uvI                                         ::  symmetric key

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cone`

    ++  cone                                                ::  reconfiguration
              $%  [& p=twig]                                ::  transform
                  [| p=(list ,@tas)]                        ::  alter
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++chum`

    ++  chum  ,@uvI                                         ::  hashed passcode

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++claw`

    ++  claw                                                ::  startup chain
              $:  joy=(unit coal)                           ::  local context
                  ran=(unit coal)                           ::  arguments
                  pux=(unit path)                           ::  execution path
                  jiv=(unit coal)                           ::  app configuration
                  kyq=(unit coal)                           ::  app customization
                  gam=(unit coal)                           ::  app image
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++clip`

    ++  clip  (each ,@if ,@is)                              ::  client IP

See %eyre documentation.

    ~zod/try=> `clip`[%& .127.0.0.1]
    [%.y p=.127.0.0.1]
    ~zod/try=> `clip`[%| .12.0.0.0.342d.d24d.0.0]
    [%.n p=.12.0.0.0.342d.d24d.0.0]
    ~zod/try=> `clip`[%| .0.0.0.1]
    ! type-fail
    ! exit

### `++coal`

    ++  coal  ,*                                            ::  untyped vase

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++code`

    ++  code  ,@uvI                                         ::  symmetric key

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cone`

    ++  cone                                                ::  reconfiguration
              $%  [& p=twig]                                ::  transform
                  [| p=(list ,@tas)]                        ::  alter
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++coop`

    ++  coop  (unit ares)                                   ::  e2e ack

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++corn`

    ++  corn                                                ::  flow by server
              $:  hen=duct                                  ::  admin channel
                  nys=(map flap bait)                       ::  packets incoming
                  olz=(map flap cape)                       ::  packets completed
                  wab=(map ship bath)                       ::  relationship
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cred`

    ++  cred                                                ::  credential
              $:  hut=hoot                                  ::  client host
                  aut=(jug ,@tas ,@t)                       ::  client identities
                  orx=oryx                                  ::  CSRF secret
                  acl=(unit ,@t)                            ::  accept-language
                  cip=(each ,@if ,@is)                      ::  client IP
                  cum=(map ,@tas ,*)                        ::  custom dirt
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++cuff`

    ++  cuff                                                ::  permissions
              $:  p=(unit (set monk))                       ::  readers
                  q=(set monk)                              ::  authors
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++deed`

    ++  deed  ,[p=@ q=step r=?]                             ::  sig, stage, fake?

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++dome`

    ++  dome                                                ::  project state
              $:  ang=agon                                  ::  pedigree
                  ank=ankh                                  ::  state
                  let=@ud                                   ::  top id
                  hit=(map ,@ud tako)                       ::  changes by id
                  lab=(map ,@tas ,@ud)                      ::  labels
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++dore`

    ++  dore                                                ::  foreign contact
              $:  wod=road                                  ::  connection to
                  wyl=will                                  ::  inferred mirror
                  caq=clot                                  ::  symmetric key state
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++dove`

    ++  dove  ,[p=@ud q=(map ,@ud ,@)]                      ::  count hash 13-blocks

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++epic`

    ++  epic                                                ::  FCGI parameters
              $:  qix=(map ,@t ,@t)                         ::  query
                  ced=cred                                  ::  client credentials
                  bem=beam                                  ::  original path
                  but=path                                  ::  ending
                  nyp=path                                  ::  request model
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++flap`

    ++  flap  ,@uvH                                         ::  network packet id

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++flow`

    ++  flow                                                ::  packet connection
              $:  rtt=@dr                                   ::  decaying avg rtt
                  wid=@ud                                   ::  logical wdow msgs
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++fort`

    ++  fort                                                ::  formal state
              $:  %0                                        ::  version
                  gad=duct                                  ::  client interface
                  hop=@da                                   ::  network boot date
                  ton=town                                  ::  security
                  zac=(map ship corn)                       ::  flows by server
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++frog`

    ++  frog  ,[p=@da q=nori]                               ::  time and change

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++gank`

    ++  gank  (each vase (list tank))                       ::  abstract result

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++gift`

    ++  gift                                                ::  one-way effect
              $%  [%$ p=vase]                               ::  trivial output
                  [%cc p=(unit case)]                       ::  change case
                  [%ck p=@tas]                              ::  change desk
                  [%cs p=path]                              ::  change spur
                  [%de p=@ud q=tank]                        ::  debug/level
                  [%ex p=(unit vase) q=lath]                ::  exec/patch
                ::[%fd p=vase]                              ::  fundamental down
                ::[%fo p=vase]                              ::  fundamental forward
                ::[%fu p=vase]                              ::  fundamental up
                  [%ha p=tank]                              ::  single error
                  [%ho p=(list tank)]                       ::  multiple error
                  [%la p=tank]                              ::  single statement
                  [%lo p=(list tank)]                       ::  multiple statement
                  [%mu p=type q=(list)]                     ::  batch emit
                  [%mx p=(list gift)]                       ::  batch gift
                  [%ok p=@ta q=nori]                        ::  save changes
                  [%og p=@ta q=mizu]                        ::  save direct
                  [%sc p=(unit skit)]                       ::  stack library
                  [%sp p=(list lark)]                       ::  spawn task(s)
                  [%sq p=ship q=@tas r=path s=*]            ::  send request
                  [%sr p=ship q=path r=*]                   ::  send response
                  [%te p=(list ,@t)]                        ::  dump lines
                  [%th p=@ud q=love]                        ::  http response
                  [%tq p=path q=hiss]                       ::  http request
                  [%va p=@tas q=(unit vase)]                ::  set/clear variable
                  [%xx p=curd]                              ::  return card
                  [%xy p=path q=curd]                       ::  push card
                  [%xz p=[p=ship q=term] q=ship r=mark s=zang]
                  [%zz p=path q=path r=curd]                ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++zang`

    ++  zang                                                ::  XX evil hack
              $%  [%backlog p=path q=?(%da %dr %ud) r=@]    ::
                  [%hola p=path]                            ::
                  $:  %mess  p=path                         ::
                    $=  q                                   ::
                  $%  [%do p=@t]                            ::  act
                      [%exp p=@t q=tank]                    ::  code
                      [%say p=@t]                           ::  speak
                  ==  ==                                    ::
                  [%tint p=ship]                            ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++gilt`

    ++  gilt  ,[@tas *]                                     ::  presumed gift

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++gens`

    ++  gens  ,[p=lang q=gcos]                              ::  general identity

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++germ`

    ++  germ  ?(%init %fine %that %this %mate %meld)        ::  merge style

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++gcos`

    ++  gcos                                                ::  id description
              $%  [%czar ~]                                 ::  8-bit ship
                  [%duke p=what]                            ::  32-bit ship
                  [%earl p=@t]                              ::  64-bit ship
                  [%king p=@t]                              ::  16-bit ship
                  [%pawn p=(unit ,@t)]                      ::  128-bit ship
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++goad`

    ++  goad                                                ::  common note
              $%  [%eg p=riot]                              ::  simple result
                  [%gr p=mark q=*]                          ::  gall rush/rust
                  [%hp p=httr]                              ::  http response
                  ::  [%ht p=@ud q=scab r=cred s=moth]          ::  http request
                  [%it p=~]                                 ::  interrupt event
                  [%lq p=ship q=path r=*]                   ::  client request
                  [%ly p=newt q=tape]                       ::  lifecycle event
                  [%ow p=cape]                              ::  one-way reaction
                  [%rt p=(unit)]                            ::  roundtrip response
                  [%up p=@t]                                ::  prompt response
                  [%wa ~]                                   ::  alarm
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++goal`

    ++  goal                                                ::  app request
              $%  [%$ p=type]                               ::  open for input
                  [%do p=vase q=vase]                       ::  call gate sample
                  [%eg p=kite]                              ::  single request
                  [%es p=ship q=desk r=rave]                ::  subscription
                  [%gr ~]                                   ::  gall response
                  [%ht p=(list rout)]                       ::  http server
                  [%hp ~]                                   ::  http response
                  [%lq p=@tas]                              ::  listen for service
                  [%ow ~]                                   ::  one-way reaction
                  [%rt ~]                                   ::  roundtrip response
                  [%up p=prod]                              ::  user prompt
                  [%wa p=@da]                               ::  alarm
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++govt`

    ++  govt  path                                          ::  country/postcode

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hand`

    ++  hand  ,@uvH                                         ::  hash of code

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hart`

    ++  hart  ,[p=? q=(unit ,@ud) r=host]                   ::  http sec/port/host

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hate`

    ++  hate  ,[p=purl q=@p r=moth]                         ::  semi-cooked request

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++heir`

    ++  heir  ,[p=@ud q=mess r=(unit love)]                 ::  status/headers/data

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hiss`

    ++  hiss  ,[p=purl q=moth]                              ::  outbound request

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hist`

    ++  hist  ,[p=@ud q=(list ,@t)]                         ::  depth texts

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hole`

    ++  hole  ,@t                                           ::  session identity

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hoot`

    ++  hoot  ,[p=? q=(unit ,@ud) r=host]                   ::  secure/port/host

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++hort`

    ++  hort  ,[p=(unit ,@ud) q=host]                       ::  http port/host

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++host`

    ++  host  $%([& p=(list ,@t)] [| p=@if])                ::  http host

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++httq`

    ++  httq                                                ::  raw http request
              $:  p=meth                                    ::  method
                  q=@t                                      ::  unparsed url
                  r=(list ,[p=@t q=@t])                     ::  headers
                  s=(unit octs)                             ::  body
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++httr`

    ++  httr  ,[p=@ud q=mess r=(unit octs)]                 ::  raw http response

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++httx`

    ++  httx                                                ::  encapsulated http
              $:  p=?                                       ::  https?
                  q=clip                                    ::  source IP
                  r=httq                                    ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++kite`

    ++  kite  ,[p=care q=case r=ship s=desk t=spur]         ::  parsed global name

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++json`

    ++  json                                                ::  normal json value
              $|  ~                                         ::  null
              $%  [%a p=(list json)]                        ::  array
                  [%b p=?]                                  ::  boolean
                  [%o p=(map ,@t json)]                     ::  object
                  [%n p=@ta]                                ::  number
                  [%s p=@ta]                                ::  string
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++jsot`

    ++  jsot                                                ::  strict json top
              $%  [%a p=(list json)]                        ::  array
                  [%o p=(map ,@t json)]                     ::  object
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lamb`

    ++  lamb                                                ::  short path
              $%  [& p=@tas]                                ::  auto
                  [| p=twig]                                ::  manual
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lane`

    ++  lane                                                ::  packet route
              $%  [%if p=@da q=@ud r=@if]                   ::  IP4/public UDP/addr
                  [%is p=@ud q=(unit lane) r=@is]           ::  IPv6 w/alternates
                  [%ix p=@da q=@ud r=@if]                   ::  IPv4 provisional
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lang`

    ++  lang  ,@ta                                          ::  IETF lang as code

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lark`

    ++  lark  ,[p=(unit ,@tas) q=lawn]                      ::  parsed command

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lass`

    ++  lass  ?(%0 %1 %2)                                   ::  power increment

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lath`

    ++  lath  $%                                            ::  pipeline stage
                  [%0 p=lass q=lamb r=(list cone) s=twig]   ::  command
                  [%1 p=twig]                               ::  generator
                  [%2 p=twig]                               ::  filter
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lawn`

    ++  lawn  (list lath)                                   ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lice`

    ++  lice  ,[p=ship q=buck]                              ::  full license

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++life`

    ++  life  ,@ud                                          ::  regime number

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lint`

    ++  lint  (list rock)                                   ::  fragment array

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++lobe`

    ++  lobe  ,@                                            ::  blob ref

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++love`

    ++  love  $%                                            ::  http response
                  [%ham p=manx]                             ::  html node
                  [%mid p=mite q=octs]                      ::  mime-typed data
                  [%raw p=httr]                             ::  raw http response
                  [%wan p=wain]                             ::  text lines
                  [%zap p=@ud q=(list tank)]                ::  status/error
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++luge`

    ++  luge  ,[p=mark q=*]                                 ::  fully typed content

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++maki`

    ++  maki  ,[p=@ta q=@ta r=@ta s=path]                   ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++mace`

    ++  mace  (list ,[p=life q=ring])                       ::  private secrets

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++marv`

    ++  marv  ?(%da %tas %ud)                               ::  release form

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++math`

    ++  math  (map ,@t (list ,@t))                          ::  semiparsed headers

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++meal`

    ++  meal                                                ::  payload
              $%  [%back p=cape q=flap r=@dr]               ::  acknowledgment
                  [%buck p=coop q=flap r=@dr]               ::  e2e ack
                  [%bond p=life q=path r=@ud s=*]           ::  message
                  [%bund p=life q=path r=@ud s=*]           ::  e2e message
                  [%carp p=@ q=@ud r=@ud s=flap t=@]        ::  skin/inx/cnt/hash
                  [%fore p=ship q=(unit lane) r=@]          ::  forwarded packet
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++mess`

    ++  mess  (list ,[p=@t q=@t])                           ::  raw http headers

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++meta`

    ++  meta                                                ::  path metadata
              $%  [& q=@uvI]                                ::  hash
                  [| q=(list ,@ta)]                         ::  dir
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++meth`

    ++  meth                                                ::  http methods
              $?  %conn                                     ::  CONNECT
                  %delt                                     ::  DELETE
                  %get                                      ::  GET
                  %head                                     ::  HEAD
                  %opts                                     ::  OPTIONS
                  %post                                     ::  POST
                  %put                                      ::  PUT
                  %trac                                     ::  TRACE
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++mite`

    ++  mite  (list ,@ta)                                   ::  mime type

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++miso`

    ++  miso                                                ::  ankh delta
              $%  [%del p=*]                                ::  delete
                  [%ins p=*]                                ::  insert
                  [%mut p=udon]                             ::  mutate
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++mizu`

    ++  mizu  ,[p=@u q=(map ,@ud tako) r=rang]              ::  new state

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++moar`

    ++  moar  ,[p=@ud q=@ud]                                ::  normal change range

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++moat`

    ++  moat  ,[p=case q=case r=path]                       ::  change range

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++mood`

    ++  mood  ,[p=care q=case r=path]                       ::  request in desk

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++moth`

    ++  moth  ,[p=meth q=math r=(unit octs)]                ::  http operation

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++name`

    ++  name  ,[p=@t q=(unit ,@t) r=(unit ,@t) s=@t]        ::  first mid/nick last

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++newt`

    ++  newt  ?(%boot %kick %mess %slay %wake)              ::  lifecycle events

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++nose`

    ++  nose                                                ::  response, kernel
              $?  [%$ p=(unit ,[p=tutu q=(list)])]          ::  standard input
                  goad                                      ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++note`

    ++  note                                                ::  response, user
              $?  [%$ p=(unit ,[p=type q=(list)])]          ::  standard input
                  [%do p=vase]                              ::  execution result
                  goad                                      ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++nori`

    ++  nori                                                ::  repository action
              $%  [& q=soba]                                ::  delta
                  [| p=@tas]                                ::  label
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++octs`

    ++  octs  ,[p=@ud q=@]                                  ::  octet-stream

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++oryx`

    ++  oryx  ,@t                                           ::  CSRF secret

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++pact`

    ++  pact  path                                          ::  routed path

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++pail`

    ++  pail  ?(%none %warm %cold)                          ::  connection status

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++plan`

    ++  plan  (trel view (pair ,@da (unit ,@dr)) path)      ::  subscription

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++plea`

    ++  plea  ,[p=@ud q=[p=? q=@t]]                         ::  live prompt

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++pork`

    ++  pork  ,[p=(unit ,@ta) q=(list ,@t)]                 ::  fully parsed url

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++pred`

    ++  pred  ,[p=@ta q=@tas r=@ta ~]                       ::  proto-path

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++prod`

    ++  prod  ,[p=prom q=tape r=tape]                       ::  prompt

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++prom`

    ++  prom  ?(%text %pass %none)                          ::  format type

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++purl`

    ++  purl  ,[p=hart q=pork r=quay]                       ::  parsed url

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++putt`

    ++  putt                                                ::  outgoing message
              $:  ski=snow                                  ::  sequence acked/sent
                  wyv=(list rock)                           ::  packet list XX gear
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++pyre`

    ++  pyre                                                ::  cascade stash
              $:  p=(map ,[p=path q=path r=coal] coal)      ::  by path
                  q=(map ,[p=path q=@uvI r=coal] coal)      ::  by source hash
                  r=(map ,[p=* q=coal] coal)                ::  by (soft) twig
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++quay`

    ++  quay  (list ,[p=@t q=@t])                           ::  parsed url query

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++quri`

    ++  quri                                                ::  request-uri
              $%  [& p=purl]                                ::  absolute
                  [| p=pork q=quay]                         ::  relative
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++race`

    ++  race                                                ::  inbound stream
              $:  did=@ud                                   ::  filled sequence
                  dod=?                                     ::  not processing
                  bum=(map ,@ud ares)                       ::  nacks
                  mis=(map ,@ud ,[p=cape q=lane r=flap s=(unit)]) ::  misordered
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rank`

    ++  rank  ?(%czar %king %duke %earl %pawn)              ::  ship width class

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rang`

    ++  rang  $:  hut=(map tako yaki)                       ::
                  lat=(map lobe blob)                       ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rant`

    ++  rant                                                ::  namespace binding
              $:  p=[p=care q=case r=@tas]                  ::  clade release book
                  q=path                                    ::  spur
                  r=*                                       ::  data
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rave`

    ++  rave                                                ::  general request
              $%  [& p=mood]                                ::  single request
                  [| p=moat]                                ::  change range
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rill`

    ++  rill                                                ::  outbound stream
              $:  sed=@ud                                   ::  sent
                  san=(map ,@ud duct)                       ::  outstanding
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++riot`

    ++  riot  (unit rant)                                   ::  response/complete

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++road`

    ++  road                                                ::  secured oneway route
              $:  exp=@da                                   ::  expiration date
                  lun=(unit lane)                           ::  route to friend
                  lew=will                                  ::  will of friend
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rock`

    ++  rock  ,@uvO                                         ::  packet

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rout`

    ++  rout  ,[p=(list host) q=path r=oryx s=path]         ::  http route (new)

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++rump`

    ++  rump  ,[p=care q=case r=@tas s=path]                ::  relative path

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++saba`

    ++  saba  ,[p=ship q=@tas r=moar s=dome]                ::  patch/merge

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sack`

    ++  sack  ,[p=ship q=ship]                              ::  incoming [our his]

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sufi`

    ++  sufi                                                ::  domestic host
              $:  hoy=(list ship)                           ::  hierarchy
                  val=wund                                  ::  private keys
                  law=will                                  ::  server will
                  seh=(map hand ,[p=ship q=@da])            ::  key cache
                  hoc=(map ship dore)                       ::  neighborhood
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++salt`

    ++  salt  ,@uv                                          ::  entropy

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++seal`

    ++  seal                                                ::  auth conversation
              $:  whu=(unit ship)                           ::  client identity
                  pul=purl                                  ::  destination url
                  wit=?                                     ::  wait for partner
                  foy=(unit ,[p=ship q=hole])               ::  partner to notify
                  pus=(unit ,@ta)                           ::  password
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sect`

    ++  sect  ?(%black %blue %red %orange %white)           ::  banner

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++shed`

    ++  shed                                                ::  packet flow
              $:  $:  rtt=@dr                               ::  smoothed rtt
                      rto=@dr                               ::  retransmit timeout
                      rtn=(unit ,@da)                       ::  next timeout
                      rue=(unit ,@da)                       ::  last heard from
                  ==                                        ::
                  $:  nus=@ud                               ::  number sent
                      nif=@ud                               ::  number live
                      nep=@ud                               ::  next expected
                      caw=@ud                               ::  logical window
                      cag=@ud                               ::  congest thresh
                  ==                                        ::
                  $:  diq=(map flap ,@ud)                   ::  packets sent
                      pyz=(map soup ,@ud)                   ::  message/unacked
                      puq=(qeu ,[p=@ud q=soul])             ::  packet queue
                  ==                                        ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++skit`

    ++  skit  ,[p=(unit ,@ta) q=(list ,@ta) r=(list ,@ta)]  ::  tracking path

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++skin`

    ++  skin  ?(%none %open %fast %full)                    ::  encoding stem

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++slip`

    ++  slip  ,[p=path q=goal]                              ::  traceable request

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++snow`

    ++  snow  ,[p=@ud q=@ud r=(set ,@ud)]                   ::  window exceptions

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++soap`

    ++  soap  ,[p=[p=life q=life] q=path r=@ud]             ::  statement id

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++soup`

    ++  soup  ,[p=path q=@ud]                               ::  new statement id

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++soul`

    ++  soul                                                ::  packet in travel
              $:  gom=soup                                  ::  message identity
                  nux=@ud                                   ::  xmission count
                  liv=?                                     ::  deemed live
                  lys=@da                                   ::  last sent
                  pac=rock                                  ::  packet data
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++soba`

    ++  soba  ,[p=cart q=(list ,[p=path q=miso])]           ::  delta

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++sock`

    ++  sock  ,[p=ship q=ship]                              ::  outgoing [from to]

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++spur`

    ++  spur  path                                          ::  ship desk case spur

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++step`

    ++  step  ,[p=bray q=gens r=pass]                       ::  identity stage

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tako`

    ++  tako  ,@                                            ::  yaki ref

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tart`

    ++  tart  $+([@da path note] bowl)                      ::  process core

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++taxi`

    ++  taxi  ,[p=lane q=rock]                              ::  routed packet

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tick`

    ++  tick  ,@ud                                          ::  process id

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++toro`

    ++  toro  ,[p=@ta q=nori]                               ::  general change

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++town`

    ++  town                                                ::  all security state
              $:  lit=@ud                                   ::  imperial modulus
                  any=@                                     ::  entropy
                  urb=(map ship sufi)                       ::  all keys and routes
                  fak=?                                     ::
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tube`

    ++  tube  ,[p=@ta q=@ta r=@ta s=path]                   ::  canonical path

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++tutu`

    ++  tutu  ,*                                            ::  presumed type

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++yaki`

    ++  yaki  ,[p=(list tako) q=(map path lobe) r=tako t=@da] ::  commit

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++view`

    ++  view  ?(%u %v %w %x %y %z)                          ::  view mode

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++waks`

    ++  waks  (map path woof)                               ::  list file states

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++what`

    ++  what                                                ::  logical identity
              $%  [%anon ~]                                 ::  anonymous
                  [%lady p=whom]                            ::  female person ()
                  [%lord p=whom]                            ::  male person []
                  [%punk p=sect q=@t]                       ::  opaque handle ""
              ==                                            ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++whom`

    ++  whom  ,[p=@ud q=govt r=sect s=name]                 ::  year/govt/id

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++woof`

    ++  woof  $|  %know                                     ::  udon transform
                  [%chan (list $|(@ud [p=@ud q=@ud]))]      ::

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++wund`

    ++  wund  (list ,[p=life q=ring r=acru])                ::  mace in action

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++will`

    ++  will  (list deed)                                   ::  certificate

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++worm`

    ++  worm  ,*                                            ::  vase of tart

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------

### `++zuse`

    ++  zuse  %314                                          ::  hoon/zuse kelvin
    --

XX document

Accepts
-------

Produces
--------

Source
------

Examples
--------
