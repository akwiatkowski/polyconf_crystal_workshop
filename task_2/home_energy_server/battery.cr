class HomeEnergyServer::Battery
  def initialize(@tick : Time::Span, @voltage = 48.0, @capacity : Float64 = 80.0) # capacity in Ah
    @charged = 0.5
    @overload_time = Time::Span.new(0)
    @underload_time = Time::Span.new(0)
    @full_cycles = 0.0
    @max_full_cycles = 1000.0
  end

  getter :charged

  def charge(power : Float64) : Float64
    charge_time(power: power, span: @tick)
  end

  def discharge(power : Float64) : Float64
    discharge_time(power: power, span: @tick)
  end

  def calculate_energy(power : Float64, span : Time::Span) : Float64
    current = power / @voltage
    time = span.total_hours
    energy = current * time # in Ah

    return energy
  end

  def charge_time(power : Float64, span : Time::Span) : Float64
    cq = ( calculate_energy(power: power, span: span) / @capacity)
    @full_cycles += cq
    @charged += cq

    return cq
  end

  def discharge_time(power : Float64, span : Time::Span) : Float64
    cq = ( calculate_energy(power: power, span: span) / @capacity)
    @charged -= cq

    return cq
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

  def reset!
    @charged = 0.5
  end

  def payload
    {
      charged: @charged,
      underload_time: @underload_time.total_milliseconds,
      overload_time: @overload_time.total_milliseconds,
      voltage: @voltage,
      capacity: @capacity,
      full_cycles: @full_cycles,
      max_full_cycles: @max_full_cycles
    }
  end
end
