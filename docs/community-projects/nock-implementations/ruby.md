---
navhome: /docs/
title: Ruby
sort: 2
next: true
---

# Ruby

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
