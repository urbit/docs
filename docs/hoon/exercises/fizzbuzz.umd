---
navhome: /docs/
sort: 1
comments: true
---

# Friends of FizzBuzz

1.  Consider the following implementation of FizzBuzz, which is
    equivalent to the one in the [Demo](../../demo) section.

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
      (pave !>(count))
    $(count (add 1 count))
    ```

    Modify this to produce "Fuzz" when the number is divisible by
    7, "Fuzz" when divisible by 21, "FuzzFizz" when divisible by 35,
    and "FuzzFizzBuzz" when divisible by 105.

1.  Modify FizzBuzz from the previous exercise to take both a
    start and an end number.

1.  Modify FizzBuzz from the previous exercise to count down
    instead of up.
