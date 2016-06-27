f = File.new("task_1/buffer_i_gen_batt.txt")
_ = f.gets # not important

count = f.gets.to_s.to_i

4.times do
  _ = f.gets # not important
end

interval = f.gets.to_s.to_i

2.times do
  _ = f.gets # not important
end

raw = Array(Int32).new

(count - 1).times do
  raw << f.gets.to_s.to_i
end

values = Array(Float64).new

raw.each do |r|
  v = (r.to_f - 512.0) * 0.191
  values << v
end

offset = values.min

values.each_with_index do |v, i|
  values[i] = v - offset
end


work_time = 0 # ms
energy = 0.0
threshold = 2

values.each do |v|
  if v > threshold
    work_time += 1
  end

  e = 36.0 * v * interval.to_f / 1000.0 # Joules
  energy += e
end

puts (work_time.to_f * interval.to_f) / (1000.to_f * 60.to_f)
puts (work_time.to_f / values.size.to_f)
puts energy / (3600.0 * 1000.0) # kWh

f.close
