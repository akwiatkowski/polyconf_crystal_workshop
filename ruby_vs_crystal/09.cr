i = 0

while i < 10
  puts i

  if i % 2 == 0
    puts "Even #{i}"
  end

  i += 1
end

puts "\n"

('a'..'d').each do |char|
  puts char
end
