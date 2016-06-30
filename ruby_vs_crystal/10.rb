class House
  def initialize(room_count = 1)
    @room_count = room_count
  end

  attr_accessor :room_count
end

h = House.new(2)
puts h.room_count

h.room_count = 10
puts h.room_count
