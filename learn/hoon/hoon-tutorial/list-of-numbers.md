+++
title = "1.1.1 Walkthrough: List of Numbers"
weight = 3
template = "doc.html"
+++
This code-example is intended to familiarize you with the basics of Hoon syntax. It's okay if you don't understand everything immediately; some concepts may be beyond your grasp for now. What's important is that you become accustomed to the elements of the code and their look once combined into a valid program.

Below is a simple Hoon program that takes a single number `n` from the user as input and produces a list of numbers from `1` up to (but not including) `n`. So, if the user gives the number `5`, the program will produce: `~[1 2 3 4]`.

```
|=  end=@                                               ::  1
=/  count=@  1                                          ::  2
|-                                                      ::  3
^-  (list @)                                            ::  4
?:  =(end count)                                        ::  5
  ~                                                     ::  6
:-  count                                               ::  7
$(count (add 1 count))                                  ::  8
```

As we mentioned in the previous lesson, the easiest way to use such a program is to run it as a _generator_. Saving a file in the `/home/gen` directory of your ship allows you to run it from your ship's Dojo (command line) as a generator. Save the above code there as `list.hoon`. Now you can run it in the Dojo as so:

`~your-ship:> +list 5`

Try it! You can choose any natural number to put after `+list`, but it can't be zero or blank. The `+` lets the Dojo know that it's looking for a generator with the name that follows. You don't write out the `.hoon` part of the file name when running it in the Dojo.

But what do all these squiggly symbols in the program _do_? It probably isn't immediately clear. Let's go through each component of this code.

## The Code

You probably noticed that there's a column of colons and numbers in the our example. The `::` digraph tells the compiler to ignore the rest of the text on the line. Such text is referred to as a "comment" because, instead of performing a computation, it exists to explain things to human readers of the source code.

In our example program, we use comments with line numbers for convenient reference, so that we can dig into the code line by line. Important Hoon concepts will be bolded when first mentioned.

### Line 1

```
|=  end=@
```

There's a few things going on in our first line. The first part of it, `|=`, is a kind of **rune**. Runes are the building blocks of all Hoon code, represented as a pair of non-alphanumeric ASCII characters. Runes form expressions; runes are used how keywords are used in other languages. In other words, all computations in Hoon ultimately require runes. Runes and other Hoon expressions are all separated from one another by either two spaces or a line break.

All runes take a fixed number of "children." Children can themselves be runes with children, and Hoon programs work by chaining through these until a value -- not another rune -- is arrived at. For this reason, we very rarely need to close expressions. Keep this scheme in mind when examining Hoon code.

The specific purpose of the `|=` rune is to create a **gate**. A gate is what would be called a function in other languages: it takes an input, performs a specified computation, and then produces an output.

Because we're only on line 1, all we're doing with the gate is creating it, and then specifying what kind of input the gate takes with that rune's first child: `end=@`. The `end` part of our code is simply a name that we give to the user's input so that we can use the number later. `=@` means that we restrict the kind of input that our gate accepts to the **atom** type, or `@` for short. An atom is a natural number.

Our program is simple, so the _entire program_ is the gate that's being created here. The rest of our lines of code are part of the second child of our gate, and they determine how our gate produces an output.

### Line 2

```
=/  count=@  1
```

This line begins with the `=/` rune, which stores a value with a name and specifies its type. It takes three children.

`count=@` (the first child) stores `1` (the second child) as `count` and as specifies that has the `@` type.

We're using `count` to keep track of what numbers we're including in the list we're building. We'll use it later in the program.

### Line 3

```
|-
```

The `|-` rune functions as a "restart" point for recursion that will be defined later. It takes one child.

### Line 4

```
^-  (list @)
```

The `^-` rune constrains output to a certain type. It takes two children.

In this case, the rune specifies that our gate's output must be `(list @)` -- that is, a list of atoms.

### Lines 5 and 6

```
?:  =(end count)
  ~
```

`?:` is a rune that evaluates whether its first child is true or false. If that child is true, the program branches to the second child. If it's false, it branches to the third child. `?:` takes three children.

`=(end count)` checks if the user's input equals to the `count` value that we're incrementing to build the list. If these values are equal, we want to end the program, because our list has been built out to where it needs to be. Note that this expression is, in fact, a rune expression, just written a different way than you've seen so far. `=(end count)` is an _irregular form_ of `.=  end  count`, different in looks but identical in operation. `.=` is a rune that checks for the equality of its two children, and produces a "true" or "false" based on what it finds.

`~` simply represents the "null" value. The program branches here if on line 5 it finds that `end` equals `count`. Lists in Hoon always end with `~`, so we need this to be the last thing we put in our list.

## Line 7

`:-` is a rune that creates a **cell**, an ordered pair of two values, such as `[1 2]`. It takes two children.

In our case, `:-  count` creates a cell out of whatever value is stored in `count`, and then with the product of line 8.

## Line 8

```
$(count (add 1 count))
```

The above code is, once again, a compact way of writing a rune expression. All you need to know is that this line of code restarts the program at `|-`, except with the value stored in `count` incremented by 1. The construction of `(count (add 1 count))` tells the computer, "replace the value of count with count+1".

You'll notice that we use an unfamiliar word here: `add`. Unlike `count` and `end`, `add` is not defined anywhere in our program. That's because it's a gate that's predefined in the Hoon **standard library**. The standard library is filled with pre-defined gates that are generally useful, and these gates can be used just like something that you defined in your own program. You can see this gate, and other mathematical operators, in [section 1a](@/docs/reference/library/1a.md) of the standard-library documentation.

## Explanation

If you aren't clear on how the program is building the list, that's okay.

Our program works by having each iteration of the list creating a cell. In each of these cells, the head -- the cell's first position -- is filled with the current-iteration value of `count`. The tail of the cell, its second position, is filled with _the product of a new iteration of our code_ that starts at `|-`. This iteration will itself create another cell, the head of which will be filled by the incremented value of `count`, and the tail of which will start another iteration. This process continues until `?:` branches to `~` (null). When that happens, the list is terminated and the program doesn't have anything else to do, so it ends. So, a built-out list of nested cells can be visualized like this:

```
   [1 [2 [3 [4 ~]]]]

          .
         / \
        1   .
           / \
          2   .
             / \
            3   .
               / \
              4   ~
```

If you still don't intuit how this is working, don't worry. We'll take a deeper look into recursion later with our [Recursion walkthrough](../recursion).

### [Next Up: Reading -- Nouns](../nouns)
