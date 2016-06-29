require "colorize"

require "./home_energy_server/http_server"
require "./home_energy_server/current_time"
require "./home_energy_server/wind"
require "./home_energy_server/solar"
require "./home_energy_server/battery"
require "./home_energy_server/auto_resistor"
require "./home_energy_server/power_outlets"

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

    @power_outlets = HomeEnergyServer::PowerOutlets.new(battery: @battery, tick: @real_time_tick)
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

    @power_outlets.tick
    @auto_resistor.tick

    sleep @tick
  end

  def show
    puts "#{@time.current.to_s("%Y-%m-%d %H:%M")} - #{@solar.power.to_s[0..7].colorize(:yellow)} W solar, #{@wind.power.to_s[0..7].colorize(:blue)} W wind; #{(@battery.charged * 100.0).to_s[0..5].colorize(:red)} % battery, #{@power_outlets.outlets.size.to_s.colorize(:green)}/#{@power_outlets.enabled_outlets.size.to_s.colorize(:magenta)} outlets"
  end

  def payload
    {
      time: @time.current.epoch,
      solar: @solar.payload,
      wind: @wind.payload,
      battery: @battery.payload,
      auto_resistor: @auto_resistor.payload,
      power_outlets: @power_outlets.payload
    }
  end

  def reset_battery
    @battery.reset!
  end

  def add_power_outlet(name : String, power : Float64)
    @power_outlets.add(name: name, power: power)
  end

end
