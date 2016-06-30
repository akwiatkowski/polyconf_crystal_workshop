h = Hash((String | Float64), (Int32 | Nil)).new
h["a"] = 1
h["b"] = 2
h["c"] = 3

h[0.1] = 4
h[1.234] = 1234

h["nil"] = nil

puts h.inspect
puts h.class
