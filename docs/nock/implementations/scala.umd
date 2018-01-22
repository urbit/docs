---
navhome: /docs/
title: Scala
sort: 4
next: true
---

# Scala 

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
