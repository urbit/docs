---
navhome: /docs
title: Groovy
sort: 7
---

# Groovy 

From [Kohányi Róbert](https://github.com/kohanyirobert/gnock/blob/master/gnock.groovy):

```
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

def n(def a) {
  if (a in List) {
    if (a.size() == 1) {
      n(a[0])
    } else if (a.size() == 2) {
      [n(a[0]), n(a[1])]
    } else if (a.size() > 2) {
      [n(a[0]), n(a.tail())]
    } else {
      throw new IllegalStateException()
    }
  } else if (i(a)) {
    (BigInteger) a
  } else {
    throw new IllegalStateException()
  }
}

def wut(def a) {
  i(a) ? 1 : 0
}

def lus(def a) {
  if (wut(a) == 0) {
    throw new IllegalStateException()
  }
  1 + a
}

def tis(def a) {
  if (wut(a) == 1) {
    throw new IllegalStateException()
  }
  a[0] == a[1] ? 0 : 1
}

def fas(def a) {
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
    t
  } else {
    if (i(t)) {
      throw new IllegalStateException()
    }
    if (h == 2) {
      t[0]
    } else if (h == 3) {
      t[1]
    } else {
      def x = h.intdiv(2)
      if (h.mod(2) == 0) {
        fas([2, fas([x, t])])
      } else {
        fas([3, fas([x, t])])
      }
    }
  }
}

def tar(def a) {
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
    [tar([s, o]), tar([s, v])]
  } else {
    if (o == 0) {
      fas([v, s])
    } else if (o == 1) {
      v
    } else if (o == 3) {
      wut(tar([s, v]))
    } else if (o == 4) {
      lus(tar([s, v]))
    } else if (o == 5) {
      tis(tar([s, v]))
    } else {
      if (wut(v) == 1) {
        throw new IllegalStateException()
      }
      def x = v[0]
      def y = v[1]
      if (o == 2) {
        tar([tar([s, x]), tar([s, y])])
      } else if (o == 7) {
        tar(n([s, 2, x, 1, y]))
      } else if (o == 8) {
        tar(n([s, 7, [[7, [0, 1], x], 0, 1], y]))
      } else if (o == 9) {
        tar(n([s, 7, y, 2, [0, 1], 0, x]))
      } else if (o == 10) {
        if (wut(x) == 1) {
          tar([s, y])
        } else {
          def r = x[0]
          def t = x[1]
          tar(n([s, 8, t, 7, [0, 3], y]))
        }
      } else {
        if (wut(y) == 1) {
          throw new IllegalStateException()
        }
        def p = y[0]
        def q = y[1]
        if (o == 6) {
          tar(n([s, 2, [0, 1], 2, [1, p, q], [1, 0], 2, [1, 2, 3], [1, 0], 4, 4, x]))
        } else {
          throw new IllegalStateException()
        }
      }
    }
  }
}
```
