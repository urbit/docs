+++
title = "Dill"
weight = 4
template = "doc.html"
+++

In this document we describe the public interface for Dill. Namely, we describe
each `task` that Dill can be `pass`ed, and which `gift`(s) Dill can `give` in return.

Dill is unique among vanes since it is technically the first vane to be booted (though we
regard Jael as the "true" first vane). As a result, there are four `task`s in
`task:able:dill` for which Dill acts only as a middleman that passes the `task`s
directly to the Arvo kernel. Thus we have split this document into a [Dill
tasks](#dill-tasks) section and an [Arvo tasks](#arvo-tasks) section.

## Dill Tasks


### `%belt`

Every keystroke entered into the console triggers a `%belt` `task` for Dill which contains information about the keystroke, such as which key was pressed
and from which terminal.

#### Accepts

`%belt` `task`s come in a number of different types, corresponding to different
keystrokes. You can find this list in `+dill-belt` in `zuse.hoon`.

```hoon
++  dill-belt                                         ::  new belt
    $%  {$aro p/?($d $l $r $u)}                         ::  arrow key
        {$bac ~}                                        ::  true backspace
        {$cru p/@tas q/(list tank)}                     ::  echo error
        {$ctl p/@}                                      ::  control-key
        {$del ~}                                        ::  true delete
        {$hey ~}                                        ::  refresh
        {$met p/@}                                      ::  meta-key
        {$ret ~}                                        ::  return
        {$rez p/@ud q/@ud}                              ::  resize, cols, rows
        {$txt p/(list @c)}                              ::  utf32 text
        {$yow p/gill:gall}                              ::  connect to app
    ==                                                  ::
```

#### Returns

Dill returns no `gift` in response to a `%belt` `task`.


### `%blew`

This `task` is called whenever the terminal emulator is resized, so that Dill can adjust
the text output to fit the new window size.

#### Accepts

```hoon
[p=@ud q=@ud]
```

`p` is the number of columns and `q` is the number of rows.

#### Returns

Dill returns no `gift` in response to a `%blew` `task`.


### `%boot`

This `task` is used only once, when Arvo first enters the [adult
stage](@/docs/arvo/arvo.md#structural-interface-core). Dill is
technically the first vane to be activated, via the `%boot` `task`, which then
send Jael (considered the the "true" first vane) an `%init` `task`, which then goes on to
call `%init` `task`s for other vanes (including Dill).

#### Accepts

`%boot` takes an argument that is either `%dawn` or `%fake`. `%dawn` is the one
used in any typical scenario and activates the ordinary vane initialization
process outlined above, while `%fake` is a debugging tool.

#### Returns

`%boot` does not return a `gift`.



### `%crud`

This `task` is used by Dill to produce error reports. It prints the received
error message(s) (a `(list tank)`) to the terminal. The level of detail of the
error message is set by `$log-level`, which is either `%hush`, `%soft`, or `%loud`.

#### Accepts

```hoon
[err=@tas tac=(list tank)]
```

`err` is the type of error and `tac` is the associated error message.

#### Returns

`%crud` does not return a `gift`.


### `%flog`

A `%flog` `task` is a wrapper over a `task` sent by another vane. Dill removes the wrapper
and sends the bare `task` to itself over the default `duct`.

#### Accepts

`%flog` `task`s can take any valid Dill `task` as an argument.

#### Returns

`%flog` never returns a `gift` on its own, but the wrapped `task` might.

#### Example

`%crud` `task`s from other vanes are typically passed to Dill wrapped in a
`%flog` `task` to print errors to the terminal.



### `%flow`

This `task` is not used.


### `%hail`

`%hail` refreshes the terminal by sending an empty message to the default duct
for Dill,
causing the terminal to redraw itself (?)

#### Accepts

```hoon
[ ~ ]
```

#### Returns

`%hail` returns no `gift`s.


### `%heft`

`%heft` causes Dill to `pass` a `%wegh` `task` to all other vanes (but not to
itself), thus obtaining a complete digest of Arvo's memory usage.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

`%heft` does not directly return any `gift`s, but each `%wegh` `task` sent will
return a `%mass` `gift`.


### `%hook`

This task is not used.


### `%harm`

This `task` is not used.


### `%init`

This `task` is called only once, when Arvo first enters the [adult
stage](@/docs/arvo/arvo.md#structural-interface-core). It performs
initial setup for Dill, such as setting the width of the console.

Note that this is not actually the first `task` passed to Dill - see [%boot](#%boot).

#### Accepts

`%init` takes no arguments.

#### Returns

`%init` returns no `gift`s.


### `%knob`

`%knob` sets the verbosity level for each error tag.

#### Accepts

```hoon
[tag=@tas level=log-level]
```

`tag` is the error tag. `level` is the verbosity, set to either `%hush`,
`%soft`, or `%loud`.

#### Returns

`%knob` does not return a gift.




### `%noop`

`%noop` does nothing - it stands for "no operation".

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task`, predictably, returns nothing.

#### Example

This can be useful if a shell command requires a Dill `task` but you don't want
Dill to do anything.



### `%talk`

This `task` is not used.

### `%text`

This `task` prints a `tape` to the dojo by first converting it from a UTF8
`tape` to a `list` of UTF32 codepoints (`@c`'s) and then recursively popping off a character from the
`tape` and sending it to to Unix to be printed into the terminal via a `%blit` event.

#### Accepts

```hoon
[p=tape]
```

#### Returns

This `task` returns zero or more `%blit` `gift`s, each containing a .


### `%trim`

`%trim` is a common vane `task` used to reduce memory usage. However, it does
nothing for Dill.

#### Accepts

```hoon
[p=@ud]
```

This is a common parameter for `%trim` `task`s across all vanes but does nothing
for Dill.

#### Returns

This `task` returns no `gift`s.



### `%vega`

This is a common vane `task` used to inform the vane that the kernel has been
upgraded. Dill does not do anything in response to this.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task` returns no `gift`s.



## Arvo tasks

These `task`s live in `task:able:dill` but are passed directly to the Arvo
kernel for processing.

### `%lyra`

This `task` updates the kernel.

#### Accepts

```hoon
[p=@t q=@t]
```

`p` is the contents of the new `hoon.hoon` and `q` is the contents of the new `arvo.hoon`.

#### Returns

This `task` returns no `gift`s.


### `%pack`

This `task` defragments and deduplicates Arvo's memory. This is ultimately
performed by the interpreter so you won't find the code in `arvo.hoon` but
rather under `c3__pack` in `urbit/worker/main.c`.

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task` returns no `gift`s.


### `%veer`

This `task` is used to install `zuse` and vanes. It is handled by `+veer` in
`arvo.hoon`.

#### Accepts

```hoon
[p=@ta q=path r=@t]
```

`p` is the vane letter, `q` is the formal `path` to the
vane, and `r` is the source code for the vane. The vane letter is `%` followed
by the first letter of the vane in lowercase, such as `%d` for Dill. `p=%$` in
the case of `zuse`.

#### Returns

This `task` returns no `gift`s.


### `%verb`

This `task` toggles verbose mode for all of Arvo, which is located here since
Dill is the vane that prints errors. To be precise, `%verb` toggles the laconic
bit `lac` in the [Arvo state](@/docs/arvo/arvo.md#the-state).

#### Accepts

```hoon
[ ~ ]
```

#### Returns

This `task` returns no `gift`s.
