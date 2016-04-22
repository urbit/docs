---
sort: 14
---

# Exercises

The best way to cement this knowledge in your mind is to do
exercises.  These are roughly in order of ascending difficulty,
and they are intended to form a sort of primer to Hoon.

## Friends of FizzBuzz

1.  Consider the following implementation of FizzBuzz, which is
    equivalent to the one in the [Demo](demo) section.

    ```
    |=  end/atom
    =+  count=1
    |-
    ^-  (list tape)
    ?:  =(end count)
       ~
    :-
      ?:  =(0 (mod count 15))
        "FizzBuzz"
      ?:  =(0 (mod count 5))
        "Fizz"
      ?:  =(0 (mod count 3))
        "Buzz"
      (text !>(count))
    $(count (add 1 count))
    ```

    Modify this to produce "Fuzz" when the number is divisible by
    7, "Fuzz" when divisible by 21, "FuzzFizz" when divisble by 35,
    and "FuzzFizzBuzz" when divisble by 105.

1.  Modify FizzBuzz from the previous exercise to take both a
    start and an end number.

1.  Modify FizzBuzz from the previous exercise to count down
    instead of up.

##  Math

1.  Write a function that produces a list of the first `n`
    triangular numbers.  The `n`th triangular number is the sum
    of the first `n` positive integers.

1.  Using the program from the previous exercise, write a
    function that produces the first `n` tetrahedral numbers.
    The `n`th tetrahedral number is the sum of the first `n`
    triangular numbers.

##  Conway's Game of Life

Conway's Game of Life is a zero-player game played on an `n`x`n`
grid of spaces, each of which is either "alive" or "dead".  Every
iteration, some or all of the spaces change from alive to dead or
from dead to alive.

Specifically, for each iteration, each dead space becomes alive
if and only if it is adjacent to exactly three live spaces.  Each
live remains alive if and only if it is adjacent to either two or
three live spaces.  In this context, "adjacent to" includes the
eight spaces that share either a side or a corner with the space.
Thus, in the following map, the center space (dead) is adjacent
to exactly three live spaces, so it will be alive in the next
iteration.  `#` signifies a live space and `.` signifies a dead
space.

    ..#
    ...
    ##.


1.  Write a function that takes nine loobean inputs, `nw`, `nc`,
    `ne`, `cw`, `cc`, `ce`, `sw`, `sc`, and `se`.  Produce 'yes'
    if the center space will be alive in the next generation and
    'no' if it will be dead.

1.  Write a function that takes an integer `n` and produces an
    `n` by `n` grid of loobeans, (hereafter, "board"),
    initialized to 'no'.  This grid should be represented as a
    list of `n` lists of length `n`.

1.  Write a function that takes a board, a row index, and a
    column index, and produces a new board, identical to the old
    except that the state of the space referred to by the row and
    column indices has been toggled.

1.  Use the following function to pretty-print the board.  For
    bonus points, try to follow what it's doing.

    ```
    ::  XX  test
    |=  board/(list (list ?))
    ^-  tang
    %+  turn  board
    |=  row/(list ?)
    :-  %leaf
    ^-  tape
    %+  turn  row
    |=  space/?
    ?:  space
      '# '
    '. '
    ```

    If you run this function with a board, you'll get a
    pretty-printable object (a `tang`), but it won't be
    pretty-printed.  When running the generator from the dojo,
    run `&tang +generator arguments` to mark the result as a
    `tang`, which will tell the dojo to intelligently
    pretty-print it.

1.  Using the functions created in the previous exercises, create
    a 10 by 10 board, and flip the states of the spaces at
    coordinates (counting from the top left, indexed from 0)
    `(2,1)`, `(3,2)`, `(1,3)`, `(2,3)`, and `(3,3)`.  Use the
    pretty printer to print out the board.  Your output should be
    the following:

    ```
    . . . . . . . . . .
    . . # . . . . . . .
    . . . # . . . . . .
    . # # # . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    ```

1.  Write a function that iterates every space on the board.
    Print out the new board.  It should look like this:

    ```
    . . . . . . . . . .
    . . . . . . . . . .
    . # . # . . . . . .
    . . # # . . . . . .
    . . # . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    . . . . . . . . . .
    ```

    >  Note that the spaces on the edge don't have the full nine
    >  neighbors.  For now, assume that they're always dead.

1.  Write a function that runs the above function `n` times on
    the board.  Observe the board as the game progresses.
    Congratulations, you've written Conway's Game of Life in
    Hoon!

1.  One common way to handle the edge of the board is to pretend
    that it "wraps around", forming a torus.  In other words, say
    that the spaces on the left edge of the map are adjacent to
    the ones on the right edge, and the spaces on the top edge
    are adjacent to the spaces on the bottom edge.  Pay special
    attention to the corners.
