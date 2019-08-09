+++
title = "Admin and Operations"
weight = 2
template = "doc.html"
+++
Your urbit (also called your _ship_) is a persistent Unix process that you
mainly control from the console. For some things, a browser will also work.

## Shutdown

You can turn your urbit off with `Ctrl-d` from the Talk or Dojo prompts.

You can force-quit your urbit with `Ctrl-z` from anywhere.

## Restart

To restart your urbit simply pass the name of your pier:

```
$ urbit some-planet
```

or

```
$ urbit comet
```

## Logging

To log an urbit's command line output to a file, use `script`:

```
$ script urbit.log urbit your-urbit
```

## Moving your pier

Piers are designed to be portable, but it _must_ be done while the urbit
is turned off. Urbit networking is stateful, so you can't run two copies
of the same urbit in two places.

To move a pier, simply move the contents of the directory it lives in.
To keep these files as small as possible we usually use the `--sparse`
option in `tar`. With a pier `your-urbit/`, something like this should work:

```
tar -Scvzf ~/your-urbit.tar.gz ~/your-urbit/
scp your-old-server:~/your-urbit.tar.gz your-new-server:~
```

Then to unzip it, on your other Unix server, run:

```
tar xfvz your-urbit.tar.gz
```

Delete the tar file, and, after installing Urbit on your new server,
start your urbit back up with:

```
urbit your-urbit
```

## Console

Your Urbit terminal is separated into two parts: the prompt (the bottom
line) and the record (everything above that). The record is shared; all
the output from all the apps in your command set appears in it. The
prompt is multiplexed.

In the CLI, Urbit apps can process your input before you hit return. To
see this in action try entering `)` as the first character at the Dojo
prompt. Since there is no Dojo command or Hoon expression that starts
with ')', the Dojo rejects it.

`Ctrl-x` - Switches the prompt between running console apps

`Ctrl-c` - Crash current event.  Processed at the Unix layer and prints a stack
trace.

`Ctrl-d` - From Talk or Dojo, stops your Urbit process.

`Ctrl-z` - Stops the Urbit process from _anywhere_.

`↑` / `↓` - History navigation

The following emacs-style key bindings are available:

```
Ctrl-a    Cursor to beginning of the line (Home)
Ctrl-b    Cursor one character backward (left-arrow)
Ctrl-e    Cursor to the end of the line (End)
Ctrl-f    Cursor one character forward (right-arrow)
Ctrl-g    Beep; cancel reverse-search
Ctrl-k    Kill to end of line
Ctrl-l    Clear the screen
Ctrl-n    Next line in history (down-arrow)
Ctrl-p    Previous line in history (up-arrow)
Ctrl-r    Reverse-search
Ctrl-t    Transpose characters
Ctrl-u    Kill to beginning of line
Ctrl-y    Yank from kill buffer
```

Full coverage of the Urbit shell, the Dojo is covered in the
[Shell walkthrough](@/docs/using/shell.md).

## Web

On startup Urbit tries to bind to `localhost:80`. If you're already
running something on port `80` -- such as any other HTTP server, or another urbit -- you'll find the urbit
that you just started on `8080`, `8081`, and so on. For planets only, we also proxy web
domains through Urbit's own servers. Any planet `~your-urbit` is also at
`your-urbit.arvo.network`, but only after you [set up DNS](../dns-proxying).

Your urbit serves a simple homepage from `http://localhost` or
`https://your-urbit.arvo.network` that should be self-explanatory. Since
our HTTPS isn't audited / battle tested, we just call it "secure" HTTPS.
You can find that on `8443`. Or `8444` (and so on) if you're already
running something on `8443`.

## Moons {#moons}

Planets can spawn moons, which are meant for connected devices: phones, smart
TVs, digital thermostats. The basic idea is: your planet runs permanently in a
data center somewhere and moons run on all your devices.  Each planet can issue
~4 billion (`2^32`) moons.

To generate a random moon from your planet, run:

```
~sampel-palnet:dojo> +moon
moon: ~faswep-navred-sampel-palnet
\/~.0wd.rZU67.3jSny.z1vda.7sr-s.EL1Jt.-76Nj.ugXxY.g6-Bx.HvKZl.G53oV.hPnXe.7U3E3.J4CEe.MEVuq.~08Nt\/
  .zNT0K.k-Ab~.Nn90d.OZ2fT.-XlQQ.Cfrkf.y6~K0.2Do09.EaE3W.BSK--.5Q~9N.y3QIP.eokH-.T6lwz.gg8MX.7LU5
  x.DJROE.IzQsy.OXOLr.IOE3a.-QI40.H5ukK.Cw-u4.uxE-y.V-o1F.Q84g0.effP0.de01g.600g1
\/                                                                                               \/
```

You must manually edit the output of `+moon` to get
the correct format for the `<key>`:

- strip out the `\/`

- combine into one line, omitting spaces

- trim the leading `~.`

`<key>` would be `0wd.rZU67.3jSny.z1vda ... <snip> ... effP0.de01g.600g1`
in this example.

Put `<key>` in a file and that file becomes `<keyfile>`.

Another way of generating `<keyfile>` is:

```
~sampel-palnet:dojo> @moon/key +moon
moon: ~faswep-navred-sampel-palnet
```

`<keyfile>` will be at `path/to/sampel-palnet/.urb/put/moon.key`
and does not need editing to be used with the `-k` option.

You can use the resulting output in the same installation flow from the
[Booting a Ship](@/docs/getting-started/booting-a-ship.md) guide, following the same scheme as for booting a planet. That scheme is:

```
$ urbit -w <moonname> -G <key> -c <piername>
```

or

```
$ urbit -w <moonname> -k <keyfile> -c <piername>
```

The `-c <piername>` argument is not required, but it is recommended; otherwise,
the resulting directory is a rather unwieldy moon name.

Here's how an example moon might be booted:

```
$ urbit -w faswep-navred-sampel-palnet -G <key> -c mymoon
```

or

```
$ urbit -w faswep-navred-sampel-palnet -k <keyfile> -c mymoon
```

Moons are automatically synced to their parent `%kids` desk, and can control
applications on their parent planet using `|link`.  You can read more about
those operations in the [filesystem](@/docs/using/filesystem.md) and [console](@/docs/using/shell.md)
walkthroughs, respectively.


## Continuity breaches

While the Urbit network is in this alpha state, we sometimes have to
reboot the whole network. This happens either when major changes need
to be shipped or we hit a bug that can't be fixed over the air.

Because Urbit networking is stateful we call this a _continuity breach_.
Everything has to be restarted from scratch. Your pier will continue to
function after we have breached, but it wont connect to the rest of the
Urbit network.

When this happens, back up any files you'd like to save, shut down your
urbit and recreate it (as if you were starting for the first time).
