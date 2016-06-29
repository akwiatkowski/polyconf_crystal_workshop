class HomeEnergyServer::SingleOutlet
  def initialize(@name : String, @power : Float64)
    @enabled = true
  end

  getter :name
  property :power
  property :enabled

  def payload
    {
      name: name,
      power: power,
      enabled: enabled
    }
  end
end
