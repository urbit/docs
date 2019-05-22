+++
title = "Bank Account"
weight = 0
template = "doc.html"
+++

Write a door that can act as a bank account with the ability to withdraw, deposit, and check the balance.

```
:-  %say
|=  *
:-  %noun
=<  =~  new-account
      (deposit 100)
      (deposit 100)
      (withdraw 50)
      balance
    ==
|%
++  new-account
  |_  balance=@ud
  ++  deposit
    |=  amount=@ud
    +>.$(balance (add balance amount))
  ++  withdraw
    |=  amount=@ud
    +>.$(balance (sub balance amount))
  --
--
```

We start with the three lines we have in every `%say` generator. 

```
:-  %say
|=  *
:-  %noun
```

We're creating a cell the head of which is a `%say` and the tail of which is a gate that produces a cell with a head of the mark of the kind of data we are going to produce.

```
=<  =~  new-account
      (deposit 100)
      (deposit 100)
      (withdraw 50)
      balance
    ==
```

Here we're going to compose two runes using `=<` which has inverted arguments. We use this rune to keep the heaviest twig to the bottom of the code.

`=~` is a rune that composes multiple expressions. We take `new-account` and use that as the subject for the call to `deposit`. `deposit` and `withdraw` both produce a new version of the door which is used in subsequent calls which is why we are able to chain them in this fashion, the final reference is to `balance` which is the balance contain in the core we are about to examine.

```
|%
++  new-account
  |_  balance=@ud
  ++  deposit
    |=  amount=@ud
    +>.$(balance (add balance amount))
  ++  withdraw
    |=  amount=@ud
    +>.$(balance (sub balance amount))
  --
--
```

We've chosen here to wrap our door in it's own core to emulate the style of programming that is used when creating libraries. `new-account` is the name of our door. Recall that a door is a core with one or more arms that has a sample. Here our door has a sample of one `@ud` with the face `balance` and two arms, `deposit` and `withdraw`.

Each of these arms produces a gate which takes an `@ud` argument. Each of these gates has a similar bit of code inside.

```
+>.$(balance (add balance amount))
```

With wing syntax remember that we're looking for `+>`, or the 3rd element, out of `$`, which is to say the subject of the gate we are in, which is the entire `new-account` door. We change `balance` to be the result of adding `balance` and `amount` and produce the door as the result. `withdraw` functions the same way only doing subtraction instead of addition.

The important point to notice here is that the sample, `balance`, is stored as part of the door rather than existing outside of it.