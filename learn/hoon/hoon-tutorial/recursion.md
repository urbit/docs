+++
title = "1.5.1 Walkthrough: Recursion"
weight = 9
template = "doc.html"
+++
[Recursion](.) is a common pattern for solving certain problems in most programming
languages, and Hoon is no exception. One of the classically recursive problems
is that of factorial. The factorial of _n_ is the product of all positive
integers less than or equal to N. Thus the factorial of 5, denoted as _5!_,
would be:

```
5 * 4 * 3 * 2 * 1 = 120
```

### Factorial In Hoon

Let's implement a factorial calculator in Hoon. To do so, we'll write a
recursive `gate` (Hoon's equivalent of a function) to perform the relevant
computation. Save the code below as `factorial.hoon` in your ship's `/gen`
directory.

```
|=  n=@ud
?:  =(n 1)
  1
(mul n $(n (dec n)))
```

Our `gate` takes one sample (argument) `n` that must nest inside `@ud`, the
unsigned-integer type.

Next we check to see if `n` is `1`. If so, the result is just `1`, since
`1 * 1 = 1`.

If, however, `n` is _not_ `1`, then we branch to the final line of the code,
`(mul n $(n (dec n)))`, where the recursion logic lives. Here, we multiply `n`
by the recursion of `n` minus `1`. `$` initiates recursion: it calls the gate
that we're already in, but replaces its sample.

In our example, we multiply `n` with the product of this _entire gate
all over again_ with `$(n (dec n))`,  except when that new gate has its sample
decremented by one. This works recursively because each new gate will, of
course, itself contain the code to call a further-decremented gate. Gates will
continue to call new, further-decremented gates until `n` is `1`, and that `1`
will be the final number to be multiplied by.

Let's run the program in the Dojo:

```
> +factorial 5
120
```

It may help to visualize the operation of our example gate. The pseudo-Hoon below
illustrates what happens when we use it to find the factorial of 5:

```
(factorial 5)
(mul 5 (factorial 4))
(mul 5 (mul 4 (factorial 3)))
(mul 5 (mul 4 (mul 3 (factorial 2))))
(mul 5 (mul 4 (mul 3 (mul 2 (factorial 1)))))
(mul 5 (mul 4 (mul 3 (mul 2 1))))
(mul 5 (mul 4 (mul 3 2)))
(mul 5 (mul 4 6))
(mul 5 24)
120
```

It's easy to see how we're "floating" gate calls until we reach the final
iteration of such calls that only produces a value. The `mul n` component of the
gate leaves something like `mul 5`, waiting for the final series of terms
to be operated upon. The `$(n (dec n))` component is what expands out the
expression, as illustrated by `(factorial 4)`. Once the expression cannot be
expanded out further, the operations work backwards, successively feeding values
into the `mul` functions behind them.

#### Tail-Call Optimization

Our last example isn't a very efficient use computing resources. The
pyramid-shaped illustration approximates what's happening on the **call stack**, a
memory structure that tracks the instructions of the program. In our example
code, every time a parent gate calls another gate, the gate being called is
"pushed" to the top of the stack in the form of a frame. This process continues
until a value is produced instead of a function, completing the stack.

```
                  Push order      Pop order
(fifth frame)         ^               |
(fourth frame)        |               |
(third frame)         |               |
(second frame)        |               |
(first frame)         |               V
```

Once this stack of frames is completed, frames "pop" off the stack starting at
the top. When a frame is popped, it executes the contained gate and passes
produced data to the frame below it. This process continues until the stack
is empty, giving us the gate's output.

When a program's final expression uses the stack in this way, it's considered to
be **not tail-recursive**. This usually happens when the last line of executable
code calls more than one gate, our example code's `(mul n $(n (dec n)))` being
such a case. That's because such an expression needs to hold each iteration of
`$(n (dec n)` in memory so that it can know what to run against the `mul`
function every time.

To reiterate: if you have to manipulate the result of a recursion as the last
expression of your gate, as we did in our example, the function is not
tail-recursive, and therefore not very efficient with memory. A problem arises
when we try to recurse more times that we have space on the stack. This will
result in our computation failing and producing a stack overflow. If we tried
to find the factorial of `5.000.000`, for example, we would almost certainly
run out of stack space.

But the Hoon compiler, like most compilers, is smart enough to notice when the
last statement of a parent can reuse the same frame instead of needing to
add new ones onto the stack. If we write our code properly, we can use a single
frame that simply has its values replaced with each recursion.

#### A Tail-Recursive Gate

With a bit of refactoring, we can write a version of our factorial gate that
_is_ tail-recursive and can take advantage of this feature:

```
|=  n=@ud
=/  t=@ud  1
|-
?:  =(n 1)
    t
$(n (dec n), t (mul t n))
```

The above code should look familiar. We are still building a gate that
takes one argument `n`. This time, however, we are also putting a face on a
`@ud` and setting it's initial value to 1. The `|-` here is used to create a new
gate with one arm `$` and immediately call it. Think of `|-` as the recursion
point.

We then evaluate `n` to see if it is 1. If it is we return the value of `t`. In
the case that `n` is anything other than 1, we perform our recursion:

```
$(n (dec n), t (mul t n))
```

All we are doing here is recursing our new gate and modifying the values of `n`
and `t`. `t` is used as an accumulator variable that we use to keep a running
total for the factorial computation.

Let's use pseudo-Hoon to illustrate how the stack is working in this example for
factorial 5.

```
(factorial 5)
(|- 5 1)
(|- 4 5)
(|- 3 20)
(|- 2 60)
(|- 1 120)
120
```

We simply multiply `t` and `n` to produce the new value of `t`, and then
decrement `n` before repeating. Since this `$` call is the final and solitary
thing that is run in the default case and since we are doing all computation
before the call, this version is properly tail-recursive. We don't need to do
anything to the result of the recursion except recurse it again. That means that
each iteration can be replaced instead of held in memory.

#### A Note on `$`

`$` (pronounced "buc") is, in its use with recursion, a reference to the gate that we are inside
of. That's because a gate is just a core with a single arm named `$`. The
subject is searched depth-first, head before tail, with faces skipped, and
stopping on the first result. In other words, the first match found in the head
will be returned. If you wished to refer to the outer `$` in this context, the
idiomatic way would be to use [`^$`](@/docs/reference/hoon-expressions/rune/ket.md). The `^` operator
skips the first match of a name.

### Exercises

1. Write a recursive gate that produces the first _n_
[Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number)

2. Write a recursive gate that produces a list of moves to solve the
[Tower of Hanoi problem](https://en.wikipedia.org/wiki/Tower_of_Hanoi).
Disks are stacked on a pole by decreasing order of size. Move all of the
disks from one pole to another with a third pole as a spare, moving one
disc at a time, without putting a larger disk on top of a smaller disk.

### [Next Up: Reading -- The Subject and its Legs](../the-subject-and-its-legs/)
