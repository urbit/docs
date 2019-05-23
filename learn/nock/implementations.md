+++
title = "Implementations"
weight = 4
template = "doc.html"
+++
We use a C implementation for our Nock interpreter. But building a Nock interpreter in another language is a fun exercise. Check out our community Nock implementations, shown below our official C implementation.  (Note: the community implementations were written for a slightly older version of Nock, Nock 5K.  The current version is Nock 4K.):

## Table of Contents

- #### [C](#C)

- #### [Clojure](#clojure)

- #### [C#](#c-sharp)

- #### [Groovy](#groovy)

- #### [Haskell](#haskell)

- #### [JavaScript](#javascript)

- #### [Python](#python)

- #### [Ruby](#ruby)

- #### [Scala](#scala)

- #### [Scheme](#scheme)

- #### [Swift](#swift)

## C Implementation

The actual production Nock interpreter.  Note gotos for tail-call elimination,
and manual reference counting.  More about the C environment can be found
in the [runtime system documentation](./docs/learn/vere/runtime.md).
```
/* _n_nock_on(): produce .*(bus fol).  Do not virtualize.
*/
static u3_noun
_n_nock_on(u3_noun bus, u3_noun fol)
{
  u3_noun hib, gal;

  while ( 1 ) {
    hib = u3h(fol);
    gal = u3t(fol);

#ifdef U3_CPU_DEBUG
    u3R->pro.nox_d += 1;
#endif

    if ( c3y == u3r_du(hib) ) {
      u3_noun poz, riv;

      poz = _n_nock_on(u3k(bus), u3k(hib));
      riv = _n_nock_on(bus, u3k(gal));

      u3a_lose(fol);
      return u3i_cell(poz, riv);
    }
    else switch ( hib ) {
      default: return u3m_bail(c3__exit);

      case 0: {
        if ( c3n == u3r_ud(gal) ) {
          return u3m_bail(c3__exit);
        }
        else {
          u3_noun pro = u3k(u3at(gal, bus));

          u3a_lose(bus); u3a_lose(fol);
          return pro;
        }
      }
      c3_assert(!"not reached");

      case 1: {
        u3_noun pro = u3k(gal);

        u3a_lose(bus); u3a_lose(fol);
        return pro;
      }
      c3_assert(!"not reached");

      case 2: {
        u3_noun nex = _n_nock_on(u3k(bus), u3k(u3t(gal)));
        u3_noun seb = _n_nock_on(bus, u3k(u3h(gal)));

        u3a_lose(fol);
        bus = seb;
        fol = nex;
        continue;
      }
      c3_assert(!"not reached");

      case 3: {
        u3_noun gof, pro;

        gof = _n_nock_on(bus, u3k(gal));
        pro = u3r_du(gof);

        u3a_lose(gof); u3a_lose(fol);
        return pro;
      }
      c3_assert(!"not reached");

      case 4: {
        u3_noun gof, pro;

        gof = _n_nock_on(bus, u3k(gal));
        pro = u3i_vint(gof);

        u3a_lose(fol);
        return pro;
      }
      c3_assert(!"not reached");

      case 5: {
        u3_noun wim = _n_nock_on(bus, u3k(gal));
        u3_noun pro = u3r_sing(u3h(wim), u3t(wim));

        u3a_lose(wim); u3a_lose(fol);
        return pro;
      }
      c3_assert(!"not reached");

      case 6: {
        u3_noun b_gal, c_gal, d_gal;

        u3x_trel(gal, &b_gal, &c_gal, &d_gal);
        {
          u3_noun tys = _n_nock_on(u3k(bus), u3k(b_gal));
          u3_noun nex;

          if ( 0 == tys ) {
            nex = u3k(c_gal);
          } else if ( 1 == tys ) {
            nex = u3k(d_gal);
          } else return u3m_bail(c3__exit);

          u3a_lose(fol);
          fol = nex;
          continue;
        }
      }
      c3_assert(!"not reached");

      case 7: {
        u3_noun b_gal, c_gal;

        u3x_cell(gal, &b_gal, &c_gal);
        {
          u3_noun bod = _n_nock_on(bus, u3k(b_gal));
          u3_noun nex = u3k(c_gal);

          u3a_lose(fol);
          bus = bod;
          fol = nex;
          continue;
        }
      }
      c3_assert(!"not reached");

      case 8: {
        u3_noun b_gal, c_gal;

        u3x_cell(gal, &b_gal, &c_gal);
        {
          u3_noun heb = _n_nock_on(u3k(bus), u3k(b_gal));
          u3_noun bod = u3nc(heb, bus);
          u3_noun nex = u3k(c_gal);

          u3a_lose(fol);
          bus = bod;
          fol = nex;
          continue;
        }
      }
      c3_assert(!"not reached");

      case 9: {
        u3_noun b_gal, c_gal;

        u3x_cell(gal, &b_gal, &c_gal);
        {
          u3_noun seb = _n_nock_on(bus, u3k(c_gal));
          u3_noun pro;

          u3t_off(noc_o);
          pro = u3j_kick(seb, b_gal);
          u3t_on(noc_o);

          if ( u3_none != pro ) {
            u3a_lose(fol);
            return pro;
          }
          else {
            if ( c3n == u3r_ud(b_gal) ) {
              return u3m_bail(c3__exit);
            }
            else {
              u3_noun nex = u3k(u3at(b_gal, seb));

              u3a_lose(fol);
              bus = seb;
              fol = nex;
              continue;
            }
          }
        }
      }
      c3_assert(!"not reached");

      case 10: {
        u3_noun p_gal, q_gal;

        u3x_cell(gal, &p_gal, &q_gal);
        {
          u3_noun zep, hod, nex;

          if ( c3y == u3r_du(p_gal) ) {
            u3_noun b_gal = u3h(p_gal);
            u3_noun c_gal = u3t(p_gal);
            u3_noun d_gal = q_gal;

            zep = u3k(b_gal);
            hod = _n_nock_on(u3k(bus), u3k(c_gal));
            nex = u3k(d_gal);
          }
          else {
            u3_noun b_gal = p_gal;
            u3_noun c_gal = q_gal;

            zep = u3k(b_gal);
            hod = u3_nul;
            nex = u3k(c_gal);
          }

          u3a_lose(fol);
          return _n_hint(zep, hod, bus, nex);
        }
      }

      case 11: {
        u3_noun ref = _n_nock_on(u3k(bus), u3k(u3h(gal)));
        u3_noun gof = _n_nock_on(bus, u3k(u3t(gal)));
        u3_noun val;

        u3t_off(noc_o);
        val = u3m_soft_esc(ref, u3k(gof));
        u3t_on(noc_o);

        if ( !_(u3du(val)) ) {
          u3m_bail(u3nt(1, gof, 0));
        }
        if ( !_(u3du(u3t(val))) ) {
          //
          //  replace with proper error stack push
          //
          u3t_push(u3nc(c3__hunk, _n_mush(gof)));
          return u3m_bail(c3__exit);
        }
        else {
          u3_noun pro;

          u3z(gof);
          u3z(fol);
          pro = u3k(u3t(u3t(val)));
          u3z(val);

          return pro;
        }
      }
      c3_assert(!"not reached");
    }
  }
}
```

## Clojure

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

## C#


From [Julien Beasley](https://github.com/zass30/Nock5KCSharp):

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NockInterpreter
{
    class Interpreter
    {
        static Dictionary<string, Noun> memocache = new Dictionary<string, Noun>();

        public static Noun Nock(Noun noun)
        {
        Start:
            Noun cache_noun;
            if (memocache.TryGetValue(noun.ToString(), out cache_noun))
            {
                return cache_noun;
            }

            if (Atom.IsAtom(noun))
                throw new Exception("Infinite loop nocking an atom: " + noun.ToString());
            else
            {
                Noun subject = noun.n1;
                if (Noun.IsCell(noun.n2))
                {
                    Cell formula = (Cell)noun.n2;
                    if (Noun.IsAtom(formula.n1)) // we have lines 25-37 of spec
                    {
                        Atom op = (Atom)formula.n1;
                        Noun operands = formula.n2;

                        switch (op.value)
                        {
                            case 0: // 25 ::    *[a 0 b]         /[b a]
                                memocache[noun.ToString()] = fas(operands, subject);
                                return memocache[noun.ToString()];
                            case 1: // 26 ::    *[a 1 b]         b
                                memocache[noun.ToString()] = operands;
                                return memocache[noun.ToString()];
                            case 2: // 27 ::    *[a 2 b c]       *[*[a b] *[a c]]
                                if (Noun.IsCell(operands))
                                {
                                    Noun a = Nock(subject, operands.n1);
                                    Noun b = Nock(subject, operands.n2);
                                    noun = Noun.CreateNoun(a, b);
                                    goto Start;
                                    //                                    return Nock(Nock(subject, operands.n1), Nock(subject, operands.n2));
                                }
                                throw new Exception("Atom after operand 2: " + operands.ToString());
                            case 3: // 28 ::    *[a 3 b]         ?*[a b]
                                memocache[noun.ToString()] = wut(Nock(subject, operands));
                                return memocache[noun.ToString()];
                            case 4: // 29 ::    *[a 4 b]         +*[a b]
                                memocache[noun.ToString()] = lus(Nock(subject, operands));
                                return memocache[noun.ToString()];
                            case 5: // 30 ::    *[a 5 b]         =*[a b]
                                memocache[noun.ToString()] = tis(Nock(subject, operands));
                                return memocache[noun.ToString()];
                            case 6: // 32 ::    *[a 6 b c d]     *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
                                if (Noun.IsCell(operands) && Noun.IsCell(operands.n2))
                                {
                                    Noun b = operands.n1;
                                    Noun c = operands.n2.n1;
                                    Noun d = operands.n2.n2;
                                    noun = Noun.CreateNoun("[" + subject + " 2 [0 1] 2 [1 " + c + " " + d + "] [1 0] 2 [1 2 3] [1 0] 4 4 " + b + "]");
                                    goto Start;
                                    //                                    return Nock(Noun.CreateNoun("[" + subject + " 2 [0 1] 2 [1 " + c + " " + d + "] [1 0] 2 [1 2 3] [1 0] 4 4 " + b + "]"));
                                }
                                throw new Exception("Unhandled pattern for operand 6");
                            case 7: // 33 ::    *[a 7 b c]       *[a 2 b 1 c]
                                if (Noun.IsCell(operands))
                                {
                                    Noun b = operands.n1;
                                    Noun c = operands.n2;
                                    noun = Noun.CreateNoun("[" + subject + " 2 " + b + " 1 " + c + "]");
                                    goto Start;
                                    //                                    return Nock(Noun.CreateNoun("[" + subject + " 2 " + b + " 1 " + c + "]"));
                                }
                                throw new Exception("Atom after operand 7: " + operands.ToString());
                            case 8: // 34 ::    *[a 8 b c]       *[a 7 [[7 [0 1] b] 0 1] c]
                                if (Noun.IsCell(operands))
                                {
                                    Noun b = operands.n1;
                                    Noun c = operands.n2;
                                    noun = Noun.CreateNoun("[" + subject + " 7 [[7 [0 1] " + b + "] 0 1] " + c + "]");
                                    goto Start;
                                    //                                    return Nock(Noun.CreateNoun("[" + subject + " 7 [[7 [0 1] " + b + "] 0 1] " + c + "]"));
                                }
                                throw new Exception("Atom after operand 8: " + operands.ToString());
                            case 9: // 35 ::    *[a 9 b c]       *[a 7 c 2 [0 1] 0 b]
                                if (Noun.IsCell(operands))
                                {
                                    Noun b = operands.n1;
                                    Noun c = operands.n2;
                                    noun = Noun.CreateNoun("[" + subject + " 7 " + c + " 2 [0 1] 0 " + b + "]");
                                    goto Start;
                                    //                                    return Nock(Noun.CreateNoun("[" + subject + " 7 " + c + " 2 [0 1] 0 " + b + "]"));
                                }
                                throw new Exception("Atom after operand 9: " + operands.ToString());
                            case 10:
                                if (Noun.IsCell(operands))
                                {
                                    if (Noun.IsCell(operands.n1)) // 36 ::    *[a 10 [b c] d]  *[a 8 c 7 [0 3] d]
                                    {
                                        Noun b = operands.n1.n1;
                                        Noun c = operands.n1.n2;
                                        Noun d = operands.n2;
                                        noun = Noun.CreateNoun("[" + subject + " 8 " + c + " 7 [0 3] " + d + "]");
                                        goto Start;
                                        //                                        return Nock(Noun.CreateNoun("[" + subject + " 8 " + c + " 7 [0 3] " + d + "]"));
                                    }
                                    else // 37 ::    *[a 10 b c]      *[a c]
                                    {
                                        Noun c = operands.n2;
                                        noun = Noun.CreateNoun(subject, c);
                                        goto Start;
                                        //                                        return Nock(subject, c);
                                    }
                                }
                                throw new Exception("Atom after operand 10: " + operands.ToString());
                            default:
                                throw new Exception("Unknown operand: " + op.value);
                        }
                    }
                    else // 23 ::    *[a [b c] d]     [*[a b c] *[a d]]
                    {
                        memocache[noun.ToString()] = Noun.CreateNoun(Nock(subject, formula.n1), Nock(subject, formula.n2));
                        return memocache[noun.ToString()];
                    }
                }
            }
            throw new Exception("Unhandled pattern");
        }

        public static Noun Nock(string program)
        {
            Noun noun = Noun.CreateNoun(program);
            return Nock(noun);
        }

        public static Noun Nock(Noun n1, Noun n2)
        {
            Noun noun = Noun.CreateNoun(n1, n2);
            return Nock(noun);
        }

        private static Noun tis(Noun noun)
        {
            if (Noun.IsAtom(noun.ToString()))
                throw new Exception("Infinite loop tising an atom: " + noun.ToString());
            else
            {
                Cell cell = (Cell)noun;

                if (cell.n1.ToString() == cell.n2.ToString())
                    return Noun.CreateNoun("0");
                else
                    return Noun.CreateNoun("1");
            }
        }

        private static Noun lus(Noun noun)
        {
            if (Noun.IsAtom(noun.ToString()))
            {
                Atom a = (Atom)noun;
                int v = a.value + 1;
                return Noun.CreateNoun(v.ToString());
            }
            else
                throw new Exception("Infinite loop lusing a cell: " + noun.ToString());
        }

        private static Noun wut(Noun noun)
        {
            if (Noun.IsAtom(noun.ToString()))
                return Noun.CreateNoun("1");
            else
                return Noun.CreateNoun("0");
        }

        private static Noun fas(Noun n1, Noun n2)
        {
            Noun noun = Noun.CreateNoun(n1, n2);
            return fas(noun);
        }

        private static Noun fas(Noun noun)
        {
            if (Noun.IsAtom(noun.ToString()))
                throw new Exception("Infinite loop fasing an atom: " + noun.ToString());
            else
            {
                Cell c = (Cell)noun;
                // If n1 isn't an atom, I assume we throw? This isn't defined in the spec. Confirmed by John B by email. This spins forever.
                if (Noun.IsCell(c.n1.ToString()))
                    throw new Exception("Axis must be an atom: " + c.ToString());
                else
                {
                    Atom a = (Atom)c.n1;
                    if (a.value == 1)
                        return c.n2;
                    else if (a.value >= 2)
                    {
                        if (!Noun.IsCell(c.n2.ToString()))
                        {
                            throw new Exception("Only a cell can have an axis of 2 or 3: " + c.n2.ToString());
                        }
                        else
                        {
                            Cell c2 = (Cell)c.n2;
                            if (a.value == 2)
                                return c2.n1;
                            else if (a.value == 3)
                                return c2.n2;
                            else if (a.value % 2 == 0)
                            {
                                int half = a.value / 2;
                                return fas(Noun.CreateNoun("2", fas(Noun.CreateNoun(half.ToString(), c2))));
                            }
                            else if (a.value % 2 == 1)
                            {
                                int half = a.value / 2;
                                return fas(Noun.CreateNoun("3", fas(Noun.CreateNoun(half.ToString(), c2))));
                            }
                            else
                            {
                                throw new Exception("Infinite loop somewhere in fasing: " + c.n2.ToString());
                            }
                        }
                    }
                }
                throw new Exception("Infinite loop somewhere in fasing: " + c.n2.ToString());
            }
        }
    }

    class Noun
    {
        public Noun n1;
        public Noun n2;

        // takes a program, returns a pair of nouns, stringified.
        public static Tuple<string, string> SplitCell(string program)
        {

            int stackCount = 0;
            int i = 0;
            // split the string right after the first space
            foreach (char c in program)
            {
                if (IsValidChar(c))
                {
                    if (c == '[')
                        stackCount++;
                    else if (c == ']')
                        stackCount--;
                    else if (c == ' ')
                    {
                        // if we see a space, and our stack count is at 1, then we've found our split point
                        if (stackCount == 1)
                        {
                            string a = program.Substring(1, i - 1);
                            string b = program.Substring(i + 1, program.Length - (i + 2));

                            // to implement proper bracket closing, surround b with brackets if it isn't a cell and isn't an atom
                            if (!IsCell(b) && !IsAtom(b))
                                b = "[" + b + "]";
                            Tuple<string, string> tuple = new Tuple<string, string>(a, b);
                            return tuple;
                        }
                    }
                }
                else
                    throw new Exception("Invalid char in cell: " + c);
                i++;
            }
            throw new Exception("Invalid cell: " + program);
        }

        public static bool IsCell(string program)
        {
            // check if cell is valid, as above but make sure no space after bracket
            // valid tokens are: space, int, [, ]
            // from [ => [, int
            // from int => space, ], int
            // from ] => space, ]
            // from space => int, [

            // stack count must always be nonzero
            // first and last elements must be [ and ]

            int i = 0; // i is the stack count for brackets.
            int counter = 0;
            char s = '\0'; // s is the last seen character
            // split the string right after the first space
            foreach (char c in program)
            {
                if (s == '\0')
                {
                    if (c != '[')
                        return false;
                }
                else if (s == '[')
                {
                    if (!(c == '[' || IsInt(c)))
                        return false;
                }
                else if (IsInt(s))
                {
                    if (!(IsInt(c) || c == ' ' || c == ']'))
                        return false;
                }
                else if (s == ']')
                {
                    if (!(c == ']' || c == ' '))
                        return false;
                }
                else if (s == ' ')
                {
                    if (!(c == '[' || IsInt(c)))
                        return false;
                }
                s = c;
                counter++;
                if (c == '[')
                    i++;
                else if (c == ']')
                    i--;
                if (i <= 0 && counter != program.Length) // stack count can't be zero unless it's the last character
                    return false;
            }

            // We should end with stack count of zero
            if (i == 0)
                return true;
            else
                return false;
        }

        public static bool IsInt(char c)
        {
            if (c == '0' ||
                c == '1' ||
                c == '2' ||
                c == '3' ||
                c == '4' ||
                c == '5' ||
                c == '6' ||
                c == '7' ||
                c == '8' ||
                c == '9')
                return true;
            else
                return false;
        }

        public static bool IsValidChar(char c)
        {
            if (c == ' ' ||
                c == '[' ||
                c == ']' ||
                IsInt(c))
                return true;
            else
                return false;
        }

        public static bool IsAtom(string program)
        {
            int i = 0;
            if (int.TryParse(program, out i))
            {
                if (i >= 0)
                    return true;
            }
            return false;
        }

        public static bool IsAtom(Noun noun)
        {
            return IsAtom(noun.ToString());
        }

        public static bool IsCell(Noun noun)
        {
            return IsCell(noun.ToString());
        }

        public static Noun CreateNoun(string program)
        {
            if (IsAtom(program))
                return new Atom(program);
            else
                return new Cell(program);
        }

        public static Noun CreateNoun(Noun n1, Noun n2)
        {
            return CreateNoun("[" + n1.ToString() + " " + n2.ToString() + "]");
        }

        public static Noun CreateNoun(string p1, Noun n2)
        {
            return CreateNoun("[" + p1 + " " + n2.ToString() + "]");
        }

        public static Noun CreateNoun(Noun n1, string p2)
        {
            return CreateNoun("[" + n1.ToString() + " " + p2 + "]");
        }

        public static Noun CreateNoun(string p1, string p2)
        {
            return CreateNoun("[" + p1 + " " + p2 + "]");
        }
    }

    class Atom : Noun
    {
        public int value;

        public override string ToString()
        {
            return value.ToString();
        }

        public Atom(string program)
        {
            if (IsAtom(program))
            {
                int i = 0;
                bool result = int.TryParse(program, out i);
                value = i;
            }
            else
                throw new ArgumentException("Invalid Atom: " + program);
            n1 = null;
            n2 = null;
        }
    }

    class Cell : Noun
    {
        public override string ToString()
        {
            return "[" + n1.ToString() + " " + n2.ToString() + "]";
        }

        public Cell(string program)
        {
            if (IsCell(program))
            {
                Tuple<string, string> split = SplitCell(program);
                n1 = CreateNoun(split.Item1);
                n2 = CreateNoun(split.Item2);
            }
            else
                throw new ArgumentException("Invalid Cell: " + program);
        }
    }
}
```

## Groovy

From [Kohányi Róbert](https://github.com/kohanyirobert/gnock/blob/master/gnock.groovy):

```
@Memoized
def i(def a) {
  a.class in [
    byte, Byte,
    char, Character,
    short, Short,
    int, Integer,
    long, Long,
    BigInteger
  ] && a >= 0
}

@Memoized
def n(def a) {
  def r
  n(a, { r = it })
  r
}

@TailRecursive
def n(def a, def r) {
  if (a in List) {
    if (a.size() == 1) {
      r(a[0])
    } else if (a.size() >= 2) {
      n(a[0], { t ->
        n(a.size() == 2 ? a[1] : a.tail(), { h ->
          r([t, h])
        })
      })
    } else {
      throw new IllegalStateException()
    }
  } else if (i(a)) {
    r((BigInteger) a)
  } else {
    throw new IllegalStateException()
  }
}

@Memoized
def wut(def a) {
  i(a) ? 1 : 0
}

@Memoized
def lus(def a) {
  if (wut(a) == 0) {
    throw new IllegalStateException()
  }
  1 + a
}

@Memoized
def tis(def a) {
  if (wut(a) == 1) {
    throw new IllegalStateException()
  }
  a[0] == a[1] ? 0 : 1
}

@Memoized
def fas(def a) {
  def r
  fas(a, { r = it })
  r
}

@TailRecursive
def fas(def a, def r) {
  if (wut(a) == 1) {
    throw new IllegalStateException()
  }
  def h = a[0]
  if (!i(h)) {
    throw new IllegalStateException()
  }
  def t = a[1]
  if (h == 0) {
    throw new IllegalStateException()
  } else if (h == 1) {
    r(t)
  } else {
    if (i(t)) {
      throw new IllegalStateException()
    }
    if (h == 2) {
      r(t[0])
    } else if (h == 3) {
      r(t[1])
    } else {
      fas([h.intdiv(2), t], { p ->
        fas([2 + h.mod(2), p], { q ->
          r(q)
        })
      })
    }
  }
}

@Memoized
def tar(def a) {
  def r
  tar(a, { r = it})
  r
}

@TailRecursive
def tar(def a, def r) {
  if (wut(a) == 1) {
    throw new IllegalStateException()
  }
  def s = a[0]
  def f = a[1]
  if (wut(f) == 1) {
    throw new IllegalStateException()
  }
  def o = f[0]
  def v = f[1]
  if (wut(o) == 0) {
    tar([s, o], { p ->
      tar([s, v], { q ->
        r([p, q])
      })
    })
  } else {
    if (o == 0) {
      r(fas([v, s]))
    } else if (o == 1) {
      r(v)
    } else if (o == 3) {
      tar([s, v], {
        r(wut(it))
      })
    } else if (o == 4) {
      tar([s, v], {
        r(lus(it))
      })
    } else if (o == 5) {
      tar([s, v], {
        r(tis(it))
      })
    } else {
      if (wut(v) == 1) {
        throw new IllegalStateException()
      }
      def x = v[0]
      def y = v[1]
      if (o == 2) {
        tar([s, x], { p ->
          tar([s, y], { q ->
            tar([p, q], {
              r(it)
            })
          })
        })
      } else if (o == 7) {
        tar(n([s, 2, x, 1, y]), {
          r(it)
        })
      } else if (o == 8) {
        tar(n([s, 7, [[7, [0, 1], x], 0, 1], y]), {
          r(it)
        })
      } else if (o == 9) {
        tar(n([s, 7, y, 2, [0, 1], 0, x]), {
          r(it)
        })
      } else if (o == 10) {
        if (wut(x) == 1) {
          tar([s, y], {
            r(it)
          })
        } else {
          tar(n([s, 8, x[1], 7, [0, 3], y]), {
            r(it)
          })
        }
      } else {
        if (wut(y) == 1) {
          throw new IllegalStateException()
        }
        if (o == 6) {
          tar(n([s, 2, [0, 1], 2, [1, y[0], y[1]], [1, 0], 2, [1, 2, 3], [1, 0], 4, 4, x]), {
            r(it)
          })
        } else {
          throw new IllegalStateException()
        }
      }
    }
  }
}
```

## Haskell

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

## Hoon

```
|=  {sub/* fol/*}
^-  *
?<  ?=(@ fol)
?:  ?=(^ -.fol)
  [$(fol -.fol) $(fol +.fol)]
?+    fol
  !!
    {$0 b/@}
  ?<  =(0 b.fol)
  ?:  =(1 b.fol)  sub
  ?<  ?=(@ sub)
  =+  [now=(cap b.fol) lat=(mas b.fol)]
  $(b.fol lat, sub ?:(=(2 now) -.sub +.sub))
::
    {$1 b/*}
  b.fol
::
    {$2 b/{^ *}}
  =+  ben=$(fol b.fol)
  $(sub -.ben, fol +.ben)
::
    {$3 b/*}
  =+  ben=$(fol b.fol)
  .?(ben)
::
    {$4 b/*}
  =+  ben=$(fol b.fol)
  ?>  ?=(@ ben)
  +(ben)
::
    {$5 b/*}
  =+  ben=$(fol b.fol)
  ?>  ?=(^ ben)
  =(-.ben +.ben)
::
    {$6 b/* c/* d/*}
  $(fol =>(fol [2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]))
::
    {$7 b/* c/*}         $(fol =>(fol [2 b 1 c]))
    {$8 b/* c/*}         $(fol =>(fol [7 [[7 [0 1] b] 0 1] c]))
    {$9 b/* c/*}         $(fol =>(fol [7 c 2 [0 1] 0 b]))
    {$10 @ c/*}          $(fol c.fol)
    {$10 {b/* c/*} d/*}  =+($(fol c.fol) $(fol d.fol))
==
```

## JavaScript

From [Joe Bryan](https://github.com/joemfb/nock.js/blob/master/nock.js):

```
(function (self, factory) {
  'use strict'

  if (typeof define === 'function' && define.amd) {
    define([], factory)
  } else if (typeof module === 'object' && typeof module.exports === 'object') {
    module.exports = factory()
  } else {
    self.nock = factory()
  }
}(this, function () {
  'use strict'

  /**
   * Nock is a combinator interpreter on nouns. A noun is an atom or a cell.
   * An atom is an unsigned integer of any size; a cell is an ordered pair of nouns.
   *
   * @see http://urbit.org/docs/nock/definition/
   * @see https://media.urbit.org/whitepaper.pdf
   */

  var useMacros = false

  /*
   *  code conventions:
   *
   *    `n` is a noun,
   *    `s` is a subject noun,
   *    `f` is a formula (or cell of formulas)
   */

  /*  operators  */

  /**
   * wut (?): test for atom (1) or cell (0)
   *
   *   ?[a b]           0
   *   ?a               1
   */
  function wut (n) {
    return typeof n === 'number' ? 1 : 0
  }

  /**
   * lus (+): increment an atom
   *
   *   +[a b]           +[a b]
   *   +a               1 + a
   */
  function lus (n) {
    if (wut(n) === 0) throw new Error('lus cell')
    return 1 + n
  }

  /**
   * tis (=): test equality
   *
   *   =[a a]           0
   *   =[a b]           1
   *   =a               =a
   */
  function tis (n) {
    if (wut(n) === 1) throw new Error('tis atom')
    return deepEqual(n[0], n[1]) ? 0 : 1
  }

  /**
   * fas (/): resolve a tree address
   *
   *   /[1 a]           a
   *   /[2 a b]         a
   *   /[3 a b]         b
   *   /[(a + a) b]     /[2 /[a b]]
   *   /[(a + a + 1) b] /[3 /[a b]]
   *   /a               /a
   */
  function fas (addr, n) {
    if (n === undefined) throw new Error('invalid fas noun')
    if (addr === 0) throw new Error('invalid fas addr: 0')

    if (addr === 1) return n
    if (addr === 2) return n[0]
    if (addr === 3) return n[1]

    return fas(2 + (addr % 2), fas((addr / 2) | 0, n))
  }

  /*  formulas  */

  /**
   * slot (0): resolve a tree address
   *
   *   *[a 0 b]         /[b a]
   */
  function slot (s, f) {
    var p = fas(f, s)

    if (p === undefined) throw new Error('invalid fas addr: ' + f)

    return p
  }

  /**
   * constant (1): return the formula regardless of subject
   *
   *   *[a 1 b]  b
   */
  function constant (s, f) {
    return f
  }

  /**
   * evaluate (2): evaluate the product of second formula against the product of the first
   *
   *   *[a 2 b c]  *[*[a b] *[a c]]
   */
  function evaluate (s, f) {
    return nock(nock(s, f[0]), nock(s, f[1]))
  }

  /**
   * cell (3): test if the product is a cell
   *
   *   *[a 3 b]         ?*[a b]
   */
  function cell (s, f) {
    return wut(nock(s, f))
  }

  /**
   *  incr (4): increment the product
   *
   *   *[a 4 b]         +*[a b]
   */
  function incr (s, f) {
    return lus(nock(s, f))
  }

  /**
   * eq (5): test for equality between nouns in the product
   *
   *   *[a 5 b]         =*[a b]
   */
  function eq (s, f) {
    return tis(nock(s, f))
  }

  /*  macro-formulas  */

  /**
   * ife (6): if/then/else
   *
   *   *[a 6 b c d]      *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
   */
  function macroIfe (s, f) {
    return nock(s, [2, [[0, 1], [2, [[1, [f[1][0], f[1][1]]], [[1, 0], [2, [[1, [2, 3]], [[1, 0], [4, [4, f[0]]]]]]]]]]])
  }

  function ife (s, f) {
    var cond = nock(s, f[0])

    if (cond === 0) return nock(s, f[1][0])
    if (cond === 1) return nock(s, f[1][1])

    throw new Error('invalid ife conditional')
  }

  /**
   * compose (7): evaluate formulas composed left-to-right
   *
   *   *[a 7 b c]  *[a 2 b 1 c]
   */
  function macroCompose (s, f) {
    return nock(s, [2, [f[0], [1, f[1]]]])
  }

  function compose (s, f) {
    // alternate form:
    // return nock(nock(s, f[0]), constant(s, f[1]))
    return nock(nock(s, f[0]), f[1])
  }

  /**
   * extend (8): evaluate the second formula against [product of first, subject]
   *
   *   *[a 8 b c]  *[a 7 [[7 [0 1] b] 0 1] c]
   */
  function macroExtend (s, f) {
    return nock(s, [7, [[[7, [[0, 1], f[0]]], [0, 1]], f[1]]])
  }

  function extend (s, f) {
    // alternate form:
    // return nock([compose(s, [[0, 1], f[0]]), s], f[1])
    return nock([nock(s, f[0]), s], f[1])
  }

  /**
   * invoke (9): construct a core and evaluate one of it's arms against it
   *
   *   *[a 9 b c]  *[a 7 c 2 [0 1] 0 b]
   */
  function macroInvoke (s, f) {
    return nock(s, [7, [f[1], [2, [[0, 1], [0, f[0]]]]]])
  }

  function invoke (s, f) {
    var prod = nock(s, f[1])
    return nock(prod, slot(prod, f[0]))
  }

  /**
   * hint (10): skip first formula, evaluate second
   *
   *   *[a 10 [b c] d]  *[a 8 c 7 [0 3] d]
   *   *[a 10 b c]      *[a c]
   */
  function macroHint (s, f) {
    if (wut(f[0]) === 0) return nock(s, [8, [f[0][1], [7, [[0, 3], f[1]]]]])
    return nock(s, f[1])
  }

  function hint (s, f) {
    if (wut(f[0]) === 0) {
      if (wut(f[0][1]) === 1) throw new Error('invalid hint')
      nock(s, f[0][1])
    }
    return nock(s, f[1])
  }

  /*  indexed formula functions  */
  var macroFormulas = [slot, constant, evaluate, cell, incr, eq, macroIfe, macroCompose, macroExtend, macroInvoke, macroHint]
  var formulas = [slot, constant, evaluate, cell, incr, eq, ife, compose, extend, invoke, hint]

  /**
   * nock (*)
   *
   * the nock function
   *
   *   *[a [b c] d]     [*[a b c] *[a d]]
   *   *a               *a
   */
  function nock (s, f) {
    if (wut(f[0]) === 0) return [nock(s, f[0]), nock(s, f[1])]

    var idx = f[0]

    if (idx > 10) throw new Error('invalid formula: ' + idx)

    if (useMacros) return macroFormulas[idx](s, f[1])

    return formulas[idx](s, f[1])
  }

  /* construct a JS noun (group an array into pairs, associating right) */
  function assoc (x) {
    if (!x.length) return x

    if (x.length === 1) return assoc(x[0])

    return [assoc(x[0]), assoc(x.slice(1))]
  }

  /* deep equality for arrays or primitives */
  function deepEqual (a, b) {
    if (a === b) return true

    if (!(Array.isArray(a) && Array.isArray(b))) return false
    if (a.length !== b.length) return false

    for (var i = 0; i < a.length; i++) {
      if (!deepEqual(a[i], b[i])) return false
    }

    return true
  }

  /* parse a hoon-serialized nock formula and construct a JS noun */
  function parseNoun (x) {
    if (Array.isArray(x)) return assoc(x)

    if (typeof x === 'string') {
      var str = x.replace(/[\."']/g, '').split(' ').join(',')
      return assoc(JSON.parse(str))
    }

    return x
  }

  function nockInterface () {
    var args = [].slice.call(arguments)
    var subject, formula, noun

    if (args.length === 1) {
      formula = parseNoun(args[0])
    } else if (args.length === 2) {
      subject = parseNoun(args[0])
      formula = parseNoun(args[1])
    } else {
      noun = assoc(args)
      subject = noun[0]
      formula = noun[1]
    }

    if (!formula) throw new Error('formula required')

    if (!subject) {
      // !=(~)
      subject = [1, 0]
    }

    return nock(subject, formula)
  }

  return {
    nock: nockInterface,
    _nock: nock,
    useMacros: function (arg) {
      useMacros = arg === undefined || arg
      return this
    },
    util: {
      assoc: assoc,
      parseNoun: parseNoun,
      deepEqual: deepEqual
    },
    operators: {
      wut: wut,
      lus: lus,
      tis: tis,
      fas: fas
    },
    formulas: {
      slot: slot,
      constant: constant,
      evaluate: evaluate,
      cell: cell,
      incr: incr,
      eq: eq,
      macroIfe: macroIfe,
      ife: ife,
      macroCompose: macroCompose,
      compose: compose,
      macroExtend: macroExtend,
      extend: extend,
      macroInvoke: macroInvoke,
      invoke: invoke,
      macroHint: macroHint,
      hint: hint
    }
  }
}))
```

## Python

From [James Tauber](https://github.com/jtauber/pynock/blob/master/nock.py):

```
#!/usr/bin/env python3

# []
def l(*lst):
    if len(lst) == 1:
        return(lst[0], 0)
    if len(lst) == 2:
        return lst
    else:
        return (lst[0], l(*lst[1:]))

# *
def nock(noun):
    return tar(noun)

# ?
def wut(noun):
    if isinstance(noun, int):
        return 1
    else:
        return 0


# +
def lus(noun):
    if isinstance(noun, int):
        return 1 + noun
    else:
        return noun


# =
def tis(noun):
    if noun[0] == noun[1]:
        return 0
    else:
        return 1


# /
def slot(noun):
    if noun[0] == 1:
        return noun[1]
    elif noun[0] == 2:
        return noun[1][0]
    elif noun[0] == 3:
        return noun[1][1]
    elif noun[0] % 2 == 0:
        return slot((2, slot((noun[0] // 2, noun[1]))))
    elif noun[0] % 2 == 1:
        return slot((3, slot(((noun[0] - 1) // 2, noun[1]))))


def tar(noun):
    if isinstance(noun[1][0], int):
        if noun[1][0] == 0:
            return slot((noun[1][1], noun[0]))
        elif noun[1][0] == 1:
            return noun[1][1]
        elif noun[1][0] == 2:
            return nock((nock((noun[0], noun[1][1][0])), nock((noun[0], noun[1][1][1]))))
        elif noun[1][0] == 3:
            return wut(nock((noun[0], noun[1][1])))
        elif noun[1][0] == 4:
            return lus(nock((noun[0], noun[1][1])))
        elif noun[1][0] == 5:
            return tis(nock((noun[0], noun[1][1])))
        elif noun[1][0] == 6:
            return nock(l(noun[0], 2, (0, 1), 2, l(1, noun[1][1][1][0], noun[1][1][1][1]), (1, 0), 2, l(1, 2, 3), (1, 0), 4, 4, noun[1][1][0]))
        elif noun[1][0] == 7:
            return nock(l(noun[0], 2, noun[1][1][0], 1, noun[1][1][1]))
        elif noun[1][0] == 8:
            return nock(l(noun[0], 7, l(l(7, (0, 1), noun[1][1][0]), 0, 1), noun[1][1][1]))
        elif noun[1][0] == 9:
            return nock(l(noun[0], 7, noun[1][1][1], l(2, (0, 1), (0, noun[1][1][0]))))
        elif noun[1][0] == 10:
            if isinstance(noun[1][1][0], int):
                return nock((noun[0], noun[1][1][1]))
            else:
                return nock(l(noun[0], 8, noun[1][1][0][1], 7, (0, 3), noun[1][1][1][0]))
    else:
        return (nock((noun[0], noun[1][0])), nock((noun[0], noun[1][1])))
```

## Ruby

From [T.J. Corcoran](https://github.com/TJamesCorcoran/nock/blob/master/nock.rb):

```
def str_to_tree(str)
  arr = []
  str.scan(/\+|\=|\?|\/|\*|\[|\]|\d+/).each do |token|
  end
end

def max_depth(arr)
  ret = arr.is_a?(Array) ?  [max_depth(arr[0]), max_depth(arr[1])].max + 1 : 1
  ret
end

def pp(arr)
  depth = max_depth(arr)
  space = 128
  1.up_to(8) do |depth|
    space = space / 2
    min = 2 ** (depth - 1)
    max = (2 ** depth) - 1
    min.upto(max) { |axis|
  end

end

def norm(arr)
  return arr unless arr.is_a?(Array)
  while arr.size > 2
    size = arr.size
    arr[size - 2] = [ arr[size - 2], arr.pop ]
  end
  arr = arr.map { |x| norm(x)   }
end

def wut(arr)
  arr.is_a?(Array) ? YES : NO
end

def lus(atom)
  raise "not an atom" unless atom.is_a?(Fixnum)
  atom + 1
end

def tis(arr)
  raise "not pair" unless arr.is_a?(Array) && arr.size == 2
  ( arr[0] == arr[1] ) ? YES : NO
end

def slot(axis, arr, allow_error = true)
  raise "axis on atom" unless arr.is_a?(Array)
  return arr if axis == 1
  return arr[0] if axis == 2
  return arr[1] if axis == 3
  return slot(2, slot(axis/2, arr))   if (axis %2) == 0
  return slot(3, slot(axis/2, arr))
end


def nock(arr)
  raise "error: nocking an atom" unless arr.is_a?(Array)

  oper = slot(4, arr)
  a    = slot(2, arr)
  b    = slot(5, arr)

  if oper.is_a?(Array)
    return  [ nock( [ a, [b, c]]), nock( [a, d]) ]
  end


  case oper
    when 0 then
    slot(b,a )

    when 1 then
    b

    when 2 then
    b_prime = slot(2, b)
    c       = slot(3,b)
    nock( [ nock([a, b_primce]), nock([a, c]) ])

    when 3 then
    wut(nock([a, b]))

    when 4 then
    lus(nock([a, b]))

    when 5 then
    tis(nock([a, b]))

    when 6 then
    b_prime = slot(2, b)
    c = slot(6,b)
    d = slot(7,b)
    nock( norm([a, 2, [0, 1], 2, [1, c, d], [1, 0], 2, [1, 2, 3], [1, 0], 4, 4, b]) )

    when 7 then
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 2, b_prime, 1, c]))

    when 8 then
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 7, [[7, [0, 1], b_prime], 0, 1], c]))

    when 9 then
    b_prime = slot(2, b)
    c = slot(3,b)
    nock( norm ([a, 7, c, 2, [0, 1], 0, b_prime]))

    when 10 then
    if wut(slot(2,b)) == TRUE
      b_prime = slot(4, b)
      c       = slot(5, b)
      d       = slot(3, b)
      c = slot(3,b)
      nock( norm ([a, 8, c, 7, [0, 3], d]))
    else
      b_prime = slot(2, b)
      c       = slot(3, b)
      nock( norm ([a, 10, [b, c]]))
    end
    else
      raise "error: unknown opcode #{oper.inspect}"
    end
end
```

## Scala

From [Steve Randy Waldman](https://github.com/swaldman/nnnock/blob/master/src/main/scala/com/mchange/sc/v1/nnnock/package.scala):

```
package object nnnock {

  sealed trait Noun;
  case class Atom( value : Int ) extends Noun;
  case class Cell( head : Noun, tail : Noun ) extends Noun;
  implicit def toAtom( value : Int ) : Atom = Atom( value );
  implicit def toInt( atom : Atom ) : Int = atom.value;

  def nock( a : Noun ) : Noun = *(a)


  object Cell {
    private def apply( nl : List[Noun] ) : Cell = {
      nl match {
  case a :: b :: Nil => Cell(a, b);
  case a :: b :: c :: Nil => Cell(a, Cell(b, c));
  case a :: b :: c :: tail => Cell(a, this.apply( b :: c :: tail ) );
      }
    }
    def apply(a : Noun, b : Noun, tail : Noun*) : Cell = apply( a :: b :: tail.toList );
  }

  def ?( noun : Noun ) : Noun = noun match {
    case _ : Cell => 0;
    case _ : Atom => 1;
  }

  @tailrec def plus( noun : Noun ) : Noun = noun match {
    case a : Atom => 1 + a;
    case c : Cell => plus( c ); //intentional endless spin
  }

  def heq( noun : Noun ) : Atom = noun match {
    case Cell( a : Atom, b : Atom ) => if ( a == b ) 0 else 1;
    case Cell( a : Cell, b : Atom ) => 1;
    case Cell( a : Atom, b : Cell ) => 1;
    case Cell( a : Cell, b : Cell ) => if ((heq( Cell( a.head, b.head ) ) | heq( Cell( a.tail, b.tail ) )) == 0) 0 else 1;
    case a : Atom => heq( a ); //intentional endless spin
  }

  def /( noun : Noun ) : Noun = noun match {
    case Cell(Atom(1), a) => a;
    case Cell(Atom(2), Cell(a, b)) => a;
    case Cell(Atom(3), Cell(a, b)) => b;
    case Cell(Atom(value), b ) => {
      val a = value / 2;
      val num = if ( value % a == 0 ) 2 else 3;
      /(Cell(num, /(Cell(a, b))));
    }
    case a => /( a ); //intentional endless spin
  }


    def *( noun : Noun ) : Noun = noun match {
      case Cell( a, Cell(Cell(b, c), d) ) => Cell( *(Cell(a,b,c)), *(Cell(a,d)) );
      case Cell( a, Cell(Atom(value), tail) ) => {
        (value, tail) match {
    case (0, b) => /( Cell(b, a) );
    case (1, b) => b;
    case (2, Cell(b, c)) => *( Cell( *( Cell(a,b) ), *( Cell(a,c) ) ) );
    case (3, b) => ?( *( Cell(a,b) ) );
    case (4, b) => plus( *( Cell(a,b) ) );
    case (5, b) => heq( *( Cell(a,b) ) );
    case (6, Cell(b, Cell(c, d))) => *( Cell(a,2,Cell(0,1),2,Cell(1,c,d),Cell(1,0),2,Cell(1,2,3),Cell(1,0),4,4,b) ); //wtf?
    case (7, Cell(b, c)) => *( Cell(a,2,b,1,c) );
    case (8, Cell(b, c)) => *( Cell(a,7,Cell(Cell(7,Cell(0,1),b),0,1),c) ); //wtf2
    case (9, Cell(b, c)) => *( Cell(a,7,c,2,Cell(0,1),0,b) );
    case (10, Cell(Cell(b,c),d)) => *( Cell(a,8,c,7,Cell(0,3),d) );
    case (10, Cell(b, c)) => *( Cell(a,c) );
    case _ => *( noun ); //intentional endless spin
        }
      }
      case a => *( a ); //intentional endless spin
    }
  }
```

## Scheme

From [Kohányi Róbert](https://github.com/kohanyirobert/snock/blob/master/snock.ss):

```
(import (rnrs (6)))

(define (i a) a)

(define (n a r)
  (cond
    ((list? a)
     (let ((l (length a)))
       (cond
         ((equal? l 0) (raise 1))
         ((equal? l 1) (r (car a)))
         (else
           (let ((t (cond
                      ((equal? l 2) (cadr a))
                      (else (cdr a)))))
             (n (car a)
                (lambda (p) (n t
                               (lambda (q) (r (cons p q)))))))))))
    ((fixnum? a) (r a))
    (else (raise 2))))

(define (wut a)
  (cond
    ((fixnum? a) 1)
    (else 0)))

(define (lus a)
  (cond
    ((equal? (wut a) 0) (raise 3))
    (else (+ 1 a))))

(define (tis a)
  (cond
    ((equal? (wut a) 1) (raise 4))
    ((equal? (car a) (cdr a)) 0)
    (else 1)))

(define (fas a r)
  (cond
    ((equal? (wut a) 1) (raise 5))
    (else
      (let ((h (car a))
          (t (cdr a)))
      (cond
        ((not (fixnum? h)) (raise 6))
        ((equal? h 0) (raise 7))
        ((equal? h 1) (r t))
        ((fixnum? t) (raise 8))
        ((equal? h 2) (r (car t)))
        ((equal? h 3) (r (cdr t)))
        (else
            (fas (cons (div h 2) t)
                 (lambda (p) (fas (cons (+ 2 (mod h 2)) p)
                                  (lambda (q) (r q)))))))))))

(define (tar a r)
  (cond
    ((equal? (wut a) 1) (raise 9))
    (else
      (let ((s (car a))
            (f (cdr a)))
        (cond
          ((equal? (wut f) 1) (raise 10))
          (else
            (let ((o (car f))
                  (v (cdr f)))
              (cond
                ((equal? (wut o) 0) (tar (cons s o)
                                         (lambda (p) (tar (cons s v)
                                                          (lambda (q) (r (cons p q)))))))
                ((equal? o 0) (r (fas (cons v s) i)))
                ((equal? o 1) (r v))
                ((equal? o 3) (tar (cons s v)
                                   (lambda (p) (r (wut p)))))
                ((equal? o 4) (tar (cons s v)
                                   (lambda (p) (r (lus p)))))
                ((equal? o 5) (tar (cons s v)
                                   (lambda (p) (r (tis p)))))
                ((equal? (wut v) 1) (raise 11))
                (else
                  (let ((x (car v))
                        (y (cdr v)))
                    (cond
                      ((equal? o 2) (tar (cons s x)
                                         (lambda (p) (tar (cons s y)
                                                          (lambda (q) (tar (cons p q)
                                                                           (lambda (u) (r u))))))))
                      ((equal? o 7) (tar (n (list (list s) 2 (list x) 1 (list y)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 8) (tar (n (list (list s) 7 (list (list 7 (list 0 1) (list x)) 0 1) (list y)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 9) (tar (n (list (list s) 7 (list y) 2 (list 0 1) 0 (list x)) i)
                                         (lambda (p) (r p))))
                      ((equal? o 10) (cond
                                       ((equal? (wut x) 1) (tar (cons s y)
                                                                (lambda (p) (r p))))
                                       (else (tar (n (list (list s) 8 (list (cdr x)) 7 (list 0 3) (list y)) i)
                                                  (lambda (p) (r p))))))
                      ((equal? (wut y) 1) (raise 12))
                      ((equal? o 6) (tar (n (list
                                              (list s)
                                              2
                                              (list 0 1)
                                              2
                                              (list 1 (list (car y)) (list (cdr y)))
                                              (list 1 0)
                                              2
                                              (list 1 2 3)
                                              (list 1 0)
                                              4
                                              4
                                              (list x))
                                            i)
                                         (lambda (p) (r p))))
                      (else (raise 13)))))))))))))
```

## Swift

```
import Foundation
//  1   ::  A noun is an atom or a cell.
//  2   ::  An atom is a natural number.
//  3   ::  A cell is an ordered pair of nouns.
//  4
//  5   ::  nock(a)             *a
//  6   ::  [a b c]             [a [b c]]
//  7
//  8   ::  ?[a b]              0
//  9   ::  ?a                  1
// 10   ::  +[a b]              +[a b]
// 11   ::  +a                  1 + a
// 12   ::  =[a a]              0
// 13   ::  =[a b]              1
// 14   ::  =a                  =a
// 15
// 16   ::  /[1 a]              a
// 17   ::  /[2 a b]            a
// 18   ::  /[3 a b]            b
// 19   ::  /[(a + a) b]        /[2 /[a b]]
// 20   ::  /[(a + a + 1) b]    /[3 /[a b]]
// 21   ::  /a                  /a
// 22
// 23   ::  *[a [b c] d]        [*[a b c] *[a d]]
// 24
// 25   ::  *[a 0 b]            /[b a]
// 26   ::  *[a 1 b]            b
// 27   ::  *[a 2 b c]          *[*[a b] *[a c]]
// 28   ::  *[a 3 b]            ?*[a b]
// 29   ::  *[a 4 b]            +*[a b]
// 30   ::  *[a 5 b]            =*[a b]
// 31
// 32   ::  *[a 6 b c d]        *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
// 33   ::  *[a 7 b c]          *[a 2 b 1 c]
// 34   ::  *[a 8 b c]          *[a 7 [[7 [0 1] b] 0 1] c]
// 35   ::  *[a 9 b c]          *[a 7 c 2 [0 1] 0 b]
// 36   ::  *[a 10 [b c] d]     *[a 8 c 7 [0 3] d]
// 37   ::  *[a 10 b c]         *[a c]
// 38
// 39   ::  *a                  *a

//  1   ::  A noun is an atom or a cell.
public indirect enum Noun: IntegerLiteralConvertible, ArrayLiteralConvertible, Equatable, Hashable, CustomStringConvertible
{
    //  2   ::  An atom is a natural number.
    public typealias ATOM = UIntMax

    case Atom(ATOM)
    //  3   ::  A cell is an ordered pair of nouns.
    case Cell(Noun, Noun)
    case Invalid

    public static var YES: Noun { return .Atom(0) }
    public static var NO: Noun  { return .Atom(1) }

    public init(_ noun: Noun) { self = noun }

    //  6   ::  [a b c]          [a [b c]]
    public init(_ nouns: [Noun]) {
        self = .Invalid
        if nouns.count > 0 {
            var reverse = nouns.reverse().generate()
            self = reverse.next()!
            while let n = reverse.next() {
                self = .Cell(n, self)
            }
        }
    }

    // protocol IntegerLiteralConvertible
    public typealias IntegerLiteralType = ATOM
    public init(integerLiteral value: IntegerLiteralType) {
        self = .Atom(value)
    }

    // protocol ArrayLiteralConvertible
    public typealias Element = Noun
    public init(arrayLiteral elements: Element...) {
        self = Noun(elements)
    }

    // Array subscript
    public subscript(axis: ATOM) -> Noun {
        return fas(.Cell(.Atom(axis), self))
    }

    // protocol Hashable
    public var hashValue: Int {
        //return self.description.hashValue
        switch self {
        case let .Atom(a):
            return a.hashValue
        case let .Cell(a, b):
            return (5381 + 31 &* a.hashValue) &+ b.hashValue
        default:
            abort()
        }
    }

    // protocol CustomStringConvertible
    public var description: String {
        return describe()
    }

    private func describe(depth: Int = 0) -> String {
        var sub = ""
        let next = depth+1
        switch self {
        case .Invalid:
            return "[%INVALID%]"
        case let .Atom(atom):
            return "\(atom)"
        case let .Cell(.Cell(a, b), c):
            sub =  "[\(a.describe(next)) \(b.describe(next))] \(c.describe(next))"
        case let .Cell(a, b):
            sub = "\(a.describe(next)) \(b.describe(next))"
        }
        return depth == 0 ? "[\(sub)]" : sub
    }
}

// protocol Equatable
public func == (left: Noun, right: Noun) -> Bool
{
    switch (left, right) {
    case let (.Atom(lhs), .Atom(rhs)):          return lhs == rhs
    case let (.Cell(lp, lq), .Cell(rp, rq)):    return lp == rp && lq == rq
    case (.Invalid, .Invalid):                  return true
    default:                                    return false
    }
}

public func wut(noun: Noun) -> Noun
{
    switch noun {
        //  8   ::  ?[a b]           0
    case .Cell:
        return Noun.YES
    case .Atom:
        //  9   ::  ?a               1
        return Noun.NO
    default:
        //return wut(noun)
        abort()
    }
}

public func lus(noun: Noun) -> Noun
{
    if case let .Atom(a) = noun {
        // 11   ::  +a               1 + a
        return .Atom(1+a)
    }
    // 10   ::  +[a b]           +[a b]
    //return lus(noun)
    abort()
}

public func tis(noun: Noun) -> Noun
{
    if case let .Cell(a, b) = noun {
        // 12   ::  =[a a]           0
        // 13   ::  =[a b]           1
        return (a == b) ? Noun.YES : Noun.NO
    }
    // 14   ::  =a               =a
    //return tis(noun)
    abort()
}

public func fas(noun: Noun) -> Noun
{
    switch noun {
        // 16   ::  /[1 a]           a
    case let .Cell(1, a):
        return a
        // 17   ::  /[2 a b]         a
    case let .Cell(2, .Cell(a, _)):
        return a
        // 18   ::  /[3 a b]         b
    case let .Cell(3, .Cell(_, b)):
        return b
        // 19   ::  /[(a + a) b]        /[2 /[a b]]
        // 20   ::  /[(a + a + 1) b]    /[3 /[a b]]
    case let .Cell(.Atom(axis), tree):
        let inner = Noun.Atom(axis / 2)
        let outer = Noun.Atom(2 + (axis % 2))
        return fas(.Cell(outer, fas(.Cell(inner, tree))))
    default:
        // 21   ::  /a                  /a
        //return fas(noun)
        abort()
    }
}

public func tar(noun: Noun) -> Noun
{
    switch noun {
    case let .Cell(a, formula):
        switch formula {
            // 23   ::  *[a [b c] d]     [*[a b c] *[a d]]
        case let .Cell(.Cell(b, c), d):
            return .Cell(tar([a, b, c]), tar([a, d]))

            // 25   ::  *[a 0 b]         /[b a]
        case let .Cell(0, b):
            return fas([b, a])

            // 26   ::  *[a 1 b]         b
        case let .Cell(1, b):
            return b

            // 27   ::  *[a 2 b c]       *[*[a b] *[a c]]
        case let .Cell(2, .Cell(b, c)):
            return tar([tar([a, b]), tar([a, c])])

            // 28   ::  *[a 3 b]         ?*[a b]
        case let .Cell(3, b):
            return wut(tar([a, b]))

            // 29   ::  *[a 4 b]         +*[a b]
        case let .Cell(4, b):
            return lus(tar([a, b]))

            // 30   ::  *[a 5 b]         =*[a b]
        case let .Cell(5, b):
            return tis(tar([a, b]))

            // 32   ::  *[a 6 b c d]     *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
        case let .Cell(6, .Cell(b, .Cell(c, d))):
            return tar([a, 2, [0, 1], 2, [1, c, d], [1, 0], 2, [1, 2, 3], [1, 0], 4, 4, b])

            // 33   ::  *[a 7 b c]       *[a 2 b 1 c]
        case let .Cell(7, .Cell(b, c)):
            return tar([a, 2, b, 1, c])

            // 34   ::  *[a 8 b c]       *[a 7 [[7 [0 1] b] 0 1] c]
        case let .Cell(8, .Cell(b, c)):
            return tar([a, 7, [[7, [0, 1], b], 0, 1], c])

            // 35   ::  *[a 9 b c]       *[a 7 c 2 [0 1] 0 b]
        case let .Cell(9, .Cell(b, c)):
            return tar([a, 7, c, 2, [0, 1], 0, b])

            // 36   ::  *[a 10 [b c] d]  *[a 8 c 7 [0 3] d]
        case let .Cell(10, .Cell(.Cell(_, c), d)):
            return tar([a, 8, c, 7, [0, 3], d])

            // 37   ::  *[a 10 b c]      *[a c]
        case let .Cell(10, .Cell(_, c)):
            return tar([a, c]);

        default:
            //return tar(noun)
            abort()
        }
    default:
        //return tar(noun)
        abort()
    }
}


public var nock_functions = Dictionary<Noun, Noun -> Noun>()

public func dao(formula: Noun) -> Noun->Noun
{
    if let cached = nock_functions[formula] {
        return cached
    }

    let compiler = { () -> Noun -> Noun in
        switch formula {
        case let .Cell(.Cell(b, c), d):     // Distribution
            let (p, q) = (dao(.Cell(b, c)), dao(d))
            return { a in .Cell(p(a), q(a)) }

        case let .Cell(0, b):               // Axis
            return { a in fas(.Cell(b, a)) }

        case let .Cell(1, b):               // Just
            return { _ in b }

        case let .Cell(2, .Cell(b, c)):     // Fire
            let (f, g) = (dao(b), dao(c))
            return { a in dao(g(a))(f(a)) }

        case let .Cell(3, b):               // Depth
            let f = dao(b)
            return { a in wut(f(a)) }

        case let .Cell(4, b):               // Bump
            let f = dao(b)
            return { a in lus(f(a)) }

        case let .Cell(5, b):               // Same
            let f = dao(b)
            return { a in tis(f(a)) }

        case let .Cell(6, .Cell(b, .Cell(c, d))): // If
            let (p, q, r) = (dao(b), dao(c), dao(d))
            return { a in
                switch p(a) {
                case Noun.self.YES:
                    return q(a)
                case Noun.self.NO:
                    return r(a)
                default:
                    return tar(.Cell(a, formula))
                }
            }

        case let .Cell(7, .Cell(b, c)):     // Compose
            let (f, g) = (dao(b), dao(c))
            return { a in g(f(a)) }

        case let .Cell(8, .Cell(b, c)):     // Push
            let (f, g) = (dao(b), dao(c))
            return { a in g(.Cell(f(a), a)) }

        case let .Cell(9, .Cell(b, c)):     // Call
            let f = dao(c)
            return { a in
                let core = f(a)
                let arm = dao(fas(.Cell(b, core)))
                return arm(core)
            }

        case let .Cell(10, .Cell(.Cell(_, c), d)): // Hint
            let ignore = dao(c)
            let f = dao(d)
            return { a in ignore(a); return f(a) }

        case let .Cell(10, .Cell(_, c)):    // Hint
            let f = dao(c)
            return { a in f(a) }

        default:
            return { a in tar(.Cell(a, formula)) }
        }
    }

    let r = compiler()
    nock_functions[formula] = r
    return r
}

public func nock(n: Noun) -> Noun
{
    if case let .Cell(a, b) = n {
        let f = dao(b)
        return f(a)
    }
    return nock(n)
}
```
