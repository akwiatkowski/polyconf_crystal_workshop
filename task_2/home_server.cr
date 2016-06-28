require "./home_energy_server/http_server"
require "./home_energy_server/current_time"
require "./home_energy_server/wind"
require "./home_energy_server/solar"
require "./home_energy_server/battery"

class HomeServer
  def initialize
    @time = HomeEnergyServer::CurrentTime.new

    @wind = HomeEnergyServer::Wind.new(time: @time)
    @solar = HomeEnergyServer::Sun.new(time: @time)

    @battery = HomeEnergyServer::Battery.new
  end

  def make_it_so
    future do
      server = HomeEnergyServer::HttpServer.new(h: self)
      server.make_it_so
    end

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

    @battery.charge(@solar.power, @time.span)
    @battery.charge(@wind.power, @time.span)
    @battery.tick(@time.span)
  end

  def show
    puts "#{@time.current} - #{@solar.power}, #{@wind.power}; #{@battery.current_capacity}"
  end

  def payload
    {
      time: @time.current.epoch,
      solar: @solar.payload,
      wind: @wind.payload,
      battery: @battery.payload
    }
  end
end
