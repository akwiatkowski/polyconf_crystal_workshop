h = Hash((String | Float64), Int32).new
h["a"] = 1
h["b"] = 2
h["c"] = 3

h[0.1] = 4
h[1.234] = 1234

puts h.inspect
