class HomeEnergyServer::Battery
  def initialize(@voltage = 48.0, @capacity : Float64 = 80.0) # capacity in Ah
    @charged = 0.5
    @overload_time = Time::Span.new(0)
    @underload_time = Time::Span.new(0)
  end

  def charge(power : Float64, span : Time::Span)
    current = power / @voltage
    time = span.total_hours
    energy = current * time # in Ah

    @charged += (energy / @capacity)
  end

  def current_capacity
    @capacity * @charged
  end

  def tick(span : Time::Span)
    if @charged > 1.0
      @overload_time += span
    end

    if @charged < 0.0
      @underload_time += span
    end
  end

  def payload
    {
      charged: @charged,
      underload_time: @underload_time.total_milliseconds,
      overload_time: @overload_time.total_milliseconds,
      voltage: @voltage,
      capacity: @capacity
    }
  end
end
