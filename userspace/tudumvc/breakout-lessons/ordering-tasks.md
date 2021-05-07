+++
title = "Ordering Tasks"
weight = 16
template = "doc.html"
+++

Let's work with a task list in dojo to better understand - enter the following:
```hoon
>=a `(map id=@ud [label=@tU done=?])`(my :~([1 ['first task' %.n]] [2 ['second task' %.n]] [3 ['third task' %.n]]))
```
Then enter just `a` and you should see something like this:
```hoon
>a
{[p=id=1 q=[label='first task' done=%.n]] [p=id=2 q=[label='second task' done=%.n]] [p=id=3 q=[label='third task' done=%.n]]}
```

Now you have a face of `a` stored in the dojo with a `map` just like your type `tasks` in `%tudumvc`'s /sur file.  Let's take a peek at what [`key:by`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1751) does - try:
```hoon
> ~(key by a)
{id=1 id=2 id=3}
```

It produces a [`set`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1915) of all of the `key`s in the `map`. Next, we need to establish what [`tap:in`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1410) does - try:
```hoon
> =b ~(key by a)
```
First, pin the last step's results to a face of `b` in the dojo, making things cleaner, then:
```hoon
> `(list @ud)`~(tap in b)
~[3 2 1]
```

You now have a list of `id`s, and you've removed the `id` face which will allow us to do further manipulation to find our greatest value. 

Lastly, take a look at what [`sort`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L739) can do - try:
```hoon
=c `(list @ud)`~(tap in b)
```
Again, first, to store the prior work with a new face of `c`, then:
```
> +(-:(sort c gth))
4
```

And there you have it. You sorted `c` by [`gth`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L2691) (greater than) as the criteria for sorting, then you increment the head (highest existing value) using the shorthand `+(<value to increment>)`. Dojo returns 4, the next available `id`.

After that, all you need to do is use that as the value of `new-id` and then use [`put:by`](https://github.com/urbit/urbit/blob/fab9a47a925f73f026c39f124e543e009d211978/pkg/arvo/sys/hoon.hoon#L1632) to add the new `label` with a `done`-ness state of `%.n` at the appropriate `id` `key` position in your `tasks` map.