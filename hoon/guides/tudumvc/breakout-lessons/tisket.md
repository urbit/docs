# `=^` (tisket)

[`=^`](https://urbit.org/docs/reference/hoon-expressions/rune/tis/#tisket) performs a very important role that is documented well, again, in [~timluc-miptev's Gall Guide](https://github.com/timlucmiptev/gall-guide/blob/master/poke.md#the--idiom).  Basically, what it does is it creates a new `face` (here, `cards`) that can take some value, a `wing` of the subject (here, `state`) that has some value (which will be replaced), then some hoon (which will create a `cell` of two values - we'll call this the 'producing hoon'), then some more hoon (the 'recipient hoon').  The 'producing hoon' produces a `cell` of two values.  The two values map onto the new `face` (the `head` to `cards`) and the `wing` (the `tail` to `state`).  If our producing hoon is written correctly, it will produce a `(quip card _state)` which maps perfectly onto `cards` `state`.  Our receiving hoon then does some action based on these changes (in this case, produces a `(quip card _this)` from `[cards this]` where `this` in the `tail` there has been updated with the new `state`).

Using the example app from Lesson 3, we can examine further:
```
=^  cards  state
?+  mark  (on-poke:def mark vase)
  %tudumvc-action  (poke-actions !<(action:tudumvc vase))
==
[cards this]
```
Here, the app tests the incoming `mark` using [`?+`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wutlus) to do something like a case-when statement with a default (NOTE: this default uses `default-agent` which we've aliased above as `def`).  We only have _one_ case in our initial example here - so, solong as the mark is `&tudumvc-action`, we will call `(poke-action !<(action:firststep vase))`
  * **NOTE:** [`!<`](https://urbit.org/docs/reference/hoon-expressions/rune/zap/#zapgal) automatically checks to ensure that our vase matches our mold of the `action` defined in our `sur` file).

`poke-action` must, with our argument, necessarily return a `(quip card _state)`, or a list of `card`s and a version of our `state` (potentially with updated values).

To finish examining this section, we should look at `poke-action`:
```
++  poke-actions
  |=  =action:tudumvc
  ^-  (quip card _state)
  ?-  -.action
    %add-task
  `state(task task:action)
  ==
--
```
We know that `poke-action` will receive an `action:tudumvc` as defined in our `sur` file, because we've dynamically type checked it above (`(poke-action !<(action:tudumvc vase))`). From there, we simply check _without default_ [`?-`](https://urbit.org/docs/reference/hoon-expressions/rune/wut/#wuthep) that the `head` of our `action` (or `vase`) is `%add-task` (our only `poke` `action` available in our `sur` file). That being true, we replace `task:state` with the `tail` of our incoming `vase`, e.g. the new message.

`` `state(message +.action)`` is the equivalent of `:-(~  %=(state message +.action))` which just means "return an (empty) list of `card`s and the `state` with the `task` `face` of the `state` replaced with whatever the `task` `face` of our `action` or `vase` is".