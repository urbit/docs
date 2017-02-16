---
navhome: /docs/
title: Clojure
sort: 5
next: true
---

# Clojure

From [Matt Earnshaw](https://github.com/mattearnshaw/anock/blob/master/src/anock/core.clj):

```
(ns anock.core
  (:import anock.NockException))

(declare atom? cell? cell)

(defn noun?
  "A noun is an atom or a cell."
  [noun & ns]
  (if ns false
      (or (atom? noun) (cell? noun))))

(defn atom?
  "An atom is a natural number."
  [noun & ns]
  (if ns false
   (and (integer? noun) (>= noun 0))))

(defn cell?
  "A cell is an ordered pair of nouns."
  [noun]
  (cond 
   (atom? noun) false
   (nil? noun) false
   (not= 2 (count noun)) false
   :else (and (noun? (first noun)) 
              (noun? (second noun)))))

(defn tis
  "= (pronounced 'tis') tests a cell for equality."
  [noun]
  (if (atom? noun) (throw (anock.NockException. "Cannot tis an atom."))
      (let [[a b] noun]
        (if (= a b) 0 1))))

(defn wut
  "? (pronounced 'wut') tests whether a noun is a cell."
  [noun]
  (cond
   (atom? noun) 1
   (cell? noun) 0
   :else (throw (anock.NockException. "Invalid noun."))))

(defn lus
  "+ (pronounced 'lus') adds 1 to an atom."
  [noun]
  (if (atom? noun) (inc noun)
      (throw (anock.NockException. "Can only lus atoms."))))

(defn fas
  "/ (pronounced 'fas') is a tree address function."
  [noun]
  (if (atom? noun) (throw (anock.NockException. "Cannot fas an atom."))
      (let [[a b] (cell noun)]
        (assert (and (pos? a) (atom? a)) "Subject of fas must be a positive atom.")
        (if (and (not (coll? b)) (or (= 2 a) (= 3 a)))
          (throw (anock.NockException. (str "Cannot fas noun: " noun))))
        (cond
          (= 1 a) b
          (= 2 a) (first b)
          (= 3 a) (second b)
          (even? a) (fas [2 (fas [(/ a 2) b])])
          (odd? a) (fas [3 (fas [(/ (dec a) 2) b])])))))

(defn tar
  "* (pronounced 'tar') means Nock"
  [noun]
  (if (atom? noun) (throw (anock.NockException. "Cannot tar an atom."))
      (try
        (let [noun (cell noun) [x [y z]] noun]
          (cond
            (cell? y) (cell (tar [x y]) (tar [x z]))
            (zero? y) (fas [z x])
            (= 1 y) z
            (= 3 y) (wut (tar [x z]))
            (= 4 y) (lus (tar [x z]))
            (= 5 y) (tis (tar [x z]))
            :else (let [[p q] z]
                    (cond
                      (= 2 y) (tar [(tar [x p]) (tar [x q])])
                      (= 6 y) (tar [x 2 [0 1] 2 [1 (first q) (second q)]
                                    [1 0] 2 [1 2 3] [1 0] 4 4 p])
                      (= 7 y) (tar [x 2 p 1 q])
                      (= 8 y) (tar [x 7 [[7 [0 1] p] 0 1] q])
                      (= 9 y) (tar [x 7 q 2 [0 1] 0 p])
                      (= 10 y) (if (cell? p)
                                 (tar [x 8 (second p) 7 [0 3] q])
                                 (tar [x q]))))))
        (catch RuntimeException e
          (throw (anock.NockException. (str "Cannot tar the noun " noun)))))))

(def nock tar)

; Some convenience functions
(defn apply* [f x]
  (if (and (= 1 (count x)) (coll? (first x)))
    (apply f x)
    (f x)))

(defn bracket
  "[a b c] -> [a [b c]]"
  [[a & b :as c]]
  (let [b (vec b)]
    (cond
      (and (noun? a) (apply noun? b)) (vec c)
      (apply noun? b) (apply vector (bracket a) b)
      (noun? a) [a (apply* bracket b)]
      :else [(bracket a) (apply* bracket b)])))

(defn cell [& nouns]
  (if (apply atom? nouns)
    (throw (anock.NockException. "Cannot convert atom to cell."))
    (apply* bracket nouns)))
```
