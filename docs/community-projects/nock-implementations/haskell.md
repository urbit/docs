---
navhome: /docs/
title: Haskell
sort: 3
next: true
---

# Haskell

From [Steve Dee](https://github.com/mrdomino/hsnock/blob/master/Language/Nock5K/Spec.hs):

```
module Language.Nock5K.Spec where
import Control.Monad.Instances

wut (a :- b)                         = return $ Atom 0
wut a                                = return $ Atom 1

lus (a :- b)                         = Left "+[a b]"
lus (Atom a)                         = return $ Atom (1 + a)

tis (a :- a') | a == a'              = return $ Atom 0
tis (a :- b)                         = return $ Atom 1
tis a                                = Left "=a"

fas (Atom 1 :- a)                    = return a
fas (Atom 2 :- a :- b)               = return a
fas (Atom 3 :- a :- b)               = return b
fas (Atom a :- b) | a > 3            = do  x <- fas $ Atom (a `div` 2) :- b
                                           fas $ Atom (2 + (a `mod` 2)) :- x
fas a                                = Left "/a"

tar (a :- (b :- c) :- d)             = do x <- tar (a :- b :- c)
                                          y <- tar (a :- d)
                                          return $ x :- y

tar (a :- Atom 0 :- b)               = fas $ b :- a
tar (a :- Atom 1 :- b)               = return b
tar (a :- Atom 2 :- b :- c)          = do  x <- tar (a :- b)
                                           y <- tar (a :- c)
                                           tar $ x :- y
tar (a :- Atom 3 :- b)               = tar (a :- b) >>= wut
tar (a :- Atom 4 :- b)               = tar (a :- b) >>= lus
tar (a :- Atom 5 :- b)               = tar (a :- b) >>= tis

tar (a :- Atom 6 :- b :- c :- d)     = tar (a :- Atom 2 :- (Atom 0 :- Atom 1) :-
                                            Atom 2 :- (Atom 1 :- c :- d) :-
                                            (Atom 1 :- Atom 0) :- Atom 2 :-
                                            (Atom 1 :- Atom 2 :- Atom 3) :-
                                            (Atom 1 :- Atom 0) :- Atom 4 :-
                                            Atom 4 :- b)
tar (a :- Atom 7 :- b :- c)          = tar (a :- Atom 2 :- b :- Atom 1 :- c)
tar (a :- Atom 8 :- b :- c)          = tar (a :- Atom 7 :-
                                            ((Atom 7 :- (Atom 0 :- Atom 1) :- b) :-
                                             Atom 0 :- Atom 1) :- c)
tar (a :- Atom 9 :- b :- c)          = tar (a :- Atom 7 :- c :- Atom 2 :-
                                            (Atom 0 :- Atom 1) :- Atom 0 :- b)
tar (a :- Atom 10 :- (b :- c) :- d)  = tar (a :- Atom 8 :- c :- Atom 7 :-
                                            (Atom 0 :- Atom 3) :- d)
tar (a :- Atom 10 :- b :- c)         = tar (a :- c)

tar a                                = Left "*a"
```
