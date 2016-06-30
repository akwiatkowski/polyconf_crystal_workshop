file = File.open("buffer_i_gen_batt.txt")

values = Array(Float64).new

meas_offset = -512
linear_coefficient = 0.191

6.times do
    file.gets
end

interval = file.gets.to_s.to_i
puts interval

file.each_line do |raw_line|
    line = raw_line.to_s.strip
    puts line.inspect
    unless line == ""
        raw_value = line.to_i
        # real_value = (raw_value + meas_offset) * linear_coefficient
        # values << real_value
        # puts real_value
    end
end

file.close

min_value = values.min

values.each do |value|
    value -= min_value
end
