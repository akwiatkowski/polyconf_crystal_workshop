require "./home_energy_server/current_time"
require "./home_energy_server/wind"
require "./home_energy_server/solar"

class HomeServer
  def initialize
    @time = HomeEnergyServer::CurrentTime.new

    @wind = HomeEnergyServer::Wind.new(time: @time)
    @solar = HomeEnergyServer::Sun.new(time: @time)

  end

  def make_it_so
    loop do
      tick
      show
      sleep 0.05
    end
  end

  def tick
    @time.tick
    @solar.tick
    @wind.tick
  end

  def show
    puts "#{@time.current} - #{@solar.power}, #{@wind.power}"
  end
end
