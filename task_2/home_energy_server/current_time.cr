class HomeEnergyServer::CurrentTime
  def initialize
    @time = Time.now
  end

  def tick
    @time += Time::Span.new(0, 10, 0)
  end

  def current : Time
    return @time
  end
end
