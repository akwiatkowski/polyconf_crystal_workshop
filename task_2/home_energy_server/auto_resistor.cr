require "./battery"

class HomeEnergyServer::AutoResistor
  def initialize(@battery : HomeEnergyServer::Battery, @tick : Time::Span, @enabled = true, @power = 200.0)
    @work_time = Time::Span.new(0)
    @working = false
  end

  property :enabled

  def tick
    @working = false
    if @battery.charged > 0.9
      run
    end
  end

  def run
    puts "Autoresistor discharge #{@power}"
    @battery.discharge(@power)
    @work_time += @tick
    @working = true
  end

  def payload
    {
      power: @power,
      working: @working,
      work_time: @work_time.total_milliseconds
    }
  end
end
