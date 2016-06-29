require "./battery"
require "./single_outlet"

class HomeEnergyServer::PowerOutlets
  def initialize(@battery : HomeEnergyServer::Battery, @tick : Time::Span)
    @outlets = Array(HomeEnergyServer::SingleOutlet).new
  end

  getter :outlets

  def tick

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
