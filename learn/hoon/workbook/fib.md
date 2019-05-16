Write a generator that produce a list of Fibonacci numbers up to n.

```
|=  n=@ud
%-  flop
=+  [i=0 p=0 q=1 r=*(list @ud)]
|-  ^+  r
?:  =(i n)  r
%=  $
  i  +(i)
  p  q
  q  (add p q)
  r  [q r]
==
```

First we need to produce a gate which takes an `@ud` so we know when to stop producing the list. 

```
%-  flop
```
Next we're going to call `flop` on the output of the rest of the program. `flop` is a standard library function to reverse a list. Why are we using this instead of producing the list in the order we want it in the first place? With lists adding an element to the end is an expensive operation that gets more expensive the longer the list is. Adding an element to the front however is cheap. In Big O Notation, adding to the end of a list is O(n) and the front is O(1).

```
=+  [i=0 p=0 q=1 r=*(list @ud)]
```

We are going to need several values throughout the execution of this task so we set them all up here. It's worth noticing that because the subject is searched head first, ignoring faces, we can define a number of faces at once by putting them in a tuple like this.

The only one of these that is interesting is `r` We're using `*` to bunt, or get the default value for, the mold `(list @ud)`.

```
|-  ^+  r
```

Next we define the trap that will contain the majority of our program. We also use `^+` to cast the output by example. This will result in the output being the same type as `r`, a list of `@ud`.

```
?:  =(i n)  r
```

Here is our terminating case, if `i` and `n` are equal we produce `r` as the result.

```
%=  $
  i  +(i)
  p  q
  q  (add p q)
  r  [q r]
==
```

The final expression in our program calls the `$` arm of the trap we are in with some changes. We increment `i`, set `p` to be `q` and `q` becomes the sum of `q` and `q`. `r` becomes a cell of `q` and whatever `r` was previously. This is the list that will get flopped to produce the result at the end of the computation.