+++
title = "Tutorial: Move Trace"
weight = 12
template = "doc.html"
+++

In this tutorial we will run a simple "move trace" and use the output to get a
picture of what the Arvo kernel proper does during the routine task of setting a
timer. Some level of familiarity with the kernel is required for this section,
which can be obtained in our [Arvo kernel tutorial](@/docs/arvo/arvo.md#the-kernel).

## Running a move trace

Ultimately, everything that happens in Arvo is reduced to Unix events, and the
Arvo kernel acts as a sort of traffic cop for vanes and apps to talk to one
another. Here we look at how a simple command, `-time ~s1`, goes from pressing
Enter on your keyboard in Dojo towards returning a notification that one second
has elapsed.

To follow along yourself, boot up a fake `~zod` and enter `|verb` into the dojo
and press Enter to enable verbose mode (this is tracked by the laconic bit
introduced in the section on [the
state](@/docs/arvo/arvo.md#the-state)) in the kernel documentation, followed by `-time ~s1`
followed by Enter. Your terminal should pretty print a series of `move`s that looks something like this:

```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
["||" %pass [%g %g] [[%deal [~zod ~zod] %dojo %poke] /use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo] [i=/d t=~[//term/1]]]
["|||" %give %g [%unto %fact] [i=/g/use/hood/~zod/out/~zod/dojo/drum/phat/~zod/dojo t=~[/d //term/1]]]
["||||" %give %g [%unto %fact] [i=/d t=~[//term/1]]]
["|||||" %give %d %blit [i=//term/1 t=~]]
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
["|||||" %give %d %blit [i=//term/1 t=~]]
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
~s1..0007
```
This gives us a move trace that is a list of `move`s and some
associated metadata. Some of the `move`s are a bit of a distraction from what's
going on overall such as acknowledgements that a `poke` was received
(`%poke-ack`s), so we've omitted them for clarity. Furthermore, two `move`s (the
`%blit` `card`s) is not printed even in verbose mode because it occurs so
frequently, but there are only two of them here and so we have added it in.

The main process that is occurring here is a sequence of `%pass` `move`s initiated
by pressing Enter in the terminal that goes on to be handled by Dill, then Gall,
and finally Behn. After the timer has elapsed, a sequence of `%give` `move`s is
begun by Behn, which then passes through Gall and ultimately ends up back at the
terminal. Any `move`s besides `%pass` in the first segment of the move trace is a
secondary process utilized for book-keeping, spawning processes, interpreting
commands, etc. All of this will be explained in detail below.


It is important to note that this move trace should be thought of
as being from the "point of view" of the kernel - each line represents the
kernel taking in a message from one source and passing it along to its
destination. It is then processed at that destination (which could be a vane or
an app), and the return of that process is sent back to Arvo in the form of
another `move` to perform and the loop begins again. Thus this move trace does
not display information about what is going on inside of the vane or app such as
private function calls, only what the kernel itself sees.

## Interpreting the move trace

In this section we will go over the move trace line-by-line, explaining how the
move trace is printed, what each line means (including some things not found in
the move trace), and a particular focus on what code is being activated in the
first few lines that should equip you well enough to unravel the rest of the
move trace in as much detail as you desire.


### The call

Let's put the first part of the move trace into a diagram to make following
along a little easier.

<div style="text-align:center">
<img src="https://media.urbit.org/docs/arvo/move-trace-with-key.png">
</div>

Here, each arrow represents the passing of some information, with most of it
being from vane to vane. Here, when Vane A has an arrow to a card and then an
arrow to Vane B, this represents either a `%pass` `note/task` sequence or a
`%give` `gift/sign` sequence that actually has the Arvo kernel in the middle.
That is to say, Vane A `%pass`es a `note` to the Arvo kernel addressed to Vane
B, and the Arvo kernel then `%pass`es a `task` to Vane B. For more information,
see the [Arvo kernel tutorial](@/docs/arvo/arvo.md#the-kernel).

This simple action ends up involving four vanes - Dill, Gall, Behn, and Ford -
as well as four applications - hood, spider, dojo, and time.

Now let's go through each line one by one.
```
["" %unix p=%belt //term/1 ~2020.1.14..19.01.25..7556]
```
This tells us that Unix has sent a `%belt` `card`, which corresponds to
terminal input (the Enter keystroke) at time `~2020.1.14..19.01.25..7556`

Here is the line of code in `arvo.hoon`, found in the [section
3bE core](@/docs/arvo/arvo.md#section-3be-core), that generated the output:

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

Next in our move trace we have this:
```
["|" %pass [%d %g] [[%deal [~zod ~zod] %hood %poke] /] [i=//term/1 t=~]]
```
Here, Dill `%pass`es a `task` `card` saying to `%poke` Gall's hood app (with the
Enter keystroke).

Let's glance at part of the `+jack` arm in `arvo.hoon`, located in the [section 3bE
core](@/docs/arvo/arvo.md#section-3be-core). This arm is what the Arvo kernel uses to send `card`s,
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

Code for writing traces can be a bit tricky, but let's try not to get too
distracted by the lark expressions and such. By paying attention to the lines
concerning the laconic bit (following `!lac`) we can mostly determine what is being told to us.

From the initial input event, Arvo has generated a `card` that it is now
`%pass`ing from Dill (represented by `%d`) to Gall (represented by `%g`). The
`card` is a `%deal` `task`, asking Gall to `%poke` hood using data that has
originated from the terminal `//term/1`, namely that the Enter key was pressed. The line `:-  (runt [s.gum '|'] "")`
displays the causal chain length metadatum mentioned above. Lastly, `[~zod ~zod]` tells us that
`~zod` is both the sending and receiving ship.

From here on our explanations will be more brief. We include some information
that cannot be directly read from the move trace in [brackets]. Onto the next line:

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

Next is the `move` that is not actually printed in the move trace mentioned
above:

```
["|||||" %give %d %blit [i=//term/1 t=~]]
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

### The return

Now Unix sets a timer for one second, waits one second, and then informs Behn that a second has
passed, leading to a chain of `%give` `move`s that ultimately prints
`~s1..0007`.

Let's throw the move trace into a table:

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
["|||||" %give %d %blit [i=//term/1 t=~]]
```

Dill `%give`s a `%blit` (terminal output) event to Unix [saying to print a new line with output `~s1..0007`].

```
["||" %give %g [%unto %kick] [i=/g/use/dojo/~zod/out/~zod/spider/drum/wool t=~[/d //term/1]]]
```

Gall's spider also closes the subscription from dojo [since the thread has completed].

