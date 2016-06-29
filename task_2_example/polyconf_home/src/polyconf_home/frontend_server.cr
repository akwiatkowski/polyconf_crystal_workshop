require "kemal"
require "json"

class PolyconfHome::FrontendServer
  def initialize
    get_payload

  end

  def start
    get "/" do
      name = set_power.inspect
      render "src/views/root.ecr"
    end

    ws "/ws" do |socket|
      # Handle incoming message and echo back to the client
      socket.on_message do |message|
        socket.send "Echo back from server #{message}"
      end

      # Executes when the client is disconnected. You can do the cleaning up here.
      socket.on_close do
        puts "Closing socket"
      end

      socket.send "Hello from Kemal 1!"
      sleep 1
      socket.send "Hello from Kemal 2!"

    end

    Kemal.run
  end

  def get_payload
    response = HTTP::Client.get "localhost:3080"
    body = response.body
    json = JSON.parse(body)

    time = Time.epoch(json["time"].to_s.to_i)
    puts time.inspect

    solar_power = json["solar"]["power"]
    puts solar_power

    return json
  end

  def set_power
    name = "olek"
    power = 4.0

    response = HTTP::Client.post("localhost:3080", nil, {"name" => name, "power" => power}.to_json)
    body = response.body
    json = JSON.parse(body)

    return json
  end
end
