class HomeEnergyServer::CurrentTime
  def initialize
    @time = Time.now
    @span = Time::Span.new(0, 10, 0)
  end

  getter :span

  def tick
    @time += @span
  end

  def current : Time
    return @time
  end
end
