---
navhome: /docs/
title: Python
sort: 1
next: true
---

# Python 

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
