---
navhome: /docs/
sort: 17
title: Examples
next: true
---

# Examples

Now we know enough to write two quick examples: the Sieve of
Eratosthenes (a naive prime sieve) and a tic-tac-toe engine.

(Note that these are not examples of perfect Hoon code; they are
meant for teaching.  They err, more than usual for Hoon, on the
side of simple manual construction over high-octane FP.)

## `sieve`: code in basic style

A function that produces the list of primes less than or equal to
its argument, an atom:
```
:gate  thru/atom                                        ::  1
:cast  (list atom)                                      ::  2
:var   field/(set atom)  (silt (gulf 2 thru))           ::  3
:rap   abet:main                                        ::  4
:core                                                   ::  5
++  abet                                                ::  6
  (sort (~(tap in field) ~) lth)                        ::  7
::                                                      ::  8
++  main                                                ::  9
  :var   factor/atom  2                                 ::  10
  :loop  :like  ..main                                  ::  11
  :if    (gth (mul factor factor) thru)                 ::  12
    ..main                                              ::  13
  :moar(factor +(factor), ..main (reap factor))         ::  14
::                                                      ::  15
++  reap                                                ::  16
  :gate  factor/atom                                    ::  17
  :var   count/atom  (mul 2 factor)                     ::  18
  :loop  :like  ..reap                                  ::  19
  :if    (gth count thru)                               ::  20
    ..reap                                              ::  21
  :moar                                                 ::  22
    count  (add count factor)                           ::  23
    field  (~(del in field) count)                      ::  24
  ==                                                    ::  25
--                                                      ::  26
```

## `sieve`: explanation

```
:gate  thru/atom                                        ::  1
:cast  (list atom)                                      ::  2
:var   field/(set atom)  (silt (gulf 2 thru))           ::  3
```

Line `1`: we are building a gate (function) whose sample
(argument) is `thru`, an atom.

Line `2`: the product of this gate is a list of atoms.

Line `3`: we introduce a variable `field`, whose type is a set of
atoms.  The `silt` function converts a list to a set.  The `gulf`
function creates the range `2` through `thru` inclusive, as a
list of atoms.

Line `4`: below, we introduce a core which does our work.  With
reverse flow, we compute `main` on this core, then `abet` on the
product of `main`.  (`abet:main` means `:rap(abet main)`.)

The core is a state machine; `main` produces the core itself,
with the computation completed.  `abet` then extracts the result.

```
:core                                                   ::  5
++  abet                                                ::  6
  (sort (~(tap in field) ~) lth)                        ::  7
```

Line `5`: we wrap a core around our existing subject.  The
`field` and `thru` atoms are within the payload and of course
remain accessible.

Lines `6` and `7`: the `abet` arm, which produces the field as a
sorted list.  `in` is the set core; `tap` is an arm which
produces a gate that exports the set as a list, prepending it to
a tail which is nil in this case (and most cases).  We sort this
list in ascending order with `lth` (less-than).

```
++  main                                                ::  9
  :var   factor/atom  2                                 ::  10
  :loop  :like  ..main                                  ::  11
```

Line `9`: the `main` arm, which performs the main calculation.

Line `10`: we declare a counter, `factor`, which will iterate
up through the factors we're removing.

Line `11`: we start a loop.  The product of the loop is cast to
`..main`, which is the core we're in (`+1.main`).

```
  :if    (gth (mul factor factor) thru)                 ::  12
    ..main                                              ::  13
  :moar(factor +(factor), ..main (reap factor))         ::  14
```

Lines `12` and `13`: we terminate the loop, returning `..main`,
if the square of the counter exceeds the range.

Line `14`: repeats the loop, incrementing the counter, and
replacing the core with a version sieved by `reap`.

```
++  reap                                                ::  16
  :gate  factor/atom                                    ::  17
  :var   count/atom  (mul 2 factor)                     ::  18
```

Lines `16` and `17`: the `reap` arm, which produces a gate that
removes multiples of a factor from the field (set of possible
primes).  The  sample of this gate is the factor to remove.

Line `18`: we declare a variable `count`, an atom, with the
initial value `(mul 2 factor)`.

```
  :loop  :like  ..reap                                  ::  19
  :if    (gth count thru)                               ::  20
    ..reap                                              ::  21
  :moar                                                 ::  22
    count  (add count factor)                           ::  23
    field  (~(del in field) count)                      ::  24
  ==                                                    ::  25
--                                                      ::  26
```

Line `19`: we enter a loop.  This loop produces the core itself.

Lines `20` and `21`: we are done if the counter is out of range.

Lines `22` to `25`: repeat the loop, stepping `count` to the next
multiple of `factor`, and deleting it from `field`.

## `sieve`: code in kernel style

Finally, the same code transliterated into runes (and in a more
concise "kernel" style).

```
|=  top/@
^-  (list @)
=+  fed=(silt (gulf 2 top))
=<  abet:main
|%
++  abet  (sort (~(tap in fed)) lth)
++  main
  =+  fac=2
  |-  ^+  ..main
  ?:  (gth (mul fac fac) top)
    ..main
  $(fac +(fac), ..main (reap fac))
::
++  reap
  |=  fac/atom
  =+  cot=(mul 2 fac)
  |-  ^+  ..reap
  ?:  (gth cot top)
    ..reap
  $(cot (add cot fac), fed (~(del in fed) cot))
--
```

### `toe`: tic-tac-toe engine

The `toe` tic-tac-toe engine applies a list of events to a game
state, producing a list of game actions.  Events are tic-tac-toe
moves (`move)`; actions are tic-tac-toe results (`fact`).

```
:rap  :gate  feed/(list move)                           ::  1
      :new   game/game                                  ::  2
      :loop  :cast  (list fact)                         ::  3
      :ifno  feed  ~                                    ::  4
      :sip  this/(unit fact)                            ::  5
          game                                          ::  6
        (~(do go game) i.feed)                          ::  7
      :var   rest/(list fact)  :moar(feed t.feed)       ::  8
      :ifno(this rest [u.this rest])                    ::  9
::                                                      ::  10
:per  :core                                             ::  11
      ++  side   atom                                   ::  12
      ++  spot   {x/atom y/atom}                        ::  13
      ++  fact   :book  {$tie $~}                       ::  14
                        {$win p/cord}                   ::  15
                 ==                                     ::  16
      ++  move   :book  {$x p/spot}                     ::  17
                        {$o p/spot}                     ::  18
                        {$z $~}                         ::  19
                 ==                                     ::  20
      ++  game   :bank  w/?                             ::  21
                        a/side                          ::  22
                        z/side                          ::  23
                 ==                                     ::  24
      --                                                ::  25
:core                                                   ::  26
++  bo                                                  ::  27
  :door   half/side                                     ::  28
  ++  bit  :gate(a/atom =(1 (cut 0 [a 1] half)))        ::  29
  ++  off  :gate(a/spot (add x.a (mul 3 y.a)))          ::  30
  ++  get  :gate(a/spot (bit (off a)))                  ::  31
  ++  set  :gate(a/spot (con half (bex (off a))))       ::  32
  ++  win  :calt  lien                                  ::  33
             (rip 4 0wl04h0.4A0Aw.4A00s.0e070)          ::  34
           :gate(a/atom =(a (dis a half)))              ::  35
  --                                                    ::  36
++  go                                                  ::  37
  :door  game/game                                      ::  38
  ++  do                                                ::  39
    :gate  act/move                                     ::  40
    :cast  {(unit fact) ^game}                          ::  41
    :case  act                                          ::  42
      {$x *}  :sure(w.game ~(mo on p.act))              ::  43
      {$o *}  :deny(w.game ~(mo on p.act))              ::  44
      {$z *}  [~ nu]                                    ::  45
    ==                                                  ::  46
  ::                                                    ::  47
  ++  nu  :like(game [& 0 0])                           ::  48
  ++  on                                                ::  49
    :door    here/spot                                  ::  50
    ++  is   :or  (~(get bo a.game) here)               ::  51
                  (~(get bo z.game) here)               ::  52
             ==                                         ::  53
    ++  mo   :cast  {(unit fact) ^game}                 ::  54
             :deny  is                                  ::  55
             :var   next/side  (~(set bo a.game) here)  ::  56
             :if    ~(win bo next)                      ::  57
                [[~ %win ?:(w.game %x %o)] nu]          ::  58
             [~ game(w !w.game, a z.game, z next)]      ::  59
    --                                                  ::  60
  --                                                    ::  62
--                                                      ::  63
```

### `toe`: explanation

```
:rap  :gate  feed/(list move)                           ::  1
      :new   game/game                                  ::  2
      :loop  :cast  (list fact)                         ::  3
      :ifno  feed  ~                                    ::  4
```

Line `1` wraps a conclusion around a stack of cores.  The cores
at `11` and `26` are the data structures and functions of the
engine; the conclusion is the interface and top-level logic.  It
produces a gate whose sample is `feed`, a list of `move`.

Line `2` declares a blank new variable named `game`, whose type
is the `game` mold (tic-tac-toe game state) defined on line `21`.
Under line `2`, `game` pulls the variable and `^game` the mold.

Line `3` enters a loop producing a list of game events, `fact`.

Line `4` produces nil, `~`, if `feed` is empty.

```
      :sip  this/(unit fact)                            ::  5
          game                                          ::  6
        (~(do go game) i.feed)                          ::  7
```

Lines `5` through `7` apply the move.  We open a `go` core on the
current game state, produce a `do` gate, and call that gate on
the move.  The product of the `do` gate is a pair; the head is
`(unit fact)`, either `~` or `[~ fact]`; the tail is a new
`game`.  The `:sip` twig declares the head as a new variable,
`this`; it modifies the subject by setting `game` to the tail.

```
      :var   rest/(list fact)  :moar(feed t.feed)       ::  8
      :ifno(this rest [u.this rest])                    ::  9
```

Line `8` declares a new variable, `rest`, which is all the facts
generated by the moves in `t.feed`, the tail of the move list.
(Yes, this is gratuitous head recursion.)  Line `9` produces
`rest` if the `i.feed` move produced no fact; otherwise it
prepends the new fact to `rest`.

```
:per  :core                                             ::  11
      ++  side   atom                                   ::  12
      ++  spot   {x/atom y/atom}                        ::  13
```

Line `11` wraps a library core around a data structure core, a
common pattern.  (You could put the molds and the gates in the
same core, but the compiler couldn't constant-fold gate samples
that use these molds, an efficiency cost.)

Line `12` defines the `side` mold, an alias for `atom` (`@`).
A side is a half of the board, as a marked/unmarked bitfield.

Line `13` defines the `spot` mold, a 2D coordinate.

```
      ++  fact   :book  {$tie $~}                       ::  14
                        {$win p/cord}                   ::  15
                 ==                                     ::  16
```

Lines `14` to `16` define the `fact` mold, a game event (i.e.,
output action), as a book (tagged union).  There are two forms of
`fact`: `[%tie ~]` (reporting a tie), and `[%win cord]`
(reporting that `'X'` or `'O'` won a game.

```
      ++  move   :book  {$x p/spot}                     ::  17
                        {$o p/spot}                     ::  18
                        {$z $~}                         ::  19
                 ==                                     ::  20
```

Lines `17` to `20` define the `move` mold, a game move.  This is
either `[%x spot]`, `[%o spot]`, or `[%z ~]` to reset the board.

```
      ++  game   :bank  w/?                             ::  21
                        a/side                          ::  22
                        z/side                          ::  23
                 ==                                     ::  24
      --                                                ::  25
```

Lines `21` to `23` define the `game` mold, the game state.  This
is an `a` side, the next side to move; a `z` side, the other
side; and `w`, which is `&` (yes) if `a` is X and `b` is O; `|`
otherwise.  (Obviously, we swap `a` and `z` on every move.)

```
:core                                                   ::  26
++  bo                                                  ::  27
  :door   half/side                                     ::  28
  ++  bit  :gate(a/atom =(1 (cut 0 [a 1] half)))        ::  29
  ++  off  :gate(a/spot (add x.a (mul 3 y.a)))          ::  30
  ++  get  :gate(a/spot (bit (off a)))                  ::  31
  ++  set  :gate(a/spot (con half (bex (off a))))       ::  32
```

Line `26` introduces the library core, which contains the doors
`bo` (for `side` bitfields) and `go` (for game state).

Lines `27` to `28` begin the `bo` core, a door around `half`, a
board side.

Line `29` is the `bit` gate, which tests a bit in `half`.

Line `30` is the `off` gate, which maps from a `spot` (coordinate)
to a bit index.

Line `31` is the `get` gate, which produces the bit at a `spot`.

Line `32` is the `set` gate, which produces a new side with the
bit at a `spot` set.  It works by ORing (`con`) `half` with the
binary exponent (`bex`) of the offset (`off`) of the spot.

```
  ++  win  :calt  lien                                  ::  33
             (rip 4 0wl04h0.4A0Aw.4A00s.0e070)          ::  34
           :gate(a/atom =(a (dis a half)))              ::  35
  --                                                    ::  36
```

Lines `33` to `35` are a victory test.  It calls the
standard `lien` function, which iterates a boolean gate over a
list and produces `&` (yes) if any item tests as true, against a
list of magic bitfields (expanded from a base64 constant), each
of which must equal itself when ANDed (`dis`) with `half`.

```
++  go                                                  ::  37
  :door  game/game                                      ::  38
  ++  do                                                ::  39
    :gate  act/move                                     ::  40
    :cast  {(unit fact) ^game}                          ::  41
```

Lines `37` to `38` begin the `go` core, a door around a `game`.
Again we name the sample `game`.  (This is a legitimate style,
but not used much.)

Lines `40` to `42` begin the `do` gate, whose sample is `act`, a
move.  The product is cast to a pair of `(unit fact)` and a new
game state, written `^game` to skip to the second binding.

```
    :case  act                                          ::  42
      {$x *}  :sure(w.game ~(mo on p.act))              ::  43
      {$o *}  :deny(w.game ~(mo on p.act))              ::  44
      {$z *}  [~ nu]                                    ::  45
    ==                                                  ::  46
  ::                                                    ::  47
```

Lines `42` through `46` switch on the form of `act`.  If it's an
`%x` or `%o` move, we assert that it's the right turn, then use
the `mo` door to apply the move.  If it's a `%z` move, we clear
the board.

```
  ++  nu  :like(game [& 0 0])                           ::  48
  ++  on                                                ::  49
    :door    here/spot                                  ::  50
    ++  is   :or  (~(get bo a.game) here)               ::  51
                  (~(get bo z.game) here)               ::  52
             ==                                         ::  53
```

Line `48` is the `nu` arm, which produces a blank game state.

Lines `49` to `50` begin the `on` door, a door around `here`, a
`spot`.  Just as we have multiple computed attributes against the
game state, we have multiple computed attributes (`is` and `mo`)
against the combination of game state and coordinate.

Lines `51` to `53` define the `is` arm, which is `&` (yes) iff
either `a` or `z` has played `here`.

```
    ++  mo   :cast  {(unit fact) ^game}                 ::  54
             :deny  is                                  ::  55
             :var   next/side  (~(set bo a.game) here)  ::  56
             :if    ~(win bo next)                      ::  57
                [[~ %win ?:(w.game %x %o)] nu]          ::  58
             [~ game(w !w.game, a z.game, z next)]      ::  59
    --                                                  ::  60
  --                                                    ::  62
--                                                      ::  63
```

Line `54` begins the `mo` arm, which produces (with a
nonessential cast) a pair of `(unit fact)` and game state.
Again we see `^game` to pull the mold, since `game` is the
current game state in the `go` core.

Line `55` asserts that no one has yet played `here`.

Line `56` declares a variable `next`, as game side `a` with
`here` played in it.

Lines `57` and `58` test if `a` has won with this move.  If so,
we produce the win fact and a blank game state.

Line `59` produces no fact (since nothing has happened), but
inverts the `w` turn indicator, replaces side `a` with the other
side `z`, and replaces `z` with `next`.

### `toe`: code, kernel style

```
=<  |=  fed/(list move)
    =|  mag/game
    |-  ^-  (list fact)
    ?~  fed  ~
    =^  did/(unit fact)  mag  (~(do go mag) i.fed)
    =+  res=$(fed t.fed)
    ?~(did res [u.did res])
=>  |%
    ++  side  @
    ++  spot  {x/@ y/@}
    ++  fact  $%  {$tie $~}
                  {$win p/cord}
              ==
    ++  move  $%  {$x p/spot}
                  {$o p/spot}
                  {$z $~}
              ==
    ++  game  $:  w/?
                  a/side
                  z/side
              ==                                          
    --
|%
++  bo
  |_  haf/side
  ++  bit  |=(a/atom =(1 (cut 0 [a 1] haf)))
  ++  get  |=(a/spot (bit (off a)))
  ++  off  |=(a/spot (add x.a (mul 3 y.a)))
  ++  set  |=(a/spot (con haf (bex (off a))))
  ++  win  %+  lien
             (rip 4 0wl04h0.4A0Aw.4A00s.0e070)
           |=(a/atom =(a (dis a haf)))
  --
++  go
  |_  mag/game
  ++  do
    |=  act/move
    ^-  {(unit fact) game}
    ?-  act
      {$x *}  ?>(w.mag ~(mo on p.act))
      {$o *}  ?<(w.mag ~(mo on p.act))
      {$z *}  [~ nu]
    ==
  ::
  ++  nu  `game`[& 0 0]
  ++  on
    =|  her/spot
    |%
    ++  is   ?|  (~(get bo a.mag) her)
                 (~(get bo z.mag) her)
             ==
    ++  mo  ^-  {(unit fact) game}
            ?<  is
            =+  next=(~(set bo a.mag) her)
            ?:  ~(win bo next)
               [[~ %win ?:(w.mag %x %o)] nu]
            [~ mag(w !w.mag, a z.mag, z next)]
    --
  --
--
```

## Basic molds
```
++  atom  @                                             ::  just an atom
++  axis  @                                             ::  tree address
++  bean  ?                                             ::  0=&=yes, 1=|=no
++  bloq  @                                             ::  blockclass
++  char  @tD                                           ::  UTF-8 byte
++  cord  @t                                            ::  text atom (UTF-8)
++  gate  $-(* *)                                       ::  general gate
++  knot  @ta                                           ::  ASCII text
++  noun  *                                             ::  any noun
++  null  $~                                            ::  null, nil, etc
++  time  @da                                           ::  galactic time
++  path  (list knot)                                   ::  eg, fs location
++  tang  (list tank)                                   ::  error trace
++  tank                                                ::
          $%  {$leaf p/tape}                            ::  printing formats
              $:  $palm                                 ::  backstep list
                  p/{p/tape q/tape r/tape s/tape}       ::
                  q/(list tank)                         ::
              ==                                        ::
              $:  $rose                                 ::  flat list
                  p/{p/tape q/tape r/tape}              ::  mid open close
                  q/(list tank)                         ::
              ==                                        ::
          ==                                            ::
++  tanq                                                ::  future tank   
          $?  {$~ p/(list tanq)}                        ::  list of printables
              {$~ $~ p/tape}                            ::  simple string
              (pair @tas tanq)                          ::  captioned
          ==                                            ::
++  tape  (list char)                                   ::  string as list
++  term  @tas                                          ::  ascii symbol
++  wall  (list tape)                                   ::  text lines (no \n)
++  wain  (list cord)                                   ::  text lines (no \n)

::::
::::

++  tree  |*  a/gate                                 ::  binary tree
          $@($~ {n/a l/(tree a) r/(tree a)})            ::
++  trap  |*(a/_* _|?(*a))                              ::  makes perfect sense
++  trel  |*  {a/gate b/gate c/gate}           ::  just a triple
          {p/a q/b r/c}                                 ::
++  each  |*  {a/gate b/gate}                           ::  either a or b
          $%({$& p/a} {$| p/b})                         ::    a default

++  qual  |*  {a/gate b/gate c/gate d/gate} ::  just a quadruple
          {p/a q/b r/c s/d}                             ::
++  pair  |*({a/gate b/gate} {p/a q/b})           ::  just a pair
++  quid  |*({a/gate b/*} {a _b})                    ::  for =^
++  quip  |*({a/gate b/*} {(list a) _b})             ::  for =^
++  unit  |*  a/gate                                 ::  maybe
          $@($~ {$~ u/a})                               ::
++  list  |*  a/gate                                 ::  null-term list
          $@($~ {i/a t/(list a)})                       ::
++  lone  |*(a/gate p/a)                             ::  just one thing

::::
::::
++  map  |*  {a/gate b/gate}                      ::  associative tree
         $@($~ {n/{p/a q/b} l/(map a b) r/(map a b)})   ::
++  qeu  |*  a/gate                                     ::  queue
         $@($~ {n/a l/(qeu a) r/(qeu a)})               ::
++  set  |*  a/gate                                     ::  set
         $@($~ {n/a l/(set a) r/(set a)})               ::
++  jar  |*({a/gate b/gate} (map a (list b)))           ::  map of lists
++  jug  |*({a/gate b/gate} (map a (set b)))            ::  map of sets
```

###  Basic libraries
