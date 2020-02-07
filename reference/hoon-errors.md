+++
title = "Hoon Errors"
weight = 6
template = "doc.html"
+++

In this section we explore strategies for debugging and understanding what your
Hoon code is doing. We cover common errors that dojo may spit out, how to turn
on debugging and verbose mode, and how to use debugging printfs. We conclude with a [tutorial](#stack-trace-tutorial)
on how to understand the stack trace obtained when setting a simple timer app to
count one second.

## Syntax errors

When you get a syntax error, you'll see a message like

```
syntax error at [10 12]
```

This is a line and column number; more exactly, the line and
column of the first byte the parser couldn't interpret as part of
a correct Hoon file.  These values are always correct.

Usually, the line and column tell you everything you need to
know.  But the worst-case scenario for a syntax error is that,
somewhere above, you've confused Hoon's tall form by using the
wrong fanout for a rune.  For example, `%+` ([**cenlus**](@/docs/reference/hoon-expressions/rune/cen.md#cenlus),
a function call whose sample is a cell) has three subhoons:

```hoon
%+  foo
  bar
baz
```

But if you make a mistake and write

```hoon
%+  foo
bar
```

the parser will eat the next reference below and try to treat it as a
part of the `%+`.  This can cause a cascading error somewhere
below, usually stopped by a `==` or `--`.

When this happens, don't panic!  Binary search actually works
quite well.  Any reference can be stubbed out as `!!`.  Find the
prefix of your file that compiles, then work forward until
the actual error appears.

## Semantic errors

Now your code parses but doesn't compile.

### Turn on debugging or verbose mode

Your first step should be to put a `!:` ("zapcol") rune at the
top of the file.  This is like calling the C compiler with `-g`;
it tells the Hoon compiler to generate tracing references.

Bear in mind that `!:` breaks tail-call optimization.  This is a
bug, but a relatively low-priority bug.  `!.` turns off `!:`.
Note that `!:` and `!.` are reference-level, not file-level; you can
wrap any reference in either.

You may also find it helpful to turn on verbose mode by entering `|verb` into dojo, which prints (almost)
everything happening in the kernel to the console. This is useful for performing
stack trace. An extensive stack trace tutorial is [below](#stack-trace-tutorial).

### Error trace

If you have `!:` on, you'll see an error trace, like

```
/~zod/home/0/gen/hello:<[7 3].[11 21]>
/~zod/home/0/gen/hello:<[8 1].[11 21]>
/~zod/home/0/gen/hello:<[9 1].[11 21]>
/~zod/home/0/gen/hello:<[10 1].[11 21]>
/~zod/home/0/gen/hello:<[11 1].[11 21]>
/~zod/home/0/gen/hello:<[11 7].[11 21]>
nest-fail
```

The bottom of this trace is the line and column of the reference which
failed to compile, then the cause of the error (`nest-fail`).

Hoon does not believe in inundating you with possibly irrelevant
debugging information.  Your first resort is always to just look
at the code and try to figure out what's wrong.  This practice
strengthens your Hoon muscles.

(Consider the opposite extreme; imagine if you had a magic bot
that always fixed your compiler errors for you.  Pro: no time
wasted on compiler errors.  Con: you never learn Hoon.)

## Common errors

Moral fiber is all very well and good, but sometimes you're
stumped.  Couldn't the compiler help a little?  These messages do
mean something.  Here are the three most common:

### `nest-fail`

This is a type mismatch (`nest` is the Hoon typechecker).  It
means you tried to pound a square peg into a round hole.

What was the peg and what was the hole?  Hoon doesn't tell you by
default, because moral fiber, and also because in too many cases
trivial errors lead to large intimidating dumps.  However, you
can use the `~!` rune ([**sigzap**](@/docs/reference/hoon-expressions/rune/sig.md#sigzap)) to print the type of any hoon in your stack trace.

For instance, you wrote `(foo bar)` and got a `nest-fail`.  Change
your code to be:

```hoon
~!  bar
~!  +6.foo
(foo bar)
```

You'll get the same `nest-fail`, but this will show the type of
`bar`, then the type of the sample of the `foo` gate.

### `find.foo`

A `find.foo` error means limb `foo` wasn't found in the subject.
In other words, "undeclared variable."

The most common subspecies of `find` error is `find.$`, meaning
the empty name `$` was not found.  This often happens when you
use a reference that does not produce a gate/mold, as a gate/mold. For
instance, `(foo bar)` will give `find.$` if `foo` is not actually a
function.

### `mint-vain` and `mint-lost`

These are errors caused by type inference in pattern matching.
`mint-vain` means this hoon is never executed.  `mint-lost` means there's a case in a `?-` ([**wuthep**](@/docs/reference/hoon-expressions/rune/wut.md#wuthep)) that isn't handled.

## Runtime crashes

If your code crashes at runtime or overflows the stack, you'll
see a stack trace that looks just like the trace above.  Don't
confuse runtime crashes with compilation errors, though.

If your code goes into an infinite loop, kill it with `ctrl-c` (you'll
need to be developing on the local console; otherwise, the
infinite loop will time out either too slowly or too fast).  The
stack trace will show what your code was doing when interrupted.

The counterpart of `~!` for runtime crashes is `~|`
([**sigbar**](@/docs/reference/hoon-expressions/rune/sig.md#sigbar)):

```hoon
~|  foo
(foo bar)
```

If `(foo bar)` crashes, the value of `foo` is printed in the
stack trace.  Otherwise, the `~|` has no effect.

## Debugging printfs

The worst possibility, of course, is that your code runs but does
the wrong thing.  This is relatively unusual in a typed
functional language, but it still happens.

`~&` ([**sigpam**](@/docs/reference/hoon-expressions/rune/sig.md#sigpam)) is Hoon's debugging printf.
This pretty-prints its argument:

```hoon
~&  foo
(foo bar)
```

will always print `foo` every time it executes.  A variant is
`~?` ([**sigwut**](@/docs/reference/hoon-expressions/rune/sig.md#sigwut)), which prints only if a condition is
true:

```hoon
~?  =(37 (lent foo))  foo
(foo bar)
```

For now, you need to be on the local console to see these debug
printfs (which are implemented by interpreter hints).  This is a
bug and, like all bugs, will be fixed at some point.





## Stack trace tutorial

In this tutorial we will run a simple stack trace and use the output to get a
picture of what the Arvo kernel proper does during the routine task of setting a
timer. Some level of familiarity with the kernel is required for this section,
which can be obtained in our [Arvo documentation](@/docs/tutorials/arvo/arvo.md#the-kernel).

### Running a stack trace

Ultimately, everything that happens in Arvo is reduced to Unix events, and the
Arvo kernel acts as a sort of traffic cop for vanes and apps to talk to one
another. Here we look at how a simple command, `-time ~s1`, goes from pressing
Enter on your keyboard in Dojo towards returning a notification that one second
has elapsed.

To follow along yourself, boot up a fake `~zod` and enter `|verb` into the dojo
and press Enter to enable verbose mode (this is tracked by the laconic bit
introduced in the section on [the
state](@/docs/tutorials/arvo/arvo.md#the-state)) in the kernel documentation, followed by `-time ~s1`
followed by Enter. Your terminal should display something like this:

```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo] [i=/d t=~[//term/1]]]
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
["|||||" %give %d %blit [=//term/1 t=~]]
["|||" %pass [%g %f] [%build /use/dojo/~zod/drum/hand] [i=/d t=~[//term/1]]]
["||||" %give %f %made [i=/g/use/dojo/~zod/drum/hand t=~[/d //term/1]]]
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
["||||||" %give %g [%unto %watch-ack] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
//term/1]]]
["||||||" %pass [%g %f] [%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
["|||||||" %give %f %made [i=/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
["||||||||" %pass [%g %f] [%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
["|||||||||" %give %f %made [i=/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
["||||||||||" %pass [%g %b] [%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556] [i=/d t=~[//term/1]]]
["|||||||||||" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
> -time ~s1
```
followed by a pause of one second, then
```
["" %unix p=%wake //behn ~2020.1.14..19.01.26..755d]
["|" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
["|" %give %b %wake [i=/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 t=~[/d //term/1]]]
["||" %give %g [%unto %fact] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
["|||||" %give %d %blit [=//term/1 t=~]]
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
~s1..0007
```
This gives us a stack trace that is a list of `move`s and some
associated metadata. Some of the `move`s are a bit of a distraction from what's
going on overall such as acknowledgements that a `poke` was received
(`%poke-ack`s), so we've omitted them for clarity. Furthermore, two `move`s (the
`%blit` `card`s) is not printed even in verbose mode because it occurs so
frequently, but there are only two of them here and so we have added it in.

The main process that is occurring here is a sequence of `%pass` `move`s initiated
by pressing Enter in the terminal that goes on to be handled by Dill, then Gall,
and finally Behn. After the timer has elapsed, a sequence of `%give` `move`s is
begun by Behn, which then passes through Gall and ultimately ends up back at the
terminal. Any `move`s besides `%pass` in the first segment of the stack trace is a
secondary process utilized for book-keeping, spawning processes, interpreting
commands, etc. All of this will be explained in detail below.


It is important to note that this stack trace should be thought of
as being from the "point of view" of the kernel - each line represents the
kernel taking in a message from one source and passing it along to its
destination. It is then processed at that destination (which could be a vane or
an app), and the return of that process is sent back to Arvo in the form of
another `move` to perform and the loop begins again. Thus this stack trace does
not display information about what is going on inside of the vane or app such as
private function calls, only what the kernel itself sees.

### Interpreting the stack trace

In this section we will go over the stack trace line-by-line, explaining how the
stack trace is printed, what each line means (including some things not found in
the stack trace), and a particular focus on what code is being activated in the
first few lines that should equip you well enough to unravel the rest of the
stack trace in as much detail as you desire.


#### The call

Let's put the first part of the stack trace into a table to make reading a little easier.

| Length | move    | vane(s)   |                                                                                                     action | duct                                                                                  |
|--------|---------|-----------|-----------------------------------------------------------------------------------------------------------:|---------------------------------------------------------------------------------------|
| 0      | `%unix` |           | `%belt`                                                                                                    |                                                                                       |
| 1      | `%pass` | `[%d %g]` | `[[%deal [~zod ~zod] %hood %poke] /]`                                                                      | `//term/1`                                                                            |
| 2      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo]`                       | `/d<br>//term/1`                                                                      |
| 3      | `%give` | `%g`      | `[%unto %fact]`                                                                                            | `/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo<br>/d<br>//term/1`                |
| 4      | `%give` | `%g`      | `[%unto %fact]`                                                                                            | `/d<br>//term/1`                                                                      |
| 5      | `%give` | `%d`      | `%blit`                                                                                                    | `//term/1`                                                                            |
| 3      | `%pass` | `[%g %f]` | `[%build /use/dojo/~zod/drum/hand]`                                                                        | `/d<br>//term/1`                                                                      |
| 4      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/dojo/~zod/drum/hand<br>/d<br>//term/1`                                        |
| 5      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool]`                            | `/d<br>//term/1`                                                                      |
| 6      | `%give` | `%g`      | `[%unto %watch-ack]`                                                                                       | `/g/use/dojo/~zod/out/~zod/spider/drum/wool<br>/d<br>//term/1`                        |
| 5      | `%pass` | `[%g %g]` | `[[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool]`                             | `/d<br>//term/1`                                                                      |
| 6      | `%pass` | `[%g %f]` | `[%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u]`                                  | `/d<br>//term/1`                                                                      |
| 7      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u<br>/d<br>//term/1`  |
| 8      | `%pass` | `[%g %f]` | `[%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u]`                                 | `/d<br>//term/1`                                                                      |
| 9      | `%give` | `%f`      | `%made`                                                                                                    | `/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u<br>/d<br>//term/1` |
| 10     | `%pass` | `[%g %b]` | `[%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556]` | `/d<br>//term/1`                                                                      |
| 11     | `%give` | `%b`      | `%doze`                                                                                                    | `//behn/0v1p.sn2s7`                                                                   |

This simple action ends up involving four vanes - Dill, Gall, Behn, and Ford -
as well as four applications - hood, spider, dojo, and time.

Now let's go through each line one by one.
```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
```
This tells us that Unix has sent a `%belt` `card`, which corresponds to
terminal input (the Enter keystroke) at time `~2020.1.14..19.01.25..7556`

Here is the line of code in `arvo.hoon`, found in the [section
3bE core](@/docs/tutorials/arvo/arvo.md#section-3be-core), that generated the output:

```hoon
    ~?  !lac  ["" %unix -.q.ovo p.ovo now]
```
First we note that this line is executed only if the laconic bit is set to true,
as we did when we input `|verb`. Here, `ovo` is the input `ovum`. Knowing that an `ovum` is a `[p=wire q=curd]`,
we can then say that this is a `%unix` `move` tagged with `%belt` whose cause is a `wire` given by `//term/1`,
where the empty span `//` represents Unix and `term/1` represents the terminal
in Unix. Here we have a `wire` instead of a `duct` (i.e. a list of `wire`s)
since Unix I/O events are always the beginning and end of the Arvo event loop,
thus only a single `wire` is ever required at this initial stage.

The `""` here is a metadatum that keeps track of how many steps deep in the
causal chain the event is. An event
with `n` `|`'s was caused by the most recent previous event with `n-1` `|`'s. In
this case, Unix events are an "original cause" and thus represented by an empty
string.

At this point in time, Dill has received the `move` and then processes it. The
`%belt` `task` in `dill.hoon` is `+call`ed, which is processed using the `+send`
arm:

```hoon
      ++  send                                          ::  send action
        |=  bet/dill-belt
        ^+  +>
        ?^  tem
          +>(tem `[bet u.tem])
        (deal / [%poke [%dill-belt -:!>(bet) bet]])
```

Dill has taken in the command and in response it `%pass`es a `task` `card` with
instructions to `%poke` hood, which is a Gall app
primarily used for interfacing with Dill. Here, `+deal` is an arm for
`%pass`ing a `card` to Gall to ask it to create a `%deal` `task`:


```hoon
      ++  deal                                          ::  pass to %gall
        |=  [=wire =deal:gall]
        (pass wire [%g %deal [our our] ram deal])
```

Next in our stack trace we have this:
```
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
```
Here, Dill `%pass`es a `task` `card` saying to `%poke` Gall's hood app (with the
Enter keystroke).

Let's glance at part of the `+jack` arm in `arvo.hoon`, located in the [section 3bE
core](@/docs/tutorials/arvo/arvo.md#section-3be-core). This arm is what the Arvo kernel uses to send `card`s,
and here we look at the segment that includes `%pass` `move`s.

```hoon
  ++  jack                                              ::  dispatch card
    |=  [lac=? gum=muse]
    ^-  [[p=(list ovum) q=(list muse)] _vanes]
    ~|  %failed-jack
    ::  =.  lac  |(lac ?=(?(%g %f) p.gum))
    ::  =.  lac  &(lac !?=($b p.gum))
    %^    fire
        p.gum
      s.gum
    ?-    -.r.gum
        $pass
      ~?  &(!lac !=(%$ p.gum))
        :-  (runt [s.gum '|'] "")
        :^  %pass  [p.gum p.q.r.gum]
          ?:  ?=(?(%deal %deal-gall) +>-.q.q.r.gum)
            :-  :-  +>-.q.q.r.gum
                (,[[ship ship] term term] [+>+< +>+>- +>+>+<]:q.q.r.gum)
            p.r.gum
          [(symp +>-.q.q.r.gum) p.r.gum]
        q.gum
      [p.q.r.gum ~ [[p.gum p.r.gum] q.gum] q.q.r.gum]
```

Code for writing stack traces can be a bit tricky, but let's try not to get too
distracted by the lark expressions and such. By paying attention to the lines
concerning the laconic bit (following `!lac`) we can mostly determine what is being told to us.

From the initial input event, Arvo has generated a `card` that it is now
`%pass`ing from Dill (represented by `%d`) to Gall (represented by `%g`). The
`card` is a `%deal` `task`, asking Gall to `%poke` hood using data that has
originated from the terminal `//term/1`, namely that the Enter key was pressed. The line `:-  (runt [s.gum '|'] "")`
displays the causal chain length metadatum mentioned above. Lastly, `[~zod ~zod]` tells us that
`~zod` is both the sending and receiving ship.

From here on our explanations will be more brief. We include some information
that cannot be directly read from the stack trace in [brackets]. Onto the next line:

```
["||" %pass [%g %g] [[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo] [i=/d t=~[//term/1]]]
```

Here is another `%pass` `move`, this time from Gall to iself as denoted by `[%g
%g]`. Gall's hood has received the `%deal` `card` from Dill, and in response it is
`%poke`ing dojo with the information [that Enter was pressed].

```
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
```

Gall's dojo `%give`s a `gift` with a `%fact` (subscription update) to Gall's hood, [saying to clear
the terminal prompt].

```
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
```
Gall's hood `%give`s a `gift` with a `%fact` to Dill [saying to replace the current terminal line with `~zod:dojo>`]

Next is the `move` that is not actually printed in the stack trace mentioned
above:

```
["|||||" %give %d %blit [=//term/1 t=~]]
```

Dill `%give`s a `%blit` (terminal output) event to Unix [saying to replace the current terminal line with `~zod:dojo>`].

```
["|||" %pass [%g %f] [%build /use/dojo/~zod/drum/hand] [i=/d t=~[//term/1]]]
```

Gall's dojo also `%pass`es a `%build` request to Ford [asking to run "~s1" against the subject we use in the dojo].

```
["||||" %give %f %made [i=/g/use/dojo/~zod/drum/hand t=~[/d //term/1]]]
```

Ford `%give`s a result back to dojo [with the value `~s1`]

```
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %watch] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
```

Gall's dojo `%pass`es a `%watch` to Gall's spider app [to start listening for the result of the thread it's about to start].

```
["||||||" %give %g [%unto %watch-ack] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider acknowledges the subscription from dojo.

```
["|||||" %pass [%g %g] [[%deal [~zod ~zod] %spider %poke] /use/dojo/~zod/out/~zod/spider/drum/wool] [i=/d t=~[//term/1]]]
```

Gall's dojo also `%pass`es a `%poke` to Gall's spider [asking it start the thread "-time" with argument `~s1`].

```
["||||||" %pass [%g %f] [%build /use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
```

Gall's spider `%pass`es a `%build` request to Ford [asking it to find the path in `/ted` where the "time" thread is].

```
["|||||||" %give %f %made [i=/g/use/spider/~zod/find/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
```

Ford `%give`s a result back to Gall's spider [saying it's in `/ted/time.hoon`].

```
["||||||||" %pass [%g %f] [%build /use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u] [i=/d t=~[//term/1]]]
```

Gall's spider `%pass`es a `%build` request to Ford [asking it to compile the file `/ted/time.hoon`].

```
["|||||||||" %give %f %made [i=/g/use/spider/~zod/build/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u t=~[/d //term/1]]]
```

Ford `%give`s a result back to Gall's spider [with the compiled thread].

```
["||||||||||" %pass [%g %b] [%wait /use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556] [i=/d t=~[//term/1]]]
```

Gall's spider's thread with id `~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u` asks Behn to set a timer [for one second].

```
["|||||||||||" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
```

Behn `%give`s a `%doze` `card` to Unix, asking it to set a timer [for one second from
now]. At this point Arvo may rest.

#### The return

Now Unix sets a timer for one second, waits one second, and then informs Behn that a second has
passed, leading to a chain of `%give` `move`s that ultimately prints
`~s1..0007`.

Let's throw the stack trace into a table:

| length | move    | vane(s) | card            | duct                                                                                                             |
|--------|---------|---------|-----------------|------------------------------------------------------------------------------------------------------------------|
| 0      | `%unix` |         | `%wake`         | `//behn`                                                                                                         |
| 1      | `%give` | `%b`    | `%doze`         | `//behn/0v1p.sn2s7`                                                                                              |
| 1      | `%give` | `%b`    | `%wake`         | `/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 /d //term/1` |
| 2      | `%give` | `%g`    | `[%unto %fact]` | `/g/use/dojo/~zod/out/~zod/spider/drum/wool /d //term/1`                                                         |
| 3      | `%give` | `%g`    | `[%unto %fact]` | `/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo /d //term/1`                                                 |
| 4      | `%give` | `%g`    | `[%unto %fact]` | `/d //term/1`                                                                                                    |
| 5      | `%give` | `%d`    | `%blit`         | `//term/1`                                                                                                       |
| 2      | `%give` | `%g`    | `[%unto %kick]` | `/g/use/dojo/~zod/out/~zod/spider/drum/wool /d //term/1`                                                         |

Now we follow it line-by-line:

```
["" %unix p=%wake //behn ~2020.1.14..19.01.26..755d]
```

Unix sends a `%wake` (timer fire) `card` at time `~2020.1.14..19.01.26..755d`.

```
["|" %give %b %doze [i=//behn/0v1p.sn2s7 t=~]]
```

Behn `%give`s a `%doze` `card` to Unix, asking it to set a timer [for whatever next timer it has in its queue].

```
["|" %give %b %wake [i=/g/use/spider/~zod/thread/~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u/wait/~2020.1.14..19.01.26..7556 t=~[/d //term/1]]]
```

Behn `%give`s a `%wake` to Gall's spider's thread with id `~.dojo_0v6.210tt.1sme1.ev3qm.qgv2e.a754u`.

```
["||" %give %g [%unto %fact] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider `%give`s a `%fact` (subscription update) to dojo [saying that the thread completed successfully and produced value `~s1.0007`].

```
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
```

Gall's dojo `%give`s a `%fact` to hood [saying to output `~s1..0007`].

```
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
```

Gall's hood `%give`s a `%fact` to Dill [saying to output `~s1..0007`].

```
["|||||" %give %d %blit [=//term/1 t=~]]
```

Dill `%give`s a `%blit` (terminal output) event to Unix [saying to print a new line with output `~s1..0007`].

```
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider also closes the subscription from dojo [since the thread has completed].
