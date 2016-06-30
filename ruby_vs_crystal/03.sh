# ruby
time ruby 01.cr 

# crystal
time crystal 01.cr

# compilation takes time
crystal 01.cr -o 01
time ./01

# optimization
crystal 01.cr --release -o 01r
time ./01r
