class House
  def initialize(@room_count = 1)
  end

  property :room_count
end

h = House.new(room_count: 2)
puts h.room_count

h.room_count = 10
puts h.room_count
