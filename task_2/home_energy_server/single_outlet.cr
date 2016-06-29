class HomeEnergyServer::SingleOutlet
  def initialize(@name : String, @power : Float64)
    @enabled = true
    @consumed_energy = 0.0
    @work_time = Time::Span.new(0)
  end

  getter :name
  property :power
  property :enabled
  property :consumed_energy
  property :work_time

  def payload
    {
      name: name,
      power: power,
      enabled: enabled,
      consumed_energy: consumed_energy,
      work_time: work_time.total_milliseconds
    }
  end
end
