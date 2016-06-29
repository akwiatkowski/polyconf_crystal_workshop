require "./battery"
require "./single_outlet"

class HomeEnergyServer::PowerOutlets
  def initialize(@battery : HomeEnergyServer::Battery, @tick : Time::Span)
    @outlets = Array(HomeEnergyServer::SingleOutlet).new
  end

  getter :outlets

  def tick
    can_be_enabled = true

    @outlets.each do |o|
      can_be_enabled = false if @battery.charged < 0.0

      if can_be_enabled == false
        if o.enabled
          puts "Outlet #{o.name.to_s.colorize(:red)} will be DISABLED"
        end

        # disable all outlets because of battery underload
        o.enabled = false

      else
        # process only enabled outlets
        if o.enabled
          # discharge from batteries
          e = @battery.discharge(o.power)
          # and move energy to outlets
          o.consumed_energy += e
          o.work_time += @tick
        end

      end
    end

  end

  def payload
    {
      outlets: @outlets.map{|o| o.payload }
    }
  end

  def enabled_outlets
    @outlets.select{|o| o.enabled }
  end

  def add(name : String, power : Float64)
    f = @outlets.select{|o| o.name == name}
    if f.size > 0
      outlet = f[0] as HomeEnergyServer::SingleOutlet
    else
      outlet = HomeEnergyServer::SingleOutlet.new(name: name, power: power)
      @outlets << outlet
    end

    outlet.power = power
    outlet.enabled = true

    outlet
  end
end
