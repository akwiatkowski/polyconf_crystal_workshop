require "colorize"

require "./home_energy_server/http_server"
require "./home_energy_server/current_time"
require "./home_energy_server/wind"
require "./home_energy_server/solar"
require "./home_energy_server/battery"
require "./home_energy_server/auto_resistor"

class HomeServer
  def initialize(
      @tick = 0.5,
      @real_time_tick = Time::Span.new(0, 10, 0),
      @resistor_power = 400.0,
      @solar_max_power = 100.0,
      @wind_max_power = 500.0
    )
    @time = HomeEnergyServer::CurrentTime.new(span: @real_time_tick)

    @wind = HomeEnergyServer::Wind.new(time: @time, max_power: @wind_max_power)
    @solar = HomeEnergyServer::Sun.new(time: @time, max_power: @solar_max_power)

    @battery = HomeEnergyServer::Battery.new(tick: @real_time_tick)
    @auto_resistor = HomeEnergyServer::AutoResistor.new(battery: @battery, tick: @real_time_tick, enabled: true, power: @resistor_power)
  end

  def make_it_so
    future do
      server = HomeEnergyServer::HttpServer.new(h: self)
      server.make_it_so
    end

    loop do
      tick
      show
    end


  end

  def tick
    @time.tick
    @solar.tick
    @wind.tick

    @battery.charge(@solar.power)
    @battery.charge(@wind.power)
    @battery.tick(@time.span)

    @auto_resistor.tick

    sleep @tick
  end

  def show
    puts "#{@time.current.to_s("%Y-%m-%d %H:%M")} - #{@solar.power.to_s[0..7].colorize(:yellow)} W solar, #{@wind.power.to_s[0..7].colorize(:blue)} W wind; #{(@battery.charged * 100.0).to_s[0..5].colorize(:red)} % battery"
  end

  def payload
    {
      time: @time.current.epoch,
      solar: @solar.payload,
      wind: @wind.payload,
      battery: @battery.payload,
      auto_resistor: @auto_resistor.payload
    }
  end

  def reset_battery
    @battery.reset!
  end
end
