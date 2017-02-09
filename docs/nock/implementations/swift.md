---
navhome: /docs/
title: Swift
sort: 10
next: true
---

# Swift

```swift
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
