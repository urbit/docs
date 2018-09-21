---
navhome: /docs/
title: C#
sort: 12
next: true
---

# C#

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
