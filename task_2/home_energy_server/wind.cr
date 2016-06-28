class HomeEnergyServer::Wind
  def initialize(@time : HomeEnergyServer::CurrentTime, @max_power = 500)
    @last_time = @time.current as Time
    @day_coeff = generate_day_coeff as Float64
    @current_coeff = 1.0

    20.times do
      puts generate_current_coeff
    end
  end

  def generate_day_coeff
    r = RandomGaussian.new(0.2, 0.8).rand as Float64
    r = 0.0 if r < 0.0
    r = 1.5 if r > 1.5

    return r
  end

  def generate_current_coeff
    r = RandomGaussian.new(1.0, 0.5).rand as Float64
    r = 0.3 if r < 0.3
    r = 2.0 if r > 2.0

    return r
  end

  def tick
    if @last_time.day != time.day
      # new day
      @last_time = time
      @day_coeff = generate_day_coeff

      puts "current day wind coeff #{@day_coeff}"
    end
  end

  def time
    @time.current
  end

  def power
    c = generate_current_coeff as Float64
    @current_coeff = (@current_coeff + c) / 2.0

    return @max_power.to_f * @day_coeff * @current_coeff
  end

end
