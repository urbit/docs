---
navhome: /docs/
title: Groovy
sort: 7
next: true
---

# Groovy 

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
