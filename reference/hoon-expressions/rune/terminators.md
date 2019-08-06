+++
title = "Terminators -- and =="
weight = 15
template = "doc.html"
+++
The `--` and `==` are used as terminators: `--` for core expressions, and `==` for terminating a 'running' or 'jogging' series of Hoon expressions.

## Runes

### -- "hephep"

##### Syntax

The `--` rune is used to indicate the end of a core expression.

##### Discussion

The `|%`, `|_`, and `|^` runes are used to create cores that can have arbitrarily many arms.  When you have defined all the desired arms in a core expression (using the `++`, `+$`, and `+*` runes), use `--` to terminate the expression.

##### Examples

```
> =num |%
         ++  two  2
         ++  add-two  |=(a=@ (add 2 a))
         ++  double  |=(a=@ (mul 2 a))
       --

> two.num
2

> (add-two.num 12)
14

> (double.num 12)
24
```

### == "tistis"

##### Syntax

The `==` rune is used to indicate the end of a 'jogging' or 'running' series of Hoon expressions.

##### Discussion

Certain runes are used to create expressions that may include arbitrarily many subexpressions.  Such expressions are terminated with the `==` rune.  For example, the `:*` and `:~` runes are used to create a cell of any length.  (The latter is just like the former except that it adds a null value at the end of the cell.)  For another example, the `%=` rune used used to make arbitrarily many changes to a given wing value.

##### Examples

```
> :*  2
      3
      4
      5
      6
  ==
[2 3 4 5 6]

> :~  2
      3
      4
      5
      6
  ==
[2 3 4 5 6 ~]

> =values [a=12 b=14 c=16 d=18 e=20]

> %=  values
    a  13
    b  15
    c  17
    d  19
    e  21
  ==
[a=13 b=15 c=17 d=19 e=21]
```
