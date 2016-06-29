require "./home_server"

s = HomeServer.new(
  tick: 0.02,
  real_time_tick: Time::Span.new(0, 5, 0),
  resistor_power: 2000.0,
  wind_max_power: 500.0,
  solar_max_power: 100.0
)

s.add_power_outlet(
  name: "root",
  power: 0.01
)

s.add_power_outlet(
  name: "too_much",
  power: 2000.0
)

s.make_it_so
