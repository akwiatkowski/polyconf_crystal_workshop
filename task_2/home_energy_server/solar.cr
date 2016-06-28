require "../utils/random_gaussian"

class HomeEnergyServer::Sun
  # @day_coeff : Float64

  def initialize(@time : HomeEnergyServer::CurrentTime, @max_power = 100)
    @last_time = @time.current as Time
    @day_coeff = generate_day_coeff as Float64
  end

  def generate_day_coeff
    r = RandomGaussian.new(1.0, 0.6).rand as Float64
    r = 0.1 if r < 0.1
    r = 1.0 if r > 1.0

    return r
  end

  def tick
    if @last_time.day != time.day
      # new day
      @last_time = time
      @day_coeff = generate_day_coeff

      puts "current day solar coeff #{@day_coeff}"
    end
  end

  def time
    @time.current
  end

  def month_coeff
    #time.month
    return 200.0
  end

  def power
    min = time.hour * 60 + time.minute
    noon = 12 * 60
    day = 24 * 3600

    c = (min - noon).to_f.abs * month_coeff / day
    c = 1.0 - c
    c = 0.0 if c < 0.0

    c = c ** 0.6

    return @max_power.to_f * @day_coeff * c
  end

  def payload
    {power: power, max_power: @max_power}
  end
  
end
