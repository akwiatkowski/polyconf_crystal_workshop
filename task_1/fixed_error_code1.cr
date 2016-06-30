f = File.new("buffer_i_gen_batt.txt")

6.times do
  _ = f.gets
end

interval = f.gets

def real_val(raw_val)
  (raw_val - 520) * 0.191
end

def normalize
end

loop do
  break unless n = f.gets

  unless n.to_s.strip == ""
    puts n.to_s.strip.to_i
  end

  # puts n.to_i
end
