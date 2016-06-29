class HomeEnergyServer::CurrentTime
  def initialize(@span = Time::Span.new(0, 10, 0))
    @time = Time.now
  end

  getter :span

  def tick
    @time += @span
  end

  def current : Time
    return @time
  end
end
